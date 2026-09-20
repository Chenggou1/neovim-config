# Neovim 快捷键指南

> Leader 键：`Space`

本文档描述自定义快捷键的组织方式和稳定入口，不复制插件的全部默认键位。
实际映射及其 `desc` 是唯一事实来源；按下 Leader 可通过 WhichKey 逐层浏览，
也可以运行 `:Telescope keymaps` 按键位或功能名称搜索当前可用映射。

## Leader 功能域

下面展示分组结构；保存、文件树等直接操作列在下一节。

```text
<leader>
├── b  标签页
├── c  Code
├── d  Diagnostics
├── f  Find
├── g  Git
│   └── m  Merge
├── k  Coding Agent
├── l  Links
├── m  Build（当前仅 CMake）
├── s  Shell
├── t  Test
├── x  Debug
└── z  Fold
```

一级前缀表达功能领域，后续按键表达动作。例如：

- `<leader>cf`：Code → Format
- `<leader>dn`：Diagnostics → Next
- `<leader>gmo`：Git → Merge → Ours
- `<leader>tn`：Test → Nearest
- `<leader>sn`：Shell → New

## 查找快捷键

- 按下 Leader，等待 WhichKey 显示当前层级。
- 继续输入分组键，逐层查看子节点。
- 运行 `:Telescope keymaps`，按描述、模式或键位模糊搜索。
- 使用 `:verbose nmap <按键>` 查询映射来源，例如 `:verbose nmap <leader>ca`。
- Buffer-local 映射只在对应上下文出现，例如 LSP、Rust 和 Diffview。

## 无分组的常用操作

| 快捷键 | 模式 | 功能 |
| --- | --- | --- |
| `jk` | Insert | 返回 Normal 模式 |
| `jk` | Terminal | 返回 Terminal-Normal 模式 |
| `<leader>w` | Normal | 保存当前文件 |
| `<leader>e` | Normal | 打开并聚焦文件树 |
| `<leader>o` | Normal | 打开启动面板；Alpha 加载后可用 |
| `<leader>y` | Normal/Visual | 复制到系统剪贴板 |
| `<leader>p` | Normal/Visual | 从系统剪贴板粘贴 |
| `<leader>"` | Normal | 搜索 Yanky 复制历史 |
| `<leader><Left>` | Normal | 返回上一位置 |
| `<leader><Right>` | Normal | 前进到下一位置 |
| `<leader>1`～`9` | Normal | 跳转到对应标签页 |
| `H` | Normal/Visual/Operator | 跳到行首非空白字符 |
| `L` | Normal/Visual/Operator | 跳到行尾 |

## `<leader>b`：标签页

| 快捷键 | 功能 |
| --- | --- |
| `<leader>bn` | 新建标签页并打开启动面板 |
| `<leader>bq` | 关闭当前标签页 |
| `<leader>b<Left>` | 上一个标签页 |
| `<leader>b<Right>` | 下一个标签页 |

## `<leader>c`：代码

| 快捷键 | 功能 | 上下文 |
| --- | --- | --- |
| `<leader>ca` | Code Action | LSP；Rust 中由 RustLsp 实现 |
| `<leader>cf` | 格式化当前 buffer | 全局 |
| `<leader>cm` | 展开宏 | Rust |
| `<leader>cn` | 重命名符号 | LSP |
| `<leader>co` | 切换代码大纲 | 全局 |
| `<leader>cr` | 保存并运行当前文件 | Python、Rust、C、C++ |

`:RunFile` 与 `<leader>cr` 等价：

- Python：在 uv 项目中执行 `uv run python <当前文件>`。
- Rust：运行 `src/main.rs` 或 `src/bin/<name>.rs` 对应的 Cargo binary。
- C/C++：编译并运行当前单文件，产物写入项目根目录 `.cache/nvim-run/`。
- 多文件或带外部依赖的 C/C++ 项目应使用构建系统。

## `<leader>d`：诊断

| 快捷键 | 功能 |
| --- | --- |
| `<leader>dd` | 查看当前诊断；Rust 中由 RustLsp 渲染 |
| `<leader>dn` | 下一个诊断 |
| `<leader>dp` | 上一个诊断 |

