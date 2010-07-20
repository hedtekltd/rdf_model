require 'spec_helper'

describe RdfModel::Prefixes do
  def test_class()
    Class.new() do
      def self.find_by_sparql(query)
        query
      end
      def escape_attribute_name (name)
        name
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
    @c.find_by_sparql("SELECT * WHERE { http://test.host/1 ?p ?o }").should =~ /PREFIX test: <http:\/\/test.host\/> .* SELECT \* WHERE { test:1 \?p \?o }/
  end

  it "should automatically apply global prefixes to sparql queries" do
    @c.find_by_sparql("SELECT * WHERE { http://www.w3.org/1999/02/22-rdf-syntax-ns#test ?p ?o }").should =~ /SELECT \* WHERE { rdf:test \?p \?o }/
  end

  it "should automatically include the global prefixes for RDF" do
    @c.prefix.should include({:rdf => "http://www.w3.org/1999/02/22-rdf-syntax-ns#"})
    @c.prefix.should include({rdfs: "http://www.w3.org/2000/01/rdf-schema#"})
  end

  it "should automatically include vocabularies as prefixes if vocabularies are present" do
    b = mock(RdfModel::Vocabularies::Vocabulary, :uri => "http://test.host/vocab")
    @c.stub!(:vocabulary).and_return({:test => b})
    @c.prefix.should include({:vocab_test => "http://test.host/vocab"})
  end

  it "should rewrite attribute names for prefixes using 'escape_name'" do
    @c.prefix :test => "http://test.host/"
    @c.new.escape_attribute_name("http://test.host/SPECIES").should == "test_SPECIES"
  end

  context "prefix subclasses" do
    before(:each) do
      @sub_c = test_subclass(@c)
    end

    it "should apply inherited prefixes to sparql queries" do
      @c.prefix :test => "http://test.host/"
      @sub_c.prefix :test2 => "http://test2.host/"
      @sub_c.find_by_sparql("SELECT * WHERE { http://test.host/1 http://test2.host/2 ?o }").should =~ /SELECT \* WHERE { test:1 test2:2 \?o }/
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