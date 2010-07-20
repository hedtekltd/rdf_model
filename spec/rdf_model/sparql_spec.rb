require 'spec_helper'

describe RdfModel::Sparql do
  before(:each) do
    RdfModel::TRIPLESTORE_CONFIG.load_rails_config_file(File.join(File.dirname(__FILE__), "..", "config", "triplestore.yml"), "test")
    ::FourStore::Store.stub!(:new).and_return(@store = mock(::FourStore::Store))
  end

  def test_class
    Class.new do
      include RdfModel::Sparql
    end
  end

  it "should re-use the same connection for multiple classes" do
    ::FourStore::Store.should_receive(:new).once().with("test-uri")
    c = test_class
    c2 = test_class
    c.connection.should == c2.connection
  end

  it "should allow queries to be made on the connection" do
    c = test_class
    @store.should_receive(:select).with("SELECT * WHERE { ?s ?o ?p }")
    c.find_by_sparql("SELECT * WHERE { ?s ?o ?p }")
  end

  it "should create an object when using find_by_uri" do
    c = test_class
    @store.should_receive(:select).with("SELECT ?p ?o WHERE { http://test.host/ ?p ?o }").and_return({"p" => "blah", "o" => "test"})
    c.should_receive(:new).with("http://test.host/", {"p" => "blah", "o" => "test"}).and_return(mock(c))
    c.find_by_uri("http://test.host/")
  end

  it "should allow you to specify an id prefix" do
    c = test_class
    c.id_prefix "species"
    c.id_prefix.should == "species"
  end

  it "should allow you to find by ID" do
    c = test_class
    @store.should_receive(:select).with("SELECT ?p ?o WHERE { species:1 ?p ?o }").and_return({"p" => "blah", "o" => "test"})
    c.id_prefix "species"
    c.should_receive(:new).with("species:1", {"p" => "blah", "o" => "test"}).and_return(mock(c))
    c.find_by_id(1)
  end
end