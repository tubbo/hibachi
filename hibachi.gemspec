# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hibachi/version'

Gem::Specification.new do |spec|
  spec.name          = "hibachi"
  spec.version       = Hibachi::VERSION
  spec.authors       = ["Tom Scott"]
  spec.email         = ["tscott@weblinc.com"]

  spec.summary       = "An Object-Resource Mapper for Chef configuration."
  spec.description   = "#{spec.summary}"
  spec.homepage      = "http://github.com/tubbo/hibachi"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(/\Aspec/)
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'travis'
  spec.add_development_dependency 'codeclimate-test-reporter'

  spec.add_dependency 'rails'
  spec.add_dependency 'ridley'
  spec.add_dependency 'active_attr'
end
