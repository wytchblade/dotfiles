local api = vim.api

local opt = vim.opt
local cmd = vim.cmd
local api = vim.api
local nvim_create_autocmd = api.nvim_create_autocmd
local nvim_set_hl = api.nvim_set_hl

-- don't auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- wrap words "softly" (no carriage return) in mail buffer
api.nvim_create_autocmd("Filetype", {
  pattern = "mail",
  callback = function()
    vim.opt.textwidth = 0
    vim.opt.wrapmargin = 0
    vim.opt.wrap = true
    vim.opt.linebreak = true
    vim.opt.columns = 80
    vim.opt.colorcolumn = "80"
  end,
})

-- Highlight on yank
api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- go to last loc when opening a buffer
-- this mean that when you open a file, you will be at the last position
api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- auto close brackets
api.nvim_create_autocmd("FileType", { pattern = "man", command = [[nnoremap <buffer><silent> q :quit<CR>]] })

-- show cursor line only in active window
local cursorGrp = api.nvim_create_augroup("CursorLine", { clear = true })
api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  pattern = "*",
  command = "set cursorline",
  group = cursorGrp,
})
api.nvim_create_autocmd(
  { "InsertEnter", "WinLeave" },
  { pattern = "*", command = "set nocursorline", group = cursorGrp }
)

-- Enable spell checking for certain file types
api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  -- { pattern = { "*.txt", "*.md", "*.tex" }, command = [[setlocal spell<cr> setlocal spelllang=en,de<cr>]] }
  {
    pattern = { "*.txt", "*.md", "*.tex" },
    callback = function()
      vim.opt.spell = true
      vim.opt.spelllang = "en"
    end,
  }
)

-- vim.api.nvim_create_autocmd("ColorScheme", {
--   callback = function()
--     vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
--     vim.api.nvim_set_hl(0, "LspInfoBorder", { link = "Normal" })
--     vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
--   end,
-- })

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- resize neovim split when terminal is resized
vim.api.nvim_command("autocmd VimResized * wincmd =")

-- fix terraform and hcl comment string
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FixTerraformCommentString", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].commentstring = "# %s"
  end,
  pattern = { "terraform", "hcl" },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end


    map("gl", vim.diagnostic.open_float, "Open Diagnostic Float")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
    map("gD", vim.lsp.buf.declaration, "Goto Declaration")

    map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")

    local wk = require("which-key")
    wk.add({
      { "<leader>la", vim.lsp.buf.code_action,                           desc = "Code Action" },
      { "<leader>lA", vim.lsp.buf.range_code_action,                     desc = "Range Code Actions" },
      { "<leader>ls", vim.lsp.buf.signature_help,                        desc = "Display Signature Information" },
      { "<leader>lr", vim.lsp.buf.rename,                                desc = "Rename all references" },
      { "<leader>lf", vim.lsp.buf.format,                                desc = "Format" },
      { "<leader>lc", require("config.utils").copyFilePathAndLineNumber, desc = "Copy File Path and Line Number" },
      { "<leader>Wa", vim.lsp.buf.add_workspace_folder,                  desc = "Workspace Add Folder" },
      { "<leader>Wr", vim.lsp.buf.remove_workspace_folder,               desc = "Workspace Remove Folder" },
      {
        "<leader>Wl",
        function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end,
        desc = "Workspace List Folders",
      },
    })

    local function client_supports_method(client, method, bufnr)
      if vim.fn.has 'nvim-0.11' == 1 then
        return client:supports_method(method, bufnr)
      else
        return client.supports_method(method, { bufnr = bufnr })
      end
    end

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
        end,
      })
    end


    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,

})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})


-- When a broot terminal buffer is closed, switch to the previous buffer, stored in #, subsequently removing the brot buffer
vim.api.nvim_create_autocmd("TermClose", {
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local name = vim.fn.bufname(buf)

    if name:match("broot") then
      -- Switch to alternate buffer if possible
      local alt = vim.fn.bufnr("#")
      if alt ~= -1 and vim.api.nvim_buf_is_valid(alt) then
        vim.cmd("buffer #")
      else
        -- fallback: open a new empty buffer instead
        vim.cmd("enew")
      end

      -- Now safely delete the broot terminal buffer
      vim.schedule(function()
        pcall(vim.cmd, "bd! " .. buf)
      end)
    end
  end,
})

