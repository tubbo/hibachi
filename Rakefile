require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'yard'

RSpec::Core::RakeTask.new :test

YARD::Rake::YardocTask.new :doc do |t|
  t.options = %w(--markup=markdown)
end
