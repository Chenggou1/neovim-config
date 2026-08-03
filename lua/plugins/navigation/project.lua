return {
	"DrKJeff16/project.nvim",
	version = "v6.0.0-1",
	event = "VeryLazy",
	config = function()
		require("project").setup({
			-- 自动检测并记录实际打开的项目
			manual_mode = false,
			lsp = {
				enabled = true,
				no_fallback = false,
			},
			-- 用于检测项目的文件/目录
			patterns = { ".git", "pyproject.toml", "package.json", "Cargo.toml", "Makefile", "CMakeLists.txt" },
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
