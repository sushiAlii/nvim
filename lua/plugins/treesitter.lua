return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")
        ts.setup({})

        local parsers = {
            "javascript", "typescript", "tsx",
            "go", "gomod", "gowork", "gosum",
            "rust",
            "lua", "luadoc",
            "json", -- covers "jsonc" filetype too (no separate jsonc parser)
            "html", "css",
            "markdown", "markdown_inline",
            "vim", "vimdoc",
            "bash",
        }
        ts.install(parsers)

        local ft_group = vim.api.nvim_create_augroup("SushidevTreesitter", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            group = ft_group,
            pattern = {
                "javascript", "javascriptreact",
                "typescript", "typescriptreact",
                "go", "gomod", "gowork", "gosum",
                "rust",
                "lua",
                "json",
                "html", "css",
                "markdown",
                "vim", "vimdoc",
                "bash",
            },
            callback = function()
                -- Parser may not be installed yet on first run; don't error.
                pcall(vim.treesitter.start)
            end,
        })

        -- jsonc has no dedicated parser; reuse the json grammar.
        vim.api.nvim_create_autocmd("FileType", {
            group = ft_group,
            pattern = "jsonc",
            callback = function()
                pcall(vim.treesitter.start, 0, "json")
            end,
        })
    end,
}
