return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async", -- required dependency
  },
  event = "BufReadPost", -- lazy load when opening a buffer
  config = function()
    -- nvim-ufo setup
    require("ufo").setup({
      provider_selector = function(bufnr, filetype, buftype)
        -- Use treesitter, then fallback to indent
        return { "treesitter", "indent" }
      end
    })

    -- Keymaps for folding
    vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
    vim.keymap.set("n", "zm", require("ufo").closeFoldsWith)
    vim.keymap.set("n", "zp", function()
      require("ufo").peekFoldedLinesUnderCursor()
    end)

    -- Recommended: set fold options
    vim.o.foldcolumn = "1" -- show fold column
    vim.o.foldlevel = 2   -- keep folds open by default
    vim.o.foldlevelstart = 2
    vim.o.foldenable = true
  end
}
