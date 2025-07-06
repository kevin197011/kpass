# frozen_string_literal: true

require_relative 'kpass/converter'
require_relative 'kpass/bitwarden'
require_relative 'kpass/cli'
require_relative 'kpass/version'

module Kpass
  class Error < StandardError; end
end
