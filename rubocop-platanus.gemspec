# frozen_string_literal: true

require_relative "lib/rubocop/platanus/version"

Gem::Specification.new do |spec|
  spec.name = "rubocop-platanus"
  spec.version = RuboCop::Platanus::VERSION
  spec.authors = %w(Platanus)
  spec.email = ["rubygems@platan.us"]
  spec.homepage = "https://github.com/platanus/rubocop-platanus"
  spec.summary = "A code checking and style enforcing tool."
  spec.description = "A RuboCop extension for enforcing Platanus best practices and code style."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      # rubocop: disable Layout/LineLength
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
      # rubocop: enable Layout/LineLength
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.3.11"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "rubocop", "~> 1.9"
  spec.add_runtime_dependency 'rubocop'
end
