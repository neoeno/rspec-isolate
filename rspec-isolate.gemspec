
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rspec/isolate/version"

Gem::Specification.new do |spec|
  spec.name          = "rspec-isolate"
  spec.version       = Rspec::Isolate::VERSION
  spec.authors       = ["Kay Lack"]
  spec.email         = ["kay@herostrat.us"]

  spec.summary       = %q{Enforce isolation in your unit tests.}
  spec.homepage      = "https://www.github.com/neoeno/rspec-isolate"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
