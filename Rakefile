#!/usr/bin/env ruby

require "rubygems"
require "rake/testtask"
require "rubygems/package_task"
require "rdoc/task"

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
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.title    = "FreeImage"
  # Show source inline with line numbers
  rdoc.options << "--line-numbers"
  # Make the readme file the start page for the generated html
  rdoc.main = 'README.rdoc'
end

# Test Task
Rake::TestTask.new do |t|
  t.libs << "test"
  t.verbose = true
end