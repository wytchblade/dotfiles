-- Add 'nowait' so it fires immediately even if other maps exist
-- local opts = { noremap = true, silent = true, nowait = true }
local opts = { noremap = true, silent = true }
local map = vim.keymap.set

-- Fast saving and quitting
-- map("n", "<leader>w", ":write!<CR>", { silent = false, desc = "Save file" })
-- map("n", "<leader>q", ":q!<CR>", opts)

-- Remap for dealing with visual line wraps
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- paste over currently selected text without yanking it
map("v", "p", '"_dp')
map("v", "P", '"_dP')

-- copy everything between { and } including the brackets
-- p puts text after the cursor,
-- P puts text before the cursor.
map("n", "YY", "va{Vy", opts)

-- Move line on the screen rather than by line in the file
-- map("n", "j", "gj", opts)
-- map("n", "k", "gk", opts)

-- Move to start/end of line
map({ "n", "x", "o" }, "H", "^", opts)
map({ "n", "x", "o" }, "L", "g_", opts)

-- Navigate buffers and center cursor
-- Add 'nowait' so it fires immediately even if other maps exist
-- map("n", "<leader>j", ":bnext<CR>zz", { noremap = true, silent = true, nowait = true })
map("n", "<leader>j", "<Cmd>bnext | normal! zz<CR>", opts)
map("n", "<leader>k", ":bprevious<CR>zz", opts)

-- Panes resizing
map("n", "+", ":vertical resize +5<CR>")
map("n", "_", ":vertical resize -5<CR>")
map("n", "=", ":resize +5<CR>")
map("n", "-", ":resize -5<CR>")

-- Map enter to ciw in normal mode
-- map("n", "<CR>", "ciw", opts)  -- Commented out: This overwrites word on Enter - too disruptive
-- map("n", "<BS>", "ci", opts)   -- Commented out: This changes text on Backspace - too disruptive

map("n", "n", "nzz", opts)
map("n", "N", "Nzz", opts)
map("n", "*", "*zzv", opts)
map("n", "#", "#zzv", opts)
map("n", "g*", "g*zz", opts)
map("n", "g#", "g#zz", opts)

-- map ; to resume last search
-- map("n", ";", "<cmd>Telescope resume<cr>", opts)

-- search current buffer
-- map("n", "<C-s>", ":Telescope current_buffer_fuzzy_find<CR>", opts)

-- Split line with X
map("n", "X", ":keeppatterns substitute/\\s*\\%#\\s*/\\r/e <bar> normal! ==^<cr>", { silent = true })

-- ctrl + x to cut full line
map("n", "<C-x>", "dd", opts)

-- Select all
map("n", "<C-a>", "ggVG", opts)

-- write file in current directory
-- :w %:h/<new-file-name>
map("n", "<C-n>", ":w %:h/", opts)





-- delete forward
-- w{number}dw
-- delete backward
-- w{number}db

-- map("n", "<C-P>", ':lua require("config.utils").toggle_go_test()<CR>', opts)

-- Get highlighted line numbers in visual mode
map("v", "<leader>ln", ':lua require("config.utils").get_highlighted_line_numbers()<CR>', opts)

map('n', '<leader>rl', function()
  vim.cmd('w')
  vim.cmd('SlimeSendCurrentLine')
end, { desc = '[Slime] [l]ine: Send current line to REPL' })

map('n', '<leader>L', ':cd %:h<CR>', {
  desc = '[L]ocate file in system'
})

-- This file defines a Lua function to open a terminal and initialize tmux.

-- The function that will be called by the keymap.
local function open_tmux_terminal()
  -- The command to open a terminal and run the 'tmux' command.
  -- `:terminal` opens a new terminal in a horizontal split.
  local cmd_string = 'terminal tmux'
  
  -- We use vim.cmd() to execute the command directly.
  vim.cmd(cmd_string)
end

-- This file defines a Lua function to open a vertical split terminal and then initialize a Tmux session within it.

-- The function that will be called by the keymap.
local function open_tmux_vsplit()
  -- The command to open a terminal in a vertical split (`vsplit`)
  -- and then run the tmux command.
  -- `tmux attach || tmux new-session` will attach to an existing session
  -- or create a new one if none exists.
  local cmd_string = 'vsplit | terminal tmux attach || tmux new-session'
  
  -- We use vim.cmd() to execute the command directly.
  vim.cmd(cmd_string)
end

--[[ map('n', '<leader>T', open_tmux_vsplit, {
  desc = 'Windowed Tmux'
}) ]]

-- Opens a vsplit terminal
map('n', '<leader>T', function()
  vim.cmd('vsplit | terminal')
end, {
  desc = 'Windowed Tmux'
})

