local M = {}

function M.on_attach(_, bufnr)
    local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- 覆盖通用 LSP 键，使用 rustaceanvim 增强版
    map("K", function()
        require("core.keymaps.lsp").focus_float_or(function()
            vim.cmd.RustLsp("hover", "actions")
        end)
    end, "悬浮操作 / 聚焦浮窗")
    map("<leader>ca", function()
        vim.cmd.RustLsp("codeAction")
    end, "代码操作")
    map("<leader>cd", function()
        vim.cmd.RustLsp({ "renderDiagnostic", "current" })
    end, "渲染 Rust 诊断")
    map("<leader>cm", function()
        require("core.rust.macro_expansion").expand()
    end, "展开宏")
end

return M
