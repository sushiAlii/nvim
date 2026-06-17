local harpoon = require("harpoon")

-- Required initial setup
harpoon:setup()

-- 1. Mark a file (Add current file to your quick list)
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon file" })

-- 2. Open the Visual Menu (See all your bookmarked files)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Open Harpoon menu" })

-- 3. Instant Jump Keys (Jump straight to files 1 through 4)
vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, { desc = "Jump to Harpoon file 1" })
vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end, { desc = "Jump to Harpoon file 2" })
vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end, { desc = "Jump to Harpoon file 3" })
vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end, { desc = "Jump to Harpoon file 4" })

