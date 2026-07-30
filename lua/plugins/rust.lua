return {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false, -- rustaceanvim sets itself up via FileType autocmd internally
    ft = { "rust" },
    config = function()
        vim.g.rustaceanvim = {
            server = {
                default_settings = {
                    ["rust-analyzer"] = {
                        cargo = { allFeatures = true },
                        checkOnSave = true,
                        check = { command = "clippy" },
                        procMacro = { enable = true },
                    },
                },
                on_attach = function(_, bufnr)
                    local opts = { buffer = bufnr }
                    vim.keymap.set("n", "<leader>vca", function()
                        vim.cmd.RustLsp("codeAction")
                    end, opts)
                    vim.keymap.set("n", "<leader>rr", function()
                        vim.cmd.RustLsp("runnables")
                    end, opts)
                    vim.keymap.set("n", "K", function()
                        vim.cmd.RustLsp({ "hover", "actions" })
                    end, opts)
                end,
            },
        }
    end,
}
