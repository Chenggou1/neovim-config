local dedupe = require("core.diagnostic_dedupe")

local rust_analyzer = {
	bufnr = 1,
	lnum = 44,
	col = 12,
	end_lnum = 44,
	end_col = 31,
	severity = vim.diagnostic.severity.ERROR,
	code = "E0308",
	source = "rust-analyzer",
	message = "expected Rc<Node<T>, Global>, found Node<{unknown}>",
}

local rustc = {
	bufnr = 1,
	lnum = 44,
	col = 12,
	end_lnum = 44,
	end_col = 31,
	severity = vim.diagnostic.severity.ERROR,
	code = "E0308",
	source = "rustc",
	message = "mismatched types\nexpected struct `Rc<Node<T>>`\nfound enum `Node<_>`",
}

local bufnr = vim.api.nvim_create_buf(false, true)
vim.bo[bufnr].filetype = "rust"
rust_analyzer.bufnr = bufnr
rustc.bufnr = bufnr

local rust_analyzer_namespace = vim.api.nvim_create_namespace("test.rust-analyzer")
local rustc_namespace = vim.api.nvim_create_namespace("test.rustc")
vim.diagnostic.set(rust_analyzer_namespace, bufnr, { rust_analyzer })
vim.diagnostic.set(rustc_namespace, bufnr, { rustc })

assert(dedupe.format(rust_analyzer) == nil, "the float formatter kept the rust-analyzer duplicate")
assert(dedupe.format(rustc) == rustc.message, "the float formatter removed the rustc diagnostic")
assert(#vim.diagnostic.get(bufnr) == 2, "the float formatter mutated stored diagnostics")

vim.api.nvim_buf_delete(bufnr, { force = true })
print("Float formatting hides duplicates without changing stored diagnostics")

local shifted_bufnr = vim.api.nvim_create_buf(false, true)
vim.bo[shifted_bufnr].filetype = "rust"
local shifted_rust_analyzer = vim.deepcopy(rust_analyzer)
local shifted_rustc = vim.deepcopy(rustc)
shifted_rust_analyzer.bufnr = shifted_bufnr
shifted_rust_analyzer.lnum = 47
shifted_rust_analyzer.end_lnum = 47
shifted_rust_analyzer.col = 25
shifted_rust_analyzer.end_col = 38
shifted_rustc.bufnr = shifted_bufnr
shifted_rustc.lnum = 46
shifted_rustc.end_lnum = 46
shifted_rustc.col = 25
shifted_rustc.end_col = 38

vim.diagnostic.set(rust_analyzer_namespace, shifted_bufnr, { shifted_rust_analyzer })
vim.diagnostic.set(rustc_namespace, shifted_bufnr, { shifted_rustc })

assert(
	dedupe.format(shifted_rust_analyzer) == nil,
	"the float formatter kept a compiler duplicate shifted by one line"
)

vim.api.nvim_buf_delete(shifted_bufnr, { force = true })
print("Float formatting handles one-line range drift between diagnostic sources")

require("lazy").load({ plugins = { "tiny-inline-diagnostic.nvim" } })
local float_config = vim.diagnostic.config().float
assert(type(float_config) == "table", "diagnostic float configuration is unavailable")
assert(float_config.format == dedupe.format, "diagnostic floats do not use the deduplicating formatter")

print("Diagnostic floats use the Rust deduplicating formatter")

local float_bufnr = vim.api.nvim_create_buf(false, true)
vim.bo[float_bufnr].filetype = "rust"
vim.api.nvim_buf_set_lines(float_bufnr, 0, -1, false, vim.fn['repeat']({ "" }, 45))
vim.api.nvim_set_current_buf(float_bufnr)

rust_analyzer.bufnr = float_bufnr
rustc.bufnr = float_bufnr
local hint = {
	bufnr = float_bufnr,
	lnum = 43,
	col = 14,
	end_lnum = 43,
	end_col = 23,
	severity = vim.diagnostic.severity.HINT,
	code = "E0308",
	source = "rustc",
	message = "consider dereferencing to access the inner value",
}

vim.diagnostic.set(rust_analyzer_namespace, float_bufnr, { rust_analyzer })
vim.diagnostic.set(rustc_namespace, float_bufnr, { rustc, hint })

assert(dedupe.format(hint) == hint.message, "a related Rust hint was removed with the duplicate error")

local popup_bufnr = vim.diagnostic.open_float({
	bufnr = float_bufnr,
	pos = 44,
	scope = "line",
})
assert(popup_bufnr, "diagnostic float did not open")
local popup_winid = vim.fn.win_findbuf(popup_bufnr)[1]
assert(popup_winid, "diagnostic float window did not open")

local popup_text = table.concat(vim.api.nvim_buf_get_lines(popup_bufnr, 0, -1, false), "\n")
local _, error_code_count = popup_text:gsub("E0308", "")
assert(error_code_count == 1, "diagnostic float rendered duplicate E0308 errors")
assert(popup_text:find("mismatched types", 1, true), "diagnostic float did not keep the rustc message")
assert(
	not popup_text:find("expected Rc<Node<T>, Global>", 1, true),
	"diagnostic float kept the rust-analyzer duplicate"
)

vim.api.nvim_win_close(popup_winid, true)
vim.api.nvim_buf_delete(float_bufnr, { force = true })
print("Diagnostic float renders one E0308 and preserves related hints")
