# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'faraday'
require 'faraday_bang/version'

Gem::Specification.new do |spec|
  spec.name          = "faraday_bang"
  spec.version       = Faraday::Bang::VERSION
  spec.authors       = ["Mark Bates"]
  spec.email         = ["mark@markbates.com"]
  spec.summary       = %q{Adds error raising ! methods to Farday.}
  spec.description   = %q{Adds error raising ! methods to Farday.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "minitest", '>=5.2.3'
end
