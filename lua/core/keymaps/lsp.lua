local M = {}

function M.focus_float_or(callback)
	local float_win = vim.b.lsp_floating_preview
	if float_win and vim.api.nvim_win_is_valid(float_win) then
		vim.api.nvim_set_current_win(float_win)
		return
	end

	callback()
end

function M.on_attach(client, bufnr)
	-- 启用 inlay hints (Neovim 0.10.0+)
	if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	local map = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
	end
	map("n", "gd", vim.lsp.buf.definition, "跳转到定义")
	map("n", "gD", vim.lsp.buf.declaration, "跳转到声明")
	map("n", "grr", function()
		require("telescope.builtin").lsp_references({
			include_current_line = true,
		})
	end, "查找引用")
	map("n", "gri", function()
		require("telescope.builtin").lsp_implementations()
	end, "跳转到实现")
	map("n", "K", function()
		M.focus_float_or(vim.lsp.buf.hover)
	end, "悬浮文档 / 聚焦浮窗")
	map("n", "<leader>cn", vim.lsp.buf.rename, "重命名")
	map("n", "<leader>ca", vim.lsp.buf.code_action, "代码操作")
end

return M
