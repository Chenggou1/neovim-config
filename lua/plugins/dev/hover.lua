return {
	"lewis6991/hover.nvim",
	lazy = false,
	config = function()
		require("hover").config({
			providers = {
				{
					module = "hover.providers.lsp",
					name = "LSP 文档",
					priority = 2000,
				},
				"core.hover.cppman",
				"hover.providers.man",
			},
			preview_opts = { border = "rounded" },
			title = true,
		})

		local open = function()
			local hover_win = vim.b.hover_preview
			if hover_win and vim.api.nvim_win_is_valid(hover_win) then
				vim.api.nvim_set_current_win(hover_win)
				return
			end
			require("hover").open()
		end
		vim.keymap.set("n", "K", open, { desc = "查看文档" })
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("hover_keymap", { clear = true }),
			callback = function(event)
				-- Neovim 为 LSP buffer 安装默认 K 映射；在此处覆盖它，保持各语言一致。
				vim.keymap.set("n", "K", open, { buffer = event.buf, desc = "查看文档" })
			end,
		})
		vim.keymap.set("n", "<C-n>", function()
			require("hover").switch("next")
		end, { desc = "下一文档来源" })
		vim.keymap.set("n", "<C-p>", function()
			require("hover").switch("previous")
		end, { desc = "上一文档来源" })
	end,
}
