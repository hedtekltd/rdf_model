module ::RdfModel::Prefixes
  GLOBAL_PREFIXES = {
          :rdf => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
          :rdfs => "http://www.w3.org/2000/01/rdf-schema#"
  }

  def self.included(base)
    base.extend ClassMethods
    class << base
      alias :sparql_without_prefixing :find_by_sparql
      alias :find_by_sparql :sparql_with_prefixing
    end

    base.class_eval do
      #hooks into the attribute name escaping
      alias :escape_attribute_name_without_prefixing :escape_attribute_name
      alias :escape_attribute_name :escape_attribute_name_with_prefixing
    end
  end

  def xml_namespaces
    self.class.prefix.inject({}) do |xml_prefix_hsh, prefix|
      xml_prefix_hsh.merge({"xmlns:#{prefix[0]}" => prefix[1]})
    end
  end

  def escape_attribute_name_with_prefixing(name)
    self.class.prefix.each do |prefix_name, uri|
      if name =~ /#{Regexp.escape(uri)}/
        return escape_attribute_name_with_prefixing(name.gsub(uri, "#{prefix_name}_"))
      end
    end
    escape_attribute_name_without_prefixing(name)
  end

  module ClassMethods
    def prefix(prefixes = nil)
      @prefixes ||= {}
      if prefixes
        @prefixes.merge! prefixes
      end
      vocab_prefixes = {}
      if respond_to?(:vocabulary)
        vocabulary.each do |name, vocab|
          vocab_prefixes[:"vocab_#{name}"] = vocab.uri
        end
      end
      @prefixes.merge(superclass.respond_to?(:prefix) ? superclass.prefix : GLOBAL_PREFIXES).merge(vocab_prefixes)
    end

    def sparql_with_prefixing(query)
      sparql_without_prefixing([generate_prefixes, escape_uris(query)].join(' '))
    end

    def escape_uris(query)
      prefix.inject(query) {|q, prefix| q.gsub(/#{prefix[1]}/, "#{prefix[0]}:")}
    end

    private

    def generate_prefixes
      prefix.map {|name, uri| "PREFIX #{name}: <#{uri}>"}.join(' ')
    end
  end
end