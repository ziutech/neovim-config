local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

local setup = {
	plugins = {
		marks = true, -- show s a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = false, -- adds help for motions
			text_objects = false, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	-- operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<cr>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "single", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { "j", "k" },
		v = { "j", "k" },
	},
}

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
	["b"] = {
		"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown())<cr>",
		"Buffers",
	},
	["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
	["w"] = { "<cmd>w<CR>", "Save" },
	["q"] = { "<cmd>qa<CR>", "Quit" },
	["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
	["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
	["f"] = { "<cmd>Telescope find_files<cr>", "Find files" },
	["F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },

	p = {
		name = "Packer",
		c = { "<cmd>PackerCompile<cr>", "Compile" },
		i = { "<cmd>PackerInstall<cr>", "Install" },
		s = { "<cmd>PackerSync<cr>", "Sync" },
		S = { "<cmd>PackerStatus<cr>", "Status" },
		u = { "<cmd>PackerUpdate<cr>", "Update" },
	},

	g = {
		name = "Git",
		j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
		k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
		l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
		p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
		r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
		R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
		s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
		u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
		o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
		b = {
			":Telescope git_branches theme=dropdown<cr>",
			"Checkout branch",
		},
		c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
		d = { ":Telescope git_bcommits theme=ivy<cr>", "Diff" },
	},

	l = {
		name = "LSP",
		d = { "<cmd>Telescope diagnostics theme=dropdown<cr>", "Document Diagnostics" },
		f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format" },
		i = { "<cmd>LspInfo<cr>", "Info" },
		I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
		j = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Next Diagnostic" },
		k = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
		t = { "<cmd>TroubleToggle<cr>", "Trouble" },
		-- l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },

		-- TroubleToggle is better
		-- q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
		r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
		s = { "<cmd>Telescope treesitter<cr>", "Document Symbols" },
	},

	r = {
		name = "Rust",
    a = {":RustCodeAction<cr>", "Code actions"},
		r = { ":lua require'rust-tools.runnables'.runnables()<cr>", "Runnables" },
		d = { ":lua require'rust-tools.debuggables'.debuggables()<cr>", "Debuggables" },
		i = { ":lua require'rust-tools.inlay_hints'.toggle_inlay_hints()<cr>", "Inlay hints" },
		h = { ":lua require'rust-tools.hover_actions'.hover_actions()<cr>", "Hover actions" },
		c = { ":lua require'rust-tools.open_cargo_toml'.open_cargo_toml()<cr>", "Cargo toml" },
		j = { ":lua require'rust-tools.join_lines'.join_lines()<cr>", "Join lines" },
		-- s = { ":lua require'rust-tools.ssr'.ssr()<cr>", "Structural search and replace" },
	},

	d = {
		name = "Debugger",
		b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Breakpoint" },
		B = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Clear breakpoint" },
		d = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
		n = { "<cmd>lua require'dap'.step_over()<cr>", "Step over" },
		N = { "<cmd>lua require'dap'.step_into()<cr>", "Step into" },
		t = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate" },
		u = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle ui" },
	},
	s = {
		name = "Search",
		r = { "<cmd>Telescope resume<cr>", "Resume last search" },
		m = { "<cmd>Telescope marks<cr>", "Marks" },
		h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
		R = { "<cmd>Telescope registers<cr>", "Registers" },
		k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
		C = { "<cmd>Telescope commands<cr>", "Commands" },
	},
}

local lspopts = {
	mode = "n",
	prefix = "",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = true,
}

local lspmappings = {
	g = {
		c = {
			name = "Comment",
			c = "Toggle line",
			-- A = "Add comment after",
			o = "Add comment under",
			O = "which_key_ignore",
		},
		b = "which_key_ignore",
		d = { ":Telescope lsp_definitions<cr>", "Definition" },
		D = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration" },
		i = { ":Telescope lsp_implementations<cr>", "Implementation" },
		r = { ":Telescope lsp_references<cr>", "References" },
		l = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Diagnostic" },
	},
}
local vopts = {
	mode = "v", -- VISUAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}
local vmappings = {}

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
which_key.register(lspmappings, lspopts)