## `<leader>f`：查找

| 快捷键 | 功能 |
| --- | --- |
| `<leader>ff` | 查找文件 |
| `<leader>fg` | 全局搜索，需要 ripgrep |
| `<leader>fc` | 当前文件内搜索 |
| `<leader>ft` | 按 TODO/FIX/WARN 等标签查找注释 |

## `<leader>g`：Git

| 快捷键 | 模式 | 功能 |
| --- | --- | --- |
| `<leader>gg` | Normal | 打开 Git Graph |
| `<leader>gd` | Normal | 打开当前改动的 Diffview |
| `<leader>gf` | Normal | 查看当前文件历史 |
| `<leader>gf` | Visual | 查看选中行的历史 |
| `<leader>gF` | Normal | 查看整个项目历史 |

Diffview 三路合并中的 `<leader>gm` 子树：

| 快捷键 | 功能 |
| --- | --- |
| `<leader>gmo` | 当前冲突选择 OURS |
| `<leader>gmt` | 当前冲突选择 THEIRS |
| `<leader>gmb` | 当前冲突选择 BASE |
| `<leader>gma` | 当前冲突保留全部版本 |
| `<leader>gmO` | 整个文件选择 OURS |
| `<leader>gmT` | 整个文件选择 THEIRS |
| `<leader>gmB` | 整个文件选择 BASE |
| `<leader>gmA` | 整个文件保留全部版本 |
| `[x` / `]x` | 上一个 / 下一个冲突 |
| `dx` / `dX` | 删除当前冲突 / 整个文件的冲突区域 |

## `<leader>k`：Coding Agent

| 快捷键 | 模式 | 功能 |
| --- | --- | --- |
| `<leader>ks` | Normal | 选择并打开 Coding Agent |
| `<leader>kf` | Normal | 发送当前文件 |
| `<leader>kv` | Visual | 发送选区位置 |
| `<leader>kp` | Normal/Visual | 输入提示并发送上下文 |
| `<leader>kw` | Normal | 解释光标下的单词 |

## `<leader>l`：链接

| 快捷键 | 功能 |
| --- | --- |
| `<leader>ll` | 列出当前文件中的链接；回车复制 |
| `<leader>lc` | 复制光标下的链接 |
| `<leader>lo` | 复制并打开光标下的链接 |

## `<leader>m`：构建

`<leader>m` 已预留为跨语言构建系统入口，目前只实现 CMake。Cargo、uv 等适配器
将在统一构建模块完成后显式加入；不支持的动作不会回退到猜测命令。

| 快捷键 | 功能 |
| --- | --- |
| `<leader>mg` | CMake 生成/配置 |
| `<leader>mb` | CMake 构建 |
| `<leader>mr` | CMake 运行 |
| `<leader>mc` | CMake 清理 |
| `<leader>mt` | 选择构建目标 |
| `<leader>ml` | 选择运行目标 |
| `<leader>mp` | 选择构建预设 |
| `<leader>mA` | 设置目标参数和环境变量 |

## `<leader>s`：终端

| 快捷键 | 功能 |
| --- | --- |
| `<C-\>` | 打开或关闭默认终端，可加数字选择终端 |
| `<leader>sn` | 新建水平终端 |
| `<leader>sf` | 新建浮动终端 |
| `<leader>ss` | 选择已有终端 |

终端名称取自当前项目或目录；同名时追加编号。终端中使用 `jk` 返回
Terminal-Normal 模式，随后可按 `q` 隐藏终端。

## `<leader>t`：测试

测试由 Neotest 统一管理，当前显式支持 Python 和 Rust。其他文件类型会提示不支持，
不会回退到通用测试命令。

| 快捷键 | 功能 |
| --- | --- |
| `<leader>tn` | 运行光标附近的测试 |
| `<leader>tf` | 运行当前文件测试 |
| `<leader>ts` | 运行测试套件 |
| `<leader>tl` | 重新运行上次测试 |
| `<leader>td` | 使用 DAP 调试光标附近的测试 |
| `<leader>to` | 查看测试输出 |
| `<leader>tt` | 切换测试概览 |
| `<leader>tx` | 停止测试 |

