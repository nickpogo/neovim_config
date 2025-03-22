local M = {}


local telescope = require("telescope.builtin")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")

function M.check_grammar()
  -- Ensure API key is available
  local openai_api_key = os.getenv("OPENAI_API_KEY")
  if not openai_api_key then return end

  -- Get selected text (force latest selection)
  vim.cmd('normal! "vy')  -- Yank selection into register v
  local text = vim.fn.getreg("v")

  if text == "" then return end  -- Exit if nothing is selected

  -- Define ChatGPT prompt (only returns corrected text)
  local prompt = "Fix any grammar, punctuation, and style mistakes in the following text. " ..
                 "Return only the corrected version, with no explanations or comments:\n\n" .. text

  -- Escape JSON properly
  local json_payload = vim.fn.json_encode({
    model = "gpt-4o-mini",
    messages = { { role = "user", content = prompt } },
    max_tokens = 500
  })

  -- OpenAI API request
  local cmd = string.format(
    "curl -s -X POST https://api.openai.com/v1/chat/completions " ..
    "-H 'Authorization: Bearer %s' " ..
    "-H 'Content-Type: application/json' " ..
    "-d '%s'",
    openai_api_key, json_payload
  )

  local handle = io.popen(cmd)
  if not handle then return end
  local result = handle:read("*a")
  handle:close()

  -- Decode JSON response
  local json = vim.fn.json_decode(result)
  if not json or not json.choices or #json.choices == 0 then return end

  -- Get the AI's corrected version
  local corrected_text = json.choices[1].message.content

  -- Telescope entries
  local suggestions = {
    { display = "Original", text = text },
    { display = "Corrected", text = corrected_text }
  }

  -- Open Telescope with **corrected layout order**
  require("telescope.pickers").new({}, {
    prompt_title = "Grammar Suggestions",
    layout_strategy = "vertical",  -- Up/down split

    layout_config = {
      height = 0.95,             -- Use 95% of the screen height
      preview_cutoff = 1,        -- Ensure preview is always shown
      prompt_position = "bottom", -- Keep input at the bottom
      preview_height = 0.75,     -- **Top section (largest) - Preview**
    },
    finder = finders.new_table({
      results = suggestions,
      entry_maker = function(entry)
        return {
          value = entry.text,
          display = entry.display,
          ordinal = entry.display
        }
      end
    }),
    sorter = conf.generic_sorter({}),
    previewer = previewers.new_buffer_previewer({
      define_preview = function(self, entry)
        if entry and entry.value then
          local bufnr = self.state.bufnr
          local win_id = self.state.winid  -- Get preview window ID

          local lines = vim.split(entry.value, "\n", true)
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

          -- Set buffer options (to be safe)
          vim.api.nvim_buf_set_option(bufnr, "modifiable", false)  

          -- Force wrapping in the **window** (NOT just the buffer)
          if win_id then
            vim.api.nvim_win_set_option(win_id, "wrap", true)        -- Enable wrap
            vim.api.nvim_win_set_option(win_id, "linebreak", true)   -- Prevent word splitting
            vim.api.nvim_win_set_option(win_id, "breakindent", true) -- Indent wrapped lines
          end
        end
      end
    }),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        -- Replace selected text with the AI's corrected version
        if selection and selection.display == "Corrected" then
          vim.cmd("normal! gv\"_d")  -- Delete selected text
          vim.api.nvim_put({ selection.value }, "", true, true)  -- Insert corrected version
        end
      end)
      return true
    end
  }):find()
end


