local M = {}

local compiler_sources = {
	clippy = true,
	rustc = true,
}

local function same_error(left, right)
	local left_lnum = left.lnum or 0
	local right_lnum = right.lnum or 0
	local start_line_shift = left_lnum - right_lnum
	local end_line_shift = (left.end_lnum or left_lnum) - (right.end_lnum or right_lnum)

	return tostring(left.code or "") == tostring(right.code or "")
		and left.severity == right.severity
		and (left.col or 0) == (right.col or 0)
		and (left.end_col or left.col or 0) == (right.end_col or right.col or 0)
		and math.abs(start_line_shift) <= 1
		and start_line_shift == end_line_shift
end

function M.format(diagnostic)
	local bufnr = diagnostic.bufnr or 0
	if vim.bo[bufnr].filetype == "rust" and diagnostic.source == "rust-analyzer" then
		for _, candidate in ipairs(vim.diagnostic.get(bufnr)) do
			if compiler_sources[candidate.source] and same_error(candidate, diagnostic) then
				return nil
			end
		end
	end

	return diagnostic.message
end

return M
