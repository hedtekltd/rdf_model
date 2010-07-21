#Bring in the railstie if we are in rails
require 'rails/rdf_model' if defined?(Rails)

#Load the configuration and connection classes first
require 'rdf_model/configuration'
require 'rdf_model/connection'

#Load the model modules
require 'rdf_model/sparql'
require 'rdf_model/associations'
require 'rdf_model/attributes'
require 'rdf_model/prefixes'
require 'rdf_model/types'
require 'rdf_model/vocabularies'

#Load the base class that ties the model together
require 'rdf_model/base'