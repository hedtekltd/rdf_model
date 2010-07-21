require 'spec_helper'

describe RdfModel::Attributes do

  def test_class
    Class.new do
      def initialize(uri, attributes)
        
      end
      include RdfModel::Attributes
    end
  end

  it "should allow access to defined attributes" do
    c = test_class
    c.new("", [{"p" => "testing", "o" => "test1"}]).testing.should == ["test1"]
  end

  it "should populate the attributes hash with an array containing the attribute data" do
    c = test_class
    c.new("", [{"p" => "testing", "o" => "test1"}]).attributes.should include({"testing" => ["test1"]})
  end

  it "should create an array for the data if an attribute appears multiple times" do
    c = test_class
    c.new("", [{"p" => "testing", "o" => "test1"}, {"p" => "testing", "o" => "test2"}]).attributes.should include({"testing" => ["test1", "test2"]})
  end

end