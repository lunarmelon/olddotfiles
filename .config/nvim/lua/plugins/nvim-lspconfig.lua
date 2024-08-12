local on_attach = require("util.lsp").on_attach
local diagnostic_signs = require("util.icons").diagnostic_signs
local typescript_organise_imports = require("util.lsp").typescript_organise_imports

local config = function()
	require("neoconf").setup({})
	local cmp_nvim_lsp = require("cmp_nvim_lsp")
	local lspconfig = require("lspconfig")
	local capabilities = cmp_nvim_lsp.default_capabilities()

	-- lua
	lspconfig.lua_ls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		settings = { -- custom settings for lua
			Lua = {
				-- make the language server recognize "vim" global
				diagnostics = {
					globals = { "vim" },
					disable = { "missing-fields" },
				},
				workspace = {
					library = {
						vim.fn.expand("$VIMRUNTIME/lua"),
						vim.fn.expand("$XDG_CONFIG_HOME") .. "/nvim/lua",
					},
				},
				telemetry = { enable = false },
			},
		},
	})

	-- python
	lspconfig.pyright.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		settings = {
			pyright = {
				disableOrganizeImports = false,
				analysis = {
					useLibraryCodeForTypes = true,
					autoSearchPaths = true,
					diagnosticMode = "workspace",
					autoImportCompletion = true,
				},
			},
		},
	})

	--typescript
	lspconfig.tsserver.setup({
		on_attach = on_attach,
		capabilities = capabilities,
		filetypes = {
			"typescript",
			"typescriptreact",
			"javascript",
			"javascriptreact",
			"ejs",
		},
		commands = {
			TypeScriptOrganizeImports = typescript_organise_imports,
		},
		settings = {
			typescript = {
				indentStyle = "Space",
				indentSize = "2",
			},
		},
		root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
	})

	-- json
	lspconfig.jsonls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { "json", "jsonc" },
	})

	-- docker
	lspconfig.dockerls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- bash
	lspconfig.bashls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = {
			"sh",
			"aliasrc",
			"zshrc",
		},
	})

	-- typescriptreact, javascriptreact, css, sass, scss, less, ejs
	lspconfig.emmet_ls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = {
			"typescriptreact",
			"javascriptreact",
			"javascript",
			"css",
			"sass",
			"scss",
			"less",
			"html",
			"ejs",
		},
	})

	-- emmet
	lspconfig.emmet_language_server.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = {
			"html",
			"typescriptreact",
			"javascriptreact",
			"ejs",
		},
	})

	-- html
	lspconfig.html.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = {
			"javascriptreact",
			"typescriptreact",
			"html",
			"ejs",
		},
	})

	-- css
	lspconfig.cssls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = {
			"css",
		},
	})

	-- tailwindcss
	lspconfig.tailwindcss.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = {
			"css",
			"typescriptreact",
			"javascriptreact",
		},
	})

	-- C/C++
	lspconfig.clangd.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = {
			"clangd",
			"--offset-encoding=utf-16",
		},
	})

	-- Toml
	lspconfig.taplo.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = {
			"toml",
		},
	})

	for type, icon in pairs(diagnostic_signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	local luacheck = require("efmls-configs.linters.luacheck")
	local stylua = require("efmls-configs.formatters.stylua")

	local flake8 = require("efmls-configs.linters.flake8")
	local black = require("efmls-configs.formatters.black")

	local eslint = require("efmls-configs.linters.eslint")
	local prettier_d = require("efmls-configs.formatters.prettier_d")

	local biome = require("efmls-configs.formatters.biome")
	local fixjson = require("efmls-configs.formatters.fixjson")

	local shellcheck = require("efmls-configs.linters.shellcheck")
	local shfmt = require("efmls-configs.formatters.shfmt")

	local cpplint = require("efmls-configs.linters.cpplint")
	local clangformat = require("efmls-configs.formatters.clang_format")

	local djlint = require("efmls-configs.linters.djlint")

	local stylelint = require("efmls-configs.linters.stylelint")

	local hadolint = require("efmls-configs.linters.hadolint")

	lspconfig.efm.setup({
		filetypes = {
			"lua",
			"python",
			"typescript",
			"json",
			"sh",
			"html",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"markdown",
			"docker",
			"css",
			"c",
			"cpp",
			"perl",
			"ejs",
			"toml",
		},
		init_options = {
			documentFormatting = true,
			documentRangeFormatting = true,
			hover = true,
			documentSymbol = true,
			codeAction = true,
			completion = true,
		},
		settings = {
			languages = {
				lua = { luacheck, stylua },
				python = { flake8, black },
				typescript = { eslint, prettier_d },
				json = { biome, fixjson },
				jsonc = { biome, fixjson },
				sh = { shellcheck, shfmt },
				javascript = { eslint, prettier_d },
				javascriptreact = { eslint, prettier_d },
				typescriptreact = { eslint, prettier_d },
				markdown = { prettier_d },
				html = { djlint, prettier_d },
				css = { stylelint, prettier_d },
				c = { clangformat, cpplint },
				cpp = { clangformat, cpplint },
				docker = { hadolint, prettier_d },
				ejs = { djlint, prettier_d },
			},
		},
	})
end

return {
	"neovim/nvim-lspconfig",
	config = config,
	lazy = false,
	dependencies = {
		"windwp/nvim-autopairs",
		"williamboman/mason.nvim",
		"creativenull/efmls-configs-nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
	},
}
