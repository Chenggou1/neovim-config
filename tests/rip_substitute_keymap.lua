local expected_description = "查找并替换"

local rg_result = vim.system({ "rg", "--version" }, { text = true }):wait()
assert(rg_result.code == 0, "ripgrep is unavailable")

local rg_major_version = tonumber(rg_result.stdout:match("^ripgrep (%d+)"))
assert(rg_major_version and rg_major_version >= 15, "rip-substitute requires ripgrep 15.0.0 or newer")

for _, mode in ipairs({ "n", "x" }) do
	local mapping = vim.fn.maparg("<leader>fr", mode, false, true)
	assert(not vim.tbl_isempty(mapping), ("<leader>fr is not mapped in %s mode"):format(mode))
	assert(mapping.desc == expected_description, ("unexpected <leader>fr description in %s mode"):format(mode))
	assert(type(mapping.callback) == "function", ("<leader>fr has no Lua callback in %s mode"):format(mode))
end

require("lazy").load({ plugins = { "nvim-rip-substitute" } })
assert(type(require("rip-substitute").sub) == "function", "rip-substitute entry point is unavailable")

print("rip-substitute keymap is available in normal and visual modes")
