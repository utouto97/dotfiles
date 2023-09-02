local M = {
	-- 	--------------------------------------------------
	-- 	-- Terminal
	-- 	--------------------------------------------------

	{
		"akinsho/toggleterm.nvim",
		cmd = { "ToggleTerm", "ToggleTermSendVisualLines" },
		version = "2.*",
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
	-- 	-- Fuzzy finder
	-- 	--------------------------------------------------

	{
		"nvim-telescope/telescope.nvim",
		version = "0.1.0",
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
		build = function()
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
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("gitsigns").setup()
		end,
	},

	-- 	--------------------------------------------------
	-- 	-- Others
	-- 	--------------------------------------------------

	{
		"tyru/open-browser.vim",
		keys = { "<Plug>(openbrowser-smart-search)" },
		init = function()
			vim.keymap.set("n", "gu", "<Plug>(openbrowser-smart-search)")
			vim.keymap.set("v", "gu", "<Plug>(openbrowser-smart-search)")
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		ft = "markdown",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			vim.g.mkdp_auto_close = 0
		end,
	},
	{
		"terrortylor/nvim-comment",
		keys = {
			{ "gc", "<cmd>CommentToggle<cr>", mode = "n" },
			{ "gc", "<cmd>CommentToggle<cr>", mode = "v" },
		},
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
	{
		"pwntester/octo.nvim",
		keys = {
			{ "gh", "<cmd>Octo actions<cr>", desc = "github cli" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("octo").setup()
		end,
	},
}

return M
