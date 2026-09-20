local M = {}

function M.setup(term_manager, resolve_cwd_fn)
	local function terminal_cwd()
		return resolve_cwd_fn and resolve_cwd_fn() or vim.loop.cwd()
	end

	vim.keymap.set("n", "<leader>sn", function()
		local cwd = terminal_cwd()
		local name = require("core.terminal_names").create(cwd)
		vim.cmd("TermNew dir=" .. vim.fn.fnameescape(cwd) .. " name=" .. name)
	end, { desc = "新建终端" })

	vim.keymap.set("n", "<leader>ss", "<cmd>TermSelect<CR>", { desc = "选择终端" })

	vim.keymap.set("n", "<leader>sf", function()
		local cwd = terminal_cwd()
		local name = require("core.terminal_names").create(cwd) .. "-float"
		vim.cmd("TermNew direction=float dir=" .. vim.fn.fnameescape(cwd) .. " name=" .. vim.fn.fnameescape(name))
	end, { desc = "新建浮动终端" })

	-- Terminal mode：使用 jk 退出到 Normal mode（保留 ESC 用于终端程序如 Claude Code）
	vim.keymap.set("t", "jk", [[<C-\><C-n>]], { noremap = true, desc = "退出终端模式" })
	vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "切换到左侧窗口" })
	vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "切换到右侧窗口" })
end

return M
