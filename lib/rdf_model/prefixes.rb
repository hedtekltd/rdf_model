module RdfModel::Prefixes
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
      @prefixes.merge(superclass.respond_to?(:prefix) ? superclass.prefix : {}) 
    end

    def sparql_with_prefixing(query)
      sparql_without_prefixing([generate_prefixes, escape_uris(query)].join(' '))
    end

    private

    def generate_prefixes
      @prefixes.map {|name, uri| "PREFIX #{name}: <#{uri}>"}.join(' ')
    end

    def escape_uris(query)
      @prefixes.inject(query) {|query, prefix| query.gsub(/#{prefix[1]}/, "#{prefix[0]}:")}
    end
  end
end