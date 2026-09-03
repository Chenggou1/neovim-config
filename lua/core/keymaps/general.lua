local M = {}

function M.setup()
	vim.g.mapleader = " "
	local utils = require("core.utils")

	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
	end

	-- Insert 模式：使用 jk 退出到 Normal 模式（保留 ESC 键用于其他工具）
	map("i", "jk", "<Esc>", "退出 Insert 模式")

	-- 手动保存当前文件
	map("n", "<leader>w", "<cmd>write<CR>", "保存当前文件")

	-- 使用 <leader>y 将选中文本复制到系统剪贴板
	map({ "n", "v" }, "<leader>y", '"+y', "复制到系统剪贴板")

	-- 使用 <leader>p 从系统剪贴板粘贴
	map({ "n", "v" }, "<leader>p", '"+p', "粘贴系统剪贴板")

	-- Normal、Visual 和 Operator-pending 模式：H 跳行首（^），L 跳行尾（$）
	map({ "n", "v", "o" }, "H", "^", "Jump to line start (non-blank)")
	map({ "n", "v", "o" }, "L", "$", "Jump to line end")

	-- 折叠快捷键由 nvim-ufo 插件统一管理
	require("core.run_file").setup()

	-- 历史导航：只在普通编辑窗口中后退/前进，避免影响 Diffview 等特殊视图
	local function jump_history(key)
		return function()
			if not utils.is_normal_file_buffer(0) or vim.wo.diff then
				return
			end

			local keys = vim.api.nvim_replace_termcodes(key, true, false, true)
			vim.api.nvim_feedkeys(keys, "n", false)
		end
	end

	map("n", "<leader><Left>", jump_history("<C-o>"), "返回上一位置")
	map("n", "<leader><Right>", jump_history("<C-i>"), "前进到下一位置")

	-- 标签页管理（Leader b 系列，解决 macOS Neovide 远程连接容器时 Alt 键失效问题）
	map("n", "<leader>bn", "<cmd>tabnew | Alpha<CR>", "新建标签页")
	map("n", "<leader>bq", "<cmd>tabclose<CR>", "关闭当前标签页")
	map("n", "<leader>b<Left>", "<cmd>tabprev<CR>", "上一个标签页")
	map("n", "<leader>b<Right>", "<cmd>tabnext<CR>", "下一个标签页")

	-- 快速跳转到指定标签页（Leader + 1-9，无描述以节省 which-key 空间）
	for i = 1, 9 do
		vim.keymap.set("n", "<leader>" .. i, i .. "gt", { noremap = true, silent = true })
	end
end

return M
