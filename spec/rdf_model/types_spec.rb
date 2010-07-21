require 'spec_helper'

describe RdfModel::Types do
  def test_class
    Class.new do
      include RdfModel::Types
    end
  end
  it "should provide a way to specify the model's type" do
    c = test_class
    c.model_type "http://test.host/test"
    c.model_type.should == "http://test.host/test"
  end

  it "should let you specify the predicate for the ID of a model" do
    c = test_class
    c.id_predicate "http://test.host/blah"
    c.id_predicate.should == "http://test.host/blah"
  end

  it "should let you specify how to construct the name of a model" do
    c = test_class
    c.name_finder({:test1 => "http://test.host/test1", :test2 => "http://test.host/test2"}, :order => [:test1, :test2])
    c.name_finder.should == {:selectors => {:test1 => "http://test.host/test1", :test2 => "http://test.host/test2"}, :order => [:test1, :test2]}
  end

  it "should let you find all the instances of a model" do
    c = test_class
    c.name_finder({:test1 => "http://test.host/test1", :test2 => "http://test.host/test2"}, :order => [:test1, :test2])
    c.id_predicate "http://test.host/blah"
    c.model_type "http://test.host/test"
    c.should_receive(:find_by_sparql).with("SELECT ?id ?test1 ?test2 WHERE { ?model rdf:type http://test.host/test ; http://test.host/blah ?id ; http://test.host/test1 ?test1 ; http://test.host/test2 ?test2 }").and_return([{"id" => 12, "test1" => "new", "test2" => "test"}])
    c.find_all.should == [{"id" => 12, "name" => "new test"}]
  end
end