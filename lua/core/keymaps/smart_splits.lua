local M = {}

function M.setup(ss)
	local map = vim.keymap.set
	-- 窗口间光标移动
	map("n", "<C-h>", ss.move_cursor_left)
	map("n", "<C-j>", ss.move_cursor_down)
	map("n", "<C-k>", ss.move_cursor_up)
	map("n", "<C-l>", ss.move_cursor_right)
end

return M
