class ::RdfModel::Base
  attr_accessor :uri
  def initialize(uri, rdf_data)
    self.uri = uri
  end
  
  include ::RdfModel::Attributes
  include ::RdfModel::Sparql
  include ::RdfModel::Rdfizer
  include ::RdfModel::Prefixes
  include ::RdfModel::Vocabularies
  include ::RdfModel::Associations
  include ::RdfModel::Types
end