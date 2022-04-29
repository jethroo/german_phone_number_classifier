# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'german_phone_number_classifier/version'

Gem::Specification.new do |spec|
  spec.name          = 'german_phone_number_classifier'
  spec.version       = GermanPhoneNumberClassifier::VERSION
  spec.authors       = ['Carsten Wirth']
  spec.email         = ['carsten.wirth@homeday.de']

  spec.required_ruby_version = '>= 2.7.0'

  spec.summary = 'Classifying german phone numbers'
  spec.description = 'Library for checking in which category a german phone' \
                     ' number falls in regards to Bundesnetzagentur classes.'
  spec.homepage      = 'https://github.com/jethroo/german_phone_number_classifier'
  spec.license       = 'MIT'

  # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/jethroo/german_phone_number_classifier'
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'phony', '~> 2.19.9'

  spec.add_development_dependency 'bundler', '~> 2.3'
  spec.add_development_dependency 'byebug', '~> 11.1.3'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'rubocop', '~> 1.25'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.10'
  spec.add_development_dependency 'simplecov', '~> 0.21.2'
  spec.add_development_dependency 'simplecov-console', '~> 0.9'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
