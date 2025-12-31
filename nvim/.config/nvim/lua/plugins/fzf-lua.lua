return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional but nice
  config = function()
    require("fzf-lua").setup({
      -- example default setup
      winopts = {
        height = 0.85,  -- 85% of screen height
        width  = 0.80,  -- 80% of screen width
        row    = 0.5,   -- center vertically
        col    = 0.5,   -- center horizontally
        border = "rounded",
      },
    })
  end,
  opts = {},
}
