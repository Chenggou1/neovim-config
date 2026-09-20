# Neovim 配置

## 项目简介

一套轻量、易扩展的 Neovim 配置，开箱即用，适合日常编码与学习。

## 主要特性与插件

- 🐬 **启动面板**：alpha-nvim 启动界面，海豚 ASCII 艺术，最近项目快速访问
- 🎨 **外观**：Rosé Pine Moon 主题，which-key 快捷键提示
- 🔧 **开发工具**：LSP (Pyright/clangd/jsonls/marksman/buf)，智能补全
- 📂 **导航**：neo-tree 文件树，Telescope 模糊搜索，Flash 快速跳转，项目管理
- 🐍 **Python 支持**：uv 负责项目运行与依赖管理，Pyright 提供类型检查与补全
- 🌿 **Git 集成**：gitsigns 状态显示，diffview 可视化 diff 工具
- 🖥️ **终端管理**：toggleterm 多终端支持
- 🧪 **测试**：Neotest 统一运行 Python 与 Rust 测试
- 📐 **代码折叠**：基于 Tree-sitter 的智能折叠
- 🎯 **快速跳转**：flash.nvim 增强 f/t 跳转，支持可视化标签
- 💾 **工作区恢复**：重新打开目录时自动恢复文件、阅读位置、窗口布局和 Neo-tree 状态
- 📋 **复制历史**：Yanky 保存最近 30 条复制内容，可搜索并切换历史粘贴
- 🌐 **输入法切换**：离开 Insert 模式时自动切换英文，重新进入时恢复此前的输入法

详细插件列表请查看：**[docs/PLUGINS.md](docs/PLUGINS.md)**

## 环境要求

### 基础环境

- **Neovim** ≥ 0.11（必须）

### 需要手动安装的工具

以下工具不会由本配置通过 Mason 管理，需要通过系统包管理器手动安装：

| 工具 | 用途 | 是否必须 | 安装方式 |
|------|------|---------|---------|
| **Git** | 克隆配置、安装插件和 Git 集成功能 | 必须 | `brew install git` / `apt install git` |
| **Node.js** | Mason 安装部分工具的依赖 | 必须 | `brew install node` / [官网下载](https://nodejs.org/) |
| **uv** | Python 项目与虚拟环境管理 | 开发 Python 时必须 | `brew install uv` / [官方安装说明](https://docs.astral.sh/uv/getting-started/installation/) |
| **C/C++ 工具链** | 编译 Tree-sitter parser，以及运行/调试独立 C/C++ 文件 | 必须 | `xcode-select --install` (macOS) / `apt install build-essential` (Linux) |
| **clangd** | C/C++ LSP | 开发 C/C++ 时必须 | Xcode Command Line Tools (macOS) / `apt install clangd` (Linux) |
| **clang-format** | 格式化 C/C++ | 格式化 C/C++ 时必须 | `brew install clang-format` / `apt install clang-format` |
| **LLDB / lldb-dap** | 调试 C/C++ | 调试 C/C++ 时必须 | Xcode/LLVM (macOS) / `apt install lldb` (Linux) |
| **CMake** | 使用 `<leader>m` 构建 CMake 项目 | 使用 CMake 时必须 | `brew install cmake` / `apt install cmake` |
| **Rust 工具链** | 运行、测试 Rust，并提供 rust-analyzer | 开发 Rust 时必须 | [rustup 官方安装说明](https://rustup.rs/) |
| **ripgrep** | Telescope 全局搜索 | 强烈推荐 | `brew install ripgrep` / `apt install ripgrep` |
| **cppman** | 在 C++ hover 中查看 cppreference 手册与示例 | 开发 C++ 时推荐 | `brew install cppman` / `apt install cppman` |
| **Nerd Font** | 图标显示 | 推荐 | 下载 [JetBrainsMono Nerd Font](https://www.nerdfonts.com/) |
| **输入法后端** | Normal 模式自动切换英文 | 使用中文等输入法时推荐 | macOS: `macism`；Windows/WSL: `im-select.exe`；Linux: Fcitx5/Fcitx/IBus |

**快速安装**：
```bash
# macOS
brew install git node uv ripgrep cppman clang-format cmake
xcode-select --install  # 安装 C 编译器
brew install --cask font-jetbrains-mono-nerd-font

# Ubuntu/Debian
sudo apt install git nodejs build-essential clangd clang-format lldb cmake ripgrep
```

### 自动管理的开发工具 ✅

Mason 会自动安装缺失的 LSP；格式化工具会在 Neovim 启动约 3 秒后检查并安装：

- **LSP 服务器**：pyright, jsonls, marksman
- **开发工具**：stylua, prettier, ruff, buf (Protocol Buffers LSP+formatter)

`clangd` 和 `rust-analyzer` 不由 Mason 管理，需按上表安装。

💡 **提示**：首次启动后可通过 `:Mason` 查看所有工具的安装状态。

## 快速上手

1. **克隆仓库**
   - **Linux/macOS**
     ```bash
     git clone https://github.com/Chenggou1/neovim-config.git ~/.config/nvim
     ```
   - **Windows**
     ```powershell
     git clone https://github.com/Chenggou1/neovim-config.git $Env:LOCALAPPDATA\nvim
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
| `<leader>ll` | 列出并复制当前文件中的链接 |
| `<leader>lc` | 复制光标下的链接 |
| `<leader>lo` | 复制并打开光标下的链接 |
| `<leader>"` | 查看复制历史 |
| `<A-j>` / `<A-k>` | 向下/向上移动当前行或选区 |
| `<leader>ks` | 选择并打开 Coding Agent |
| `<leader>kv` | 发送 Visual 选区的文件及行列范围 |
| `<leader>cf` | 格式化代码 |
| `<leader>co` | 打开代码大纲 |
| `<leader>cr` | 保存并运行当前 Python、Rust、C 或 C++ 文件 |
| `<leader>tn` | 运行光标附近的 Python 或 Rust 测试 |
| `<leader>tt` | 切换测试概览 |
| `<leader>sn` | 新建终端 |
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

## 运行测试

使用 `<leader>tn` 运行光标附近的测试，或使用 `<leader>tt` 打开测试概览。
当前显式支持 Python 和 Rust；其他文件类型会提示不支持，不会猜测或回退到通用测试命令。
Python 项目需要自行提供测试框架，例如运行 `uv add --dev pytest`；Rust 测试使用项目的 Cargo 工具链。
完整测试键位请查看 [快捷键速查表](docs/KEYMAPS.md)。

## 调试代码

使用 `<leader>xc` 启动或继续调试。首次调试 C/C++ 文件时会显示目标选择菜单；当前提供“调试当前文件”，确认后使用 `cc` / `c++` 和 `-g -O0` 自动编译，再通过系统 `lldb-dap` 启动。调试产物存放于项目根目录 `.cache/nvim-debug/`，不依赖 CMake。

调试前请确认 `lldb-dap` 在 `PATH` 中。macOS 安装 Xcode Command Line Tools 后通常已经提供；Linux 请通过发行版的 LLVM/LLDB 软件包安装。
Python 调试通过项目的 uv 环境启动；项目需自行安装 debugpy，例如运行 `uv add --dev debugpy`。

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
