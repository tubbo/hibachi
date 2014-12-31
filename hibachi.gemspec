# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hibachi/version'

Gem::Specification.new do |spec|
  spec.name          = "hibachi"
  spec.version       = Hibachi::VERSION
  spec.authors       = ["Tom Scott"]
  spec.email         = ["tscott@telvue.com"]
  spec.summary       = %q{A Rails model layer for your Chef configuration.}
  spec.description   = "#{spec.summary} Control your Chef configs with Rails."
  spec.homepage      = "http://github.com/tubbo/hibachi"
  spec.license       = "All Rights Reserved"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails'
  spec.add_dependency 'ridley'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'redcarpet' # for docs in markdown
  spec.add_development_dependency 'sqlite3' # for the dummy app
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
end
