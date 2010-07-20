require 'spec_helper'

describe RdfModel::Sparql do
  it "should create a connection" do
    RdfModel::TRIPLESTORE_CONFIG.load_rails_config_file(File.join(File.dirname(__FILE__), "..", "config", "triplestore.yml"), "test")
    ::FourStore::Store.should_receive(:new).with("test-uri")
    Class.new do
      include RdfModel::Sparql
    end
  end
end