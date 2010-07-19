require 'spec_helper'

describe RdfModel::Prefixes do
  def test_class()
    Class.new() do
      def self.sparql(query)
        query
      end
      include RdfModel::Prefixes
    end
  end

  def test_subclass(supr)
    Class.new(supr)
  end

  before(:each) do
    @c = test_class
  end

  it "should be able to add a prefix" do
    @c.prefix :test => "http://test.host"
    @c.prefix.should include({:test => "http://test.host"})
  end

  it "should be able to add multiple prefixes in one call" do
    @c.prefix :test1 => "http://test.host", :test2 => "http://test2.host"
    @c.prefix.should include({:test1 => "http://test.host"})
    @c.prefix.should include({:test2 => "http://test2.host"})
  end

  it "shouldn't share prefixes between classes" do
    c2 = test_class
    @c.prefix :test => "http://test.host"
    c2.prefix.should_not include({:test => "http://test.host"})
  end

  it "should automatically apply prefixes to sparql queries" do
    @c.prefix :test => "http://test.host/"
    @c.sparql("SELECT * WHERE { http://test.host/1 ?p ?o }").should == "PREFIX test: <http://test.host/> SELECT * WHERE { test:1 ?p ?o }"
  end

  context "prefix subclasses" do
    before(:each) do
      @sub_c = test_subclass(@c)
    end

    it "should inherit prefixes to subclasses" do
      @c.prefix :test => "http://test.host"
      @sub_c.prefix.should include({:test => "http://test.host"})
    end

    it "shouldn't propagate prefixes to superclasses" do
      @sub_c.prefix :test => "http://test.host"
      @c.prefix.should_not include({:test => "http://test.host"})
    end
  end
end