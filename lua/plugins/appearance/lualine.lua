return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local utils = require("core.utils")

		-- Python 虚拟环境显示（使用 venv-selector.nvim API）
		local function python_env()
			local venv_selector = utils.safe_require("venv-selector")
			if not venv_selector then
				return ""
			end

			local venv = venv_selector.venv()
			if venv and venv ~= "" then
				-- 提取虚拟环境名称（路径最后一个目录）
				local name = vim.fn.fnamemodify(venv, ":t")
				return "󰌠 " .. name
			end
			return ""
		end
		require("lualine").setup({
			options = {
				theme = "auto",
				section_separators = { left = "", right = "" },
				component_separators = "|",
				globalstatus = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff" },
				lualine_c = {
					{
						"filename",
						path = 1, -- 0: 只显示文件名, 1: 相对路径, 2: 绝对路径, 3: 智能路径
					},
				},
				lualine_x = { python_env, "encoding", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		})
	end,
}
