require "./lib/yop"

Gem::Specification.new do |s|
  s.name          = "yop"
  s.version       = Yop.version
  s.date          = Time.now

  s.summary       = "Templates-based projects manager"
  s.description   = "Yop bootstraps your projects from pre-defined templates"
  s.license       = "MIT"

  s.author        = "Baptiste Fontaine"
  s.email         = "b@ptistefontaine.fr"
  s.homepage      = "https://github.com/bfontaine/Yop"

  s.files         = Dir["lib/*.rb", "lib/**/*.rb"]
  s.test_files    = Dir["tests/*.rb", "tests/**/*.rb"]
  s.require_path  = "lib"
  s.executables  << "yop"

  s.add_runtime_dependency "trollop",  "~> 2.1"

  s.add_development_dependency "simplecov", "~> 0.7"
  s.add_development_dependency "rake",      "~> 10.1"
  s.add_development_dependency "test-unit", "~> 2.5"
  s.add_development_dependency "fakeweb",   "~> 1.3"
  s.add_development_dependency "coveralls", "~> 0.7"
  s.add_development_dependency "rubocop",   "~> 0.28"
  s.add_development_dependency "rubygems-tasks", "~> 0.2.4"
end
