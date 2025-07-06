<!--
 Copyright (c) 2025 Kk

 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

# Bitwarden CSV Import/Export

This Ruby project allows you to **batch import** and **export** login credentials to/from Bitwarden using Bitwarden CLI (`bw`).

## Requirements

- Ruby >= 2.5
- [Bitwarden CLI](https://bitwarden.com/) installed and authenticated
- CSV file for import (`accounts.csv`)

## Setup

1. Install dependencies:
   ```bash
    bundle install
   ```
2. Import accounts.csv:
   ```bash
    ruby bitwarden.rb import [file]
   ```
2. Export accounts.csv:
   ```bash
    ruby bitwarden.rb export [file]
   ```

# kpass

Convert KeePass CSV export to Bitwarden CSV format, and batch import/export Bitwarden vault items.

## Installation

```sh
gem install kpass
```

## Usage (CLI)

```sh
# KeePass → Bitwarden CSV
kpass convert input.csv output.csv

# Import CSV to Bitwarden vault
kpass import accounts.csv

# Export Bitwarden vault to CSV
kpass export output.csv
```

- `convert`：KeePass 导出 CSV 转 Bitwarden CSV
- `import`：批量导入 CSV 到 Bitwarden（需已安装并登录 bw cli）
- `export`：导出 Bitwarden vault 到 CSV

## Usage (Library)

```ruby
require 'kpass'
Kpass::Converter.convert('input.csv', 'output.csv')

bw = Kpass::Bitwarden.new
bw.import('accounts.csv')
bw.export('output.csv')
```

## License
MIT