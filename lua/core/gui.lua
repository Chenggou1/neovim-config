local M = {}

local function parse_guifont(guifont, fallback_name, fallback_size)
	local name, size = string.match(guifont or "", "([^:]+):h(%d+)")
	name = name or fallback_name
	size = tonumber(size) or fallback_size
	return name, size
end

function M.setup()
	if not vim.g.neovide then
		return
	end

	-- 字体设置
	local default_font = "JetBrainsMono Nerd Font"
	local default_size = 14
	vim.o.guifont = string.format("%s:h%d", default_font, default_size)

	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0

	-- 性能优化
	vim.g.neovide_refresh_rate = 60 -- 刷新率，配合 --no-vsync 使用
	vim.g.neovide_scroll_animation_length = 0.3 -- 滚动动画时长
	vim.g.neovide_cursor_animation_length = 0.13 -- 光标动画时长

	-- 光标效果
	vim.g.neovide_cursor_trail_size = 0.8 -- 光标轨迹长度 0~1
	vim.g.neovide_cursor_antialiasing = true -- 光标抗锯齿
	vim.g.neovide_cursor_animate_in_insert_mode = true -- 插入模式光标动画
	vim.g.neovide_cursor_animate_command_line = true -- 命令行模式光标动画
	vim.g.neovide_cursor_smooth_blink = true -- 光标平滑闪烁过渡
	vim.g.neovide_cursor_vfx_mode = "torpedo" -- 光标粒子特效：torpedo（鱼雷，更柔和）
	vim.g.neovide_cursor_vfx_particle_lifetime = 0.5 -- 粒子生命周期（降低以减少视觉干扰）
	vim.g.neovide_cursor_vfx_particle_density = 3.0 -- 粒子密度（降低以减少视觉干扰）

	-- 用户体验优化
	vim.g.neovide_input_ime = true -- 支持中文输入法（macOS 重要）
	vim.g.neovide_remember_window_size = true -- 记住窗口大小
	vim.g.neovide_hide_mouse_when_typing = true -- 打字时隐藏鼠标
	vim.g.neovide_window_blurred = true -- 窗口失焦时模糊

	-- macOS 特定优化
	vim.g.neovide_input_macos_option_key_is_meta = "only_left" -- 左 Option 键作为 Meta

	-- 字体缩放函数
	local function change_font_size(delta)
		-- 解析当前 guifont = "<name>:h<size>"
		local name, size = parse_guifont(vim.o.guifont, default_font, default_size)
		size = math.max(size + delta, 6) -- 不让字号小于 6
		vim.o.guifont = string.format("%s:h%d", name, size)
	end

	-- 快捷键：Ctrl + = / Ctrl + - / Ctrl + 0
	for _, mode in ipairs({ "n", "i" }) do
		vim.keymap.set(mode, "<C-=>", function()
			change_font_size(1)
		end, { desc = "字体放大" })
		vim.keymap.set(mode, "<C-->", function()
			change_font_size(-1)
		end, { desc = "字体缩小" })
		vim.keymap.set(mode, "<C-0>", function()
			vim.o.guifont = string.format("%s:h%d", default_font, default_size)
		end, { desc = "恢复默认字号" })
	end
end

return M
