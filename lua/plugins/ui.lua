return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        opts = {
            options = {
                theme = "rose-pine",
                globalstatus = true,
            },
            sections = {
                lualine_b = { "branch", "diff" },
                lualine_c = { "filename" },
                lualine_x = { "diagnostics", "encoding", "filetype" },
            },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            on_attach = function(bufnr)
                local gs = require("gitsigns")
                local opts = { buffer = bufnr }

                vim.keymap.set("n", "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(gs.next_hunk)
                    return "<Ignore>"
                end, vim.tbl_extend("force", opts, { expr = true }))

                vim.keymap.set("n", "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(gs.prev_hunk)
                    return "<Ignore>"
                end, vim.tbl_extend("force", opts, { expr = true }))

                vim.keymap.set("n", "<leader>gb", gs.blame_line, opts)
            end,
        },
    },
}
