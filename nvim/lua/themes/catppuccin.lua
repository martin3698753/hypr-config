return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000, -- make sure it loads before anything else
  lazy = false,
  opts = {
    flavour = 'mocha', -- latte, frappe, macchiato, mocha
    transparent_background = false,
    term_colors = true,
    integrations = {
      -- Enable integrations with other plugins you use
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      telescope = true,
      treesitter = true,
      neotree = true,
      -- oil = true,
      which_key = true,
      indent_blankline = {
        enabled = true,
        scope_color = 'lavender', -- catppuccin color
        colored_indent_levels = false,
      },
    },
  },
  config = function(_, opts)
    require('catppuccin').setup(opts)
    vim.cmd.colorscheme 'catppuccin'
  end,
}
