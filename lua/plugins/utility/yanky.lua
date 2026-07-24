return {
	"gbprod/yanky.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		ring = {
			history_length = 30,
			storage = "shada",
			sync_with_numbered_registers = false,
			ignore_registers = { "_" },
		},
		system_clipboard = {
			-- 系统剪贴板继续由 <leader>y / <leader>p 独立管理。
			sync_with_ring = false,
		},
		highlight = {
			on_yank = true,
			on_put = true,
			timer = 300,
		},
		preserve_cursor_position = {
			enabled = true,
		},
	},
	keys = {
		{ "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "复制文本" },
		{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "粘贴到光标后" },
		{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "粘贴到光标前" },
		{ "<C-p>", "<Plug>(YankyPreviousEntry)", desc = "上一条复制历史" },
		{ "<C-n>", "<Plug>(YankyNextEntry)", desc = "下一条复制历史" },
		{ '<leader>"', "<cmd>Telescope yank_history<CR>", desc = "复制历史" },
	},
	config = function(_, opts)
		require("yanky").setup(opts)
		require("telescope").load_extension("yank_history")
	end,
}
