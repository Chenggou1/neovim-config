local M = {}

function M.setup(term_manager, resolve_cwd_fn)
	-- 主键位（使用终端管理器）
	vim.keymap.set("n", "<leader>tf", function()
		term_manager.toggle_terminal("float_term", resolve_cwd_fn)
	end, { desc = "浮动终端" })

	vim.keymap.set("n", "<leader>tn", function()
		local cwd = resolve_cwd_fn and resolve_cwd_fn() or vim.loop.cwd()
		local name = require("core.terminal_names").create(cwd)
		vim.cmd("TermNew dir=" .. vim.fn.fnameescape(cwd) .. " name=" .. name)
	end, { desc = "新建终端" })

	vim.keymap.set("n", "<leader>ts", "<cmd>TermSelect<CR>", { desc = "选择终端" })

	-- Terminal mode：使用 jk 退出到 Normal mode（保留 ESC 用于终端程序如 Claude Code）
	vim.keymap.set("t", "jk", [[<C-\><C-n>]], { noremap = true, desc = "退出终端模式" })
	vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "切换到左侧窗口" })
	vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "切换到右侧窗口" })
end

return M
