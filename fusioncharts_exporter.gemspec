$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fusioncharts_exporter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fusioncharts_exporter"
  s.version     = FusionchartsExporter::VERSION
  s.authors     = ["FusionCharts"]
  s.email       = ["mail@labs.fusioncharts.com"]
  s.homepage    = "https://github.com/fusioncharts/rails-exporter"
  s.summary     = "Fusioncharts Export Handler."
  s.description = "Rails engine to export fusioncharts into image and pdf."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", ">= 3.2"
  s.add_development_dependency "rspec-rails", "~> 3.1.0"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "simplecov"

end
