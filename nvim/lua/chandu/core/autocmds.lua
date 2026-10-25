local prose_group = vim.api.nvim_create_augroup("ChanduProseWrap", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = prose_group,
  pattern = { "markdown", "text", "gitcommit", "gitrebase", "Avante", "codecompanion" },
  callback = function(args)
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true

    vim.keymap.set("n", "j", "gj", { buffer = args.buf, desc = "Down by visual line" })
    vim.keymap.set("n", "k", "gk", { buffer = args.buf, desc = "Up by visual line" })
    vim.keymap.set("n", "0", "g0", { buffer = args.buf, desc = "Start of visual line" })
    vim.keymap.set("n", "$", "g$", { buffer = args.buf, desc = "End of visual line" })

    vim.keymap.set("n", "<leader>mw", function()
      vim.wo.wrap = not vim.wo.wrap
      pcall(vim.cmd, "Markview render")
      vim.notify("wrap = " .. tostring(vim.wo.wrap))
    end, { buffer = args.buf, desc = "Toggle wrap (for markdown tables)" })
  end,
})
