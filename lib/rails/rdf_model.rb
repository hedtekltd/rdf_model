require 'rdf_model'

class ::RdfModel::Railtie < ::Rails::Railtie
  railtie_name :rdfmodel_rails

  initializer "rdf_model.load_config" do |app|
    ::RdfModel::TRIPLESTORE_CONFIG.load_rails_config_file(File.join(Rails.root, "config", "triplestore.yml"), Rails.env)
  end
end