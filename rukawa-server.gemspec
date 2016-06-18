# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rukawa/server/version'

Gem::Specification.new do |spec|
  spec.name          = "rukawa-server"
  spec.version       = Rukawa::Server::VERSION
  spec.authors       = ["joker1007"]
  spec.email         = ["kakyoin.hierophant@gmail.com"]

  spec.summary       = %q{Server for rukawa.}
  spec.description   = %q{Server for rukawa.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rukawa", "~> 0.5.1"
  spec.add_runtime_dependency "roda", "~> 2.15.0"
  spec.add_runtime_dependency "haml"
  spec.add_runtime_dependency "rufus-scheduler"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
