local step_mode = {
	active = false,
	keys = { "h", "j", "l", "c", "q", "<Esc>" },
}

local function dap_action(method, ...)
	local args = { ... }
	return function()
		require("dap")[method](unpack(args))
	end
end

local function continue_or_select_target()
	local dap = require("dap")
	if dap.session() then
		dap.continue()
		return
	end

	local filetype = vim.bo.filetype
	if filetype ~= "c" and filetype ~= "cpp" then
		dap.continue()
		return
	end

	local configurations = dap.configurations[filetype] or {}
	if #configurations == 0 then
		vim.notify("当前文件类型没有可用的调试目标", vim.log.levels.WARN, { title = "DAP" })
		return
	end

	vim.ui.select(configurations, {
		prompt = "选择调试目标: ",
		format_item = function(configuration)
			return configuration.name
		end,
	}, function(configuration)
		if configuration then
			dap.run(configuration, { filetype = filetype })
		end
	end)
end

local function compile_current_c_family()
	local dap = require("dap")
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		vim.notify("当前 buffer 尚未保存为文件", vim.log.levels.ERROR, { title = "DAP" })
		return dap.ABORT
	end

	if vim.bo.modified then
		vim.cmd("update")
	end

	local filetype = vim.bo.filetype
	local compiler = filetype == "c" and "cc" or "c++"
	local standard = filetype == "c" and "c17" or "c++20"
	if vim.fn.executable(compiler) ~= 1 then
		vim.notify(("未找到编译器：%s"):format(compiler), vim.log.levels.ERROR, { title = "DAP" })
		return dap.ABORT
	end

	local root = vim.fs.root(file, { ".git", "CMakeLists.txt" }) or vim.fn.fnamemodify(file, ":p:h")
	local relative = vim.fs.relpath(root, file) or vim.fn.fnamemodify(file, ":t")
	local output_dir = root .. "/.cache/nvim-debug/" .. vim.fn.sha256(relative):sub(1, 16)
	local output = output_dir .. "/" .. vim.fn.fnamemodify(file, ":t:r")
	vim.fn.mkdir(output_dir, "p")

	return coroutine.create(function(dap_run_co)
		vim.system({
			compiler,
			"-std=" .. standard,
			"-Wall",
			"-Wextra",
			"-Wpedantic",
			"-g",
			"-O0",
			file,
			"-o",
			output,
		}, { cwd = root, text = true }, function(result)
			vim.schedule(function()
				if result.code == 0 then
					coroutine.resume(dap_run_co, output)
					return
				end

				local message =
					vim.trim((result.stderr and result.stderr ~= "" and result.stderr) or result.stdout or "")
				if message == "" then
					message = ("编译失败，退出码：%d"):format(result.code)
				end
				vim.notify(message, vim.log.levels.ERROR, { title = "C/C++ 调试编译失败" })
				coroutine.resume(dap_run_co, dap.ABORT)
			end)
		end)
	end)
end

local function leave_step_mode(options)
	options = options or {}
	if not step_mode.active then
		return
	end

	for _, key in ipairs(step_mode.keys) do
		pcall(vim.keymap.del, "n", key)
	end
	step_mode.active = false

	if not options.silent then
		vim.notify("已退出 DAP 步进模式", vim.log.levels.INFO)
	end
end

local function enter_step_mode()
	local dap = require("dap")
	if not dap.session() then
		vim.notify("当前没有活动的 DAP 调试会话", vim.log.levels.WARN)
		return
	end
	if step_mode.active then
		return
	end

	local function step(method)
		return function()
			if not dap.session() then
				leave_step_mode({ silent = true })
				return
			end
			dap[method]()
		end
	end

	step_mode.active = true
	vim.keymap.set("n", "j", step("step_over"), { desc = "DAP：单步跳过", silent = true })
	vim.keymap.set("n", "l", step("step_into"), { desc = "DAP：单步进入", silent = true })
	vim.keymap.set("n", "h", step("step_out"), { desc = "DAP：单步跳出", silent = true })
	vim.keymap.set("n", "c", function()
		leave_step_mode({ silent = true })
		dap.continue()
	end, { desc = "DAP：继续并退出步进模式", silent = true })
	vim.keymap.set("n", "q", leave_step_mode, { desc = "退出 DAP 步进模式", silent = true })
	vim.keymap.set("n", "<Esc>", leave_step_mode, { desc = "退出 DAP 步进模式", silent = true })

	vim.notify("DAP 步进模式：j 跳过 · l 进入 · h 跳出 · c 继续 · q/Esc 退出", vim.log.levels.INFO)
end