-- New keymap to open a vsplit terminal, start tmux, and run Julia.
local function open_julia_terminal()
  local cmd_string = 'vsplit | terminal tmux new-session -A -s julia_session'
  vim.cmd(cmd_string)
end
map('n', '<leader>J', open_julia_terminal, {
  desc = 'Open Julia in a vertical split terminal with tmux'
})


-- Send motion (paragraph) to Slime, and move the cursor to the end of the paragraph
map('n', '<leader>rr', '<Plug>SlimeMotionSend}}', {
    silent = true,
    desc = 'Slime: Send Current Paragraph'
})


-- FILE MANAGEMENT
-- map('n', '<leader>e', "<cmd>Fyler<cr>", { desc = 'Open Oil' })

-- Open broot in a terminal
local function open_broot()
  
  -- Change directory to the current file's directory (assuming this is desired)
  local status, _ = pcall(vim.cmd, 'cd %:h')
  if not status then
    vim.cmd('terminal broot ~')
  end

  local cmd_string = 'terminal broot'
  -- Use pcall to execute the main command and check for errors
  local status, _ = pcall(vim.cmd, cmd_string)
  -- If status is false, an error occurred, so run the fallback command
  if not status then
    vim.cmd('terminal broot ~')
  end

  -- This command runs regardless of the success of the terminal broot command
  vim.cmd('startinsert')
end

local function open_oil()
  local cmd_string = 'Oil'
  -- Use pcall to execute the main command and check for errors
  local status, _ = pcall(vim.cmd, cmd_string)
  -- If status is false, an error occurred, so run the fallback command
  if not status then
    vim.cmd('terminal Oil ~')
  end
end
-- map('n', '<M-e>', open_broot, { desc = 'open broot' })
map('n', '<M-e>', open_oil, { desc = 'open oil' })

-- Simple exact-word search on Shift+S
vim.keymap.set("n", "S", function()
  local q = vim.fn.input("Regex Pattern: \\< ...\\>")
  if q == "" then return end
  -- escape slash so the search pattern won't break if you type '/'
  q = vim.fn.escape(q, "/")
  -- put the exact-word pattern into the search register
  vim.fn.setreg("/", "\\<" .. q .. "\\>")
  -- jump to next match and enable highlighting
  vim.cmd("silent! normal! n")
  vim.o.hlsearch = true
end, { noremap = true, silent = true, desc = "Exact word search (prompt)" })

-- paste one line below with "put"
map('n', '<C-p>', function()
  vim.cmd('put')
end, { desc = 'put' })

-- paste one line above with "0put"
map('n', '<C-M-p>', function()
  vim.cmd('.-1put')
end, { desc = 'put' })

-- required function for poening directories in terminal from oil
local function save_cwd_to_file()
  local cwd = require("oil").get_current_dir()
  local file = io.open(os.getenv("TMPDIR") .. "/.nvim_last_dir", "w")
  if file then
    file:write(cwd)
    file:close()
  end
  vim.cmd("qa")
end

-- Open directory in terminal from oil buffer
map('n', '<leader>cd', save_cwd_to_file, { desc = '[oil]: open directory' })

-- Delete word using CTRL+BKSPC
map('n', '<C-BS>', 'diw', { noremap = true, silent = true })

--  Move blocks horizontally (left/right)
-- vim.keymap.set('v', '<C-h>', ':MoveHBlock(-1)<CR>', opts)
-- vim.keymap.set('v', '<C-l>', ':MoveHBlock(1)<CR>', opts)

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- Move selected line / block of text in visual mode
-- map("v", "J", ":m '>+1<CR>gv=gv", opts)
-- vim.keymap.set('v', '<C-k>', ':MoveBlock(-1)<CR>', opts)
-- map("v", "K", ":m '<-2<CR>gv=gv", opts)
-- vim.keymap.set('v', '<C-j>', ':MoveBlock(1)<CR>', opts)

-- nvim-gomove bindings
map( "x", "<C-h>", "<Plug>GoVMBlockLeft", {} )
map( "x", "<C-j>", "<Plug>GoVMBlockDown", {} )
map( "x", "<C-k>", "<Plug>GoVMBlockUp", {} )
map( "x", "<J>", "<Plug>GoNVLineDown", {} )
map( "x", "<K>", "<Plug>GoNVLineUp", {} )
map( "x", "<C-l>", "<Plug>GoVMBlockRight", {} )

map( "n", "<C-j>", "<Plug>GoNMLineDown", {} )
map( "n", "<C-k>", "<Plug>GoNMLineUp", {} )
map( "n", "<C-h>", "<Plug>GoNMLineLeft", {} )
map( "n", "<C-l>", "<Plug>GoNMLineRight", {} )

