$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "spree_mailchimp/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "spree_mailchimp"
  s.version     = SpreeMailchimp::VERSION
  s.authors     = ["Charlie Hawker"]
  s.email       = ["charlie.hawker@staffordlong.co.uk"]
  s.homepage    = "https://github.com/staffordlong/spree_mailchimp"
  s.summary     = "Easily sync new and existing customers with a Mailchimp list"
  s.description = "Adds a mailchimp settings section to admin to push new customers to a given mailchimp list if they opt-in during checkout."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  # Runtime
  s.add_dependency('spree_core', '~> 3.1.0')
  s.add_dependency('gibbon', '~> 3.2.0')

  s.add_development_dependency "sqlite3"
end
