return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "folke/lazydev.nvim",
        "saghen/blink.cmp",
    },
    config = function()
        -- lazydev gives correct `vim` global completion/hover while editing this config
        require("lazydev").setup({})

        require("mason").setup({})

        local servers = { "lua_ls", "ts_ls", "gopls", "html" }

        -- automatic_enable is disabled: we call vim.lsp.enable() ourselves below.
        -- Letting both run double-starts every server.
        require("mason-lspconfig").setup({
            ensure_installed = servers,
            automatic_enable = false,
        })

        require("mason-tool-installer").setup({
            ensure_installed = {
                "prettierd",
                "eslint_d",
                "gofumpt",
                "goimports",
                "stylua",
            },
        })

        -- 1. Global capabilities (completion support) for every server
        vim.lsp.config("*", {
            capabilities = require("blink.cmp").get_lsp_capabilities(nil, true),
        })

        -- 2. Per-server settings
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" }, -- Stops the "undefined global vim" warning
                    },
                },
            },
        })

        vim.lsp.config("gopls", {
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                        shadow = true,
                    },
                    staticcheck = true,
                    gofumpt = true, -- Enforces strict go formatting standard
                },
            },
        })

        vim.lsp.config("ts_ls", {
            settings = {
                typescript = {
                    inlayHints = {
                        includeInlayParameterNameHints = "all",
                        includeInlayFunctionLikeReturnTypeHints = true,
                    },
                },
                javascript = {
                    inlayHints = {
                        includeInlayParameterNameHints = "all",
                        includeInlayFunctionLikeReturnTypeHints = true,
                    },
                },
            },
        })

        -- 3. Enable native LSP clients.
        -- Note: rust_analyzer is intentionally NOT enabled here -- rustaceanvim
        -- (lua/plugins/rust.lua) owns rust-analyzer startup. Enabling it here too
        -- would attach two clients to every .rs buffer.
        -- Note: eslint LSP is intentionally NOT enabled -- nvim-lint + eslint_d
        -- (lua/plugins/lint.lua) covers JS/TS linting instead.
        vim.lsp.enable(servers)

        -- 4. Diagnostics: gutter icons, inline text, float, jump keymaps
        vim.diagnostic.config({
            severity_sort = true,
            underline = true,
            virtual_text = {
                spacing = 2,
                source = "if_many",
                prefix = "●",
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "󰅚 ",
                    [vim.diagnostic.severity.WARN] = "󰀪 ",
                    [vim.diagnostic.severity.INFO] = "󰋽 ",
                    [vim.diagnostic.severity.HINT] = "󰌶 ",
                },
            },
            float = {
                border = "rounded",
                source = "if_many",
            },
        })

        vim.keymap.set("n", "[d", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, { desc = "Previous diagnostic" })
        vim.keymap.set("n", "]d", function()
            vim.diagnostic.jump({ count = 1, float = true })
        end, { desc = "Next diagnostic" })
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
        vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

        -- 5. Keymaps & inlay hints on attach
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(event)
                local opts = { buffer = event.buf }
                local client = vim.lsp.get_client_by_id(event.data.client_id)

                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)

                -- Manual format shortcut (routes through conform.nvim)
                vim.keymap.set("n", "<leader>f", function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end, opts)

                if client and client:supports_method("textDocument/inlayHint") then
                    vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
                    vim.keymap.set("n", "<leader>th", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
                    end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))
                end
            end,
        })
    end,
}
