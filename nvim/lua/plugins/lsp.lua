local M = {
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
		config = function()
			local on_attach = function(client, bufnr)
				local set = vim.keymap.set
				-- set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
				set("n", "<Leader>n", "<cmd>lua vim.lsp.buf.rename()<CR>")
				-- set("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<cr>")
				vim.api.nvim_create_autocmd({ "CursorHold" }, {
					callback = function()
						vim.diagnostic.open_float(nil, { focusable = false })
					end,
				})

				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ bufnr = bufnr })
						end,
					})
				end
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

			null_ls.setup({
				sources = null_sources,
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
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
}

return M
