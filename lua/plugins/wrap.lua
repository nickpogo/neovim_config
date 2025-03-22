return {
	"andrewferrier/wrapping.nvim",
	config = function()
		require("wrapping").setup()

		-- Create an autocommand group for TeX files
		local group = vim.api.nvim_create_augroup("TexFileWrapping", { clear = true })

		-- Set soft wrapping for .tex files
		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = "tex",
			callback = function()
				vim.defer_fn(function()
					vim.wo.wrap = true -- Enable soft wrapping
					vim.wo.linebreak = true -- Break lines at word boundaries
					vim.bo.textwidth = 0 -- Disable automatic text width
				end, 50) -- Small delay to ensure settings apply correctly
			end,
		})
	end,
}
