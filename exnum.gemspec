# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exnum/version'

Gem::Specification.new do |spec|
  spec.name          = "exnum"
  spec.version       = Exnum::VERSION
  spec.authors       = ["Kta-M"]
  spec.email         = ["mohri1219@gmail.com"]

  spec.summary       = %q{Enum Extention for Rails}
  spec.description   = %q{Enum Extention for Rails}
  spec.homepage      = "https://github.com/Kta-M/exnum"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activerecord'
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "sqlite3", "~> 1.0"
  spec.add_development_dependency "pry-rails"
  spec.add_development_dependency "codeclimate-test-reporter"
end
