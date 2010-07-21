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

  class LoggerWrapper
    attr_accessor :logger

    def initialize(logger)
      self.logger = logger
    end

    def method_missing(method, *args, &block)
      self.logger.send(method, *args, &block)
    end
  end

  class NullLogger
    def method_missing(method, *args, &block)
      #Swallow all calls
    end
  end

  TRIPLESTORE_CONFIG = Configuration.new
  LOGGER = LoggerWrapper.new(NullLogger.new)
end