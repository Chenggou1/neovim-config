local M = {}

function M.on_attach(_, bufnr)
    local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- 覆盖通用 LSP 键，使用 rustaceanvim 增强版
    map("K", function()
        vim.cmd.RustLsp("hover", "actions")
    end, "悬浮操作")
    map("<leader>ca", function()
        vim.cmd.RustLsp("codeAction")
    end, "代码操作")
end

return M
