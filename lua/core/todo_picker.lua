local M = {}

local preferred_labels = { "ALL", "FIX", "TODO", "WARN", "HACK", "NOTE", "PERF", "TEST" }

local function ensure_todo_comments_loaded()
	local ok, config = pcall(require, "todo-comments.config")
	if ok and not config.loaded and config._setup then
		config._setup()
	end
end

local function get_tabs()
	local ok, config = pcall(require, "todo-comments.config")
	if not ok or not config.options or not config.options.keywords then
		return preferred_labels
	end

	local tabs = { "ALL" }
	for _, label in ipairs(preferred_labels) do
		if label ~= "ALL" and config.options.keywords[label] then
			table.insert(tabs, label)
		end
	end
	return tabs
end

local function tab_index(tabs, active)
	for index, label in ipairs(tabs) do
		if label == active then
			return index
		end
	end
	return 1
end

local function next_tab(tabs, active, step)
	local index = tab_index(tabs, active)
	return tabs[((index - 1 + step) % #tabs) + 1]
end

local function prompt_title(tabs, active)
	local parts = {}
	for _, label in ipairs(tabs) do
		if label == active then
			table.insert(parts, "[" .. label .. "]")
		else
			table.insert(parts, label)
		end
	end
	return "注释标签  " .. table.concat(parts, "  ") .. "  Ctrl-h/l"
end

local function load_todo_extension()
	local ok, telescope = pcall(require, "telescope")
	if not ok then
		return nil
	end

	pcall(telescope.load_extension, "todo-comments")
	return telescope.extensions["todo-comments"]
end

local function open(active, default_text)
	ensure_todo_comments_loaded()

	local tabs = get_tabs()
	active = tabs[tab_index(tabs, active)]

	local extension = load_todo_extension()
	if not extension or not extension.todo then
		vim.cmd("TodoTelescope")
		return
	end

	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local opts = {
		prompt_title = prompt_title(tabs, active),
		default_text = default_text,
		attach_mappings = function(prompt_bufnr, map)
			local function switch(step)
				local prompt = action_state.get_current_line()
				actions.close(prompt_bufnr)
				vim.schedule(function()
					open(next_tab(tabs, active, step), prompt)
				end)
			end

			for _, mode in ipairs({ "i", "n" }) do
				map(mode, "<C-l>", function()
					switch(1)
				end)
				map(mode, "<C-h>", function()
					switch(-1)
				end)
			end

			return true
		end,
	}

	if active ~= "ALL" then
		opts.keywords = active
	end

	extension.todo(opts)
end

function M.open()
	open("ALL")
end

return M
