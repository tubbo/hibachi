require 'bundler/setup'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard/rake/yardoc_task'
require 'bundler/gem_helper'

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new :spec

RuboCop::RakeTask.new :lint

YARD::Rake::YardocTask.new :doc

desc "Run RuboCop and RSpec code examples"
task test: %i(lint spec)

task default: %i(build test doc)
