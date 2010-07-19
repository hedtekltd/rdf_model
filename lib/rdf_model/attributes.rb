module RdfModel::Attributes
  attr_accessor :attributes

  def initialize_with_attributes(rdf_attributes)
    self.attributes = {}
    rdf_attributes.each do |attr_pair|
      self.attributes[attr_pair['p']] = attr_pair['o']
    end
    define_attribute_methods
    initialize_without_attributes
  end

  def define_attribute_methods
    attributes.each do |name, value|
      class << self
        self
      end.send(:define_method, escape_attribute_name(name)) { process_attribute_value(name, value) }
    end
  end

  def escape_attribute_name(name)
    #this is a hook to allow other modules to intercept attribute names and process them when creating attribute methods
    name.to_sym
  end

  def process_attribute_value(name, value)
    #this is a hook to allow other modules to intercept and override attribute methods
    value
  end
  
  alias :initialize_without_attributes :initialize
  alias :initialize :initialize_with_attributes
end