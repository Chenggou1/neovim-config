local M = {}

function M.on_attach(_, bufnr)
	local map = function(lhs, rhs, desc)
		vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
	end

	map("<leader>ca", function()
		vim.cmd.RustLsp("codeAction")
	end, "代码操作")
	map("<leader>dd", function()
		vim.cmd.RustLsp({ "renderDiagnostic", "current" })
	end, "诊断信息")
	map("<leader>cm", function()
		vim.cmd.RustLsp({ "expandMacro", "float" })
	end, "展开宏")
end

return M
