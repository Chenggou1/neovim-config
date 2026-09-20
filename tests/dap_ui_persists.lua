require("lazy").load({ plugins = { "nvim-dap" } })

local dap = require("dap")
local dapui = require("dapui")

local function has_dap_console()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "dapui_console" then
			return true
		end
	end
	return false
end

for _, event in ipairs({ "event_terminated", "event_exited" }) do
	dapui.open()
	vim.wait(100)
	assert(has_dap_console(), "DAP console did not open")

	dap.listeners.before[event].dapui_config()
	vim.wait(100)
	assert(has_dap_console(), ("DAP console closed after %s"):format(event))

	dapui.close()
end

print("DAP console remains visible after terminated and exited events")
