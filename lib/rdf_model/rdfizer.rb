require 'nokogiri'

module RdfModel::Rdfizer

  def serialise_attributes(xml)
    self.attributes.each do |k, v|
      xml.send(k.to_sym) {
        xml.text(v)
      }
    end
  end

  def to_rdf_xml
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.send(:"rdf:RDF", 'xmlns:rdf' => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#') {
        xml.send(:"rdf:Description", "rdf:about" => self.uri) {
          self.serialise_attributes(xml)
        }
      }
    end
    builder.to_xml
  end
end