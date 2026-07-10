local M = {}

function M.mapping(cmp, luasnip)
	return cmp.mapping.preset.insert({
		-- Enter: 确认补全菜单选中项
		-- select = false 表示只有明确选中的项才会被确认，避免误触
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),

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

		-- Ctrl-b/f: 文档窗口滚动
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),

		-- Ctrl-n: 手动触发补全（避免与系统输入法切换冲突）
		["<C-n>"] = cmp.mapping.complete(),
	})
end

return M
