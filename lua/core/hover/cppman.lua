local M = {
	name = "C++ Reference",
	priority = 900,
}

local pager_configured = false

local function symbol_at_position(bufnr, row, col)
	local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]
	if not line then
		return nil
	end

	local before = line:sub(1, col + 1):match("[%w_:~]+$") or ""
	local after = line:sub(col + 2):match("^[%w_:~]*") or ""
	local symbol = (before .. after):gsub("^:+", ""):gsub(":+$", "")
	return symbol ~= "" and symbol or nil
end

function M.enabled(bufnr)
	return vim.bo[bufnr].filetype == "cpp" and vim.fn.executable("cppman") == 1
end

function M.execute(params, done)
	local symbol = symbol_at_position(params.bufnr, params.pos[1], params.pos[2])
	if not symbol then
		done()
		return
	end

	local query = function()
		vim.system({
			"cppman",
			"--force-columns=88",
			symbol,
		}, {
			text = true,
			env = { PAGER = "cat" },
		}, function(result)
			vim.schedule(function()
				if result.code ~= 0 or not result.stdout or result.stdout == "" then
					done()
					return
				end

				local output = result.stdout:gsub("\27%[[%d;]*[A-Za-z]", "")
				done({
					lines = vim.split(output, "\n", { plain = true, trimempty = true }),
					filetype = "man",
				})
			end)
		end)
	end

	if pager_configured then
		query()
		return
	end

	-- cppman 的 pager 选项是持久化设置，必须与查询分成两次调用。
	vim.system({ "cppman", "--pager=system" }, { text = true }, function(result)
		if result.code ~= 0 then
			vim.schedule(done)
			return
		end
		pager_configured = true
		query()
	end)
end

return M
