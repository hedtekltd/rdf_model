require '4store-ruby'

module ::RdfModel::Sparql
  def self.included(base)
    base.extend(ClassMethods)
    base.connection = ::FourStore::Store.new
  end

  module ClassMethods
    attr_accessor :connection
  end
end