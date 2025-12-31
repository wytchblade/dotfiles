return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config
  opts = {
    scope = {
      show_start = false,
      show_end = false,
      show_exact_scope = false,
    },
    indent = {
      -- Set the character to a vertical bar (or any character you prefer)
      char = "┆",
    },
  },
}


