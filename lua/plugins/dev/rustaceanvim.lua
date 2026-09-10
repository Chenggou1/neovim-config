-- Rust 开发支持
-- 依赖: 需手动安装 rust-analyzer: rustup component add rust-analyzer
local utils = require("core.utils")
local cmp_lsp = utils.safe_require("cmp_nvim_lsp")

local function rust_root_dir(filename, default)
    -- 会话恢复时若同时打开 Rust 标准库和项目文件，rustaceanvim 会将它们
    -- 分配给不同客户端，再把项目 buffer 附着到两者。标准库源码应复用当前
    -- Cargo 项目的 rust-analyzer；这样 cmp 不会得到重复的 LSP 候选项。
    if filename:find("/.rustup/toolchains/", 1, true) then
        local cargo_toml = vim.fn.findfile("Cargo.toml", vim.fn.getcwd() .. ";")
        if cargo_toml ~= "" then
            return vim.fn.fnamemodify(cargo_toml, ":p:h")
        end
    end

    return default(filename)
end

vim.g.rustaceanvim = {
    tools = {
        float_win_config = {
            border = "rounded",
        },
    },
    server = {
        root_dir = rust_root_dir,
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
    version = "9.1.0",
    lazy = false, -- rustaceanvim 自行管理按需加载
}
