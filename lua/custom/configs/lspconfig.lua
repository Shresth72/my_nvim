local config = require "plugins.configs.lspconfig"
local on_attach = config.on_attach
local capabilities = config.capabilities

local lspconfig = require "lspconfig"
local util = require "lspconfig/util"

local servers = { "tailwindcss", "eslint", "cssls", "terraformls", "csharp_ls", "gradle_ls" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
  vim.lsp.buf.execute_command(params)
end

lspconfig.pylsp.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "python" },
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          enabled = true,
          ignore = { "E501", "E402", "E251", "E225", "E226" },
        }
      }
    }
  }
})

-- lspconfig.pyright.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   settings = {
--     python = {
--       analysis = {
--         typeCheckingMode = "basic",
--         reportUnusedVariable = "none",
--         reportUnusedImport = "none",
--       },
--     },
--   },
-- }

lspconfig.ts_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    preferences = {
      disableSuggestions = true,
    },
  },
  commands = {
    OrganizeImports = {
      organize_imports,
      description = "Organize Imports",
    },
  },
}

lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose" },
}

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
}

lspconfig.hls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "haskell", "lhaskell", "cabal" },
}

lspconfig.yamlls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    schemaStore = {
      enable = true,
    },
  },
}

lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
    },
  },
}
