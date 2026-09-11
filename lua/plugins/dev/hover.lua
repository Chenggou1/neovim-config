return {
	"lewis6991/hover.nvim",
	lazy = false,
	config = function()
		local function find_hover_source_buffer(hover_win)
			for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_valid(bufnr) and vim.b[bufnr].hover_preview == hover_win then
					return bufnr
				end
			end
		end

		local function find_window_for_buffer(bufnr)
			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
				if vim.api.nvim_win_get_buf(win) == bufnr then
					return win
				end
			end
		end

		local function refocus_switched_hover(source_buf, source_win, previous_hover, attempts)
			if not vim.api.nvim_buf_is_valid(source_buf) or not vim.api.nvim_win_is_valid(source_win) then
				return
			end

			local hover_win = vim.b[source_buf].hover_preview
			if hover_win and hover_win ~= previous_hover and vim.api.nvim_win_is_valid(hover_win) then
				-- 用户等待切换时若已经移到别处，不再强行抢回焦点。
				if vim.api.nvim_get_current_win() == source_win then
					vim.api.nvim_set_current_win(hover_win)
				end
				return
			end

			if attempts > 0 then
				vim.defer_fn(function()
					refocus_switched_hover(source_buf, source_win, previous_hover, attempts - 1)
				end, 50)
			end
		end

		local function switch_document(direction)
			local hover = require("hover")
			local current_win = vim.api.nvim_get_current_win()
			local source_buf = find_hover_source_buffer(current_win)
			if not source_buf then
				hover.switch(direction)
				return
			end

			local source_win = find_window_for_buffer(source_buf)
			if not source_win then
				return
			end

			-- hover.nvim 的 switch() 从当前 buffer 读取 provider 状态，因此先回到源窗口调用。
			vim.api.nvim_set_current_win(source_win)
			hover.switch(direction)
			refocus_switched_hover(source_buf, source_win, current_win, 60)
		end

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
			require("core.keymaps.lsp").focus_float_or(function()
				local hover_win = vim.b.hover_preview
				if hover_win and vim.api.nvim_win_is_valid(hover_win) then
					vim.api.nvim_set_current_win(hover_win)
					return
				end
				require("hover").open()
			end)
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
			switch_document("next")
		end, { desc = "下一文档来源" })
		vim.keymap.set("n", "<C-p>", function()
			switch_document("previous")
		end, { desc = "上一文档来源" })
	end,
}
