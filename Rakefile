require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RuboCop::RakeTask.new

task default: %w(spec rubocop)
