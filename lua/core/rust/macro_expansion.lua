local M = {}

local state = {
	float_win = nil,
	split_buf = nil,
}

local function expansion_lines(result)
	local title = "Recursive expansion of the " .. result.name .. " macro"
	local lines = {
		"// " .. string.rep("=", #title),
		"// " .. title,
		"// " .. string.rep("=", #title),
		"",
	}

	vim.list_extend(lines, vim.split(result.expansion, "\n", { plain = true, trimempty = true }))
	return lines
end

local function open_split(lines)
	if state.split_buf and vim.api.nvim_buf_is_valid(state.split_buf) then
		vim.api.nvim_buf_delete(state.split_buf, { force = true })
	end

	local bufnr = vim.api.nvim_create_buf(false, true)
	state.split_buf = bufnr
	vim.bo[bufnr].filetype = "rust"
	vim.bo[bufnr].bufhidden = "wipe"
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	vim.bo[bufnr].modifiable = false

	vim.cmd("vsplit")
	vim.api.nvim_win_set_buf(0, bufnr)
	vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = bufnr, silent = true })
end

local function open_float(lines)
	local float_lines = vim.list_extend({ "1. Open in split", "---" }, vim.deepcopy(lines))
	local bufnr, winid = vim.lsp.util.open_floating_preview(float_lines, "rust", {
		border = "rounded",
		focus_id = "rust-macro-expansion",
		focusable = true,
		max_height = math.floor(vim.o.lines * 0.8),
		max_width = math.floor(vim.o.columns * 0.8),
		title = " Macro Expansion ",
	})

	state.float_win = winid

	local function close_float()
		if state.float_win and vim.api.nvim_win_is_valid(state.float_win) then
			vim.api.nvim_win_close(state.float_win, true)
		end
		state.float_win = nil
	end

	vim.keymap.set("n", "q", close_float, { buffer = bufnr, silent = true })
	vim.keymap.set("n", "<Esc>", close_float, { buffer = bufnr, silent = true })
	vim.keymap.set("n", "<CR>", function()
		if vim.api.nvim_win_get_cursor(0)[1] ~= 1 then
			return
		end

		close_float()
		open_split(lines)
	end, { buffer = bufnr, silent = true })
end

function M.expand()
	if state.float_win and vim.api.nvim_win_is_valid(state.float_win) then
		vim.api.nvim_set_current_win(state.float_win)
		return
	end

	local rust_analyzer = require("rustaceanvim.rust_analyzer")
	local clients = rust_analyzer.get_active_rustaceanvim_clients(0)
	if #clients == 0 then
		vim.notify("No active rust-analyzer client", vim.log.levels.WARN)
		return
	end

	local params = vim.lsp.util.make_position_params(0, clients[1].offset_encoding or "utf-8")
	rust_analyzer.buf_request(0, "rust-analyzer/expandMacro", params, function(err, result)
		if err then
			vim.notify(err.message or "Failed to expand macro", vim.log.levels.ERROR)
			return
		end
		if not result then
			vim.notify("No macro under cursor", vim.log.levels.INFO)
			return
		end

		open_float(expansion_lines(result))
	end)
end

return M
