return {
  'nvim-telescope/telescope.nvim',
  -- Always pulls the latest stable version automatically
  version = '*', 
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Highly recommended: builds the fast C-sorter on your Mac
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  config = function()
    local telescope = require('telescope')
    
    telescope.setup({})
    
    -- Load the fast extension after setup
    telescope.load_extension('fzf')
  end
}
