-- THIS WILL FORCE THE RTP OF THE INIT.LUA PARENT DIRECTORY TO BE ADDED TO NVIM RUNTIME PATH
--[[ local current_file = debug.getinfo(1).source:sub(2)

local parent_dir = vim.fn.fnamemodify(current_file, ":p:h:h")

vim.opt.rtp:prepend(parent_dir)

print("Config path: " .. vim.fn.stdpath("config")) ]]

vim.g.mapleader = " "					-- change leader to a space
vim.g.maplocalleader = " "				-- change localleader to a space
require("core.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- require("core.mason-path")
-- require("core.lsp")
-- require("config.mason-verify")
-- require("config.health-check")
--[[ -- Define a function to open Oil in the current working directory
local function open_oil_on_startup()
    -- Check if Neovim started without any file arguments
    if #vim.api.nvim_list_bufs() == 1 and vim.bo.buftype == "" and vim.fn.argc() == 0 then
        -- The first buffer is an empty, unlisted buffer, so open Oil
        -- require("Fyler").open()
        vim.cmd("Fyler")
    end
end

-- Execute the function after Neovim has finished starting up
vim.api.nvim_create_autocmd("VimEnter", {
    callback = open_oil_on_startup,
}) ]]
