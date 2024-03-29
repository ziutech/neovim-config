local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end
local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = " ", warn = " " },
  colored = false,
  update_in_insert = false,
  always_visible = true,
}

local diff = {
  "diff",
  colored = false,
  symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width,
}

local mode = {
  "mode",
  fmt = function(str)
    return "-- " .. str .. " --"
  end,
}

local filetype = {
  "filetype",
  icons_enabled = false,
  icon = nil,
}

local branch = {
  "branch",
  icons_enabled = true,
  icon = "",
}

local location = {
  "location",
  padding = 0,
}

-- cool function for progress
local progress = function()
  local current_line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")
  local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
  local line_ratio = current_line / total_lines
  local index = math.ceil(line_ratio * #chars)
  return chars[index]
end

local spaces = function()
  return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end
local macro = function()
  local current_macro = vim.api.nvim_eval("reg_recording()")
  if current_macro ~= "" then
    return "[RECORDING] " .. current_macro
  end
  return current_macro
end

local theme
if vim.g.color_name == "everblush" then
  theme = "everblush"
else
  theme = "auto"
end

lualine.setup({
  options = {
    icons_enabled = true,
    theme = theme,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "alpha", "dashboard", "NvimTree" }, -- "dap-repl", "dapui_scopes", "dapui_breakpoints", "dapui_stacks", "dapui_watches"},
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = { branch, diff, diagnostics },
    lualine_b = { mode },
    lualine_c = { macro },
    lualine_x = { "encoding", "fileformat", filetype },
    lualine_y = { location },
    lualine_z = { progress },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = { filetype },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = { "nvim-tree", "toggleterm", "symbols-outline" },
})
