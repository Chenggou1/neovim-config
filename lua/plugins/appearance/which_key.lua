return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		win = { border = "rounded" },
		layout = { spacing = 6, align = "center" },
		icons = {
			mappings = false, -- 禁用自动图标
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.add({
			-- 键位组
			{ "<leader>a", group = "大纲" },
			{ "<leader>b", group = "标签页" },
			{ "<leader>c", group = "代码" },
			{ "<leader>d", group = "Diff" },
			{ "<leader>f", group = "查找" },
			{ "<leader>g", group = "Git" },
			{ "<leader>k", group = "Codex / AI" },
			{ "<leader>m", group = "CMake" },
			{ "<leader>r", group = "运行" },
			{ "<leader>t", group = "终端" },
			{ "<leader>z", group = "折叠" },

			-- g 开头的注释快捷键（Comment.nvim）
			{ "gc", group = "注释" },
			{ "gcc", desc = "注释/取消注释当前行" },
			{ "gbc", desc = "块注释当前行" },
			{ "gco", desc = "在下方插入注释" },
			{ "gcO", desc = "在上方插入注释" },
			{ "gcA", desc = "在行尾添加注释" },

			-- Neovim 原生 LSP 快捷键
			{ "gr", group = "LSP 操作" },
			{ "gra", desc = "代码操作" },
			{ "grn", desc = "重命名" },
			{ "grr", desc = "查找引用" },
			{ "gri", desc = "跳转到实现" },
			{ "grt", desc = "跳转到类型定义" },
			{ "grx", desc = "运行 CodeLens" },

			-- 隐藏简单剪贴板快捷键，保留映射本身
			{ "<leader>y", hidden = true, mode = { "n", "v" } },
			{ "<leader>p", hidden = true, mode = { "n", "v" } },

			-- 隐藏数字快捷键（标签页跳转），避免在 which-key 中显示
			{ "<leader>1", hidden = true },
			{ "<leader>2", hidden = true },
			{ "<leader>3", hidden = true },
			{ "<leader>4", hidden = true },
			{ "<leader>5", hidden = true },
			{ "<leader>6", hidden = true },
			{ "<leader>7", hidden = true },
			{ "<leader>8", hidden = true },
			{ "<leader>9", hidden = true },
		})
	end,
}
