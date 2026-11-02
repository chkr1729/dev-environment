return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  init = function()
    -- skip the legacy nvim-treesitter module (needs nvim-treesitter.configs, gone on `main`)
    vim.g.skip_ts_context_commentstring_module = true
  end,
  config = function()
    require("ts_context_commentstring").setup({ enable_autocmd = false })

    -- import comment plugin safely
    local comment = require("Comment")

    local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

    -- enable comment
    comment.setup({
      -- for commenting tsx, jsx, svelte, html files
      pre_hook = ts_context_commentstring.create_pre_hook(),
    })
  end,
}
