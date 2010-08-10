require 'spec_helper'

describe RdfModel::Rdfizer do
  def test_class
    Class.new do
      attr_accessor :uri, :attributes

      def initialize(uri)
        self.uri = uri
        self.attributes = {}
      end

      def xml_namespaces
        {"xmlns:rdf" => "http:\/\/www.w3.org\/1999\/02\/22-rdf-syntax-ns#"}
      end

      def escape_uris(uri)
        uri
      end

      include ::RdfModel::Rdfizer
    end
  end

  it "should serialize the class URI to RDF" do
   test_class.new("test_uri").to_rdf_xml.should =~ /<rdf:Description rdf:about="test_uri"\/>/m
  end

  it "should include the RDF root tag and namespaces" do
    test_class.new("test_uri").to_rdf_xml.should =~ /<rdf:RDF xmlns:rdf="http:\/\/www.w3.org\/1999\/02\/22-rdf-syntax-ns#">.*<\/rdf:RDF>/m
  end

  it "should include attributes in the rdf" do
    c = test_class.new("test_uri")
    c.attributes = { "test_attribute" => "test_value" }
    c.to_rdf_xml.should =~ /<test_attribute>test_value<\/test_attribute>/m
  end

end