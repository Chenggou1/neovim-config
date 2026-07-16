local M = {}

local function scroll_documentation(cmp, delta, fallback)
	if cmp.scroll_docs(delta) then
		return
	end

	local ok, noice_lsp = pcall(require, "noice.lsp")
	if ok and noice_lsp.scroll(delta) then
		return
	end

	fallback()
end

function M.mapping(cmp, luasnip)
	return cmp.mapping.preset.insert({
		-- Enter: 确认补全菜单选中项
		-- select = false 表示只有明确选中的项才会被确认，避免误触
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),

		-- Tab: 应用当前选中项；尚未选中时应用第一项
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				if not cmp.get_selected_entry() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
				end
				cmp.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				})
			else
				fallback()
			end
		end, { "i", "s" }),

		-- 选择补全项；菜单未显示时保留按键原本行为
		["<Down>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
			else
				fallback()
			end
		end, { "i", "s" }),
		["<Up>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-j>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-k>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
			else
				fallback()
			end
		end, { "i", "s" }),

		-- Ctrl-e: 关闭补全菜单
		["<C-e>"] = cmp.mapping.abort(),

		-- Ctrl-b/f: 滚动 nvim-cmp 或 Noice 的文档窗口
		["<C-b>"] = cmp.mapping(function(fallback)
			scroll_documentation(cmp, -4, fallback)
		end, { "i", "s" }),
		["<C-f>"] = cmp.mapping(function(fallback)
			scroll_documentation(cmp, 4, fallback)
		end, { "i", "s" }),

		-- Ctrl-n: 手动触发补全（避免与系统输入法切换冲突）
		["<C-n>"] = cmp.mapping.complete(),
	})
end

return M
