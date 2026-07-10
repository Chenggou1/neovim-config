return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cond = function()
		return vim.loop.fs_stat(vim.fn.stdpath("data") .. "/lazy/todo-comments.nvim") ~= nil
	end,
	event = { "BufReadPost", "BufNewFile" },
	cmd = { "TodoQuickFix", "TodoLocList", "TodoTelescope" },
	keys = {
		{ "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "查找 TODO" },
	},
	opts = {
		signs = true,
	},
}
