local test_runner = require("core.test_runner")

return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-neotest/neotest-python",
	},
	keys = {
		{ "<leader>tn", test_runner.run_nearest, desc = "运行光标附近测试" },
		{ "<leader>tf", test_runner.run_file, desc = "运行当前文件测试" },
		{ "<leader>ts", test_runner.run_suite, desc = "运行测试套件" },
		{ "<leader>tl", test_runner.run_last, desc = "重新运行上次测试" },
		{ "<leader>td", test_runner.debug_nearest, desc = "调试光标附近测试" },
		{ "<leader>to", test_runner.open_output, desc = "查看测试输出" },
		{ "<leader>tt", test_runner.toggle_summary, desc = "切换测试概览" },
		{ "<leader>tx", test_runner.stop, desc = "停止测试" },
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-python"),
				require("rustaceanvim.neotest"),
			},
		})
	end,
}
