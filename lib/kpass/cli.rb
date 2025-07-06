# frozen_string_literal: true

require_relative '../kpass'

module Kpass
  module CLI
    USAGE = <<~HELP
      Usage:
        kpass convert <input.csv> <output.csv>   # KeePass → Bitwarden CSV
        kpass import <input.csv>                 # Import CSV to Bitwarden vault
        kpass export <output.csv>                # Export Bitwarden vault to CSV
        kpass --help

      Options:
        -h, --help    Show this help message
    HELP

    def self.run(argv = ARGV)
      if argv.empty? || argv.include?('-h') || argv.include?('--help')
        puts USAGE
        return 0
      end

      cmd, *args = argv

      case cmd
      when 'convert'
        if args.size != 2
          warn USAGE
          return 1
        end
        input_file, output_file = args
        begin
          Kpass::Converter.convert(input_file, output_file)
          puts "✅ Conversion complete: #{output_file}"
          0
        rescue StandardError => e
          warn "❌ Error: #{e.message}"
          2
        end
      when 'import'
        if args.size != 1
          warn USAGE
          return 1
        end
        input_file = args[0]
        begin
          bw = Kpass::Bitwarden.new
          bw.import(input_file)
          0
        rescue StandardError => e
          warn "❌ Error: #{e.message}"
          2
        end
      when 'export'
        if args.size != 1
          warn USAGE
          return 1
        end
        output_file = args[0]
        begin
          bw = Kpass::Bitwarden.new
          bw.export(output_file)
          0
        rescue StandardError => e
          warn "❌ Error: #{e.message}"
          2
        end
      else
        warn USAGE
        1
      end
    end
  end
end
