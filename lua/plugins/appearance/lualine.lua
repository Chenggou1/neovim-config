return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local utils = require("core.utils")
		local todo_status = require("core.todo_status")

		local cached_venv_path
		local cached_venv_name

		local function resolve_venv_name(venv)
			if venv == cached_venv_path then
				return cached_venv_name
			end

			local name = vim.fn.fnamemodify(venv, ":t")
			local config_path = venv .. "/pyvenv.cfg"
			if vim.fn.filereadable(config_path) == 1 then
				local ok, lines = pcall(vim.fn.readfile, config_path, "", 50)
				if ok then
					for _, line in ipairs(lines) do
						local prompt = line:match("^%s*prompt%s*=%s*(.-)%s*$")
						if prompt and prompt ~= "" then
							name = prompt:match('^"(.*)"$') or prompt:match("^'(.*)'$") or prompt
							break
						end
					end
				end
			end

			if name == ".venv" or name == "venv" then
				name = vim.fn.fnamemodify(venv, ":h:t")
			end

			cached_venv_path = venv
			cached_venv_name = name
			return name
		end

		-- Python 虚拟环境显示（使用 venv-selector.nvim API）
		local function python_env()
			local venv_selector = utils.safe_require("venv-selector")
			if not venv_selector then
				return ""
			end

			local venv = venv_selector.venv()
			if venv and venv ~= "" then
				return "󰌠 " .. resolve_venv_name(venv)
			end
			return ""
		end

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
				lualine_x = { python_env, "encoding", "filetype" },
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