nvim_create_autocmd = api.nvim_create_autocmd

nvim_create_autocmd("InsertEnter", {
  callback = function()
    opt.listchars.trail = nil
    nvim_set_hl(0, "TrailingWhitespace", { link = "Whitespace" })
  end
})

nvim_create_autocmd("InsertLeave", {
  callback = function()
    opt.listchars.trail = space
    nvim_set_hl(0, "TrailingWhitespace", { link = "Error" })
  end
})

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
  end
})


-- Optional: For new empty buffers, you might want to switch back to the global CWD
-- or the home directory. The use of 'lcd' means the window keeps its CWD 
-- even when switching to a new *empty* buffer (which has no name/path).
-- This command will revert the window's CWD to the global CWD if it's an unlisted,
-- unnamed buffer (like a new, unsaved buffer).
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "" }, -- Matches unnamed buffers
  callback = function()
    -- Only do this if the buffer has no name and is not a terminal
    if vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) == "" then
      vim.cmd("lcd " .. vim.fn.getcwd(-1, -1)) -- Revert to global CWD
    end
  end,
})



-- Automatically enter insert mode in terminal buffers (used primarily for entering broot commands)
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.cmd("startinsert")
  end,
})

-- Automatically close terminal buffers when the job exits, which prevents you from having to manually close them by pressing any key
vim.api.nvim_create_autocmd("BufLeave", {
  callback = function()
    if vim.bo.buftype == "terminal" and vim.fn.bufname():match("broot") then
      vim.cmd("bd!") -- close the buffer
    end
  end,
})


-- vim.api.nvim_create_autocmd("BufReadPre", {
--   -- Target all .tex files in any directory
--   pattern = "*.tex",
--   -- This autocommand is for the entire project
--   group = vim.api.nvim_create_augroup("VimTeXProject", { clear = true }),
--   callback = function(opts)
--     -- opts.file contains the full path of the file that is about to be read.
--     -- We are assuming that every .tex file read in the project should use 
--     -- 'main.tex' in the same directory as the currently opened file as the main file.
--     
--     -- 1. Get the directory of the file being opened (opts.file)
--     local dir = vim.fn.fnamemodify(opts.file, ":h")
--     
--     -- 2. Construct the full path to the main file
--     local main_file_path = dir .. "/main.tex"
--     
--     -- 3. Set the buffer-local variable for the current buffer
--     vim.b.vimtex_main = main_file_path
--     
--     -- Optional: Echo for confirmation
--     -- vim.api.nvim_echo({{ "Set b:vimtex_main to: " .. vim.b.vimtex_main, "Normal" }}, false, {})
--   end,
-- })




-- Set the working directory to the current buffer's file path on switch, 
-- but only for file buffers (not terminal or scratch buffers)
-- vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
--   group = "ChangeCWD",
--   callback = function()
--     local buffer_name = vim.api.nvim_buf_get_name(0)
--
--     -- Check if the buffer is a file buffer (has a path and is not a terminal buffer)
--     -- 'term://' is the filetype for Neovim's built-in terminal
--     -- 'buftype' being 'terminal' is another check for terminal buffers
--     -- The checks ensure it's a regular file buffer with a name
--     if buffer_name ~= "" and vim.bo.buftype ~= "terminal" then
--       -- Get the directory of the current buffer's file
--       -- %:p:h expands to the full path of the file, then removes the file name (head)
--       local dir = vim.fn.fnamemodify(buffer_name, ":h")
--       
--       -- Use :lcd (local change directory) to change the directory for the current window only
--       if dir ~= "" then
--         vim.cmd("lcd " .. dir)
--       end
--     end
--   end,
-- })






