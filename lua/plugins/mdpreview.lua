return {
	-- install without yarn or npm
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown", "quarto" },
		build = function()
			vim.fn["mkdp#util#install"]()
      vim.g.mkdp_filetypes = { "markdown", "quarto" }
		end,
	},

	-- install with yarn or npm
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown", "quarto" }
			vim.g.mkdp_theme = "dark"
		end,
		ft = { "markdown", "quarto" },
	},
	{
		"andrewferrier/wrapping.nvim",
		config = function()
			require("wrapping").setup()
		end,
	},
}
