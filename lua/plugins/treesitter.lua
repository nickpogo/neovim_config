return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/playground",
  },
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      auto_install = true,
      ensure_installed = { "lua", "javascript", "julia", "python", "latex", "markdown", "markdown_inline" },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "latex" }, -- This keeps VimTeX syntax highlighting active
      },
      indent = { enable = true },
      conceal = { enable = true },

      -- for molten
      textobjects = {
        enable = true, -- Enable Treesitter text objects
        move = {
          enable = true,
          set_jumps = false,
          goto_next_start = {
            ["]b"] = { query = "@code_cell.inner", desc = "next code block" },
          },
          goto_previous_start = {
            ["[b"] = { query = "@code_cell.inner", desc = "previous code block" },
          },
        },
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["ib"] = { query = "@code_cell.inner", desc = "in block" },
            ["ab"] = { query = "@code_cell.outer", desc = "around block" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>sbl"] = "@code_cell.outer",
          },
          swap_previous = {
            ["<leader>sbh"] = "@code_cell.outer",
          },
        },
      },
    })
  end,
}