-- -- Define an Autocmd Group to keep things tidy
-- local augroup = vim.api.nvim_create_augroup("MyPostLoadGroup", { clear = true })
--
-- -- Create the autocmd for the VimEnter event
-- vim.api.nvim_create_autocmd("VimEnter", {
--   group = augroup,
--   callback = function()
--     if buffer_name ~= "" and buftype ~= "terminal" then
--       vim.cmd("let &statuscolumn=' %C%l%= %#StatusColumnBorder#▍%s'")
--       -- Example: Print a message
--       print("All plugins loaded. Running post-load script!")
--
--     end
--   end,
-- })
--



-- Disables sign column in terminal windows to prevent column colors from showing 
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    -- Turn off line numbers and relative numbers essentially removing the sign column
    vim.cmd("let &statuscolumn=''")

  end,
})


-- Changes the directory of the path to the current buffer's directory, and also reset the status columns
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local buffer_name = vim.api.nvim_buf_get_name(bufnr)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
    -- Get the filetype of the current buffer
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

    -- 1. Exclude buffers from oil.nvim (filetype == 'oil')
    if filetype == 'oil' then
      return
    end

    -- 2. Check if the buffer is a file buffer (has a path and is not a terminal buffer)
    if buffer_name ~= "" and buftype ~= "terminal" then
      -- Get the directory of the current buffer's file
      -- %:p:h expands to the full path of the file, then removes the file name (head)
      local dir = vim.fn.fnamemodify(buffer_name, ":h")

      -- Use :lcd (local change directory) to change the directory for the current window only
      if dir ~= "" then
        -- You may want to check if the directory is different from the current local directory 
        -- before executing the command to avoid unnecessary operations.
        -- vim.cmd("lcd " .. dir)
        -- Safer command execution:
        pcall(vim.cmd, "lcd " .. dir)
      end

      -- reformats the line column when entering a text buffer from a terminal buffer
      -- vim.cmd("let &statuscolumn=' %s%C%l%= %#StatusColumnBorder#▍'")
      -- vim.o.statuscolumn = '%= %{%v:lnum %} %#StatusColumnBorder#▍%s'
      -- set the line number colors each time upon entering a text buffer
      -- vim.cmd('lua require("statuscol").setup()')
      -- vim.api.nvim_set_hl(0, 'LineNr', { fg = '#2b2b2b', bg = '#80401a' })
      -- vim.api.nvim_set_hl(0, 'CursorLine', { fg = 'none', bg = '#2b2b2b'})
      -- vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#2b2b2b', bg = '#ff6000' })
      -- vim.o.statuscolumn = "%!v:lua.require('bars.statuscolumn').render()";
    end
  end,
})

-- open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"help", "qf"},
  command = "wincmd L",
})




-- -- Create a dedicated augroup for easy management.
-- local qf_suppress_group = vim.api.nvim_create_augroup("SuppressQuickfix", { clear = true })
--
-- vim.api.nvim_create_autocmd("BufAdd", {
--   group = qf_suppress_group,
--   pattern = "*",
--   desc = "Immediately delete quickfix buffers upon creation.",
--   callback = function(args)
--     -- We use vim.schedule to run this check *after* the buffer has been fully initialized.
--     -- At the exact moment of BufAdd, 'buftype' may not be set to 'qf' yet.
--     vim.schedule(function()
--       local bufnr = args.buf
--
--       -- Check if the buffer is still valid before proceeding.
--       if not vim.api.nvim_buf_is_valid(bufnr) then
--         return
--       end
--
--       -- Get the buffer type.
--       local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
--
--       if buftype == "qf" then
--         -- If it's a quickfix buffer, delete it immediately and silently.
--         -- This will prevent it from ever being displayed.
--         vim.cmd("silent! bdelete! " .. bufnr)
--       end
--     end)
--   end,
-- })
--
-- vim.notify("Quickfix suppression autocommand is active.", vim.log.levels.INFO)

local function save_cwd_to_file()
  local cwd = require("oil").get_current_dir()
  local file = io.open(os.getenv("TMPDIR") .. "/.nvim_last_dir", "w")
  if file then
    file:write(cwd)
    file:close()
  end
end

-- vim.api.nvim_create_autocmd({ "VimLeavePre", "DirChanged" }, {
--   callback = save_cwd_to_file,
-- })
