lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_activemodel_validators/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_activemodel_validators"
  spec.version       = SimpleActiveModelValidators::VERSION
  spec.authors       = ["Decomplect Software LLP"]
  spec.email         = ["hello@decomplect.io"]

  spec.summary       = %(A collection of ActiveModel validators that don't pollute the global namespace.)
  spec.homepage      = "https://github.com/decomplect-io/simple_activemodel_validators"
  spec.license       = "MIT"
  spec.files = `git ls-files`.split($RS).reject do |file|
    file =~ %r{^(?:
    spec/.*
    |Gemfile
    |Rakefile
    |\.rspec
    |\.gitignore
    |\.rubocop.yml
    |\.travis.yml
    )$}x
  end
  spec.require_paths = ["lib"]
  spec.test_files = []
  spec.executables = []
  spec.extra_rdoc_files = ['LICENSE.txt', 'README.md']

  spec.add_dependency "activemodel", "~> 4.2"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rubocop", "~> 0.3"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "activerecord", "~> 4.2"
  spec.add_development_dependency "sqlite3", "~> 1.3"
  spec.add_development_dependency "yard", "~> 0.8"
  spec.add_development_dependency "redcarpet", "~> 3.3"
end
