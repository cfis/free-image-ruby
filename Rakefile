# encoding: UTF-8
# !/usr/bin/env ruby

require "rubygems"
require "rake/testtask"
require "rubygems/package_task"
require "rdoc/task"
require "fileutils"

GEM_NAME = "free-image"

# Read the spec file
spec = Gem::Specification.load("#{GEM_NAME}.gemspec")

# Setup generic gem
Gem::PackageTask.new(spec) do |pkg|
  pkg.package_dir = 'pkg'
  pkg.need_tar    = false
end

# RDoc Task
desc "Generate rdoc documentation"
RDoc::Task.new("rdoc") do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = "FreeImage"
  # Show source inline with line numbers
  rdoc.options << "--line-numbers"
  # Use Hanna - this only works with RDoc 3.1 or greater
  rdoc.generator = 'hanna'
  # Make the readme file the start page for the generated html
  rdoc.main = 'cookbook.rdoc'
  rdoc.rdoc_files = FileList['HISTORY',
                             'LICENSE',
                             '*.rdoc',
                             'lib/**/*.rb']
end

desc "Setup Cookbook"
task :cookbook => :rdoc do
  FileUtils.cp_r("test/images", "doc/cookbook")
end

# Test Task
Rake::TestTask.new do |t|
  t.pattern = 'test/**/test_*.rb'
  t.libs << "lib"
  t.libs << "test"
  t.verbose = true
end

task default: :test