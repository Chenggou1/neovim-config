return {
	"DrKJeff16/project.nvim",
	version = "v6.0.0-1",
	event = "VeryLazy",
	config = function()
		require("project").setup({
			-- 工作区根只由启动目录或项目选择器显式决定。
			-- LSP 和语言构建文件可以有各自的子 workspace，但不应自动修改 cwd。
			manual_mode = true,
			lsp = {
				enabled = false,
			},
			-- 仅供手动根目录检测使用，避免把 monorepo 内的语言 workspace 当成编辑器工作区。
			patterns = { ".git", ".hg", ".svn" },
			-- 排除工具链和插件内部目录，避免被记录为最近项目
			exclude_dirs = {
				-- 通用
				"~/.local/share/nvim/mason/*",
				"~/.rustup/*",

				-- macOS
				"/opt/homebrew",
			},
			-- 是否显示隐藏文件
			show_hidden = false,
			-- 静默 cd（不显示通知）
			silent_chdir = true,
			history = {
				save_dir = vim.fn.stdpath("data"),
				save_file = "project_history.json",
			},
		})

		-- 与 telescope 集成
		require("telescope").load_extension("projects")
	end,
}
