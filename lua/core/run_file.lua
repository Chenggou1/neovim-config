local M = {}

local function notify(message, level)

	vim.notify(message, level or vim.log.levels.INFO, { title = "RunFile" })
end

local function project_root(file, marker)
	return vim.fs.root(file, { marker })
end

local function shellescape(value)
	return vim.fn.shellescape(value)
end

local function executable_or_error(name)
	if vim.fn.executable(name) == 1 then
		return true
	end

	notify(("未找到可执行命令：%s"):format(name), vim.log.levels.ERROR)
	return false
end

local function package_name(cargo_toml)
	local in_package = false
	for _, line in ipairs(vim.fn.readfile(cargo_toml)) do
		if line:match("^%s*%[package%]%s*$") then
			in_package = true
		elseif line:match("^%s*%[") then
			in_package = false
		elseif in_package then
			local name = line:match('^%s*name%s*=%s*"([^"]+)"')
			if name then
				return name
			end
		end
	end
end

local function rust_command(file)
	local root = project_root(file, "Cargo.toml")
	if not root then
		return nil, "Rust 文件必须位于 Cargo 项目中。"
	end

	local relative = vim.fs.relpath(root, file)
	local bin = relative and relative:match("^src/bin/([^/]+)%.rs$")
	if not bin and relative == "src/main.rs" then
		bin = package_name(root .. "/Cargo.toml")
	end
	if not bin then
		return nil, "当前 Rust 文件不是可运行的 Cargo binary（仅支持 src/main.rs 和 src/bin/<name>.rs）。"
	end

	return ("cargo run --bin %s"):format(shellescape(bin)), root
end

local function python_command(file)
	local root = project_root(file, "pyproject.toml")
	if not root then
		return nil, "Python 文件必须位于 uv 项目中（缺少 pyproject.toml）。"
	end

	return ("uv run python %s"):format(shellescape(file)), root
end

local function c_family_command(file, compiler, standard)
	local root = vim.fs.root(file, { ".git", "CMakeLists.txt" }) or vim.fn.fnamemodify(file, ":h")
	local relative = vim.fs.relpath(root, file) or vim.fn.fnamemodify(file, ":t")
	local output_dir = root .. "/.cache/nvim-run/" .. vim.fn.sha256(relative):sub(1, 16)
	local output = output_dir .. "/" .. vim.fn.fnamemodify(file, ":t:r")
	vim.fn.mkdir(output_dir, "p")

	local command = table.concat({
		compiler,
		"-std=" .. standard,
		"-Wall",
		"-Wextra",
		"-Wpedantic",
		"-g",
		shellescape(file),
		"-o",
		shellescape(output),
		"&&",
		shellescape(output),
	}, " ")

	return command, root
end

local function command_for_current_file()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		return nil, "当前 buffer 尚未保存为文件。"
	end

	local filetype = vim.bo.filetype
	if filetype == "python" then
		if not executable_or_error("uv") then
			return nil
		end
		return python_command(file)
	elseif filetype == "rust" then
		if not executable_or_error("cargo") then
			return nil
		end
		return rust_command(file)
	elseif filetype == "c" then
		if not executable_or_error("cc") then
			return nil
		end
		return c_family_command(file, "cc", "c17")
	elseif filetype == "cpp" or filetype == "cxx" then
		if not executable_or_error("c++") then
			return nil
		end
		return c_family_command(file, "c++", "c++20")
	end

	return nil, ("不支持运行当前文件类型：%s"):format(filetype == "" and "未识别" or filetype)
end

local function run_in_terminal(command, cwd)
	local Terminal = require("toggleterm.terminal").Terminal
	local terminal = Terminal:new({
		cmd = command,
		dir = cwd,
		direction = "horizontal",
		close_on_exit = false,
	})
	terminal:toggle()
end

function M.run()
	if vim.bo.modified then
		vim.cmd("update")
	end

	local command, cwd_or_error = command_for_current_file()
	if not command then
		if cwd_or_error then
			notify(cwd_or_error, vim.log.levels.WARN)
		end
		return
	end

	run_in_terminal(command, cwd_or_error)
end

function M.setup()
	vim.api.nvim_create_user_command("RunFile", M.run, {
		desc = "保存并运行当前文件",
	})

	vim.keymap.set("n", "<leader>cr", M.run, {
		desc = "运行当前文件",
	})
end

return M
