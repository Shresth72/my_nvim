local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require "null-ls"

local opts = {
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.clang_format,
    null_ls.builtins.formatting.fourmolu,
    null_ls.builtins.formatting.golines,
    null_ls.builtins.formatting.shellharden,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.yamlfmt,
    null_ls.builtins.formatting.asmfmt,
    null_ls.builtins.formatting.csharpier,
    null_ls.builtins.formatting.black,

    -- null_ls.builtins.diagnostics.pylint.with({
    --   command = "pylint",
    --   args = { "--from-stdin", "$FILENAME" },
    --   diagnostics_postprocess = function(diagnostic)
    --     diagnostic.code = diagnostic.message_id
    --   end,
    -- }),
  },
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds {
        group = augroup,
        buffer = bufnr,
      }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end

    -- local pyopts = { noremap = true, silent = true }
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>m", "<cmd>lua vim.lsp.buf.format()<CR>", pyopts)
  end,
}

return opts
