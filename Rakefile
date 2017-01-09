require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet_blacksmith/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

PuppetLint::RakeTask.new(:lint) do |config|
  config.fail_on_warnings = true
  config.ignore_paths = ['vendor/**/*', 'pkg/**/*']
end

Blacksmith::RakeTask.new do |t|
  t.tag_pattern = '%s'
end

desc 'Run syntax and lint checks'
task test: [
  :metadata_lint,
  :syntax,
  :lint
]
