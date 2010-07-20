module ::RdfModel
  class Configuration
    def load_rails_config_file(filename, environment)
      @config = YAML.load(File.open(filename))[environment]
    end

    def [](key)
      @config[key]
    end
  end

  TRIPLESTORE_CONFIG = Configuration.new
end