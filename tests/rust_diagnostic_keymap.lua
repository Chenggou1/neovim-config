require("core.keymaps.diagnostics").setup()

local bufnr = vim.api.nvim_create_buf(false, true)
vim.api.nvim_set_current_buf(bufnr)
vim.bo[bufnr].filetype = "rust"

require("core.keymaps.rust").on_attach(nil, bufnr)

local mapping = vim.fn.maparg("<leader>dd", "n", false, true)
assert(not vim.tbl_isempty(mapping), "<leader>dd is unavailable in Rust buffers")
assert(mapping.buffer == 1, "Rust does not use its rendered diagnostic popup")

vim.api.nvim_buf_delete(bufnr, { force = true })
print("Rust buffers preserve the rendered diagnostic popup")
