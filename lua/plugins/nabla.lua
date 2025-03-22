return {
  "jbyuki/nabla.nvim",
  config = function()
    local ts_utils = require("nvim-treesitter.ts_utils")
    local nabla = require("nabla")

    local function is_inside_math_env()
      local node = ts_utils.get_node_at_cursor()
      while node do
        local node_type = node:type()
        if node_type == "math_environment" or node_type == "displayed_equation" or node_type == "inline_formula" then
          return true
        end
        node = node:parent()
      end
      return false
    end

    local function show_math_preview()
      if is_inside_math_env() then
        nabla.popup({ silent = true }) -- Show formula preview in popup
      end
    end

    -- Auto-trigger preview when typing inside math environments
    vim.api.nvim_create_autocmd("TextChangedI", {
      pattern = "*.tex",
      callback = show_math_preview,
    })

    -- Clear previews when leaving insert mode
    vim.api.nvim_create_autocmd("InsertLeave", {
      pattern = "*.tex",
      callback = function()
        vim.api.nvim_command("redraw") -- Redraw screen to remove overlays
      end,
    })
  end,
}
--
-- return {
--   "jbyuki/nabla.nvim",
--   config = function()
--     local ts_utils = require("nvim-treesitter.ts_utils")
--     local nabla = require("nabla")
--
--     local preview_win = nil -- Store the popup window ID
--
--     local function is_inside_math_env()
--       local node = ts_utils.get_node_at_cursor()
--       while node do
--         local node_type = node:type()
--         if node_type == "math_environment" or node_type == "displayed_equation" or node_type == "inline_formula" then
--           return true
--         end
--         node = node:parent()
--       end
--       return false
--     end
--
--     local function show_math_preview()
--       if is_inside_math_env() and vim.fn.mode() == "i" then
--         preview_win = nabla.popup({ silent = true })
--       end
--     end
--
--     local function close_math_preview()
--       if preview_win and vim.api.nvim_win_is_valid(preview_win) then
--         vim.api.nvim_win_close(preview_win, true)
--         preview_win = nil
--       end
--     end
--
--     -- Auto-trigger while typing
--     vim.api.nvim_create_autocmd("TextChangedI", {
--       pattern = "*.tex",
--       callback = show_math_preview,
--     })
--
--     -- Close previews when leaving Insert mode
--     vim.api.nvim_create_autocmd("InsertLeave", {
--       pattern = "*.tex",
--       callback = close_math_preview,
--     })
--   end,
-- }
--
