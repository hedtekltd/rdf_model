module ::RdfModel::Types
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def model_type(type = nil)
      @model_type = type if type
      return @model_type
    end

    def id_predicate(predicate = nil)
      @id_predicate = predicate if predicate
      return @id_predicate
    end

    def name_finder(predicates = nil, options = {})
      @name_finders ||= {}
      @name_finders.merge!(options)
      @name_finders[:selectors] = predicates if predicates
      return @name_finders
    end

    def find_all
      process_names(find_by_sparql(find_all_sparql_query))
    end

    private

    def selector
      return "?id #{name_order.map {|name| "?#{name}"}.join(" ")}"
    end

    def name_order
      name_finder[:order] || name_finder[:selectors].keys
    end

    def type_finder
      "?model rdf:type #{model_type}"
    end

    def id_finder
      "#{id_predicate} ?id"
    end

    def name_sparql
      name_finder[:selectors].map {|name, predicate| "#{predicate} ?#{name}"}.join(" ; ")
    end

    def find_all_sparql_query
      "SELECT #{selector} WHERE { #{type_finder} ; #{id_finder} ; #{name_sparql} }"
    end

    def process_names(results)
      results.map do |result|
        name = name_order.map {|name| result[name.to_s]}.join(" ")
        {"id" => result["id"], "name" => name}
      end
    end
  end
end