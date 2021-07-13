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
  spec.homepage      = "https://github.com/jsmestad/jsonapi-consumer"
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", '>= 3.2'
  spec.add_runtime_dependency "faraday", '>= 0.9'
  spec.add_runtime_dependency "faraday_middleware"
  spec.add_runtime_dependency "addressable", '~> 2.8.0'
  spec.add_runtime_dependency "activemodel", '>= 3.2'
  spec.add_runtime_dependency "request_store", '>= 1.4'

  spec.add_development_dependency "webmock"
  spec.add_development_dependency "mocha"
end
