return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	cmd = "Neotree",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		"s1n7ax/nvim-window-picker",
	},

	keys = require("core.keymaps.neo_tree").keys,
	-- 只保留 config，不再写 opts
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true,
			enable_git_status = true,
			enable_diagnostics = false,

			-- ✨ 统一窗口设置
			window = {
				position = "left",
				width = 30,
				mappings = {
					-- w = "open_with_window_picker" (默认配置，无需显式声明)
					["t"] = "noop", -- 禁用在新标签页打开文件
				},
			},

			-- ✨ 文件系统设置
			filesystem = {
				bind_to_cwd = false,
				follow_current_file = { enabled = true },
				hijack_netrw_behavior = "open_current",
				filtered_items = {
					visible = false,
					hide_dotfiles = true,
					hide_gitignored = true,
					never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
						".DS_Store",
						"thumbs.db",
                        ".git"
					},
				},
			},

			-- ✨ Git 视图
			sources = { "filesystem", "git_status" },
			git_status = {
				window = { position = "left", width = 30 },
			},

			-- ✨ Git 符号
			default_component_configs = {
				git_status = {
					align = "right",
					symbols = {
						added = "+",
						modified = "~",
						removed = "-",
						renamed = ">",
						untracked = "?",
						ignored = "i",
						staged = "S",
						conflict = "!",
						unstaged = "?",
					},
				},
			},
		})
	end,
}
