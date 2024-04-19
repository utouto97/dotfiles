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
vim.opt.swapfile = false

vim.o.shell = "zsh"

vim.g.mapleader = " "
vim.keymap.set("n", "ZZ", "<nop>")
vim.keymap.set("n", "ZQ", "<nop>")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
-- vim.keymap.set("n", "/", "<nop>")
-- vim.keymap.set("n", "//", "/")
vim.keymap.set("n", "s", "<nop>")
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

local opts = {
	defaults = {
		lazy = true,
	},
	performance = {
		cache = {
			enabled = true,
		},
	},
}

require("lazy").setup("plugins", opts)
