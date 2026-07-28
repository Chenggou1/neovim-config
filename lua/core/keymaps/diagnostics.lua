local M = {}

function M.setup()
	local keymap = vim.keymap.set
	local opts = { noremap = true, silent = true }
	keymap("n", "<leader>cd", function()
		-- 运行时解析函数，以使用 tiny-inline-diagnostic 对浮窗的协调包装。
		vim.diagnostic.open_float()
	end, vim.tbl_extend("force", opts, { desc = "诊断信息" }))
	keymap("n", "<leader>ck", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "上一个诊断" }))
	keymap("n", "<leader>cj", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "下一个诊断" }))
	-- keymap("n", "<leader>q", vim.diagnostic.setloclist, vim.tbl_extend("force", opts, { desc = "Diagnostics List" }))
end

return M
