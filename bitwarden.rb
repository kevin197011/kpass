# frozen_string_literal: true

# Copyright (c) 2025 Kk
# MIT License: https://opensource.org/licenses/MIT

require 'csv'
require 'json'
require 'open3'
require 'io/console'

class Bitwarden
  def initialize
    @session = get_bw_session
    ENV['BW_SESSION'] = @session
  end

  def get_bw_session
    print '🔐 解锁 Bitwarden，请输入主密码: '
    master_password = $stdin.noecho(&:gets).chomp
    puts

    stdout, stderr, status = Open3.capture3('bw', 'unlock', '--raw', stdin_data: "#{master_password}\n")
    if status.success?
      stdout.strip
    else
      puts "❌ 解锁失败: #{stderr}"
      exit 1
    end
  end

  def sanitize(str)
    str.to_s.strip.encode('UTF-8', invalid: :replace, undef: :replace)
  end

  def import(csv_file)
    puts '📥 开始批量导入账号...'

    CSV.foreach(csv_file, headers: true) do |row|
      name = sanitize(row['name'])
      username = sanitize(row['username'])
      password = sanitize(row['password'])
      url = sanitize(row['url'])

      # 获取模板
      template_json, stderr, status = Open3.capture3('bw get template item')
      unless status.success?
        puts "❌ 获取模板失败: #{stderr}"
        next
      end

      # 使用 jq 修改模板
      jq_filter = %(
        .name = "#{name}" |
        .type = 1 |
        .login.username = "#{username}" |
        .login.password = "#{password}" |
        .login.uris = [{"uri": "#{url}"}]
      )

      modified_json, stderr, status = Open3.capture3('jq', jq_filter, stdin_data: template_json)
      unless status.success?
        puts "❌ 修改模板失败: #{stderr}"
        next
      end

      # 编码
      encoded_json, stderr, status = Open3.capture3('bw encode', stdin_data: modified_json)
      unless status.success?
        puts "❌ 编码失败: #{stderr}"
        next
      end

      # 创建项目
      _, stderr, status = Open3.capture3('bw create item', stdin_data: encoded_json)
      if status.success?
        puts "✅ 成功添加 #{name}"
      else
        puts "❌ 添加失败 #{name}: #{stderr}"
      end
    end
  end

  def export(output_file)
    puts '📤 正在导出 vault 中的账号...'

    stdout, stderr, status = Open3.capture3('bw list items')
    unless status.success?
      puts "❌ 获取 items 失败: #{stderr}"
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
    puts "✅ 导出完成：#{output_file}"
  end
end

# 脚本入口
if __FILE__ == $PROGRAM_NAME
  bw = Bitwarden.new
  action = ARGV[0]
  file = ARGV[1]

  case action
  when 'import'
    bw.import(file)
  when 'export'
    bw.export(file)
  else
    puts '用法: ruby bitwarden.rb [import|export] [file]'
    puts '示例: ruby bitwarden.rb import accounts.csv'
  end
end
