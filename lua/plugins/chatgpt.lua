return {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    -- Ensure API key is set
    local openai_api_key = os.getenv("OPENAI_API_KEY")
    if not openai_api_key or openai_api_key == "" then
      vim.notify("Missing OpenAI API key! Set OPENAI_API_KEY environment variable.", vim.log.levels.ERROR)
      return
    end

    require("chatgpt").setup({
      openai_params = {
        model = "gpt-4o-mini",
        frequency_penalty = 0,
        presence_penalty = 0,
        max_tokens = 4095,
        temperature = 0.2,
        top_p = 0.1,
        n = 1,
      },
    })

    vim.keymap.set("n", "<leader>gl", "<cmd>ChatGPT<CR>", { desc = "Launch ChatGPT" })
    vim.keymap.set("n", "<leader>ge", "<cmd>ChatGPTEditWithInstruction<CR>", { desc = "Edit with instruction" })
  end,
}
