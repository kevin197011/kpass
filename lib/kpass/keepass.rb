# frozen_string_literal: true

require 'csv'

module Kpass
  class Keepass
    # Convert a KeePass CSV to Bitwarden CSV
    # @param input_file [String] Path to KeePass CSV
    # @param output_file [String] Path to Bitwarden CSV
    def self.convert(input_file, output_file)
      CSV.open(output_file, 'w') do |csv_out|
        csv_out << %w[name username password url]
        CSV.foreach(input_file, headers: true) do |row|
          name     = row['Title']&.strip || ''
          username = row['Username']&.strip || ''
          password = row['Password']&.strip || ''
          url      = row['URL']&.strip || ''
          csv_out << [name, username, password, url]
        end
      end
    end
  end
end
