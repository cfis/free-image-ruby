# encoding: UTF-8
# !/usr/bin/env ruby

require "rubygems"
require "rake/testtask"
require "rubygems/package_task"
require "rdoc/task"
require "fileutils"
require "grancher"

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
  t.libs << "test"
  t.verbose = true
end

desc "Publish rdoc to Github"
task :grancher do
  gem 'win32-open3-19'
  require 'open3'
  require 'popen4'
  grancher = Grancher.new do |g|
    # push gh-pages
    g.branch  = 'gh-pages'
    # to origin
    g.push_to = 'origin'
    # copy the doc directory
    g.directory 'doc'
  end
  grancher.commit
  grancher.push if @grancher.push_to
end