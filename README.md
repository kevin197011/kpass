# kpass

> KeePass 与 Bitwarden 批量迁移/导入/导出工具（支持命令行与 Ruby 库调用）

---

## 项目简介

`kpass` 是一个用 Ruby 编写的命令行工具和库，支持 KeePass 导出 CSV 与 Bitwarden CSV 格式的互转，并可通过 Bitwarden CLI 实现批量导入、导出账号数据，适合密码管理器迁移、备份、自动化等场景。

- 支持 KeePass → Bitwarden CSV 格式转换
- 支持批量导入 CSV 到 Bitwarden 金库（需已安装并登录 `bw` CLI）
- 支持从 Bitwarden 金库批量导出账号为 CSV
- 支持命令行和 Ruby 代码调用

---

## 环境要求

- Ruby >= 3.2.0
- [Bitwarden CLI (bw)](https://bitwarden.com/help/cli/) 已安装并完成登录认证
- 系统需安装 [jq](https://stedolan.github.io/jq/)（用于处理 JSON）

---

## 安装方法

### 方式一：Gem 安装

```sh
gem install kpass
```

### 方式二：源码安装（开发/贡献者）

```sh
git clone https://github.com/kevin197011/kpass.git
cd kpass
bin/setup   # 安装依赖
```

---

## 使用方法

### 命令行用法

```sh
# 1. KeePass CSV 转 Bitwarden CSV
kpass keepass input.csv output.csv

# 2. 批量导入 CSV 到 Bitwarden
kpass import accounts.csv

# 3. 批量导出 Bitwarden 到 CSV
kpass export output.csv
```

- `keepass`：将 KeePass 导出的 CSV 转为 Bitwarden 兼容格式
- `import`：批量导入 CSV 到 Bitwarden（需已安装并登录 bw cli）
- `export`：导出 Bitwarden 金库所有账号到 CSV

### Ruby 库用法

```ruby
require 'kpass'
Kpass::Keepass.convert('input.csv', 'output.csv')

bw = Kpass::Bitwarden.new
bw.import('accounts.csv')
bw.export('output.csv')
```

---

## CSV 文件格式说明

### Bitwarden CSV 示例

```csv
name,username,password,url
My Example11,user,pass,https://example.com
My Example12,user,pass,https://example.com
```

### KeePass 导出 CSV 要求
- 须包含 `Title,Username,Password,URL` 字段
- 建议用官方 KeePass 导出功能生成

---

## 安全提示
- **请勿将包含明文密码的 CSV 文件上传到云端或泄露给他人！**
- 导入/导出操作均需本地 Bitwarden CLI 已解锁金库，主密码不会被保存
- 建议操作完成后及时删除临时 CSV 文件

---

## 开发与贡献

- 依赖管理：`bundle install` 或 `bin/setup`
- 本地开发：`rake dev` 可自动 build & 安装本地 gem
- 代码风格：建议使用 RuboCop 检查
- 单元测试：后续补充 RSpec 测试

---

## 许可证

MIT License © 2025 kevin197011