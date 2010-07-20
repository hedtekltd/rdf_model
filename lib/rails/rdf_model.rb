require 'rdf_model'

class ::RdfModel::Railtie < ::Rails::Railtie
  railtie_name :rdfmodel_rails

  initializer "rdf_model.load_config" do |app|
    ::RdfModel::TRIPLESTORE_CONFIG = YAML.load(File.open(File.join(Rails.root, "config", "triplestore.yml")))[Rails.env]
  end
end