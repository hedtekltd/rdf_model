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
    c.new("", [{"p" => "testing", "o" => "test1"}]).testing.should == "test1"
  end

  it "should populate the attributes hash with data" do
    c = test_class
    c.new("", [{"p" => "testing", "o" => "test1"}]).attributes.should include({"testing" => "test1"})
  end

end