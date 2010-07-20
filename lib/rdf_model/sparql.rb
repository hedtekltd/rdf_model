module ::RdfModel::Sparql
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def connection
      ::RdfModel::TRIPLESTORE_CONFIG['connection-pool'].connection
    end

    def find_by_sparql(query)
      connection.select(query)
    end

    def find_by_uri(uri)
      self.new(uri, self.find_by_sparql("SELECT ?p ?o WHERE { #{uri} ?p ?o }"))
    end

    def find_by_id(id)
      find_by_uri("#{id_prefix}:#{id}")
    end

    def find_by_predicate(predicate, uri)
      uris = find_by_sparql("SELECT ?uri WHERE { ?uri #{predicate} #{uri} }")
      uris.map{|u| find_by_uri(u["uri"])}
    end

    def id_prefix(prefix = nil)
      @id_prefix = prefix if prefix
      return @id_prefix
    end
  end
end