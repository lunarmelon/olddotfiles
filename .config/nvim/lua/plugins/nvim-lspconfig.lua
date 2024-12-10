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
	lspconfig.ts_ls.setup({
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

	-- Markdown
	lspconfig.marksman.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = {
			"markdown",
		},
	})

	-- Perl
	lspconfig.perlnavigator.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = {
			"perl",
		},
	})

	-- Julia
	lspconfig.julials.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = {
			"julia",
		},
		julia_env_path = "$HOME/.julia/environments/nvim-lspconfig/",
		on_new_config = function(config, workspace_dir)
			local _ = require("mason-core.functional")
			local fs = require("mason-core.fs")
			local path = require("mason-core.path")

			-- The default configuration used by `mason-lspconfig`:
			--
			--   https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/server_configurations/julials/init.lua
			--
			-- has the following logic to obtain the current environment path:
			--
			--   1. Check if `env_path` is defined.
			--   2. Check if we are in a Julia project.
			--   3. Call julia to return the current env path.
			--
			-- However, the third step causes a significant slow down when Julia is called in a
			-- single file mode because it must wait loading Julia. Here, we will invert the
			-- logic:
			--
			--   1. Check if we are in a Julia project.
			--   2. Check if `env_path` is defined.
			--   3. Call julia to return the current env path.
			--
			-- Hence, if we define `env_path`, we can still use the project folder as root and
			-- avoid the slowdown in the single file case.
			local env_path = nil
			local file_exists = _.compose(fs.sync.file_exists, path.concat, _.concat({ workspace_dir }))
			if
				(file_exists({ "Project.toml" }) and file_exists({ "Manifest.toml" }))
				or (file_exists({ "JuliaProject.toml" }) and file_exists({ "JuliaManifest.toml" }))
			then
				env_path = workspace_dir
			end

			if not env_path then
				env_path = config.julia_env_path and vim.fn.expand(config.julia_env_path)
			end

			if not env_path then
				local ok, env = pcall(vim.fn.system, {
					"julia",
					"--startup-file=no",
					"--history-file=no",
					"-e",
					"using Pkg; print(dirname(Pkg.Types.Context().env.project_file))",
				})
				if ok then
					env_path = env
				end
			end

			config.cmd = {
				vim.fn.exepath("julia-lsp"),
				env_path,
			}
			config.cmd_env = vim.tbl_extend("keep", config.cmd_env or {}, {
				SYMBOL_SERVER = config.symbol_server,
				SYMBOL_CACHE_DOWNLOAD = (config.symbol_cache_download == false) and "0" or "1",
			})
		end,
		settings = {
			julia = {
				inlayHints = {
					static = {
						enabled = true,
						variableTypes = {
							enabled = false,
						},
					},
				},
			},
		},
	})

	-- Go
	lspconfig.gopls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = {
			"go",
		},
	})

	-- Rust
	lspconfig.rust_analyzer.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = {
			"rust",
		},
	})

	-- Ruby
	lspconfig.ruby_lsp.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = {
			"ruby",
		},
		root_dir = lspconfig.util.root_pattern("Gemfile", "package.json", "config.ru"),
	})

	for type, icon in pairs(diagnostic_signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	-- Lua
	local luacheck = require("efmls-configs.linters.luacheck")
	local stylua = require("efmls-configs.formatters.stylua")

	-- Python
	local flake8 = require("efmls-configs.linters.flake8")
	local black = require("efmls-configs.formatters.black")

	-- Javascript, Typescript, JSON, React
	local eslint = require("efmls-configs.linters.eslint")
	local prettier_d = require("efmls-configs.formatters.prettier_d")
	local fixjson = require("efmls-configs.formatters.fixjson")

	-- Bash
	local shellcheck = require("efmls-configs.linters.shellcheck")
	local shfmt = require("efmls-configs.formatters.shfmt")

	-- C, C++
	-- local cpplint = require("efmls-configs.linters.cpplint")
	local clangformat = require("efmls-configs.formatters.clang_format")

	-- Docker
	local hadolint = require("efmls-configs.linters.hadolint")

	-- Markdown
	local markdown_lint = require("efmls-configs.linters.markdownlint")

	-- Go
	local goimports = require("efmls-configs.formatters.goimports")
	local golangci_lint = require("efmls-configs.linters.golangci_lint")

	-- Ruby
	local rubocop = require("efmls-configs.linters.rubocop")

	lspconfig.efm.setup({
		filetypes = {
			"lua",
			"python",
			"json",
			"jsonc",
			"sh",
			"bash",
			"zsh",
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
			"toml",
			"julia",
			"go",
			"rust",
			"ruby",
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
				python = { black },
				typescript = { eslint, prettier_d },
				json = { eslint, fixjson },
				jsonc = { eslint, fixjson },
				sh = { shellcheck, shfmt },
				bash = { shellcheck, shfmt },
				zsh = { shfmt },
				javascript = { eslint, prettier_d },
				javascriptreact = { eslint, prettier_d },
				typescriptreact = { eslint, prettier_d },
				markdown = { markdown_lint, prettier_d },
				html = { prettier_d },
				css = { prettier_d },
				c = { clangformat },
				cpp = { clangformat },
				docker = { hadolint, prettier_d },
				go = { goimports, golangci_lint },
				rust = {},
				ruby = { rubocop },
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
		"hrsh7th/cmp-nvim-lua",
		"b0o/schemastore.nvim",
	},
}
