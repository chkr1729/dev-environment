-- nvim-treesitter `main` branch (Neovim 0.12+). The plugin only installs parsers
-- and queries; highlighting, folding and node selection are built into Neovim.
-- Requires `tree-sitter-cli` (Brewfile) and a C compiler.
local ensure_installed = {
  "json",
  "html",
  "css",
  "markdown",
  "markdown_inline",
  "latex",
  "bash",
  "lua",
  "vim",
  "dockerfile",
  "gitignore",
  "query",
  "vimdoc",
  "c",
  "cpp",
  "python",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false, -- main branch does not support lazy-loading
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local ts = require("nvim-treesitter")
    ts.install(ensure_installed)

    local available = {}
    for _, lang in ipairs(ts.get_available()) do
      available[lang] = true
    end

    local function enable(buf, lang)
      if not pcall(vim.treesitter.start, buf, lang) then
        return
      end
      vim.wo[0][0].foldmethod = "expr"
      vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("chandu_treesitter", { clear = true }),
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then
          return
        end
        if vim.treesitter.language.add(lang) then
          enable(args.buf, lang)
        elseif available[lang] then
          -- auto-install missing parsers, then attach once ready
          ts.install(lang):await(function()
            if vim.api.nvim_buf_is_valid(args.buf) then
              vim.api.nvim_buf_call(args.buf, function()
                enable(args.buf, lang)
              end)
            end
          end)
        end
      end,
    })

    vim.opt.foldlevel = 99 -- keep folds open initially

    -- incremental selection via Neovim's built-in `an` (parent) / `in` (child)
    vim.keymap.set("n", "<C-s>", "van", { remap = true, desc = "Start treesitter node selection" })
    vim.keymap.set("x", "<C-s>", "an", { remap = true, desc = "Expand to parent node" })
    vim.keymap.set("x", "<bs>", "in", { remap = true, desc = "Shrink to child node" })

    require("nvim-ts-autotag").setup()
  end,
}
