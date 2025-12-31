return {
    { "L3MON4D3/LuaSnip", keys = {} },
    {
        "saghen/blink.cmp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            {
                "supermaven-inc/supermaven-nvim",
                opts = {
                    disable_inline_completion = true, -- disables inline completion for use with cmp
                    disable_keymaps = true            -- disables built in keymaps for more manual control
                }
            },
            {
                "huijiro/blink-cmp-supermaven"
            },
        },
        -- event = "InsertEnter",
        version = "*",
        config = function()
            -- vim.cmd('highlight Pmenu guibg=none')
            -- vim.cmd('highlight PmenuExtra guibg=none')
            -- vim.cmd('highlight FloatBorder guibg=none')
            -- vim.cmd('highlight NormalFloat guibg=none')

            require("blink.cmp").setup({
                snippets = { preset = "luasnip" },
                signature = { enabled = true },
                appearance = {
                    use_nvim_cmp_as_default = false,
                    nerd_font_variant = "normal",
                },
                sources = {
                    -- per_filetype = {
                    --     codecompanion = { "codecompanion" },
                    -- },
                    default = { "lsp", "path", "supermaven", "snippets", "lazydev", "buffer", "laravel" },
                    providers = {
                        supermaven = {
                            name = 'supermaven',
                            module = "blink-cmp-supermaven",
                            async = true
                        },
                        lazydev = {
                            name = "LazyDev",
                            module = "lazydev.integrations.blink",
                            score_offset = 100,
                        },
                        laravel = {
                            name = "laravel",
                            module = "laravel.blink_source",
                        },
                        cmdline = {
                            min_keyword_length = 2,
                        },
                    },
                },

keymap = {
  preset = 'default',
  ['<A-1>'] = { function(cmp) cmp.accept({ index = 1 }) end },
  ['<A-2>'] = { function(cmp) cmp.accept({ index = 2 }) end },
  ['<A-3>'] = { function(cmp) cmp.accept({ index = 3 }) end },
  ['<A-4>'] = { function(cmp) cmp.accept({ index = 4 }) end },
  ['<A-5>'] = { function(cmp) cmp.accept({ index = 5 }) end },
  ['<A-6>'] = { function(cmp) cmp.accept({ index = 6 }) end },
  ['<A-7>'] = { function(cmp) cmp.accept({ index = 7 }) end },
  ['<A-8>'] = { function(cmp) cmp.accept({ index = 8 }) end },
  ['<A-9>'] = { function(cmp) cmp.accept({ index = 9 }) end },
  ['<A-0>'] = { function(cmp) cmp.accept({ index = 10 }) end },
},
completion = {
  menu = {
    draw = {
      columns = { { 'item_idx' }, { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
      components = {
        item_idx = {
          text = function(ctx) return ctx.idx == 10 and '0' or ctx.idx >= 10 and ' ' or tostring(ctx.idx) end,
          highlight = 'BlinkCmpItemIdx' -- optional, only if you want to change its color
        }
      }
    }
  }
},


                -- keymap = { ["<C-f>"] = {}, },
                cmdline = {
                    enabled = false,
                    completion = { menu = { auto_show = true } },
                    keymap = {
                        ["<CR>"] = { "accept_and_enter", "fallback" },
                    },
                },
            })

            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
}
