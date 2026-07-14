return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cond = function()
		return vim.loop.fs_stat(vim.fn.stdpath("data") .. "/lazy/todo-comments.nvim") ~= nil
	end,
	event = { "BufReadPost", "BufNewFile" },
	cmd = { "TodoQuickFix", "TodoLocList", "TodoTelescope" },
	keys = {
		{
			"<leader>ft",
			function()
				require("core.todo_picker").open()
			end,
			desc = "按标签查找注释",
		},
	},
	opts = {
		signs = true,
	},
}