-- local telescope = require("telescope.builtin")
-- local finders = require("telescope.finders")
-- local conf = require("telescope.config").values
-- local actions = require("telescope.actions")
-- local action_state = require("telescope.actions.state")
-- local previewers = require("telescope.previewers")
--
-- function M.check_grammar()
--   -- Ensure API key is available
--   local openai_api_key = os.getenv("OPENAI_API_KEY")
--   if not openai_api_key then return end
--
--   -- Get selected text (force latest selection)
--   vim.cmd('normal! "vy')  -- Yank selection into register v
--   local text = vim.fn.getreg("v")
--
--   if text == "" then return end  -- Exit if nothing is selected
--
--   -- Define ChatGPT prompt (only returns corrected text)
--   local prompt = "Fix any grammar, punctuation, and style mistakes in the following text. " ..
--                  "Return only the corrected version, with no explanations or comments:\n\n" .. text
--
--   -- Escape JSON properly
--   local json_payload = vim.fn.json_encode({
--     model = "gpt-4o-mini",
--     messages = { { role = "user", content = prompt } },
--     max_tokens = 500
--   })
--
--   -- OpenAI API request
--   local cmd = string.format(
--     "curl -s -X POST https://api.openai.com/v1/chat/completions " ..
--     "-H 'Authorization: Bearer %s' " ..
--     "-H 'Content-Type: application/json' " ..
--     "-d '%s'",
--     openai_api_key, json_payload
--   )
--
--   local handle = io.popen(cmd)
--   if not handle then return end
--   local result = handle:read("*a")
--   handle:close()
--
--   -- Decode JSON response
--   local json = vim.fn.json_decode(result)
--   if not json or not json.choices or #json.choices == 0 then return end
--
--   -- Get the AI's corrected version
--   local corrected_text = json.choices[1].message.content
--
--   -- Telescope entries
--   local suggestions = {
--     { display = "Original", text = text },
--     { display = "Corrected", text = corrected_text }
--   }
--
--   -- Open Telescope with an **up/down split** and force text wrapping
--   require("telescope.pickers").new({}, {
--     prompt_title = "Grammar Suggestions",
--     layout_strategy = "vertical",  -- Use up/down split
--     layout_config = {
--       height = 0.9,  -- Use 90% of the window height
--       mirror = true  -- Ensures "Original" is at the top, "Corrected" below
--     },
--     finder = finders.new_table({
--       results = suggestions,
--       entry_maker = function(entry)
--         return {
--           value = entry.text,
--           display = entry.display,
--           ordinal = entry.display
--         }
--       end
--     }),
--     sorter = conf.generic_sorter({}),
--     previewer = previewers.new_buffer_previewer({
--       define_preview = function(self, entry)
--         if entry and entry.value then
--           local bufnr = self.state.bufnr
--           local win_id = self.state.winid  -- Get preview window ID
--
--           local lines = vim.split(entry.value, "\n", true)
--           vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
--
--           -- Set buffer options (to be safe)
--           vim.api.nvim_buf_set_option(bufnr, "modifiable", false)  
--
--           -- Force wrapping in the **window** (NOT just the buffer)
--           if win_id then
--             vim.api.nvim_win_set_option(win_id, "wrap", true)        -- Enable wrap
--             vim.api.nvim_win_set_option(win_id, "linebreak", true)   -- Prevent word splitting
--             vim.api.nvim_win_set_option(win_id, "breakindent", true) -- Indent wrapped lines
--           end
--         end
--       end
--     }),
--     attach_mappings = function(prompt_bufnr, map)
--       actions.select_default:replace(function()
--         local selection = action_state.get_selected_entry()
--         actions.close(prompt_bufnr)
--
--         -- Replace selected text with the AI's corrected version
--         if selection and selection.display == "Corrected" then
--           vim.cmd("normal! gv\"_d")  -- Delete selected text
--           vim.api.nvim_put({ selection.value }, "", true, true)  -- Insert corrected version
--         end
--       end)
--       return true
--     end
--   }):find()
-- end
--
--
--
-- -- function M.check_grammar()
-- --   vim.cmd('normal! "vy')  -- Copy selection to register v (forces update)
-- --
-- --   vim.schedule(function()
-- --     local selected_text = vim.fn.getreg("v")  -- Get text from register v
-- --
-- --     if selected_text == "" then
-- --       vim.notify("No text selected!", vim.log.levels.ERROR)
-- --     else
-- --       vim.notify("Selected text: " .. selected_text, vim.log.levels.INFO)
-- --     end
-- --   end)
-- -- end
--


return M




