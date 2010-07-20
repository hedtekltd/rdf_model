require 'spec_helper'

describe RdfModel::Configuration do

  it "should load a rails config file" do
    RdfModel::TRIPLESTORE_CONFIG.load_rails_config_file(File.join(File.dirname(__FILE__), "..", "config", "triplestore.yml"), "test")
    RdfModel::TRIPLESTORE_CONFIG["sparql-uri"].should == "test-uri"
  end

end