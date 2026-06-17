local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')

-- 1. Initialize Mason package manager
mason.setup({})

-- 2. Declare the servers you want installed
local servers = { "lua_ls", "ts_ls", "eslint", "gopls" }

mason_lspconfig.setup({
	ensure_installed = servers,
})

for _, server in ipairs(servers) do
	if server == "lua_ls" then
		-- Tell the Lua server to recognize the 'vim' global variable
		vim.lsp.enable(server, {
			settings = {
				Lua = {
					diagnostics = {
						globals = { 'vim' }
					}
				}
			}
		})
	else
		-- Load all other servers normally
		vim.lsp.enable(server)
	end
end

-- 4. Your IDE Keymaps & Formatting (Keep this exactly as it was)
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(event)
		local opts = { buffer = event.buf }

		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, opts)
		vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references, opts)

		-- Manual format shortcut
		vim.keymap.set('n', '<leader>f', function()
			vim.lsp.buf.format({ async = true })
		end, opts)

		-- Auto-format on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = event.buf,
			callback = function()
				vim.lsp.buf.format({ async = false })
			end,
		})
	end,
})
