require 'spec_helper'

describe RdfModel::Associations do
  def test_class
    Class.new do
      include RdfModel::Associations
    end
  end

  it "should allow you to specify a model link" do
    c = test_class
    c2 = test_class
    c.linked_to c2, :with => "http://test.host/vocab/TEST"
    c.linked_to.should include({"http://test.host/vocab/TEST" => c2})
  end
end