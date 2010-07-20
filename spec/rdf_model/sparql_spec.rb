require 'spec_helper'

describe RdfModel::Sparql do
  it "should create a connection" do
    ::FourStore::Store.should_receive(:new)
    Class.new do
      include RdfModel::Sparql
    end
  end
end