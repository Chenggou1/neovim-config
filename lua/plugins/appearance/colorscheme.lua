return {
	"olimorris/onedarkpro.nvim",
	priority = 1000,
	config = function()
		-- 配置主题样式（社区最佳实践）
		require("onedarkpro").setup({
			styles = {
				-- 社区推荐：使用 Italic 的元素
				comments = "italic",      -- 注释使用斜体（所有主流主题推荐）
				conditionals = "italic",  -- 条件语句使用斜体（if, else, switch）

				-- 保持默认：不装饰的元素
				functions = "NONE",       -- 函数名不装饰（保持清晰）
				variables = "NONE",       -- 变量不装饰（避免过度）
				strings = "NONE",         -- 字符串不装饰
				types = "NONE",           -- 类型不装饰（可选: "bold" 增强可见性）

				-- 其他元素
				methods = "NONE",
				numbers = "NONE",
				constants = "NONE",
				operators = "NONE",
				parameters = "NONE",
				virtual_text = "NONE",
			},

			options = {
				transparency = false,  -- 如果使用 transparent.nvim，保持此为 false
			},
		})

		-- 应用主题（在 setup 之后）
		vim.cmd("colorscheme onedark")


	end,
}
