module ::RdfModel::Prefixes
  GLOBAL_PREFIXES = {
          :rdf => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
          :rdfs => "http://www.w3.org/2000/01/rdf-schema#"
  }
  def self.included(base)
    base.extend ClassMethods
    class << base
      alias :sparql_without_prefixing :sparql
      alias :sparql :sparql_with_prefixing
    end
  end

  module ClassMethods
    def prefix(prefixes = nil)
      @prefixes ||= {}
      if prefixes
        @prefixes.merge! prefixes
      end
      @prefixes.merge(superclass.respond_to?(:prefix) ? superclass.prefix : GLOBAL_PREFIXES) 
    end

    def sparql_with_prefixing(query)
      sparql_without_prefixing([generate_prefixes, escape_uris(query)].join(' '))
    end

    private

    def generate_prefixes
      prefix.map {|name, uri| "PREFIX #{name}: <#{uri}>"}.join(' ')
    end

    def escape_uris(query)
      prefix.inject(query) {|q, prefix| q.gsub(/#{prefix[1]}/, "#{prefix[0]}:")}
    end
  end
end