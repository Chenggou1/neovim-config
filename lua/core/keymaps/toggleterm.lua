local M = {}

function M.setup(term_manager, resolve_cwd_fn)
	-- 主键位（使用终端管理器）
	vim.keymap.set("n", "<leader>t1", function()
		term_manager.toggle_terminal("term1", resolve_cwd_fn)
	end, { desc = "切换终端 1" })

	vim.keymap.set("n", "<leader>t2", function()
		term_manager.toggle_terminal("term2", resolve_cwd_fn)
	end, { desc = "切换终端 2" })

	vim.keymap.set("n", "<leader>tf", function()
		term_manager.toggle_terminal("float_term", resolve_cwd_fn)
	end, { desc = "浮动终端" })

	-- 彻底关闭（杀死）当前聚焦的 ToggleTerm 终端
	local function kill_focused_toggleterm()
		local termmod = require("toggleterm.terminal")
		local id = termmod.get_focused_id() or select(1, termmod.identify())
		if id then
			local term = termmod.get(id, true)
			if term and term.shutdown then
				term:shutdown()
				return
			end
		end
		-- 回退：不是 toggleterm 或未识别，执行普通 close
		pcall(vim.cmd, "close")
	end

	-- 彻底关闭全部 ToggleTerm 终端
	local function kill_all_toggleterms()
		local termmod = require("toggleterm.terminal")
		for _, term in ipairs(termmod.get_all(true)) do
			if term and term.shutdown then term:shutdown() end
		end
	end

	-- 只在 Normal mode 下使用 leader 键，避免 Terminal mode 下空格延迟
	vim.keymap.set("n", "<leader>tq", kill_focused_toggleterm, { desc = "关闭当前 ToggleTerm (kill)" })
	vim.keymap.set("n", "<leader>tQ", kill_all_toggleterms, { desc = "关闭全部 ToggleTerm (kill all)" })

	-- Terminal mode：使用 jk 退出到 Normal mode（保留 ESC 用于终端程序如 Claude Code）
	vim.keymap.set("t", "jk", [[<C-\><C-n>]], { noremap = true, desc = "退出终端模式" })
	vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "切换到左侧窗口" })
	vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "切换到右侧窗口" })
end

return M
