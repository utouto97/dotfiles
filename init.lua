vim.cmd([[packadd packer.nvim]])

require("packer").startup(function(use)
	use({ "wbthomason/packer.nvim", opt = true })

	--------------------------------------------------
	-- # requirements
	--------------------------------------------------

	-- nvim-web-devicons
	-- required by lualine.nvim telescope.nvim
	use({ "kyazdani42/nvim-web-devicons", opt = true })

	-- plenary.nvim
	-- required by null-ls.nvim telescope.nvim neotest
	use({ "nvim-lua/plenary.nvim", opt = true })

	-- nvim-lspconfig
	-- required by mason-lspconfig.nvim
	use({ "neovim/nvim-lspconfig", opt = true })

	--------------------------------------------------
	-- Appearance
	--------------------------------------------------

	use({
		"tanvirtin/monokai.nvim",
		config = function()
			require("monokai").setup({})
		end,
	})

	use({
		"nvim-lualine/lualine.nvim",
		event = { "InsertEnter", "CursorHold", "FocusLost", "BufRead", "BufNewFile" },
		wants = { "nvim-web-devicons" },
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
	})

	use({
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufRead", "BufNewFile" },
		wants = { "nvim-treesitter" },
		config = function()
			require("indent_blankline").setup({
				space_char_blankline = " ",
				show_current_context = true,
				show_current_context_start = true,
			})
		end,
	})

	--------------------------------------------------
	-- Terminal
	--------------------------------------------------

	use({
		"akinsho/toggleterm.nvim",
		cmd = { "ToggleTerm", "ToggleTermSendVisualLines" },
		tag = "2.*",
		setup = function()
			vim.keymap.set("n", "<C-t>", "<cmd>ToggleTerm<cr>")
			vim.keymap.set("t", "<C-t>", "<cmd>ToggleTerm<cr>")
			vim.keymap.set("v", "<C-t>", ":ToggleTermSendVisualLines<cr> <bar> <cmd>ToggleTerm<cr>")
		end,
		config = function()
			require("toggleterm").setup({
				direction = "float",
				autochdir = true,
			})
		end,
	})

	--------------------------------------------------
	-- Motion
	--------------------------------------------------

	use({
		"phaazon/hop.nvim",
		branch = "v2",
		cmd = { "HopChar2" },
		setup = function()
			vim.keymap.set("n", "F", "<cmd>HopChar2<cr>")
			vim.keymap.set("v", "F", "<cmd>HopChar2<cr>")
		end,
		config = function()
			require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
		end,
	})

	use({
		"drybalka/tree-climber.nvim",
		module = { "tree-climber" },
		setup = function()
			local keyopts = { noremap = true, silent = true }
			vim.keymap.set({ "n", "v" }, "H", function()
				require("tree-climber").goto_parent()
			end, keyopts)
		end,
	})

	--------------------------------------------------
	-- LSP
	--------------------------------------------------

	use({
		"williamboman/mason.nvim",
		cmd = { "Mason" },
		config = function()
			require("mason").setup()
		end,
	})

	use({
		"williamboman/mason-lspconfig.nvim",
		event = { "BufRead", "BufNewFile" },
		requires = {
			{ "hrsh7th/cmp-nvim-lsp", opt = true },
		},
		wants = { "mason.nvim", "nvim-lspconfig", "cmp-nvim-lsp" },
		config = function()
			local on_attach = function(_, _)
				local set = vim.keymap.set
				--        set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
				--        set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
				--        set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
				--        set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
				set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
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
	})

	use({
		"jose-elias-alvarez/null-ls.nvim",
		event = { "BufRead", "BufNewFile" },
		wants = { "mason.nvim", "plenary.nvim" },
		config = function()
			local mason = require("mason")
			local mason_package = require("mason-core.package")
			local mason_registry = require("mason-registry")
			local null_ls = require("null-ls")

			mason.setup({})

			local null_sources = {
				null_ls.builtins.formatting.gofmt,
			}

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
	})

	--------------------------------------------------
	-- Treesitter
	--------------------------------------------------

	use({
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
	})

	--------------------------------------------------
	-- Completion
	--------------------------------------------------

	use({
		"hrsh7th/nvim-cmp",
		module = { "cmp" },
		requires = {
			{ "hrsh7th/cmp-nvim-lsp", event = { "InsertEnter" } },
			{ "ray-x/cmp-treesitter", event = { "InsertEnter" } },
			{ "hrsh7th/cmp-vsnip", event = { "InsertEnter" } },
			{ "hrsh7th/vim-vsnip", opt = true },
			{ "onsails/lspkind-nvim", opt = true },
		},
		wants = {
			"vim-vsnip",
			"lspkind-nvim",
		},
		config = function()
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
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "treesitter" },
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
	})

	--------------------------------------------------
	-- Fuzzy finder
	--------------------------------------------------

	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		module = { "telescope" },
		requires = {
			{ "~/work/pg/memo.nvim", opt = true },
			{ "ahmedkhalf/project.nvim", opt = true },
		},
		wants = {
			"plenary.nvim",
			"nvim-web-devicons",
			"memo.nvim",
			"project.nvim",
		},
		setup = function()
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
			vim.keymap.set("n", "<Leader>p", extension("projects", "projects"))
			vim.keymap.set("n", "<Leader>g", builtin("git_branches"))
		end,
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = {
						"node_modules",
						".git",
					},
				},
			})

			require("project_nvim").setup({
				silent_chdir = false,
				detection_methods = { "pattern" },
			})
		end,
	})

	--------------------------------------------------
	-- Task runner
	--------------------------------------------------

	use({
		"stevearc/overseer.nvim",
		config = function()
			require("overseer").setup()
		end,
	})

	--------------------------------------------------
	-- Project local settings
	--------------------------------------------------

	use({
		"klen/nvim-config-local",
		config = function()
			require("config-local").setup({})
		end,
	})

	--------------------------------------------------
	-- Testing
	--------------------------------------------------

	use({
		"nvim-neotest/neotest",
		module = { "neotest" },
		requires = {
			{ "antoinemadec/FixCursorHold.nvim", opt = true },
			{ "nvim-neotest/neotest-go", opt = true },
		},
		wants = {
			"plenary.nvim",
			"nvim-treesitter",
			"FixCursorHold.nvim",
			"neotest-go",
		},
		setup = function()
			vim.keymap.set("n", "<Leader>tl", "<cmd>lua require('neotest').summary.toggle()<cr>")
			vim.keymap.set("n", "<Leader>to", "<cmd>lua require('neotest').output.open()<cr>")
			vim.keymap.set("n", "<Leader>tt", "<cmd>lua require('neotest').run.run()<cr>")
			vim.keymap.set("n", "<Leader>tr", "<cmd>lua require('neotest').run.run_last()<cr>")
		end,
		config = function()
			local neotest_ns = vim.api.nvim_create_namespace("neotest")
			vim.diagnostic.config({
				virtual_text = {
					format = function(diagnostic)
						local message =
							diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
						return message
					end,
				},
			}, neotest_ns)
			require("neotest").setup({
				adapters = {
					require("neotest-go"),
				},
			})
		end,
	})

	--------------------------------------------------
	-- Github
	--------------------------------------------------

	use({
		"pwntester/octo.nvim",
		cmd = { "Octo" },
		wants = { "telescope.nvim" },
		setup = function()
			vim.keymap.set("n", "gh", "<cmd>Octo actions<cr>")
		end,
		config = function()
			require("octo").setup({})
		end,
	})

	--------------------------------------------------
	-- Others
	--------------------------------------------------

	use({
		"tyru/open-browser.vim",
		keys = { "<Plug>(openbrowser-smart-search)" },
		setup = function()
			vim.keymap.set("n", "gu", "<Plug>(openbrowser-smart-search)")
			vim.keymap.set("v", "gu", "<Plug>(openbrowser-smart-search)")
		end,
	})

	use({
		"iamcco/markdown-preview.nvim",
		opt = true,
		ft = "markdown",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			vim.g.mkdp_auto_close = 0
		end,
	})

	use({
		"terrortylor/nvim-comment",
		keys = {
			{ "n", "gc" },
			{ "v", "gc" },
		},
		setup = function()
			vim.keymap.set("n", "gc", "<cmd>CommentToggle<cr>")
			vim.keymap.set("v", "gc", "<cmd>CommentToggle<cr>")
		end,
		config = function()
			require("nvim_comment").setup()
		end,
	})

	use({
		"lewis6991/gitsigns.nvim",
		event = { "FocusLost", "CursorHold" },
		config = function()
			require("gitsigns").setup()
		end,
	})

	use({
		"rcarriga/nvim-notify",
		event = { "BufRead", "BufNewFile" },
		config = function()
			vim.notify = require("notify")
		end,
	})
end)

-- vim.cmd([[autocmd BufWritePost init.lua source <afile> | PackerCompile]])

vim.cmd([[
augroup MyColors
autocmd!
  autocmd ColorScheme * highlight FloatBorder guibg=none guifg=orange
  autocmd ColorScheme * highlight NormalFloat guibg=none
augroup end
]])

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
vim.opt.ambiwidth = single
vim.opt.updatetime = 1000
vim.opt.clipboard:append({ "unnamedplus" })

vim.g.mapleader = " "
vim.keymap.set("n", "ZZ", "<nop>")
vim.keymap.set("n", "ZQ", "<nop>")
-- vim.keymap.set("n", "<C-j>", "<cmd>bp<cr>")
-- vim.keymap.set("n", "<C-k>", "<cmd>bn<cr>")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("i", "jj", "<Esc>")
-- vim.keymap.set("t", "<C-j>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-x>", "<C-\\><C-n>")
