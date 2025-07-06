# frozen_string_literal: true

require_relative 'lib/kpass/version'

Gem::Specification.new do |spec|
  spec.name          = 'kpass'
  spec.version       = Kpass::VERSION
  spec.authors       = ['kk']
  spec.email         = ['kevin197011@outlook.com']

  spec.summary       = 'Convert KeePass CSV export to Bitwarden CSV format, and batch import/export Bitwarden vault items.'
  spec.description   = 'A simple CLI tool and library to convert KeePass CSV exports into Bitwarden-compatible CSV files, and batch import/export Bitwarden vault items via bw cli.'
  spec.homepage      = 'https://github.com/kevin197011/kpass'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb'] + ['README.md', 'LICENSE']
  spec.bindir        = 'exe'
  spec.executables   = ['kpass']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'csv', '~> 3.2'
  spec.add_runtime_dependency 'json', '~> 2.7'

  spec.add_development_dependency 'rspec', '~> 3.12'

  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/kevin197011/kpass/issues',
    'source_code_uri' => 'https://github.com/kevin197011/kpass',
    'changelog_uri' => 'https://github.com/kevin197011/kpass/blob/main/CHANGELOG.md',
    'documentation_uri' => 'https://github.com/kevin197011/kpass#readme'
  }
end
