vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.clipboard = "unnamedplus"
vim.opt.history = 500
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.cmd("packadd matchit")

vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/ibhagwan/fzf-lua",
}, { load = true, confirm = false })

require("nvim-tree").setup({
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 32,
		side = "left",
	},
 	renderer = {
		group_empty = true,
		highlight_git = true,
		icons = {
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
			},
		},
	},
	filters = {
		dotfiles = false,
	},
	git = {
		enable = true,
		ignore = false,
	},
	update_focused_file = {
		enable = true,
		update_root = false,
	},
	actions = {
		open_file = {
			quit_on_open = false,
			resize_window = true,
		},
	},
})

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>s", "<cmd>NvimTreeFindFile<cr>", { desc = "Reveal current file" })

local fzf = require("fzf-lua")

fzf.setup({
	winopts = {
		height = 0.85,
		width = 0.85,
		preview = {
			layout = "vertical",
			vertical = "down:55%",
		},
	},
	files = {
		prompt = "Files> ",
	},
	grep = {
		prompt = "Grep> ",
	},
})

fzf.register_ui_select()

vim.keymap.set("n", "<D-p>", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "<M-p>", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "g/", fzf.live_grep, { desc = "Search text" })
