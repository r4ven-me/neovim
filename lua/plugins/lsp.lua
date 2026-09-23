return {
  "neovim/nvim-lspconfig",
  enabled = false,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lspconfig = require("lspconfig")
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Flip enabled=true above and add servers here when full LSP is needed.
    lspconfig.lua_ls.setup({ capabilities = capabilities })
    lspconfig.pyright.setup({ capabilities = capabilities })
  end,
}
