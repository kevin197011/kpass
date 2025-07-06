# frozen_string_literal: true

# Copyright (c) 2025 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

require 'time'
require_relative 'lib/kpass/version'

task default: %w[push]

task :push do
  system 'rubocop -A'
  system 'git update-index --chmod=+x push'
  system 'git add .'
  system "git commit -m 'Update #{Time.now}'"
  system 'git pull'
  system 'git push origin main'
end

task :dev do
  system 'gem build kpass.gemspec'
  system 'gem uninstall kpass -aIx'
  system "gem install --local kpass-#{Kpass::VERSION}.gem"
end
