# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jsonapi/consumer/version'

Gem::Specification.new do |spec|
  spec.name          = "jsonapi-consumer"
  spec.version       = Jsonapi::Consumer::VERSION
  spec.authors       = ["Justin Smestad"]
  spec.email         = ["justin.smestad@gmail.com"]
  spec.summary       = %q{JSONAPI client framework for API consumption.}
  spec.description   = %q{Create ActiveModel-compliant objects for your JSONAPI-based API}
  spec.homepage      = ""
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activemodel"
  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "faraday", "~> 0.9.0"
  spec.add_runtime_dependency "faraday_middleware"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "factory_girl"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "webmock"
end
