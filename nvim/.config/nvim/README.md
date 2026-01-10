# Notes

## Blame a particular line in a file (must be tracked in a git repo)
`:lua require("gitsigns").blame_line()`

## Since the migration to the main branch, nvim-treesitter has been reconfigured. Parsers were initially loaded based on the filetype, but now this has been disabled due to popups on the UI. In order to install parsers, visit the plugin file and alter the .update() method to .install() accordingly AFTER the language has been inserted into the language table

## MdMath has to be rebuilt after installing the necessary dependnecies (imagemagick, librsvg, nodejs includes npm) via the :MdMath build


## Shows keymaps installed in Snacks picker
`:lua Snacks.picker.keymaps()`

## Shows commands installed in Snacks picker
`:lua Snacks.picker.commands()`

## Add 'nowait' so it fires immediately even if other maps exist
`local <code>opts</code> = { noremap = true, silent = true, nowait = true }`

## Cut a line
`X (Capital x)`

## Wrap content with html tags (nvim-surround, prompt will appear to enter tag name)
`ysiw + t + "tag name"`

## Delete two words backwards (inclusive, the command without v is exclusive)
dv2b

## The flash.nvim plugin has been implemented to replace the f key with the flash jump plugin. Values are maintained in the extra.lua file
