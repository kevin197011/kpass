# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'kpass'
  spec.version       = Kpass::VERSION
  spec.authors       = ['Your Name']
  spec.email         = ['your.email@example.com']

  spec.summary       = 'Convert KeePass CSV export to Bitwarden CSV format, and batch import/export Bitwarden vault items.'
  spec.description   = 'A simple CLI tool and library to convert KeePass CSV exports into Bitwarden-compatible CSV files, and batch import/export Bitwarden vault items via bw cli.'
  spec.homepage      = 'https://github.com/yourusername/kpass'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb'] + Dir['bin/*'] + ['README.md']
  spec.bindir        = 'bin'
  spec.executables   = %w[kpass kpass-convert]
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'csv'
  spec.add_runtime_dependency 'json'

  spec.required_ruby_version = '>= 2.7'
end
