local opt = vim.opt

-- 编码设置（必须在最开始设置，确保所有插件正确处理字符）
opt.encoding = "utf-8" -- Neovim 内部编码
opt.fileencoding = "utf-8" -- 新建文件的默认编码
opt.fileencodings = "utf-8,gbk,gb2312,big5" -- 自动检测文件编码顺序

-- 行号设置
-- Normal 模式：相对行号（便于跳转，如 10j）
-- Insert 模式：绝对行号（便于定位具体行）
-- 动态切换由 nvim-numbertoggle 插件自动处理
opt.relativenumber = true -- 默认显示相对行号
opt.number = true -- 显示当前行的绝对行号

-- 缩进相关设置
-- 统一使用四个空格缩进，避免 Tab 与空格混用
opt.tabstop = 4 -- 一个 Tab 在编辑时相当于 4 个空格
opt.softtabstop = 4 -- 按下 Tab 键时插入 4 个空格
opt.shiftwidth = 4 -- 使用 >> 或自动缩进时移动 4 个空格
opt.expandtab = true -- 输入的 Tab 转换为空格
opt.smartindent = true -- 根据语法自动判断下一行的缩进
opt.autoindent = true -- 新行默认继承上一行的缩进

-- 其他体验设置
opt.cursorline = true -- 高亮当前行，提升可读性
opt.scrolloff = 999 -- 尽量让光标所在行保持在视口中间

-- 键位映射超时时间
opt.timeoutlen = 300 -- 等待按键序列完成的时间
opt.ttimeoutlen = 10 -- 等待键码序列完成的时间（影响 Esc 响应速度）

-- 启用鼠标，便于在终端中拖动和选择文本
opt.mouse:append("a") -- 在所有模式下都支持鼠标操作

-- 外观相关
opt.termguicolors = true -- 开启真彩色，配合主题使用效果更佳
opt.signcolumn = "yes" -- 始终显示左侧的符号列，避免文本跳动

require("core.gui").setup()
-- 默认不与系统剪贴板同步，避免 yy、dd 等操作污染剪贴板
-- 如需从系统剪贴板复制，可使用 <leader>y 等自定义按键
vim.o.clipboard = ""
-- 代码折叠由 nvim-ufo 插件管理，这里只保留基础的 treesitter 折叠表达式
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
