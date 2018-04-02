# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "thor-addons/version"

Gem::Specification.new do |spec|
  spec.name          = "thor-addons"
  spec.version       = ThorAddons::VERSION
  spec.authors       = ["Jacopo Scrinzi"]
  spec.email         = ["scrinzi.jcopo@gmail.com"]

  spec.summary       = "Thor CLI Add-ons"
  spec.description   = "Useful Add-ons Thor CLI"
  spec.homepage      = "https://github.com/eredi93/thor-addons"
  spec.license       = "MIT"

  spec.require_paths = ["lib"]

  spec.files = `git ls-files -z`.split("\x0")
    .reject { |f| f.match(%r{^(test|spec|features)/}) }

  spec.add_dependency "symbolized", "~> 0.0.1"
  spec.add_dependency "thor", "~> 0.19"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "climate_control"
  spec.add_development_dependency "gem-release"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
end
