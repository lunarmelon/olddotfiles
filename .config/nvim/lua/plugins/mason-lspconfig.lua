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
			"bashls",
			"ts_ls",
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
	dependencies = { "williamboman/mason.nvim", "jay-babu/mason-null-ls.nvim" },
}

local mason_null_ls = {
	"jay-babu/mason-null-ls.nvim",
	event = "BufReadPre",
	opts = {
		ensure_installed = {
			-- Formatters
			"stylua",
			"black",
			"prettierd",
			"shfmt",
			"clang-format",
			"perltidy",
			"php-cs-fixer",

			-- Linters
			"selene",
			"flake8",
			"eslint_d",
			"shellcheck",
			"hadolint",
			"markdownlint",
		},
		automatic_installation = true,
	},
}

return {
	mason,
	mason_lspconfig,
	mason_null_ls,
}
