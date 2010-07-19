# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rdf_model}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Workman"]
  s.date = %q{2010-07-19}
  s.description = %q{An ORM for rails3 that allows the easy integration of rdf triplestores}
  s.email = %q{workmad3@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "Gemfile",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "features/rdf_model.feature",
     "features/step_definitions/rdf_model_steps.rb",
     "features/support/env.rb",
     "lib/rdf_model.rb",
     "lib/rdf_model/prefixes.rb",
     "lib/rdf_model/vocabularies.rb",
     "rdf_model.gemspec",
     "spec/rdf_model/prefixes_spec.rb",
     "spec/rdf_model/vocabularies_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/workmad3/rdf_model}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Object RDF Mapper for Rails 3}
  s.test_files = [
    "spec/rdf_model/attributes_spec.rb",
     "spec/rdf_model/prefixes_spec.rb",
     "spec/rdf_model/vocabularies_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 1.3.0"])
      s.add_development_dependency(%q<cucumber>, ["~> 0.8.4"])
      s.add_runtime_dependency(%q<activemodel>, ["~> 3.0.0.beta4"])
    else
      s.add_dependency(%q<rspec>, ["~> 1.3.0"])
      s.add_dependency(%q<cucumber>, ["~> 0.8.4"])
      s.add_dependency(%q<activemodel>, ["~> 3.0.0.beta4"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 1.3.0"])
    s.add_dependency(%q<cucumber>, ["~> 0.8.4"])
    s.add_dependency(%q<activemodel>, ["~> 3.0.0.beta4"])
  end
end

