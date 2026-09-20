local M = {}

local supported_filetypes = {
	python = "Python",
	rust = "Rust",
}

local function neotest()
	return require("neotest")
end

local function ensure_supported()
	local filetype = vim.bo.filetype
	if supported_filetypes[filetype] then
		return true
	end

	local display_name = filetype == "" and "未识别" or filetype
	vim.notify(("暂不支持当前文件类型的测试：%s"):format(display_name), vim.log.levels.WARN, {
		title = "Test",
	})
	return false
end

function M.run_nearest()
	if ensure_supported() then
		neotest().run.run()
	end
end

function M.run_file()
	if ensure_supported() then
		neotest().run.run(vim.fn.expand("%"))
	end
end

function M.run_suite()
	if ensure_supported() then
		neotest().run.run({ suite = true })
	end
end

function M.debug_nearest()
	if ensure_supported() then
		neotest().run.run({ strategy = "dap" })
	end
end

function M.run_last()
	neotest().run.run_last()
end

function M.open_output()
	neotest().output.open({ enter = true })
end

function M.toggle_summary()
	neotest().summary.toggle()
end

function M.stop()
	neotest().run.stop()
end

return M
