return {
	"hedyhli/outline.nvim",
    lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	keys = {
		{ "<leader>a", "<cmd>Outline<CR>", desc = "代码大纲" },
	},
	opts = {
		-- 大纲窗口配置
		outline_window = {
			position = "right", -- 在右侧打开
		},
	},

