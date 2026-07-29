return {
	"keaising/im-select.nvim",
	event = "VeryLazy",
	opts = {
		-- 各平台自动选择后端：
		-- macOS: macism
		-- Windows/WSL: im-select.exe
		-- Linux: fcitx5-remote、fcitx-remote 或 ibus
		set_default_events = { "InsertLeave", "CmdlineLeave" },
		set_previous_events = { "InsertEnter" },
		async_switch_im = true,
		keep_quiet_on_no_binary = false,
	},
}
