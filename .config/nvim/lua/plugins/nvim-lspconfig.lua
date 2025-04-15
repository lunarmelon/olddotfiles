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
	--[[ 
	-- python
	lspconfig.pyright.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		settings = {
			pyright = {
				disableOrganizeImports = true,
				analysis = {
					useLibraryCodeForTypes = true,
					autoSearchPaths = true,
					diagnosticMode = "workspace",
					autoImportCompletion = true,
				},
			},
		},
	}) ]]
	lspconfig.ruff.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		settings = {
			python = {
				analysis = {
					typeCheckingMode = "off",
				},
			},
		},
	})

	--typescript
	lspconfig.ts_ls.setup({
		on_attach = on_attach,
		capabilities = capabilities,
		filetypes = {
			"typescript",
			"typescriptreact",
			"javascript",
			"javascriptreact",
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
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
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
			"zsh",
			"bash",
			"aliasrc",
			"zshrc",
			"optionrc",
		},
		settings = {
			bashIde = {
				shellcheckPath = "",
				shfmt = { spaceRedirects = true },
			},
		},
	})

	-- typescriptreact, javascriptreact, css, sass, scss, less
	lspconfig.emmet_ls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = {
			"typescriptreact",
			"javascriptreact",
			"javascript",
			"css",
			"scss",
			"less",
			"html",
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
		},
	})

	-- css
	lspconfig.cssls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = {
			"css",
			"scss",
			"less",
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

	-- toml
	lspconfig.taplo.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = {
			"toml",
		},
	})

	-- markdown
	lspconfig.marksman.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- perl
	lspconfig.perlnavigator.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = {
			"perl",
		},
	})

	-- php
	lspconfig.intelephense.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = {
			"php",
		},
	})

	for type, icon in pairs(diagnostic_signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	local null_ls = require("null-ls")
	null_ls.setup({
		sources = {
			-- Lua
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.diagnostics.selene.with({
				condition = function(utils)
					return utils.root_has_file({ ".selene.toml", "selene.toml" })
				end,
			}),

			-- Python
			-- require("none-ls.diagnostics.ruff"),
			-- require("none-ls.formatting.ruff"),

			-- JavaScript/TypeScript
			null_ls.builtins.formatting.prettierd,
			null_ls.builtins.diagnostics.eslint_d,

			-- JSON
			null_ls.builtins.formatting.fixjson,

			-- Shell
			null_ls.builtins.formatting.shfmt.with({
				extra_args = { "-i", "2", "-ci" },
			}),
			null_ls.builtins.diagnostics.shellcheck,

			-- HTML/CSS
			null_ls.builtins.formatting.prettierd,
			null_ls.builtins.diagnostics.stylelint,

			-- Markdown
			null_ls.builtins.diagnostics.markdownlint,

			-- Docker
			null_ls.builtins.diagnostics.hadolint,

			-- C/C++
			null_ls.builtins.formatting.clang_format,

			-- Perl
			null_ls.builtins.formatting.perltidy,
			null_ls.builtins.diagnostics.perlcritic,

			-- PHP
			-- null_ls.builtins.formatting.phpcbf,
			-- null_ls.builtins.diagnostics.phpcs,
		},
		on_attach = on_attach,
	})
end

return {
	"neovim/nvim-lspconfig",
	config = config,
	lazy = false,
	dependencies = {
		"windwp/nvim-autopairs",
		"williamboman/mason.nvim",
		{
			"nvimtools/none-ls.nvim",
			opts = function() end,
			dependencies = {
				"nvimtools/none-ls-extras.nvim",
			},
		},
		"jay-babu/mason-null-ls.nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lua",
		"b0o/schemastore.nvim",
	},
}
