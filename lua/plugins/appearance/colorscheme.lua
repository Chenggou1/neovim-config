return {
	"rose-pine/neovim",
	name = "rose-pine",
	priority = 1000,
	config = function()
		require("rose-pine").setup({
			highlight_groups = {
				["@lsp.mod.consuming.rust"] = {
					bold = true,
				},
			},
		})

		vim.cmd("colorscheme rose-pine-moon")
	end,
}
