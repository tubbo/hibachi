require 'bundler/setup'
require 'bundler'
require 'bundler/vendored_thor'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'
require 'hibachi/version'

RSpec::Core::RakeTask.new :spec

RuboCop::RakeTask.new :lint

YARD::Rake::YardocTask.new :doc

desc "Create a Git tag based on the gem version and push it to GitHub"
task :release do
  version = "v#{Hibachi::VERSION}"
  system "git tag #{version} && git push && git push --tags"
  Bundler.ui.confirm "Pushed hibachi #{version} to Git and CI"
end

task default: %i(lint spec)
