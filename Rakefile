require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'yard/rake/yardoc_task'

RSpec::Core::RakeTask.new :test

YARD::Rake::YardocTask.new :doc do |t|
  t.files = ['lib/**', 'README.md']
  t.options = {
    markup: 'markdown'
  }
end
