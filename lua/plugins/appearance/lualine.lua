return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local todo_status = require("core.todo_status")

		local function macro_recording()
			local register = vim.fn.reg_recording()
			return register ~= "" and "● REC @" .. register or ""
		end

		todo_status.setup()

		local lualine = require("lualine")
		lualine.setup({
			options = {
				theme = "auto",
				section_separators = { left = "", right = "" },
				component_separators = "|",
				globalstatus = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", todo_status.lualine_component },
				lualine_c = {
					{
						"filename",
						path = 1, -- 0: 只显示文件名, 1: 相对路径, 2: 绝对路径, 3: 智能路径
					},
				},
				lualine_x = { "encoding", "filetype" },
				lualine_y = { macro_recording },
				lualine_z = {},
			},
		})

		vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
			group = vim.api.nvim_create_augroup("LualineMacroRecording", { clear = true }),
			callback = function()
				vim.schedule(function()
					lualine.refresh({ force = true })
				end)
			end,
		})
	end,
}
