require 'spec_helper'

describe RdfModel::Associations do
  def test_class
    Class.new do
      def process_attribute_value(name, value)
        value
      end

      include RdfModel::Associations
    end
  end

  it "should allow you to specify a model link" do
    c = test_class
    c2 = test_class
    c.linked_to c2, :with => "http://test.host/vocab/TEST"
    c.linked_to.should include({"http://test.host/vocab/TEST" => c2})
  end

  it "should hook into the attribute processing and construct an instance" do
    c = test_class
    c2 = test_class
    c.linked_to c2, :with => "http://test.host/vocab/TEST"
    c2.should_receive(:find_by_uri).with("http://test.host/TESTING/1")
    c.new.process_attribute_value("http://test.host/vocab/TEST", "http://test.host/TESTING/1")
  end

  it "should inherit linked models from parents" do
    c = test_class
    c2 = Class.new(c)
    c3 = test_class
    c.linked_to c3, :with => "http://test.host/vocab/TEST"
    c2.linked_to.should include({"http://test.host/vocab/TEST" => c3})
  end

  it "should not interfere with a non-linked attribute request" do
    c = test_class
    c.new.process_attribute_value("http://test.host/vocab/TEST", "http://test.host/TESTING/1").should == "http://test.host/TESTING/1" 
  end

  it "should only create the linked model once" do
    c = test_class
    c2 = test_class
    c.linked_to c2, :with => "http://test.host/vocab/TEST"
    c2.should_receive(:find_by_uri).once().with("http://test.host/TESTING/1").and_return(mock(c2))
    cinst = c.new
    r1 = cinst.process_attribute_value("http://test.host/vocab/TEST", "http://test.host/TESTING/1")
    r2 = cinst.process_attribute_value("http://test.host/vocab/TEST", "http://test.host/TESTING/1")
    r1.should == r2
  end

  it "should allow you to specify an inverse model link" do
    c = test_class
    c2 = test_class
    c.linked_from c2, :with => "http://test.host/vocab/TEST", :as => 'test'
    c.linked_from.should include("http://test.host/vocab/TEST" => c2)
  end

  it "should inherit inverse model links" do
    c = test_class
    c2 = Class.new(c)
    c3 = test_class
    c.linked_from c3, :with => "http://test.host/vocab/TEST", :as => 'test'
    c2.linked_from.should include("http://test.host/vocab/TEST" => c3)
  end

  it "should create a method to access the inverse link" do
    c = test_class
    c2 = test_class
    c.linked_from c2, :with => "http://test.host/vocab/TEST", :as => 'test'
    c.new.respond_to?(:test).should be_true
  end
end