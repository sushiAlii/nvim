return {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost", "BufReadPost", "InsertLeave" },
    config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
            javascript = { "eslint_d" },
            javascriptreact = { "eslint_d" },
            typescript = { "eslint_d" },
            typescriptreact = { "eslint_d" },
        }

        local eslint_config_patterns = {
            "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs", "eslint.config.ts",
            ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json", ".eslintrc.yaml", ".eslintrc.yml",
        }

        local function has_eslint_config(bufnr)
            local buf_path = vim.api.nvim_buf_get_name(bufnr)
            if buf_path == "" then
                return false
            end
            local found = vim.fs.find(eslint_config_patterns, {
                path = vim.fs.dirname(buf_path),
                upward = true,
            })
            return #found > 0
        end

        local group = vim.api.nvim_create_augroup("SushidevLint", { clear = true })
        vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
            group = group,
            callback = function(event)
                if lint.linters_by_ft[vim.bo[event.buf].filetype] and has_eslint_config(event.buf) then
                    lint.try_lint()
                end
            end,
        })
    end,
}
