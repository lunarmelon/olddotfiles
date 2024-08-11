local mason = {
	"williamboman/mason.nvim",
	cmd = "Mason",
	event = "BufReadPre",
	opts = {
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	},
}

local mason_lspconfig = {
	"williamboman/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			"efm",
			"bashls",
			"tsserver",
			"tailwindcss",
			"pyright",
			"html",
			"cssls",
			"lua_ls",
			"emmet_ls",
			"jsonls",
			"clangd",
			"dockerls",
		},
		automatic_installation = true,
	},
	event = "BufReadPre",
	dependencies = "williamboman/mason.nvim",
}

return {
	mason,
	mason_lspconfig,
}
