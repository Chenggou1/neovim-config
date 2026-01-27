return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		current_line_blame = true, -- 显示当前行的 Git blame 信息

		-- 配置 Git 状态符号并启用行数显示
		signs = {
			add          = { text = '┃', show_count = true },
			change       = { text = '┃', show_count = true },
			delete       = { text = '▁', show_count = true },
			topdelete    = { text = '▔', show_count = true },
			changedelete = { text = '~', show_count = true },
			untracked    = { text = '┆', show_count = false }, -- 未跟踪文件不显示计数
		},

		-- 使用正常数字显示行数（移除 count_chars 以使用默认的正常大小数字 1 2 3）
	},
}
