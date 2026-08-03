local function url_under_cursor()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	local search_helpers = require("urlview.search.helpers")
	local jump = require("urlview.jump")

	for _, url in ipairs(search_helpers.content(line)) do
		for _, start_col in ipairs(jump.line_match_positions(line, url, 0)) do
			if col >= start_col and col < start_col + #url then
				return url
			end
		end
	end
end

local function act_on_url_under_cursor(action)
	local url = url_under_cursor()
	if url then
		action(url)
		return
	end

	vim.notify("光标不在链接上", vim.log.levels.WARN)
end

local function copy_and_open(url)
	local actions = require("urlview.actions")
	actions.clipboard(url)
	actions.system(url)
end

return {
	"axieax/urlview.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-telescope/telescope.nvim" },
	keys = {
		{ "<leader>fl", "<cmd>UrlView buffer<CR>", desc = "查找并复制链接" },
		{
			"<leader>cl",
			function()
				act_on_url_under_cursor(require("urlview.actions").clipboard)
			end,
			desc = "复制光标下的链接",
		},
		{
			"<leader>cL",
			function()
				act_on_url_under_cursor(copy_and_open)
			end,
			desc = "复制并打开光标下的链接",
		},
	},
	opts = {
		default_picker = "telescope",
		default_action = "clipboard",
		default_register = "+",
		-- 保持链接在文件中的出现顺序，方便按上下文选择。
		sorted = false,
	},
}
