return {
	"ahmedkhalf/project.nvim",
	event = "VeryLazy",
	config = function()
		require("project_nvim").setup({
			-- 检测项目根目录的模式
			detection_methods = { "pattern", "lsp" },
			-- 用于检测项目的文件/目录
			patterns = { ".git", "pyproject.toml", "package.json", "Makefile", "CMakeLists.txt" },
			-- 排除工具链和插件内部目录，避免被记录为最近项目
			exclude_dirs = {
				"~/.local/share/nvim/mason/*",
				"~/.rustup/*",
			},
			-- 是否显示隐藏文件
			show_hidden = false,
			-- 静默 cd（不显示通知）
			silent_chdir = true,
			-- 数据存储路径
			datapath = vim.fn.stdpath("data"),
		})

		-- 与 telescope 集成
		require("telescope").load_extension("projects")
	end,
}
