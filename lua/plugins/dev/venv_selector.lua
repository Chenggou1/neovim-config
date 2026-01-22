return {
	"linux-cultist/venv-selector.nvim",

	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-telescope/telescope.nvim",
	},

	-- 懒加载：仅在打开 Python 文件时加载
	ft = "python",

	-- 快捷键配置（与 lazy.nvim 集成，自动注册到 which-key）
	keys = {
		{
			"<leader>vs",
			"<cmd>VenvSelect<cr>",
			desc = "选择/激活 Python 虚拟环境",
			ft = "python",
		},
		{
			"<leader>vd",
			function()
				require("venv-selector").deactivate()
				vim.notify("已停用 Python 虚拟环境", vim.log.levels.INFO)
			end,
			desc = "停用 Python 虚拟环境",
			ft = "python",
		},
	},

	opts = {
		-- 使用 Telescope 选择器（已是依赖项）
		picker = "telescope",

		-- 自动在终端窗口中激活虚拟环境
		activate_venv_in_terminal = true,

		-- 启用缓存：记住每个目录的环境选择，下次自动激活
		enable_cached_venvs = true,
		cached_venv_automatic_activation = true,

		-- 激活时显示通知
		notify_user_on_venv_activation = true,

		-- 使用默认搜索路径（包括 .venv、poetry、conda 等）
		enable_default_searches = true,

		-- 搜索超时时间（毫秒）
		search_timeout = 5000,

		-- LSP 集成选项
		options = {
			-- 可选：环境激活后的回调函数
			on_venv_activate_callback = nil,
		},
	},
}
