# encoding: utf-8

Gem::Specification.new do |spec|
  spec.name        = 'free-image'
  spec.version     = '0.7.0'
  spec.summary     = 'Ruby Bindings for the Free Image Library'
  spec.description = <<-EOS
    FreeImage is an Open Source library project for developers who would like to support
    popular graphics image formats like PNG, BMP, JPEG, TIFF and others as needed by
    today's multimedia applications. FreeImage is easy to use, fast, multithreading
    safe, compatible with all 32-bit or 64-bit versions of Windows, and
    cross-platform (works both with Linux and Mac OS X).
  EOS
  spec.authors = [ 'Charlie Savage']
  spec.platform = Gem::Platform::RUBY
  spec.files = Dir.glob(['HISTORY',
                         'LICENSE',
                         'free-image.gemspec',
                         'Rakefile',
                         '*.rdoc',
                         'lib/**/*.rb',
                         'test/**/*'])
  spec.test_files = Dir.glob("test/test_*.rb")
  spec.required_ruby_version = '>= 1.8.7'
  spec.date = Time.now

  spec.add_dependency('ffi', '>=1.0.10')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('hanna-nouveau')
  spec.add_development_dependency('open4')
end