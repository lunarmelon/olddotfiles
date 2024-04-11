local opts = {
	ensure_installed = {
		"black",
		"clang-format",
		"cpplint",
		"djlint",
		"efm",
		"emmet-language-server",
		"emmet-ls",
		"eslint_d",
		"fixjson",
		"flake8",
		"html-lsp",
		"lua-language-server",
		"prettierd",
		"shellcheck",
		"shfmt",
		"stylelint",
		"stylua",
		"tailwindcss-language-server",
		"typescript-language-server",
	},
	automatic_installation = true,
}

return {
	"williamboman/mason-lspconfig.nvim",
	opts = opts,
	event = "BufReadPre",
	dependencies = "williamboman/mason.nvim",
}
