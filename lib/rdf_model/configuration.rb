module ::RdfModel
  class Configuration
    def load_rails_config_file(filename, environment)
      @config = YAML.load(File.open(filename))[environment]
      create_connection_pool
    end

    def [](key)
      @config[key]
    end

    private

    def create_connection_pool
      @config["connection-pool"] = ::RdfModel::Connection::Pool.new
    end
  end

  TRIPLESTORE_CONFIG = Configuration.new
end