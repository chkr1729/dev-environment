return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    treesitter.setup({ -- enable syntax highlighting
      highlight = {
        enable = true,
      },
      -- enable folding
      fold = {
        enable = true,
      },
      -- enable indentation
      indent = { enable = true },
      -- enable autotagging (w/ nvim-ts-autotag plugin)
      autotag = {
        enable = true,
      },
      -- ensure these language parsers are installed
      ensure_installed = {
        "json",
        --"javascript",
        --"typescript",
        --"tsx",
        --"yaml",
        "html",
        "css",
        --"prisma",
        "markdown",
        "markdown_inline",
        --"svelte",
        --"graphql",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "query",
        "vimdoc",
        "c",
        "cpp",
      },
      -- Automatically install missing parsers when opening files
      auto_install = true,

      -- Install parsers asynchronously
      sync_install = false,

      ignore_install = { -- Parsers to ignore during installation
        "haskell", -- Example of a parser to ignore
      },

      modules = {}, -- Add this field even if empty (required)

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-s>",
          node_incremental = "<C-s>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
    -- Global folding settings
    vim.opt.foldmethod = "expr" -- Use expression-based folding
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Use Tree-sitter folding expression
    vim.opt.foldenable = true -- Enable folding by default
    vim.opt.foldlevel = 99 -- Keep all folds open initially
  end,
}
