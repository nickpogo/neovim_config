return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      -- these are examples, not defaults. Please see the readme
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 21

      -- I find auto open annoying, keep in mind setting this option will require setting
      -- a keybind for `:noautocmd MoltenEnterOutput` to open the output again
      vim.g.molten_auto_open_output = false

      -- optional, I like wrapping. works for virt text and the output window
      vim.g.molten_wrap_output = true

      -- Output as virtual text. Allows outputs to always be shown, works with images, but can
      -- be buggy with longer images
      vim.g.molten_virt_text_output = true

      -- this will make it so the output shows up below the \`\`\` cell delimiter
      vim.g.molten_virt_lines_off_by_1 = true

      -- Enable LaTeX formula rendering
      vim.g.molten_latex_enable = true
      vim.g.molten_latex_renderer = "pnglatex" -- or another supported renderer


      -- Set the path explicitly in Neovim
      vim.env.PATH = vim.env.PATH .. ':/home/nickpogo/Programs/miniforge3/bin/'


      -- don't change the mappings (unless it's related to your bug)
      vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>", {desc = "Molten Init"})
      vim.keymap.set("n", "<localleader>e", ":MoltenEvaluateOperator<CR>", {desc = "Evaluate operator"})
      vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>", {desc = "Reevalute cell"})
      -- vim.keymap.set("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<CR>gv", {desc = "Evaluate visual"})
      vim.keymap.set("n", "<localleader>os", ":noautocmd MoltenEnterOutput<CR>", {desc = "Open output window"})
      vim.keymap.set("n", "<localleader>oh", ":MoltenHideOutput<CR>", {desc = "Hide output"})
      vim.keymap.set("n", "<localleader>md", ":MoltenDelete<CR>", {desc = "Delete"})

    end,
  },
  {
    -- see the image.nvim readme for more information about configuring this plugin
    "3rd/image.nvim",
    opts = {
      backend = "kitty", -- whatever backend you would like to use
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },
}
