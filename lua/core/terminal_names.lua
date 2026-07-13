local M = {}

local MAX_TERMINAL_NAME_LENGTH = 32

local function truncate_name(name, max_length)
	if #name <= max_length then
		return name
	end
	if max_length <= 1 then
		return "~"
	end
	return name:sub(1, max_length - 1) .. "~"
end

local function sanitize_name(name)
	local sanitized = name:gsub("%s+", "-"):gsub("[^%w%._%-]", "-"):gsub("%-+", "-"):gsub("^%-+", ""):gsub("%-+$", "")
	if sanitized == "" then
		return "terminal"
	end
	return sanitized
end

local function get_base_name(cwd, suffix)
	local base = vim.fn.fnamemodify(cwd or vim.loop.cwd(), ":t")
	if base == "" then
		base = "terminal"
	end

	base = sanitize_name(base)
	if suffix and suffix ~= "" then
		local suffix_part = "-" .. sanitize_name(suffix)
		base = truncate_name(base, MAX_TERMINAL_NAME_LENGTH - #suffix_part) .. suffix_part
	end

	return truncate_name(base, MAX_TERMINAL_NAME_LENGTH)
end

function M.create(cwd, suffix)
	local base = get_base_name(cwd, suffix)
	local termmod = require("toggleterm.terminal")
	local used = {}
	for _, term in ipairs(termmod.get_all(true)) do
		if term.display_name and term.display_name ~= "" then
			used[term.display_name] = true
		end
	end

	local name = base
	local index = 2
	while used[name] do
		local duplicate_suffix = "-" .. index
		name = truncate_name(base, MAX_TERMINAL_NAME_LENGTH - #duplicate_suffix) .. duplicate_suffix
		index = index + 1
	end

	return name
end

return M
