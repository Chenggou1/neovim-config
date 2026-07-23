-- Rust 开发支持
-- 依赖: 需手动安装 rust-analyzer: rustup component add rust-analyzer
local utils = require("core.utils")
local cmp_lsp = utils.safe_require("cmp_nvim_lsp")

vim.g.rustaceanvim = {
    server = {
        capabilities = cmp_lsp and cmp_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities(),
        on_attach = function(client, bufnr)
            local lsp_keys = utils.safe_require("core.keymaps.lsp")
            if lsp_keys and type(lsp_keys.on_attach) == "function" then
                lsp_keys.on_attach(client, bufnr)
            end
            local rust_keys = utils.safe_require("core.keymaps.rust")
            if rust_keys and type(rust_keys.on_attach) == "function" then
                rust_keys.on_attach(client, bufnr)
            end
        end,
    },
}

return {
    "mrcjkb/rustaceanvim",
    version = "^9",
    lazy = false, -- rustaceanvim 自行管理按需加载
}
