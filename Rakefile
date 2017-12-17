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

desc 'Release a new version of the puppet module'
deps = %i[module:clean test build module:tag module:push module:bump_commit]
task :release => deps do
  puts 'Pushing to remote git repo'
  Blacksmith::Git.new.push!
end

desc 'Run syntax and lint checks'
task test: [
  :metadata_lint,
  :syntax,
  :lint
]

Rake::Task[:default].clear
task default: [:test]
