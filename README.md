# Neovim 配置

## 项目简介

一套轻量、易扩展的 Neovim 配置，开箱即用，适合日常编码与学习。

## 主要特性与插件

- 🐬 **启动面板**：alpha-nvim 启动界面，海豚 ASCII 艺术，最近项目快速访问
- 🎨 **外观**：Rosé Pine Moon 主题，which-key 快捷键提示
- 🔧 **开发工具**：LSP (Pyright/clangd/jsonls/marksman/buf)，智能补全
- 📂 **导航**：neo-tree 文件树，Telescope 模糊搜索，Flash 快速跳转，项目管理
- 🐍 **Python 支持**：uv 管理项目 `.venv`，Pyright 提供类型检查与补全
- 🌿 **Git 集成**：gitsigns 状态显示，diffview 可视化 diff 工具
- 🖥️ **终端管理**：toggleterm 多终端支持
- 📐 **代码折叠**：基于 Tree-sitter 的智能折叠
- 🎯 **快速跳转**：flash.nvim 增强 f/t 跳转，支持可视化标签
- 💾 **工作区恢复**：重新打开目录时自动恢复文件、阅读位置、布局、Neo-tree 和 Codex 窗口
- 📋 **复制历史**：Yanky 保存最近 30 条复制内容，可搜索并切换历史粘贴
- 🌐 **输入法切换**：离开 Insert 模式时自动切换英文，重新进入时恢复此前的输入法

详细插件列表请查看：**[docs/PLUGINS.md](docs/PLUGINS.md)**

## 环境要求

### 基础环境

- **Neovim** ≥ 0.11（必须）

### 需要手动安装的工具

以下工具无法通过 Mason 自动安装，需要通过系统包管理器手动安装：

| 工具 | 用途 | 是否必须 | 安装方式 |
|------|------|---------|---------|
| **Node.js** | Mason 安装部分工具的依赖 | 必须 | `brew install node` / [官网下载](https://nodejs.org/) |
| **uv** | Python 项目与虚拟环境管理 | 开发 Python 时必须 | `brew install uv` / [官方安装说明](https://docs.astral.sh/uv/getting-started/installation/) |
| **C 编译器** | tree-sitter 编译语法解析器 | 必须 | `xcode-select --install` (macOS) / `apt install build-essential` (Linux) |
| **ripgrep** | Telescope 全局搜索 | 强烈推荐 | `brew install ripgrep` / `apt install ripgrep` |
| **Nerd Font** | 图标显示 | 推荐 | 下载 [JetBrainsMono Nerd Font](https://www.nerdfonts.com/) |
| **输入法后端** | Normal 模式自动切换英文 | 使用中文等输入法时推荐 | macOS: `macism`；Windows/WSL: `im-select.exe`；Linux: Fcitx5/Fcitx/IBus |

**快速安装**：
```bash
# macOS
brew install node uv ripgrep
xcode-select --install  # 安装 C 编译器
brew install --cask font-jetbrains-mono-nerd-font

# Ubuntu/Debian
sudo apt install nodejs build-essential ripgrep
```

### Mason 自动安装的工具 ✅

以下工具会在 Neovim 启动后 3 秒自动安装，**无需手动操作**：

**LSP 服务器**：pyright, jsonls, marksman, clangd
**开发工具**：stylua, prettier, ruff, buf (Protocol Buffers LSP+formatter)

💡 **提示**：首次启动后可通过 `:Mason` 查看所有工具的安装状态。

## 快速上手

1. **克隆仓库**
   - **Linux/macOS**
     ```bash
     git clone https://github.com/chenggouA/neovim-config.git ~/.config/nvim
     ```
   - **Windows**
     ```powershell
     git clone https://github.com/chenggouA/neovim-config.git $Env:LOCALAPPDATA\nvim
     ```
2. **首次启动**
   打开 Neovim，`lazy.nvim` 与所有插件会自动安装。安装完成后即可使用。

## 配置说明

- `init.lua`：入口文件，加载基础选项与插件
- `lua/core/`：核心配置，如选项、工具函数、Python 支持等
- `lua/plugins/`：插件定义与自定义配置

## 快捷键速览

> Leader 键：`Space`（空格）

### 常用快捷键

| 快捷键 | 功能 |
|--------|------|
| `<leader>o` | 打开启动面板 |
| `<leader>e` | 打开/聚焦文件树 |
| `<leader>ff` | 查找文件 |
| `<leader>fg` | 全局搜索 |
| `<leader>ft` | 按标签查找注释 |
| `<leader>fl` | 查找并复制当前文件中的链接 |
| `<leader>cl` | 复制光标下的链接 |
| `<leader>cL` | 复制并打开光标下的链接 |
| `<leader>"` | 查看复制历史 |
| `<A-j>` / `<A-k>` | 向下/向上移动当前行或选区 |
| `<leader>ks` | 选择并打开 Coding Agent |
| `<leader>kv` | 发送 Visual 选区的文件及行列范围 |
| `<leader>cf` | 格式化代码 |
| `<leader>cr` | 保存并运行当前 Python、Rust、C 或 C++ 文件 |
| `<leader>cn` | LSP 重命名 |
| `<leader>ca` | 代码操作 |
| `grr` | LSP 查找引用 |
| `gri` | LSP 跳转到实现 |
| `s` | Flash 快速跳转 |

完整的快捷键速查表请查看：**[docs/KEYMAPS.md](docs/KEYMAPS.md)**

## 运行代码

使用 `<leader>cr` 或 `:RunFile` 保存并运行当前文件，输出显示在 toggleterm 中：

- Python：仅限 uv 项目，执行 `uv run python <当前文件>`，无需激活虚拟环境。
- Rust：支持 `src/main.rs` 和 `src/bin/<name>.rs`，运行对应的 Cargo binary。
- C/C++：独立编译当前文件，产物存放于项目根目录 `.cache/nvim-run/`。

多文件、外部依赖或 CMake target 不会自动推断；请使用 CMake 快捷键运行这类 C/C++ 项目。

clangd 同时支持项目与独立 C/C++ 文件：优先使用编译数据库、编译 flags 或 Git 根目录；没有这些标记时以当前文件目录启动。诊断默认以代码下划线显示。

## 常见问题 / 排错

- **tree-sitter 编译失败**：确认已安装 GCC/Clang 等 C 编译器。
- **系统剪贴板未同步**：默认不与系统剪贴板共享，可使用 `<leader>y` 复制、`<leader>p` 粘贴。
- **如何安全关闭 Neovide**：推荐使用 `:wqa` 保存全部文件并退出，或确认无需保存后使用 `:qa!`。正常退出时会自动保存当前目录的会话。
- **为什么指定文件时没有恢复工作区**：只有直接打开目录且未指定文件时才自动恢复，显式文件参数会被优先保留。
- **Rust LSP 不工作**：需手动安装 rust-analyzer，Mason 不负责管理。安装方式：
  ```bash
  rustup component add rust-analyzer
  ```
- **独立 C/C++ 文件没有诊断**：确认 `clangd` 在 `PATH` 中；打开文件后，clangd 会自动以文件所在目录启动。

## 升级与维护

- 使用 `:Lazy sync` 或 `:Lazy update` 更新插件
- 建议在升级前备份 `lazy-lock.json`

## 许可证与致谢

本项目基于 [MIT 许可证](LICENSE) 开源。
感谢所有开源插件作者的贡献。
