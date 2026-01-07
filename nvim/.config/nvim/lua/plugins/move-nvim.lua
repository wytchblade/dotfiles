return {
  "fedepujol/move.nvim",
  keys = {
    -- Normal Mode
    -- { "<A-j>", ":MoveLine(1)<CR>", desc = "Move Line Up" },
    -- { "<A-k>", ":MoveLine(-1)<CR>", desc = "Move Line Down" },
    -- { "<A-h>", ":MoveHChar(-1)<CR>", desc = "Move Character Left" },
    -- { "<A-l>", ":MoveHChar(1)<CR>", desc = "Move Character Right" },
    { "<C-b>", ":MoveWord(-1)<CR>", mode = { "n" }, desc = "Move Word Left" },
    { "<C-w>", ":MoveWord(1)<CR>", mode = { "n" }, desc = "Move Word Right" },
    -- Visual Mode
    { "<C-k>", ":MoveBlock(1)<CR>", mode = { "v" }, desc = "Move Block Up" },
    { "<C-j>", ":MoveBlock(-1)<CR>", mode = { "v" }, desc = "Move Block Down" },
    { "<C-h>", ":MoveHBlock(-1)<CR>", mode = { "v" }, desc = "Move Block Left" },
    { "<C-l>", ":MoveHBlock(1)<CR>", mode = { "v" }, desc = "Move Block Right" },
  },
  opts = {
    line = {
      enable = false, -- Enables line movement
      indent = false  -- Toggles indentation
    },
    block = {
      enable = true, -- Enables block movement
      indent = false  -- Toggles indentation
    },
    word = {
      enable = true, -- Enables word movement
    },
    char = {
      enable = false -- Enables char movement
    }
    -- Config here
  }
}
