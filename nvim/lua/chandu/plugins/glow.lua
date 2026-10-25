return {
  "ellisonleao/glow.nvim",
  cmd = "Glow",
  ft = { "markdown" },
  config = function()
    require("glow").setup({
      border = "rounded",
      width_ratio = 0.9,
      height_ratio = 0.9,
      style = "dark",
      pager = true,
    })

    vim.keymap.set("n", "<leader>mg", "<cmd>Glow<CR>", { desc = "Preview markdown with glow" })
  end,
}
