module ::RdfModel::Sparql
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def connection
      ::RdfModel::TRIPLESTORE_CONFIG['connection-pool'].connection
    end
  end
end