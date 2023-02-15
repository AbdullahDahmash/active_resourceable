require_relative "lib/active_resourceable/version"

Gem::Specification.new do |s|
  s.name        = "active_resourceable"
  s.version     = ActiveResourceable::VERSION
  s.authors     = "Abdullah Dahmash"
  s.email       = [ "a@and.sa" ]
  s.homepage    = "https://github.com/AbdullahDahmash/active_resourceable"
  s.summary     = "Active Resourceable"
  s.description = "A tiny framework built on top of Rails in order to help developers focus on writing important business logic. It should be used with hotwired"
  s.license     = "MIT"

  s.required_ruby_version = ">= 2.3.0"

  s.add_dependency "activesupport", ">= 7.0.0"
  s.add_dependency "actionpack", ">= 7.0.0"
  s.add_dependency "activejob", ">= 7.0.0"
  s.add_dependency "railties", ">= 7.0.0"
  s.add_dependency "procore-sift", ">= 0.16.0"
  s.add_dependency "pagy", ">= 6.0.0"
  s.add_dependency "activejob-uniqueness", ">= 0.2.4"

  s.files       = Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
end
