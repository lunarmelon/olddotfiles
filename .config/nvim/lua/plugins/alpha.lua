local function getLen(str, start_pos)
	local byte = string.byte(str, start_pos)
	if not byte then
		return nil
	end

	return (byte < 0x80 and 1) or (byte < 0xE0 and 2) or (byte < 0xF0 and 3) or (byte < 0xF8 and 4) or 1
end

local function colorize(header, header_color_map, colors)
	for letter, color in pairs(colors) do
		local color_name = "AlphaJemuelKwelKwelWalangTatay" .. letter
		vim.api.nvim_set_hl(0, color_name, color)
		colors[letter] = color_name
	end

	local colorized = {}

	for i, line in ipairs(header_color_map) do
		local colorized_line = {}
		local pos = 0

		for j = 1, #line do
			local start = pos
			pos = pos + getLen(header[i], start + 1)

			local color_name = colors[line:sub(j, j)]
			if color_name then
				table.insert(colorized_line, { color_name, start, pos })
			end
		end

		table.insert(colorized, colorized_line)
	end

	return colorized
end

return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	opts = function()
		local mocha = require("catppuccin.palettes").get_palette("mocha")
		local dashboard = require("alpha.themes.dashboard")

		local neovim_logo = {
			"                                                    ",
			" ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
			" ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
			" ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
			" ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
			" ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
			" ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
			"                                                    ",
		}

		local header = {
			[[ ██████████████████████████████████████████████████████████████████████████████████████████████████████                                   ]],
			[[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
			[[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
			[[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
			[[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
			[[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
			[[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
			[[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
			[[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
			[[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
			[[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
			[[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
			[[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
			[[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
			[[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
			[[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
			[[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
			[[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
			[[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
			[[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
		}

		local color_map = {
			[[ WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBWWWWWWWWWWWWWW ]],
			[[ RRRRWWWWWWWWWWWWWWWWRRRRRRRRRRRRRRRRWWWWWWWWWWWWWWWWBBPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPBBWWWWWWWWWWWW ]],
			[[ RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRBBPPPPPPHHHHHHHHHHHHHHHHHHHHHHHHHHPPPPPPBBWWWWWWWWWW ]],
			[[ RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRBBPPPPHHHHHHHHHHHHFFHHHHFFHHHHHHHHHHPPPPBBWWWWWWWWWW ]],
			[[ OOOORRRRRRRRRRRRRRRROOOOOOOOOOOOOOOORRRRRRRRRRRRRRBBPPHHHHFFHHHHHHHHHHHHHHHHHHHHHHHHHHHHPPBBWWWWWWWWWW ]],
			[[ OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOBBPPHHHHHHHHHHHHHHHHHHHHBBBBHHHHFFHHHHPPBBWWBBBBWWWW ]],
			[[ OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOBBPPHHHHHHHHHHHHHHHHHHBBMMMMBBHHHHHHHHPPBBBBMMMMBBWW ]],
			[[ YYYYOOOOOOOOOOOOOOOOYYYYYYYYYYYYYYYYOOBBBBBBBBOOOOBBPPHHHHHHHHHHHHFFHHHHBBMMMMMMBBHHHHHHPPBBMMMMMMBBWW ]],
			[[ YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYBBMMMMBBBBOOBBPPHHHHHHHHHHHHHHHHHHBBMMMMMMMMBBBBBBBBMMMMMMMMBBWW ]],
			[[ YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYBBBBMMMMBBBBBBPPHHHHHHFFHHHHHHHHHHBBMMMMMMMMMMMMMMMMMMMMMMMMBBWW ]],
			[[ GGGGYYYYYYYYYYYYYYYYGGGGGGGGGGGGGGGGYYYYBBBBMMMMBBBBPPHHHHHHHHHHHHHHFFBBMMMMMMMMMMMMMMMMMMMMMMMMMMMMBB ]],
			[[ GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBBBMMMMBBPPHHFFHHHHHHHHHHHHBBMMMMMMCCBBMMMMMMMMMMCCBBMMMMBB ]],
			[[ GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBBBBBBBPPHHHHHHHHHHHHHHHHBBMMMMMMBBBBMMMMMMBBMMBBBBMMMMBB ]],
			[[ UUUUGGGGGGGGGGGGGGGGUUUUUUUUUUUUUUUUGGGGGGGGGGGGBBBBPPHHHHHHHHHHFFHHHHBBMMRRRRMMMMMMMMMMMMMMMMMMRRRRBB ]],
			[[ UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUBBPPPPHHFFHHHHHHHHHHBBMMRRRRMMBBMMMMBBMMMMBBMMRRRRBB ]],
			[[ UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUBBPPPPPPHHHHHHHHHHHHHHBBMMMMMMBBBBBBBBBBBBBBMMMMBBWW ]],
			[[ VVVVUUUUUUUUUUUUUUUUVVVVVVVVVVVVVVVVUUUUUUUUUUUUBBBBBBPPPPPPPPPPPPPPPPPPPPBBMMMMMMMMMMMMMMMMMMMMBBWWWW ]],
			[[ VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVBBMMMMMMBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBWWWWWW ]],
			[[ VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVBBMMMMBBBBWWBBMMMMBBWWWWWWWWWWBBMMMMBBWWBBMMMMBBWWWWWWWW ]],
			[[ WWWWVVVVVVVVVVVVVVVVWWWWWWWWWWWWWWWWVVVVVVVVVVBBBBBBBBWWWWBBBBBBWWWWWWWWWWWWWWBBBBBBWWWWBBBBWWWWWWWWWW ]],
		}

		local colors = {
			["W"] = { fg = mocha.base },
			["C"] = { fg = mocha.text },
			["B"] = { fg = mocha.crust },
			["R"] = { fg = mocha.red },
			["O"] = { fg = mocha.peach },
			["Y"] = { fg = mocha.yellow },
			["G"] = { fg = mocha.green },
			["U"] = { fg = mocha.blue },
			["P"] = { fg = mocha.yellow },
			["H"] = { fg = mocha.pink },
			["F"] = { fg = mocha.red },
			["M"] = { fg = mocha.overlay0 },
			["V"] = { fg = mocha.lavender },
		}

		dashboard.section.header.val = header
		dashboard.section.header.opts = {
			hl = colorize(header, color_map, colors),
			position = "center",
		}

		dashboard.section.buttons.val = {
			dashboard.button("n", "  New file", "<cmd>ene<CR>"),
			dashboard.button("SPC f f", "  Find file", "<cmd>Telescope find_files<CR>"),
			dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<CR>"),
			dashboard.button("m", "󱌣  Mason", "<cmd>Mason<CR>"),
			dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
		}
		return dashboard
	end,
	config = function(_, dashboard)
		local alpha = require("alpha")

		vim.api.nvim_create_autocmd("User", {
			callback = function()
				local stats = require("lazy").stats()
				local ms = math.floor(stats.startuptime * 100) / 100
				dashboard.section.footer.val = "󱐌 Lazy-loaded "
					.. stats.loaded
					.. "/"
					.. stats.count
					.. " plugins in "
					.. ms
					.. "ms"
				pcall(vim.cmd.AlphaRedraw)
			end,
		})
		alpha.setup(dashboard.opts)
	end,
}
