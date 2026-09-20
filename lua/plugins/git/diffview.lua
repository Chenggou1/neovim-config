-- diffview.nvim: 单标签页 Git diff 和三路合并工具
return {
	"sindrets/diffview.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewToggleFiles",
		"DiffviewFocusFiles",
		"DiffviewFileHistory",
	},
	config = function()
		local actions = require("diffview.actions")

		require("diffview").setup({
			-- 官方推荐：PR review 时默认使用 --imply-local
			-- 这样 diff 的右侧会显示工作树版本，支持 LSP
			default_args = {
				DiffviewOpen = { "--imply-local" },
			},

			-- 自定义按键映射
			keymaps = {
				-- 禁用 view 中和用户配置冲突的默认按键
				view = {
					{ "n", "<leader>b", false }, -- 禁用（与标签页管理冲突）
					{ "n", "<leader>e", false }, -- 禁用（与 neo-tree 冲突）
					{ "n", "<leader>co", false },
					{ "n", "<leader>ct", false },
					{ "n", "<leader>cb", false },
					{ "n", "<leader>ca", false },
					{ "n", "<leader>cO", false },
					{ "n", "<leader>cT", false },
					{ "n", "<leader>cB", false },
					{ "n", "<leader>cA", false },
					{ "n", "<leader>gmo", actions.conflict_choose("ours"), { desc = "选择 OURS" } },
					{ "n", "<leader>gmt", actions.conflict_choose("theirs"), { desc = "选择 THEIRS" } },
					{ "n", "<leader>gmb", actions.conflict_choose("base"), { desc = "选择 BASE" } },
					{ "n", "<leader>gma", actions.conflict_choose("all"), { desc = "保留全部版本" } },
					{ "n", "<leader>gmO", actions.conflict_choose_all("ours"), { desc = "整个文件选择 OURS" } },
					{
						"n",
						"<leader>gmT",
						actions.conflict_choose_all("theirs"),
						{ desc = "整个文件选择 THEIRS" },
					},
					{ "n", "<leader>gmB", actions.conflict_choose_all("base"), { desc = "整个文件选择 BASE" } },
					{
						"n",
						"<leader>gmA",
						actions.conflict_choose_all("all"),
						{ desc = "整个文件保留全部版本" },
					},
				},

				-- 文件面板按键映射（与 neo-tree 保持一致）
				file_panel = {
					{ "n", "w", actions.select_entry, { desc = "打开文件 diff (与 neo-tree 一致)" } },
					{ "n", "<leader>b", false }, -- 禁用（与标签页管理冲突）
					{ "n", "<leader>e", false }, -- 禁用（与 neo-tree 冲突）
					{ "n", "<leader>cO", false },
					{ "n", "<leader>cT", false },
					{ "n", "<leader>cB", false },
					{ "n", "<leader>cA", false },
					{ "n", "<leader>gmO", actions.conflict_choose_all("ours"), { desc = "整个文件选择 OURS" } },
					{
						"n",
						"<leader>gmT",
						actions.conflict_choose_all("theirs"),
						{ desc = "整个文件选择 THEIRS" },
					},
					{ "n", "<leader>gmB", actions.conflict_choose_all("base"), { desc = "整个文件选择 BASE" } },
					{
						"n",
						"<leader>gmA",
						actions.conflict_choose_all("all"),
						{ desc = "整个文件保留全部版本" },
					},
				},
			},
		})
	end,
	keys = {
		-- Git diff 操作
		{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git Diff (当前改动)" },

		-- Git 文件历史
		{ "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "Git 文件历史" },
		{ "<leader>gF", "<cmd>DiffviewFileHistory<cr>", desc = "Git 完整历史" },

		-- 可视模式下查看选中行的演进历史
		{ "<leader>gf", ":'<,'>DiffviewFileHistory<cr>", mode = "v", desc = "Git 选中行历史" },
	},
}
