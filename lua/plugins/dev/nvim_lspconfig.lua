return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },

    dependencies = {
        -- Mason 配置已移至 lua/plugins/dev/mason.lua
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim",

        -- JSON schemas for jsonls
        { "b0o/schemastore.nvim", lazy = true },
    },

    config = function()
        -- 加载诊断快捷键配置
        require("core.keymaps.diagnostics").setup()

        --------------------------------------------------------------------------
        -- 公共 capabilities
        --------------------------------------------------------------------------
        local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
        local capabilities = ok_cmp and cmp_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()

        local on_attach = function(client, bufnr)
            local ok, lsp_keys = pcall(require, "core.keymaps.lsp")
            if ok and type(lsp_keys.on_attach) == "function" then
                lsp_keys.on_attach(client, bufnr)
            end
        end
        --------------------------------------------------------------------------
        -- ① Pyright ─ 类型检查（虚拟环境由 venv-selector.nvim 插件自动配置）
        --------------------------------------------------------------------------
        vim.lsp.config.pyright = {
            capabilities = capabilities,
            on_attach = on_attach,

            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "basic",
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "openFilesOnly",
                    },
                },
            },
        }

        -- 启用 Pyright LSP
        vim.lsp.enable("pyright")

        --------------------------------------------------------------------------
        -- ② clangd ─ C/C++ LSP
        -- 注意: clangd 通过系统包管理器安装 (apt install clangd)，而非 Mason
        -- 原因: Mason 不支持某些平台（ARM64 等）的 clangd 预编译二进制
        -- 参考: https://github.com/mason-org/mason-registry/issues/5800
        --------------------------------------------------------------------------
        vim.lsp.config.clangd = {
            capabilities = capabilities,
            on_attach = on_attach,

            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--completion-style=detailed",
                "--header-insertion=iwyu",
                "--header-insertion-decorators",
                "--inlay-hints",
            },

            filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },

            -- 只在正常文件中启动,避免在 diffview 等虚拟 buffer 中启动
            root_dir = function(bufnr, on_dir)
                -- 获取 buffer 的文件名
                local fname = vim.api.nvim_buf_get_name(bufnr)

                -- 检查 1: 跳过使用特殊 URI scheme 的 buffer (diffview://, fugitive:// 等)
                if fname:match("^%w+://") then
                    return -- 不调用 on_dir，跳过 LSP 启动
                end

                -- 检查 2: 跳过特殊 buffer (terminal, help, quickfix 等)
                local ok, buftype = pcall(vim.api.nvim_buf_get_option, bufnr, "buftype")
                if ok and buftype ~= "" then
                    return -- 不调用 on_dir，跳过 LSP 启动
                end

                -- 正常文件：查找项目根目录并调用 on_dir 启动 LSP
                local root = vim.fs.root(bufnr, {
                    "compile_commands.json",
                    "compile_flags.txt",
                    ".git",
                })
                if root then
                    on_dir(root)
                end
            end,
        }

        -- 启用 clangd
        vim.lsp.enable("clangd")

        --------------------------------------------------------------------------
        -- ③ jsonls ─ JSON LSP (语法检查、schema 验证)
        --------------------------------------------------------------------------
        vim.lsp.config.jsonls = {
            capabilities = capabilities,
            on_attach = on_attach,

            settings = {
                json = {
                    schemas = require("schemastore").json.schemas(),
                    validate = { enable = true },
                },
            },
        }

        -- 启用 jsonls
        vim.lsp.enable("jsonls")

        --------------------------------------------------------------------------
        -- ④ marksman ─ Markdown LSP
        --------------------------------------------------------------------------
        vim.lsp.config.marksman = {
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "markdown", "markdown.mdx" },

            -- 只在正常文件中启动，避免在 diffview 等虚拟 buffer 中启动
            -- Neovim 0.11 新 API: root_dir(bufnr, on_dir)
            root_dir = function(bufnr, on_dir)
                -- 获取 buffer 的文件名
                local fname = vim.api.nvim_buf_get_name(bufnr)

                -- 检查 1: 跳过使用特殊 URI scheme 的 buffer (diffview://, fugitive:// 等)
                if fname:match("^%w+://") then
                    return -- 不调用 on_dir，跳过 LSP 启动
                end

                -- 检查 2: 跳过特殊 buffer (terminal, help, quickfix 等)
                local ok, buftype = pcall(vim.api.nvim_buf_get_option, bufnr, "buftype")
                if ok and buftype ~= "" then
                    return -- 不调用 on_dir，跳过 LSP 启动
                end

                -- 正常文件：查找项目根目录并调用 on_dir 启动 LSP
                local root = vim.fs.root(bufnr, { ".git", ".marksman.toml" })
                if root then
                    on_dir(root)
                end
            end,
        }

        -- 启用 marksman
        vim.lsp.enable("marksman")

        --------------------------------------------------------------------------
        -- ⑤ buf_ls ─ Protocol Buffers LSP (使用 buf 工具)
        --------------------------------------------------------------------------
        vim.lsp.config.buf_ls = {
            cmd = { "buf", "beta", "lsp" }, -- buf 工具的 LSP 模式
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "proto" },

            root_dir = vim.fs.root(0, {
                "buf.yaml",
                "buf.work.yaml",
                ".git",
            }),
        }

        -- 启用 buf_ls
        vim.lsp.enable("buf_ls")

        --------------------------------------------------------------------------
        -- ⑥ 取消 Ruff-LSP：若仅需格式化，请使用 conform.nvim
        --    如需 Ruff 诊断/Code Action，可在此重新启用
        --------------------------------------------------------------------------
    end,
}
