require 'rdf_model'

module ::RdfModel
  class Railtie < ::Rails::Railtie
    initializer "rdf_model.load_config" do |app|
      ::RdfModel::TRIPLESTORE_CONFIG.load_rails_config_file(File.join(Rails.root, "config", "triplestore.yml"), Rails.env)
    end
  end
end