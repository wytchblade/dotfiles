  return {
    'Thiago4532/mdmath.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = { filetypes = {'markdown', 'julia', 'tex', 'asciidoc', 'rmd', 'qmd'},
    -- Hide the text when in the Insert Mode.
             hide_on_insert = true,
             internal_scale = 1.0,
             dynamic_scale = 0.8,
             anticonceal = true,

    }

    -- The build is already done by default in lazy.nvim, so you don't need
    -- the next line, but you can use the command `:MdMath build` to rebuild
    -- if the build fails for some reason.
    -- build = ':MdMath build'
  }
