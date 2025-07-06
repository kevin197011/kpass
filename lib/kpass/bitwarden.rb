# frozen_string_literal: true

require 'csv'
require 'json'
require 'open3'
require 'io/console'

module Kpass
  class Bitwarden
    def initialize
      @session = get_bw_session
      ENV['BW_SESSION'] = @session
    end

    def get_bw_session
      print '🔐 Unlock Bitwarden, enter master password: '
      master_password = $stdin.noecho(&:gets).chomp
      puts

      stdout, stderr, status = Open3.capture3('bw', 'unlock', '--raw', stdin_data: "#{master_password}\n")
      if status.success?
        stdout.strip
      else
        warn "❌ Unlock failed: #{stderr}"
        exit 1
      end
    end

    def sanitize(str)
      str.to_s.strip.encode('UTF-8', invalid: :replace, undef: :replace)
    end

    def import(csv_file)
      puts '📥 Importing accounts...'

      CSV.foreach(csv_file, headers: true) do |row|
        name = sanitize(row['name'])
        username = sanitize(row['username'])
        password = sanitize(row['password'])
        url = sanitize(row['url'])

        # Get template
        template_json, stderr, status = Open3.capture3('bw get template item')
        unless status.success?
          warn "❌ Get template failed: #{stderr}"
          next
        end

        # Use jq to modify template
        jq_filter = %(
          .name = "#{name}" |
          .type = 1 |
          .login.username = "#{username}" |
          .login.password = "#{password}" |
          .login.uris = [{"uri": "#{url}"}]
        )

        modified_json, stderr, status = Open3.capture3('jq', jq_filter, stdin_data: template_json)
        unless status.success?
          warn "❌ Modify template failed: #{stderr}"
          next
        end

        # Encode
        encoded_json, stderr, status = Open3.capture3('bw encode', stdin_data: modified_json)
        unless status.success?
          warn "❌ Encode failed: #{stderr}"
          next
        end

        # Create item
        _, stderr, status = Open3.capture3('bw create item', stdin_data: encoded_json)
        if status.success?
          puts "✅ Added #{name}"
        else
          warn "❌ Add failed #{name}: #{stderr}"
        end
      end
    end

    def export(output_file)
      puts '📤 Exporting vault accounts...'

      stdout, stderr, status = Open3.capture3('bw list items')
      unless status.success?
        warn "❌ Get items failed: #{stderr}"
        return
      end

      items = JSON.parse(stdout)

      CSV.open(output_file, 'w') do |csv|
        csv << %w[name username password url]
        items.each do |item|
          next unless item['type'] == 1

          login = item['login'] || {}
          name = sanitize(item['name'])
          username = sanitize(login['username'])
          password = sanitize(login['password'])
          url = login['uris']&.first&.dig('uri').to_s

          csv << [name, username, password, url]
        end
      end
      puts "✅ Export complete: #{output_file}"
    end
  end
end
