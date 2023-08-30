vim.opt.encoding = "utf-8"
vim.opt.relativenumber = true
vim.opt.hidden = true
vim.opt.visualbell = true
vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrapscan = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.wrap = true
vim.opt.ambiwidth = single
vim.opt.updatetime = 1000
vim.opt.clipboard:append({ "unnamedplus" })
vim.opt.equalalways = false
vim.opt.termguicolors = true

vim.o.shell = "zsh"

vim.g.mapleader = " "
vim.keymap.set("n", "ZZ", "<nop>")
vim.keymap.set("n", "ZQ", "<nop>")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("t", "<C-x>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-w>", "<C-\\><C-n>")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

	-- 	--------------------------------------------------
	-- 	-- Appearance
	-- 	--------------------------------------------------
	{
		"tanvirtin/monokai.nvim",
		config = function()
			require("monokai").setup({})
		end,
	},
	{
		"mvllow/modes.nvim",
		tag = "v0.2.0",
		event = "VeryLazy",
		config = function()
			require("modes").setup()
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = false, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
			})
		end,
	},
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "VeryLazy",
		config = function()
			require("fidget").setup({})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "onedark",
					component_separators = { left = "", right = "" },
					-- section_separators = { left = '', right = ''},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "filename" },
					lualine_c = { "branch", "diff" },
					lualine_x = { "diagnostics" },
					lualine_y = { "filetype", "encoding" },
					lualine_z = { "location" },
				},
			})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufRead", "BufNewFile" },
		dependencies = { "nvim-treesitter" },
		config = function()
			require("indent_blankline").setup({
				space_char_blankline = " ",
				show_current_context = true,
				show_current_context_start = true,
			})
		end,
	},
	{
		"gen740/SmoothCursor.nvim",
		config = function()
			require("smoothcursor").setup({
				type = "exp",
				fancy = {
					enable = true,
					body = {
						{ cursor = "●", texthl = "SmoothCursorRed" },
						{ cursor = "●", texthl = "SmoothCursorOrange" },
						{ cursor = "●", texthl = "SmoothCursorYellow" },
						{ cursor = "●", texthl = "SmoothCursorGreen" },
						{ cursor = "•", texthl = "SmoothCursorAqua" },
						{ cursor = ".", texthl = "SmoothCursorBlue" },
						{ cursor = ".", texthl = "SmoothCursorPurple" },
					},
				},
			})
		end,
	},
	{
		"echasnovski/mini.indentscope",
		branch = "stable",
		event = "VeryLazy",
	},
	{
		"lewis6991/hover.nvim",
		module = { "hover" },
		config = function()
			require("hover").setup({
				init = function()
					-- Require providers
					require("hover.providers.lsp")
					-- require('hover.providers.gh')
					-- require('hover.providers.gh_user')
					-- require('hover.providers.jira')
					-- require('hover.providers.man')
					-- require('hover.providers.dictionary')
				end,
				preview_opts = {
					border = nil,
				},
				-- Whether the contents of a currently open hover window should be moved
				-- to a :h preview-window when pressing the hover keymap.
				preview_window = false,
				title = true,
			})
		end,
		init = function()
			-- Setup keymaps
			vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
		end,
	},

	-- 	--------------------------------------------------
	-- 	-- Terminal
	-- 	--------------------------------------------------

	{
		"akinsho/toggleterm.nvim",
		cmd = { "ToggleTerm", "ToggleTermSendVisualLines" },
		tag = "2.*",
		init = function()
			vim.keymap.set("n", "<C-t>", "<cmd>ToggleTerm<cr>")
			vim.keymap.set("t", "<C-t>", "<cmd>ToggleTerm<cr>")
			vim.keymap.set("v", "<C-t>", ":ToggleTermSendVisualLines<cr> <bar> <cmd>ToggleTerm<cr>")
		end,
		config = function()
			require("toggleterm").setup({
				direction = "float",
				autochdir = true,
				float_opts = {
					-- winblend = 15,
				},
			})
		end,
	},

	-- 	--------------------------------------------------
	-- 	-- LSP
	-- 	--------------------------------------------------

	{
		"williamboman/mason.nvim",
		cmd = { "Mason" },
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		event = { "BufRead", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
		},
		wants = { "mason.nvim", "nvim-lspconfig", "cmp-nvim-lsp" },
		config = function()
			local on_attach = function(_, _)
				local set = vim.keymap.set
				--        set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
				--        set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
				--        set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
				--        set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
				-- set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
				set("n", "<Leader>n", "<cmd>lua vim.lsp.buf.rename()<CR>")
				-- set("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<cr>")
				vim.api.nvim_create_autocmd({ "CursorHold" }, {
					callback = function()
						vim.diagnostic.open_float(nil, { focusable = false })
					end,
				})
			end
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local opts = { capabilities = capabilities, on_attach = on_attach }

			require("mason-lspconfig").setup()
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup(opts)
				end,
			})
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = { "BufRead", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local mason = require("mason")
			local mason_package = require("mason-core.package")
			local mason_registry = require("mason-registry")
			local null_ls = require("null-ls")

			mason.setup({})

			local null_sources = {}

			for _, package in ipairs(mason_registry.get_installed_packages()) do
				local package_categories = package.spec.categories[1]
				if package_categories == mason_package.Cat.Formatter then
					table.insert(null_sources, null_ls.builtins.formatting[package.name])
				end
				if package_categories == mason_package.Cat.Linter then
					table.insert(null_sources, null_ls.builtins.diagnostics[package.name])
				end
			end

			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			null_ls.setup({
				sources = null_sources,
				-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({
									filter = function(c)
										return c.name == "null-ls"
									end,
									bufnr = bufnr,
								})
							end,
						})
					end
				end,
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		module = { "cmp" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"ray-x/cmp-treesitter",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
			"onsails/lspkind-nvim",
		},
		config = function()
			local has_words_before = function()
				if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
					return false
				end
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
			end

			local cmp = require("cmp")
			local lspkind = require("lspkind")
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = vim.schedule_wrap(function(fallback)
						if cmp.visible() and has_words_before() then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
						else
							fallback()
						end
					end),
				}),
				sources = cmp.config.sources({
					{ name = "copilot", priority = 3 },
					{ name = "nvim_lsp", priority = 2 },
					{ name = "treesitter", priority = 1 },
				}),
				formatting = {
					format = lspkind.cmp_format({
						with_text = true,
						menu = {
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							cmp_tabnine = "[TabNine]",
							copilot = "[Copilot]",
							luasnip = "[LuaSnip]",
							nvim_lua = "[NeovimLua]",
							latex_symbols = "[LaTeX]",
							path = "[Path]",
							omni = "[Omni]",
							spell = "[Spell]",
							emoji = "[Emoji]",
							calc = "[Calc]",
							rg = "[Rg]",
							treesitter = "[TS]",
							dictionary = "[Dictionary]",
							mocword = "[mocword]",
							cmdline_history = "[History]",
						},
						maxwidth = 50,
					}),
				},
			})
		end,
	},

	-- 	--------------------------------------------------
	-- 	-- Fuzzy finder
	-- 	--------------------------------------------------

	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		module = { "telescope" },
		dependencies = {
			"utouto97/memo.nvim",
		},
		init = function()
			local function builtin(name)
				return function()
					return require("telescope.builtin")[name]({})
				end
			end

			local function extension(name, prop)
				return function()
					local telescope = require("telescope")
					telescope.load_extension(name)
					return telescope.extensions[name][prop]({})
				end
			end

			vim.keymap.set("n", "<Leader>e", builtin("find_files"))
			vim.keymap.set("n", "<Leader>r", builtin("oldfiles"))
			vim.keymap.set("n", "<Leader>l", builtin("buffers"))
			vim.keymap.set("n", "<Leader>d", builtin("diagnostics"))
			vim.keymap.set("n", "gi", builtin("lsp_implementations"))
			vim.keymap.set("n", "gi", builtin("lsp_implementations"))
			vim.keymap.set("n", "gd", builtin("lsp_definitions"))
			vim.keymap.set("n", "gr", builtin("lsp_references"))
			vim.keymap.set("n", "gs", builtin("lsp_document_symbols"))
			vim.keymap.set("n", "<Leader>m", extension("memo", "memo"))
			vim.keymap.set("n", "<Leader>gb", builtin("git_branches"))
			vim.keymap.set("n", "<Leader>gs", builtin("git_status"))
		end,
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = {
						"node_modules",
						".git",
					},
				},
				pickers = {
					find_files = {
						hidden = true,
					},
				},
			})
		end,
	},

	-- 	--------------------------------------------------
	-- 	-- Treesitter
	-- 	--------------------------------------------------

	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufRead", "BufNewFile" },
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "lua" },
				highlight = {
					enable = true,
				},
			})
		end,
	},

	-- 	--------------------------------------------------
	-- 	-- Copilot
	-- 	--------------------------------------------------
	{
		"zbirenbaum/copilot-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"zbirenbaum/copilot.lua",
				cmd = "Copilot",
				config = function()
					require("copilot").setup({
						suggestion = { enabled = false },
						panel = { enabled = false },
					})
				end,
			},
		},
		fix_pairs = true,
		config = function()
			require("copilot_cmp").setup()
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		dependencies = { "kyazdani42/nvim-web-devicons" },
		config = function()
			require("gitsigns").setup()
		end,
	},

	-- 	--------------------------------------------------
	-- 	-- Others
	-- 	--------------------------------------------------

	{
		"tyru/open-browser.vim",
		-- keys = { "<Plug>(openbrowser-smart-search)" },
		init = function()
			vim.keymap.set("n", "gu", "<Plug>(openbrowser-smart-search)")
			vim.keymap.set("v", "gu", "<Plug>(openbrowser-smart-search)")
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		opt = true,
		ft = "markdown",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			vim.g.mkdp_auto_close = 0
		end,
	},
	{
		"terrortylor/nvim-comment",
		-- keys = {
		-- 	{ "n", "gc" },
		-- 	{ "v", "gc" },
		-- },
		init = function()
			vim.keymap.set("n", "gc", "<cmd>CommentToggle<cr>")
			vim.keymap.set("v", "gc", "<cmd>CommentToggle<cr>")
		end,
		config = function()
			require("nvim_comment").setup()
		end,
	},
	-- 	{
	-- 		"klen/nvim-config-local",
	-- 		event = { "BufRead", "BufNewFile" },
	-- 		config = function()
	-- 			require("config-local").setup({})
	-- 		end,
	-- 	},
})
