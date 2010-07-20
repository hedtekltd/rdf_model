require 'spec_helper'

describe RdfModel::Connection::Pool do
  before(:each) do
    RdfModel::TRIPLESTORE_CONFIG.load_rails_config_file(File.join(File.dirname(__FILE__), "..", "..", "config", "triplestore.yml"), "test")
  end

  it "should provide a connection" do
    ::FourStore::Store.should_receive(:new).with("test-uri")
    RdfModel::TRIPLESTORE_CONFIG['connection-pool'].connection  
  end

  it "should only create one connection" do
    ::FourStore::Store.should_receive(:new).with("test-uri").and_return(mock(::FourStore::Store))
    c1 = RdfModel::TRIPLESTORE_CONFIG['connection-pool'].connection
    c2 = RdfModel::TRIPLESTORE_CONFIG['connection-pool'].connection
    c1.should == c2
  end
end