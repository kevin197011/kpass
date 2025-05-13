# frozen_string_literal: true

# Copyright (c) 2025 Kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

require 'csv'

# 将 KeePass 导出的 CSV 转换为 Bitwarden 格式
def convert_keepass_to_bitwarden(input_file, output_file)
  CSV.open(output_file, 'w') do |csv_out|
    # 写入 Bitwarden 所需的标题行
    csv_out << %w[name username password url]

    # 读取 KeePass 导出的 CSV 文件
    CSV.foreach(input_file, headers: true) do |row|
      # 提取并清理所需字段
      name     = row['Title']&.strip || ''
      username = row['Username']&.strip || ''
      password = row['Password']&.strip || ''
      url      = row['URL']&.strip || ''

      # 写入到新的 CSV 文件中
      csv_out << [name, username, password, url]
    end
  end
  puts "✅ 转换完成：#{output_file}"
end

# 主程序入口
if __FILE__ == $PROGRAM_NAME
  # if ARGV.size != 2
  #   puts "用法: ruby convert_keepass.rb <输入文件.csv> <输出文件.csv>"
  #   exit 1
  # end

  # input_file, output_file = ARGV
  convert_keepass_to_bitwarden('output.csv', 'output_bw.csv')
end
