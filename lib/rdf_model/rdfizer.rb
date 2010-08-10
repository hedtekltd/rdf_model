require 'nokogiri'

module RdfModel::Rdfizer

  def serialise_attributes(xml)
    self.attributes.each do |k, v|
      xml.send(escape_uris(k).to_sym) {
        xml.text(escape_uris(v))
      }
    end
  end

  def to_rdf_xml
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.send(:"rdf:RDF", self.xml_namespaces()) {
        xml.send(:"rdf:Description", "rdf:about" => self.uri) {
          self.serialise_attributes(xml)
        }
      }
    end
    builder.to_xml
  end
end