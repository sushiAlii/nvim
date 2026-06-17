return {
  "nvim-treesitter/nvim-treesitter",
  config = function()
    -- This downloads the JavaScript & TypeScript syntax rules automatically
    require('nvim-treesitter').install({ 'javascript', 'typescript' })
  end
}
