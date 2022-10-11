vim.cmd([[packadd packer.nvim]])

require("packer").startup(function(use)
	use({ "wbthomason/packer.nvim", opt = true })

	use({ "kyazdani42/nvim-web-devicons" })

	-- 外観
	use({
		"navarasu/onedark.nvim",
		config = function()
			require("onedark").setup({
				style = "darker",
			})
			require("onedark").load()
		end,
	})
	-- use({
	-- 	"tanvirtin/monokai.nvim",
	-- 	config = function()
	-- 		require("monokai").setup({})
	-- 	end,
	-- })
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
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
	use({ "lukas-reineke/indent-blankline.nvim" })
	-- use {
	--   "yamatsum/nvim-cursorline",
	--   config = function()
	--     require('nvim-cursorline').setup {
	--       cursorline = {
	--         enable = true,
	--         timeout = 1000,
	--         number = false,
	--       },
	--       cursorword = {
	--         enable = true,
	--         min_length = 3,
	--         hl = { underline = true },
	--       }
	--     }
	--   end
	-- }

	-- 操作
	use({
		"akinsho/toggleterm.nvim",
		tag = "v2.*",
		config = function()
			vim.keymap.set("n", "<C-t>", "<cmd>ToggleTerm<cr>")
			vim.keymap.set("t", "<C-t>", "<cmd>ToggleTerm<cr>")
			vim.keymap.set("v", "<C-t>", ":ToggleTermSendVisualLines<cr> <bar> <cmd>ToggleTerm<cr>")
			require("toggleterm").setup({
				direction = "float",
			})
		end,
	})

	-- LSP
	use({ "neovim/nvim-lspconfig" })
	use({
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	})
	use({
		"williamboman/mason-lspconfig.nvim",
		after = { "mason.nvim", "nvim-lspconfig", "cmp-nvim-lsp" },
		config = function()
			local on_attach = function(_, _)
				local set = vim.keymap.set
				--        set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
				--        set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
				--        set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
				--        set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
				set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
				set("n", "<Leader>n", "<cmd>lua vim.lsp.buf.rename()<CR>")
				set("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting_sync()<cr>")
			end
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
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
		after = "mason.nvim",
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
				-- on_attach = function(client, bufnr)
				-- 	if client.supports_method("textDocument/formatting") then
				-- 		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				-- 		vim.api.nvim_create_autocmd("BufWritePre", {
				-- 			group = augroup,
				-- 			buffer = bufnr,
				-- 			callback = function()
				-- 				vim.lsp.buf.formatting_sync()
				-- 			end,
				-- 		})
				-- 	end
				-- end,
			})
		end,
	})

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
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

	-- 補完
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
			"onsails/lspkind-nvim",
			"ray-x/cmp-treesitter",
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

	-- ファジーファインダー
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			vim.keymap.set("n", "<Leader>e", "<cmd>Telescope find_files hidden=true<cr>")
			vim.keymap.set("n", "<Leader>r", "<cmd>Telescope oldfiles<cr>")
			vim.keymap.set("n", "<Leader>l", "<cmd>Telescope buffers<cr>")
			-- vim.keymap.set("n", "<Leader>g", "<cmd>Telescope git_status<cr>")
			vim.keymap.set("n", "<Leader>d", "<cmd>Telescope diagnostics<cr>")
			vim.keymap.set("n", "g/", "<cmd>Telescope current_buffer_fuzzy_find<cr>")
			vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>")
			vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>")
			vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>")
			vim.keymap.set("n", "gs", "<cmd>Telescope lsp_document_symbols<cr>")

			require("telescope").setup({
				defaults = {
					file_ignore_patterns = {
						"node_modules",
						".git",
					},
				},
			})
		end,
	})

	use({
		"~/work/pg/memo.nvim",
		-- 'utouto97/memo.nvim',
		requires = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("memo").setup()
			require("telescope").load_extension("memo")
			vim.keymap.set("n", "<Leader>m", "<cmd>Telescope memo<cr>")
		end,
	})

	-- テスト
	use({
		"nvim-neotest/neotest",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-go",
		},
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

			vim.keymap.set("n", "<Leader>tl", "<cmd>lua require('neotest').summary.toggle()<cr>")
			vim.keymap.set("n", "<Leader>to", "<cmd>lua require('neotest').output.open()<cr>")
			vim.keymap.set("n", "<Leader>tt", "<cmd>lua require('neotest').run.run()<cr>")
			vim.keymap.set("n", "<Leader>tr", "<cmd>lua require('neotest').run.run_last()<cr>")
		end,
	})

	-- その他
	use({
		"tyru/open-browser.vim",
		config = function()
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
		config = function()
			vim.keymap.set("n", "gc", "<cmd>CommentToggle<cr>")
			vim.keymap.set("v", "gc", "<cmd>CommentToggle<cr>")

			require("nvim_comment").setup()
		end,
	})
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	})
	use({
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
		end,
	})
	use({
		"tamago324/lir.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons",
		},
		config = function()
			local actions = require("lir.actions")

			vim.keymap.set("n", "<Leader>p", require("lir.float").toggle)

			require("lir").setup({
				show_hidden_files = true,
				devicons_enable = true,
				mappings = {
					["l"] = actions.edit,
					["h"] = actions.up,
					["q"] = actions.quit,
					["K"] = actions.mkdir,
					["N"] = actions.newfile,
					["R"] = actions.rename,
					["@"] = actions.cd,
					["Y"] = actions.yank_path,
					["D"] = actions.delete,
				},
				float = {
					winblend = 0,
					curdir_window = {
						enable = true,
						highlight_dirname = true,
					},
					win_opts = function()
						local width = math.floor(vim.o.columns * 0.6)
						local height = math.floor(vim.o.lines * 0.6)
						return {
							border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
							width = width,
							height = height,
						}
					end,
				},
				hide_cursor = true,
				on_init = function()
					vim.api.nvim_echo({ { vim.fn.expand("%:p"), "Normal" } }, false, {})
					vim.cmd([[hi link LirFloatBorder Normal]])
				end,
			})
		end,
	})
end)

vim.cmd([[autocmd BufWritePost init.lua source <afile> | PackerCompile]])

vim.cmd([[
augroup MyColors
autocmd!
  autocmd ColorScheme * highlight FloatBorder guibg=none guifg=orange
  autocmd ColorScheme * highlight NormalFloat guibg=none
augroup end
]])

vim.cmd([[au BufWritePre * lua vim.lsp.buf.formatting_sync()]])

vim.opt.encoding = "utf-8"
vim.opt.relativenumber = true
vim.opt.hidden = true
--vim.opt.updatetime=250
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
