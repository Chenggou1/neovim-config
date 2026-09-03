local M = {}

local function recover(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype ~= "" then
		return
	end

	if vim.api.nvim_buf_get_name(bufnr) == "" then
		return
	end

	vim.api.nvim_buf_call(bufnr, function()
		vim.cmd("filetype detect")
	end)
end

function M.setup()
	local filetype_recovery = vim.api.nvim_create_augroup("FiletypeRecovery", { clear = true })
	vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
		group = filetype_recovery,
		callback = function(args)
			recover(args.buf)
		end,
	})

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		recover(bufnr)
	end
end

return M
