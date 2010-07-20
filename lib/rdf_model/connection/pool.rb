require '4store-ruby'

module ::RdfModel::Connection
  class Pool
    def connection
      @connection = ::FourStore::Store.new(::RdfModel::TRIPLESTORE_CONFIG['sparql-uri']) unless @connection
      return @connection
    end
  end
end