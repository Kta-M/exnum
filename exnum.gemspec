# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exnum/version'

Gem::Specification.new do |spec|
  spec.name          = "exnum"
  spec.version       = Exnum::VERSION
  spec.authors       = ["Kta-M"]
  spec.email         = ["mohri1219@gmail.com"]

  spec.summary       = %q{Enum extention for Rails}
  spec.description   = %q{Exnum is enum extention for Rails. This gem extends enum about i18n and associated parameters.}
  spec.homepage      = "https://github.com/Kta-M/exnum"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activerecord', "~> 7.0"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "pry-rails"
  spec.add_development_dependency "simplecov"
end
