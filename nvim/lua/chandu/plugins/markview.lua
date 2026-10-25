return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  ft = { "markdown", "Avante", "codecompanion" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("markview").setup({
      preview = {
        modes = { "n", "no", "c" },
        hybrid_modes = { "n" },
        linewise_hybrid_mode = true,
        callbacks = {
          on_enable = function(_, win)
            vim.wo[win].conceallevel = 2
            vim.wo[win].concealcursor = "nc"
          end,
        },
      },
      markdown = {
        headings = { shift_width = 0 },
      },
      latex = { enable = true },
    })

    vim.keymap.set("n", "<leader>mp", "<cmd>Markview toggle<CR>", { desc = "Toggle markdown preview" })
  end,
}
