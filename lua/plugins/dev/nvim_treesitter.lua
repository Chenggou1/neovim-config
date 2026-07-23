return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	lazy = false, -- nvim-treesitter does not support lazy-loading
	dependencies = {
		"HiPhish/rainbow-delimiters.nvim",
	},
	config = function()
		local parsers = {
			"c",
			"lua",
			"vim",
			"vimdoc",
			"query",
			"bash",
			"python",
			"javascript",
			"typescript",
			"html",
			"css",
			"json",
			"markdown",
			"markdown_inline",
			"cpp",
			"toml",
			"yaml",
			"rust",
		}

		local treesitter = require("nvim-treesitter")
		treesitter.setup()
		treesitter.install(parsers)

		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"sh",
				"python",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"html",
				"css",
				"json",
				"jsonc",
				"markdown",
				"cpp",
				"toml",
				"yaml",
				"rust",
			},
			callback = function(args)
				if pcall(vim.treesitter.start, args.buf) then
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