Python 项目需要自行提供 pytest 或 unittest 等运行环境。Rust 测试复用
rustaceanvim 的 Neotest 适配器。

## `<leader>x`：调试

| 快捷键 | 模式 | 功能 |
| --- | --- | --- |
| `<leader>xb` | Normal | 切换断点 |
| `<leader>xB` | Normal | 设置条件断点 |
| `<leader>xp` | Normal | 设置日志点 |
| `<leader>xc` | Normal | 选择调试目标或继续执行 |
| `<leader>xs` | Normal | 进入临时步进模式 |
| `<leader>xt` | Normal | 终止调试 |
| `<leader>xl` | Normal | 重新运行上次配置 |
| `<leader>xr` | Normal | 打开调试 REPL |
| `<leader>xu` | Normal | 切换调试界面 |
| `<leader>xe` | Normal/Visual | 查看表达式 |

临时步进模式只在活动 DAP 会话中生效：`j` 跳过、`l` 进入、`h` 跳出、`c`
继续，`q` 或 `<Esc>` 退出步进模式。

DAP 会话结束后会保留调试界面和控制台输出；确认结果后使用 `<leader>xu` 手动关闭。

## `<leader>z`：折叠

| 快捷键 | 功能 |
| --- | --- |
| `<leader>zo` | 展开所有折叠 |
| `<leader>zc` | 关闭所有折叠 |
| `<leader>zz` | 切换当前折叠 |
| `<leader>zp` | 预览当前折叠内容 |

## 非 Leader 编辑与导航

### LSP 与文档

| 快捷键 | 功能 |
| --- | --- |
| `gd` | 跳转到定义 |
| `gD` | 跳转到声明 |
| `grr` | 查找引用 |
| `gri` | 跳转到实现 |
| `K` | 查看文档；已有浮窗时聚焦浮窗 |

### 窗口与跳转

| 快捷键 | 功能 |
| --- | --- |
| `<C-h/j/k/l>` | 在窗口或 tmux pane 间移动 |
| `s` | Flash 跳转 |
| `S` | Flash Treesitter 选择 |

### 注释、移动与复制历史

| 快捷键 | 功能 |
| --- | --- |
| `gcc` | 切换当前行注释 |
| `gbc` | 切换当前行块注释 |
| `gc` | Visual/Operator 注释 |
| `<A-h/j/k/l>` | 移动当前行或选区 |
| `<A-S-h/j/k/l>` | 复制当前行或选区并移动 |
| `y` / `p` / `P` | 使用 Yanky 复制或粘贴 |

### 已知按键冲突

Normal 模式的 `<C-n>` / `<C-p>` 当前同时用于 Hover 文档来源和 Yanky 复制历史。
Yanky 尚未加载时它们切换文档来源；首次使用 Yanky 后，它们会改为切换复制历史。
这组按键需要在后续迁移中拆分，不应视为稳定接口。

### 补全

| 快捷键 | 功能 |
| --- | --- |
| `<CR>` | 确认明确选中的补全项 |
| `<Tab>` / `<S-Tab>` | Snippet 占位符前进 / 后退 |
| `<Down>` / `<Up>` | 选择下一个 / 上一个补全项 |
| `<C-j>` / `<C-k>` | 选择下一个 / 上一个补全项 |
| `<C-n>` | 手动触发补全 |
| `<C-e>` | 关闭补全菜单 |
| `<C-b>` / `<C-f>` | 滚动补全文档 |

### Neovide

| 快捷键 | 功能 |
| --- | --- |
| `<C-=>` | 放大字体 |
| `<C-->` | 缩小字体 |
| `<C-0>` | 恢复默认字号 |

## 插件窗口

Neo-tree、Outline、Diffview、Neotest Summary 等插件窗口拥有各自的 buffer-local
键位。优先使用窗口内置的帮助（支持时按 `?`），其余可通过 `:h` 查询；这些默认键位
不在本文档中重复维护。
