require 'spec_helper'

describe RdfModel::Sparql do
  before(:each) do
    RdfModel::TRIPLESTORE_CONFIG.load_rails_config_file(File.join(File.dirname(__FILE__), "..", "config", "triplestore.yml"), "test")
    ::FourStore::Store.stub!(:new).and_return(mock(::FourStore::Store))
  end

  it "should re-use the same connection for multiple classes" do
    ::FourStore::Store.should_receive(:new).once().with("test-uri")
    c = Class.new do
      include RdfModel::Sparql
    end
    c2 = Class.new do
      include RdfModel::Sparql
    end
    c.connection.should == c2.connection
  end
end