return {
	"mfussenegger/nvim-dap",
	ft = { "python", "c", "cpp" },
	dependencies = {
		"mfussenegger/nvim-dap-python",
		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "nvim-neotest/nvim-nio" },
		},
		"theHamsta/nvim-dap-virtual-text",
	},
	keys = {
		{ "<leader>xb", dap_action("toggle_breakpoint"), desc = "切换断点" },
		{
			"<leader>xB",
			function()
				require("dap").set_breakpoint(vim.fn.input("断点条件: "))
			end,
			desc = "设置条件断点",
		},
		{
			"<leader>xp",
			function()
				require("dap").set_breakpoint(nil, nil, vim.fn.input("日志点消息: "))
			end,
			desc = "设置日志点",
		},
		{ "<leader>xc", continue_or_select_target, desc = "选择调试目标/继续" },
		{ "<leader>xs", enter_step_mode, desc = "进入临时步进模式" },
		{ "<leader>xt", dap_action("terminate"), desc = "终止调试" },
		{ "<leader>xl", dap_action("run_last"), desc = "重新运行上次配置" },
		{
			"<leader>xr",
			function()
				require("dap").repl.open()
			end,
			desc = "打开调试 REPL",
		},
		{
			"<leader>xu",
			function()
				require("dapui").toggle()
			end,
			desc = "切换调试界面",
		},
		{
			"<leader>xe",
			function()
				require("dapui").eval()
			end,
			mode = { "n", "v" },
			desc = "查看表达式",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dap.adapters.lldb = function(callback)
			local command = vim.fn.exepath("lldb-dap")
			if command == "" then
				vim.notify("未找到 lldb-dap，请先安装 LLDB", vim.log.levels.ERROR, { title = "DAP" })
				return
			end

			callback({
				type = "executable",
				command = command,
				name = "lldb",
			})
		end

		dap.configurations.cpp = {
			{
				name = "调试当前文件",
				type = "lldb",
				request = "launch",
				program = compile_current_c_family,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
			},
		}
		dap.configurations.c = dap.configurations.cpp

		local function hide_non_dap_windows()
			local has_neo_tree, neo_tree_command = pcall(require, "neo-tree.command")
			if has_neo_tree then
				neo_tree_command.execute({ action = "close" })
			end

			local has_outline, outline = pcall(require, "outline")
			if has_outline then
				outline.close()
			end

			local has_term_ui, term_ui = pcall(require, "toggleterm.ui")
			local has_toggleterm, toggleterm = pcall(require, "toggleterm")
			if has_term_ui and has_toggleterm then
				local has_open_terminal = term_ui.find_open_windows()
				if has_open_terminal then
					toggleterm.toggle_all(true)
				end
			end
		end

		local function open_dap_ui()
			hide_non_dap_windows()
			dapui.open()
		end

		local function set_dap_highlights()
			local has_palette, palette = pcall(require, "rose-pine.palette")
			if not has_palette then
				return
			end

			vim.api.nvim_set_hl(0, "DapStoppedLine", {
				bg = palette.gold,
				fg = palette.base,
				bold = true,
			})
			vim.api.nvim_set_hl(0, "DapStoppedSign", {
				fg = palette.gold,
				bold = true,
			})
		end

		-- 通过当前项目的 uv 环境启动 debugpy；debugpy 由项目自行提供。
		require("dap-python").setup("uv")

		-- 阅读第三方 RL 框架时也允许进入库代码，并提供常用的远程附加配置。
		for _, configuration in ipairs(dap.configurations.python or {}) do
			configuration.justMyCode = false
			configuration.subProcess = true
		end
		table.insert(dap.configurations.python, {
			type = "python",
			request = "attach",
			name = "附加到 debugpy（127.0.0.1:5678）",
			connect = {
				host = "127.0.0.1",
				port = 5678,
			},
			justMyCode = false,
			subProcess = true,
		})

		dapui.setup()
		require("nvim-dap-virtual-text").setup({
			highlight_changed_variables = true,
			highlight_new_as_changed = true,
			show_stop_reason = true,
			only_first_definition = true,
			all_references = false,
			clear_on_continue = true,
			commented = true,
			display_callback = function(variable)
				local value = tostring(variable.value):gsub("%s+", " ")
				if #value > 120 then
					value = value:sub(1, 117) .. "..."
				end
				return variable.name .. " = " .. value
			end,
		})

		dap.listeners.before.attach.dapui_config = open_dap_ui
		dap.listeners.before.launch.dapui_config = open_dap_ui
		local function finish_dap_session()
			leave_step_mode({ silent = true })
		end
		-- terminated/exited 后保留调试布局和控制台输出，由用户通过 <leader>xu 手动关闭。
		dap.listeners.before.event_terminated.dapui_config = finish_dap_session
		dap.listeners.before.event_exited.dapui_config = finish_dap_session
		dap.listeners.before.disconnect.dap_step_mode = finish_dap_session

		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
		vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticError" })
		vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo" })
		set_dap_highlights()
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("DapHighlights", { clear = true }),
			callback = set_dap_highlights,
			desc = "根据当前主题刷新 DAP 高亮",
		})
		vim.fn.sign_define("DapStopped", {
			text = "→",
			texthl = "DapStoppedSign",
			linehl = "DapStoppedLine",
		})
	end,
}
