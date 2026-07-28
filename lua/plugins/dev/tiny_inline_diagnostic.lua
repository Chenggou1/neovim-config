return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy",
	priority = 1000, -- 高优先级，确保在其他插件之前加载
	config = function()
		require("tiny-inline-diagnostic").setup({
			preset = "ghost", -- 使用 ghost 样式（subtle, understated look）
			options = {
				-- 打开完整诊断浮窗时暂时隐藏行内提示，关闭后自动恢复
				override_open_float = true,
			},
		})

		-- 禁用 Neovim 默认的 virtual_text 和左侧符号列
		vim.diagnostic.config({
			virtual_text = false, -- 关闭默认的行末文本
			signs = false, -- 关闭左侧的 E, W 符号
			float = {
				border = "rounded",
				title = " Diagnostics ",
				header = "",
				source = "if_many",
				severity_sort = true,
				focusable = true,
			},
		})
	end,
}
