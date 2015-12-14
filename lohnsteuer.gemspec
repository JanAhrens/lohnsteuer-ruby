# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lohnsteuer/version'

Gem::Specification.new do |spec|
  spec.name          = "lohnsteuer"
  spec.version       = Lohnsteuer::VERSION
  spec.authors       = ["Jan Ahrens"]
  spec.email         = ["jan.ahrens+rubygems@googlemail.com"]
  spec.summary       = %q{German income tax calculation. Currently supports the official algorithms for 12/2015 and 2016.}
  spec.description   = ""
  spec.homepage      = "https://github.com/JanAhrens/lohnsteuer-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = '~> 2.0'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
