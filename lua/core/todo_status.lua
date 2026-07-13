local M = {}

local labels = { "FIX", "TODO", "WARN", "HACK" }
local label_colors = {
	FIX = { "DiagnosticError", "ErrorMsg", "#ea9a97" },
	TODO = { "DiagnosticInfo", "#9ccfd8" },
	WARN = { "DiagnosticWarn", "WarningMsg", "#f6c177" },
	HACK = { "DiagnosticHint", "Special", "#c4a7e7" },
}
local counts = {}
local pending = false
local timer = vim.uv.new_timer()

local function reset_counts()
	counts = {}
	for _, label in ipairs(labels) do
		counts[label] = 0
	end
end

local function refresh_lualine()
	local ok, lualine = pcall(require, "lualine")
	if ok then
		lualine.refresh({ place = { "statusline" } })
	end
end

function M.refresh()
	if pending then
		return
	end

	local ok, search = pcall(require, "todo-comments.search")
	if not ok then
		return
	end

	pending = true
	search.search(function(results)
		reset_counts()
		for _, item in ipairs(results or {}) do
			if counts[item.tag] ~= nil then
				counts[item.tag] = counts[item.tag] + 1
			end
		end
		pending = false
		refresh_lualine()
	end, {
		cwd = vim.fn.getcwd(),
		keywords = table.concat(labels, ","),
		disable_not_found_warnings = true,
	})
end

function M.schedule_refresh()
	if timer then
		timer:stop()
		timer:start(500, 0, vim.schedule_wrap(M.refresh))
	end
end

function M.component()
	local parts = {}
	for _, label in ipairs(labels) do
		local count = counts[label] or 0
		if count > 0 then
			table.insert(parts, label .. " " .. count)
		end
	end
	return table.concat(parts, " ")
end

local function extract_color(label)
	local ok, lualine_utils = pcall(require, "lualine.utils.utils")
	if not ok then
		return nil
	end

	local color_groups = vim.deepcopy(label_colors[label] or {})
	if label ~= "HACK" then
		table.insert(color_groups, 1, "TodoFg" .. label)
	end

	return lualine_utils.extract_color_from_hllist("fg", color_groups, nil)
end

local TodoComponent = require("lualine.component"):extend()

function TodoComponent:init(options)
	TodoComponent.super.init(self, options)
	self.highlights = {}

	for _, label in ipairs(labels) do
		local color = extract_color(label)
		if color then
			self.highlights[label] = self:create_hl({ fg = color }, "todo_" .. label:lower())
		end
	end
end

function TodoComponent:update_status()
	local parts = {}
	for _, label in ipairs(labels) do
		local count = counts[label] or 0
		if count > 0 then
			local prefix = self.highlights[label] and self:format_hl(self.highlights[label]) or ""
			table.insert(parts, prefix .. label .. " " .. count)
		end
	end
	return table.concat(parts, " ")
end

M.lualine_component = TodoComponent

function M.setup()
	reset_counts()

	local group = vim.api.nvim_create_augroup("TodoStatusline", { clear = true })
	vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "DirChanged" }, {
		group = group,
		callback = M.schedule_refresh,
	})

	M.schedule_refresh()
end

return M
