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

		-- 关闭默认的行末文本，但保留左侧符号列：行内下划线不明显时仍能一眼定位诊断。
		vim.diagnostic.config({
			virtual_text = false, -- 关闭默认的行末文本
			severity_sort = true, -- 同一行有多个诊断时，优先显示 Error 等更严重的标记
			signs = {
				severity = vim.diagnostic.severity.ERROR, -- 侧栏只标记错误，减少 Warning/Hint 的视觉噪声
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.INFO] = " ",
					[vim.diagnostic.severity.HINT] = "󰌵 ",
				},
			},
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
