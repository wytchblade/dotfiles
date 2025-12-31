# Useful functions

# Blame a particular line in a file (must be tracked in a git repo)
lua require("gitsigns").blame_line()

# Since the migration to the main branch, nvim-treesitter has been reconfigured. Parsers were initially loaded based on the filetype, but now this has been disabled due to popups on the UI. In order to install parsers, visit the plugin file and alter the .update() method to .install() accordingly AFTER the language has been inserted into the language table


# MdMath has to be rebuilt after installing the necessary dependnecies (imagemagick, librsvg, nodejs includes npm) via the :MdMath build
