return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    columns = {
      "icon",
      -- "permissions",
      "size",
      -- "mtime",
    },
  },
  config = function()

    -- Save the current working directory to a file on exit or directory change
    -- local function save_cwd_to_file()
    --   local cwd = require("oil").get_current_dir()
    --   local file = io.open(os.getenv("TMPDIR") .. "/.nvim_last_dir", "w")
    --   if file then
    --     file:write(cwd)
    --     file:close()
    --   end
    -- end
    --
    -- vim.api.nvim_create_autocmd({ "VimLeavePre", "DirChanged" }, {
    --   callback = save_cwd_to_file,
    -- })




    -- Declare a global function to retrieve the current directory
    function _G.get_oil_winbar()
      local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
      local dir = require("oil").get_current_dir(bufnr)
      if dir then
        return vim.fn.fnamemodify(dir, ":~")
      else
        -- If there is no current directory (e.g. over ssh), just show the buffer name
        return vim.api.nvim_buf_get_name(0)
      end
    end

    require("oil").setup({
      win_options = {
        winbar = "%!v:lua.get_oil_winbar()",
      },
    })

    require("oil").toggle_hidden()


  end,
  -- Optional dependencies
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}
