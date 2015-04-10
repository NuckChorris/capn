# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capn/version'

Gem::Specification.new do |spec|
  spec.name          = "capn"
  spec.version       = Capn::VERSION
  spec.authors       = ["Peter Lejeck"]
  spec.email         = ["me@plejeck.com"]
  spec.summary       = %q{A crunchier alternative to ActiveModel::Serializers}
  spec.description   = <<-DESC
A fast and simple serializer framework with a similar DSL to
ActiveModel::Serializers.  Uses the Postgres JSON functions to generate JSON
quickly and avoid pointless ActiveModel object instantiation.
DESC
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
