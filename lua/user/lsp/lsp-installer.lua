local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  return
end

local servers = {
  "sumneko_lua",
  "pyright",
  "tsserver",
  "rust_analyzer",
}

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }

  for _, s in ipairs(servers) do
    if server.name == s then
      local server_opts = require("user.lsp.settings." .. s)
      opts = vim.tbl_deep_extend("force", server_opts, opts)
    end
  end

  -- if server.name == "sumneko_lua" then
  -- 	local sumneko_opts = require("user.lsp.settings.sumneko_lua")
  -- 	opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
  -- end
  --
  -- if server.name == "pyright" then
  -- 	local pyright_opts = require("user.lsp.settings.pyright")
  -- 	opts = vim.tbl_deep_extend("force", pyright_opts, opts)
  -- end
  -- if server.name == "tsserver" then
  -- 	local pyright_opts = require("user.lsp.settings.tsserver")
  -- 	opts = vim.tbl_deep_extend("force", pyright_opts, opts)
  -- end
  -- if server.name == "rust_analyzer" then
  -- 	local pyright_opts = require("user.lsp.settings.rust_analyzer")
  -- 	opts = vim.tbl_deep_extend("force", pyright_opts, opts)
  --  end
  --
  -- if server.name == "hls" then
  -- 	local hls = require("user.lsp.settings.hls")
  -- 	opts = vim.tbl_deep_extend("force", hls, opts)
  -- end
  -- if server.name == "clangd" then
  --   local clangd_opts = require("user.lsp.settings.clangd")
  --   opts = vim.tbl_deep_extend("force", clangd_opts, opts)
  -- end

  -- This setup() function is exactly the same as lspconfig's setup function.
  -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  server:setup(opts)
end)
