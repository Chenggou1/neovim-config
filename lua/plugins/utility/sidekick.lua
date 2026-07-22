return {
	"folke/sidekick.nvim",
	keys = {
		{
			"<leader>ks",
			function()
				require("sidekick.cli").select({ filter = { installed = true } })
			end,
			desc = "AI: 选择 CLI",
		},
		{
			"<leader>kf",
			function()
				require("sidekick.cli").send({ msg = "{file}" })
			end,
			desc = "Codex: 发送当前文件",
		},
		{
			"<leader>kv",
			function()
				require("sidekick.cli").send({ msg = "{selection}" })
			end,
			mode = "x",
			desc = "Codex: 发送选区",
		},
		{
			"<leader>kp",
			function()
				require("sidekick.cli").prompt()
			end,
			mode = { "n", "x" },
			desc = "Codex: 输入提示",
		},
	},
	opts = {
		cli = {
			prompts = {
				changes = "请审查我当前的改动，列出问题和改进建议。",
				diagnostics = "请分析并修复 {file} 中的诊断信息：\n{diagnostics}\n说明原因。",
				diagnostics_all = "请分析并修复这些诊断信息：\n{diagnostics_all}\n说明原因。",
				document = "请为 {function|line} 补充清晰的文档注释，说明用途、参数和返回值。",
				explain = "请结合当前项目上下文，解释 {this} 的作用。",
				fix = "请分析并修复 {this}。先说明原因和方案，再进行修改。",
				optimize = "请分析 {this} 可以如何优化，说明性能、可读性和维护性的取舍。",
				review = "请审查 {file} 是否有问题或可改进之处，并按优先级说明。",
				tests = "请为 {this} 编写测试，并说明覆盖的场景。",
			},
		},
	},
}
