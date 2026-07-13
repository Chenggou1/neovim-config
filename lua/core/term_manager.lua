-- 终端管理器模块：为每个 tabpage 管理独立的终端实例
local M = {}
local terminal_names = require("core.terminal_names")

-- 存储所有 tabpage 的终端实例
-- 结构: tabpage_terminals[tabpage_id][term_type] = Terminal instance
local tabpage_terminals = {}

-- 终端类型定义
local TERM_TYPES = {
    float_term = { slot = 1, direction = "float", name_suffix = "float" },
}

-- 计算唯一的 terminal ID
-- 使用复合 ID: (tabpage_id * 1000) + slot
local function get_terminal_id(tabpage_id, slot)
    return (tabpage_id * 1000) + slot
end

-- 获取当前 tabpage 的终端映射表
local function get_tabpage_terminals()
    local tabpage_id = vim.api.nvim_get_current_tabpage()
    if not tabpage_terminals[tabpage_id] then
        tabpage_terminals[tabpage_id] = {}
    end
    return tabpage_terminals[tabpage_id], tabpage_id
end

-- 创建终端打开回调（venv 自动激活由 venv-selector.nvim 插件处理）
local function create_on_open_callback()
    return function(t)
        -- 保留此函数以便将来添加自定义终端初始化逻辑
    end
end

-- 获取或创建指定类型的终端
function M.get_or_create_terminal(term_type, cwd)
    local term_config = TERM_TYPES[term_type]
    if not term_config then
        error("Unknown terminal type: " .. term_type)
    end

    local terminals, tabpage_id = get_tabpage_terminals()

    -- 如果终端已存在，直接返回
    if terminals[term_type] then
        if not terminals[term_type].display_name or terminals[term_type].display_name == "" then
            terminals[term_type].display_name = terminal_names.create(cwd, term_config.name_suffix)
        end
        return terminals[term_type]
    end

    -- 创建新终端实例
    local Terminal = require("toggleterm.terminal").Terminal
    local term_id = get_terminal_id(tabpage_id, term_config.slot)
    local term = Terminal:new({
        id = term_id,
        direction = term_config.direction,
        display_name = terminal_names.create(cwd, term_config.name_suffix),
        on_open = create_on_open_callback(),
    })

    terminals[term_type] = term
    return term
end

-- 清理指定 tabpage 的所有终端
function M.cleanup_tabpage_terminals(tabpage_id)
    local terminals = tabpage_terminals[tabpage_id]
    if not terminals then
        return
    end

    for _, term in pairs(terminals) do
        if term and term.shutdown then
            pcall(term.shutdown, term)
        end
    end

    tabpage_terminals[tabpage_id] = nil
end

-- 切换终端（带 cwd 解析）
function M.toggle_terminal(term_type, resolve_cwd_fn)
    local cwd
    if resolve_cwd_fn then
        cwd = resolve_cwd_fn()
    end

    local term = M.get_or_create_terminal(term_type, cwd)

    -- 更新工作目录
    if cwd then
        term.dir = cwd
    end

    term:toggle()
end

-- 设置自动清理 autocmd
function M.setup_autocmds()
    local group = vim.api.nvim_create_augroup("TabpageTerminals", { clear = true })

    -- Tabpage 关闭时清理终端
    vim.api.nvim_create_autocmd("TabClosed", {
        group = group,
        callback = function(args)
            -- TabClosed 的 match 是 tabpage 的编号（字符串格式）
            local tabpage = tonumber(args.match)
            if tabpage then
                M.cleanup_tabpage_terminals(tabpage)
            end
        end,
    })

    -- Neovim 退出时清理所有终端
    vim.api.nvim_create_autocmd("VimLeavePre", {
        group = group,
        callback = function()
            for tabpage_id, _ in pairs(tabpage_terminals) do
                M.cleanup_tabpage_terminals(tabpage_id)
            end
        end,
    })
end

return M
