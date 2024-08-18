return {
	"uga-rosa/ccc.nvim",
	event = "FileType",
	opts = {
		highlighter = {
			auto_enable = true,
			lsp = true,
			filetypes = {
				"html",
				"lua",
				"css",
				"scss",
				"sass",
				"less",
				"javascript",
				"typescript",
				"javascriptreact",
				"typescriptreact",
			},
			excludes = { "lazy", "mason", "help" },
		},
	},
}
