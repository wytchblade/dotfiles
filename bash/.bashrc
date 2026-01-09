# ~/.bashrc
#

parse_git_branch() {
  local branch=$(git branch --show-current 2> /dev/null)
  if [ -n "$branch" ]; then
    echo "≼ $branch"
  fi
}


# Function to format the directory into a staircase
    # Replace slashes with a newline and the decorative "tree" character
    format_staircase_path() {
    # We use sed to skip the first slash and format the rest
    echo "$PWD" | sed "s|/|/\n├──|g"
}

export PS1='\[\e[38;2;255;96;0m\]╭──(\[\e[1;32m\]\u\[\e[0m\]) $(parse_git_branch) \[\e[38;5;245m\]@ \t$(format_staircase_path)/\n\[\e[38;2;255;96;0m\]╰─\[\e[38;2;255;96;0m\]\[\e[0m\] '

export EDITOR="nvim"
export TMPDIR=/tmp
# export TERM="kitty"
# export NVIM_APPNAME= 
export TERMINAL="kitty"
export TMUX_NEST_COUNT=1
export XDG_CONFIG_HOME="$HOME/.config"
# xport BROOT_LOG=debug broot

# Fixes cursor solid box overwriting effect
_fix_cursor() {
   echo -ne '\033[1 q'
}

# Append the function to PROMPT_COMMAND
PROMPT_COMMAND="_fix_cursor${PROMPT_COMMAND:+; $PROMPT_COMMAND}"


# Initialize zoxide
eval "$(zoxide init bash)"
# Initialize broot
# source /home/firebat/.config/broot/launcher/bash/br

# source /home/firebat/.config/broot/launcher/bash/br
# Function to return the size of the git repo
gc(){
  git commit -m "|.git| = $(du -s .git | awk '{print $1}')"
} 


# Function to run nvim and cd to its last directory on exit. An autocommand has been set up for nvim to generate this file on exit, and it stored the file in the $TMPDIR, containing the current working directory of the oil buffer. The current command keybind is stored in the keybinds.lua file as <leader>cd
nv() {
    command nvim "$@"
    if [ -f "$TMPDIR/.nvim_last_dir" ]; then
        cd "$(cat "$TMPDIR/.nvim_last_dir")"
        # Optional: remove the file so it doesn't persist across sessions
        rm "$TMPDIR/.nvim_last_dir"
    fi
}


# Custom alias to open Neovim and launch Oil in the current directory
alias nvoil='nv -c "Oil"'
#Open oil directly
bind '"\ee": "nvoil\n"'

# Initializes the edit-and-execute-command keybind
bind '"\C-e": edit-and-execute-command'

# Executes neovim function to allow for writing to /tmp after opening an oil directory. 
bind '"\e\r": "nv\n"'


alias bpy='/home/firebat/python_3.11/python'
alias bpy_venv='source /home/firebat/bpy_venv/bin/activate'

# tree view aliases
alias t1='tree -L 1'
alias t2='tree -L 2'
alias t3='tree -L 3'
alias t4='tree -L 4'
alias t5='tree -L 5'
alias t6='tree -L 6'
alias t7='tree -L 7'
alias t8='tree -L 8'
alias t9='tree -L 9'


# Advanced fzf finder using fzf and find. Toggles between a directory find and a file find. Uses process substitution to permit asynchronous piping to the fzf output (which may result in delays in finding the target file if the directory is large). Also supports toggling search depth via CTRL+<INTEGER>. Will copy the selected directory or filename to clipboard using wl-copy
ff() {
    local selected_dir
    local current_dir=$(pwd)
    selected_dir=$(fzf --sync --reverse --height=25% --algo=v1 --bind='ctrl-d:change-prompt(directories: )+reload(find . -type d)' --bind='ctrl-f:change-prompt(files: )+reload(find . -type f)' --header 'ctrl-d (directory_search) / ctrl-f (file_search)' < <(find .))
    if [[ -n "$selected_dir" ]] && [[ -d "$selected_dir" ]]; then
        cd "$selected_dir" && wl-copy "${current_dir}/${selected_dir#*/}"
    elif [[ -n "$selected_dir" ]] && [[ -f "$selected_dir" ]]; then
         wl-copy "${current_dir}/${selected_dir#*/}" && xdg-open "$selected_dir" > /dev/null 2>&1 &
    else
        echo "No file or directory selected"
    fi
}


locate(){
ls -a | fzf --bind='ctrl-d:change-prompt(directories: )+reload(find . -type d)' --bind='ctrl-f:change-prompt(files: )+reload(find . -type f)' --header 'ctrl-d (directory_search) / ctrl-f (file_search)'
}

locate(){
  fzf --bind='ctrl-d:change-prompt(directories: )+reload(find . -type d)' --bind='ctrl-f:change-prompt(files: )+reload(find . -type f)' --header 'ctrl-d (directory_search) / ctrl-f (file_search)' < <(find .)
}


# Function to run Vieb
vieb() {
    # Save the current directory and change to the new one
    pushd /home/firebat/repositories/Vieb > /dev/null

    # Run the command
    npm start &

    # Return to the previous directory
    popd > /dev/null
}

benv() {
  source /home/firebat/venv_3.11/bin/activate
}

reverse_tree(){
  path=$(pwd)

  # Split the path into an array based on the "/" delimiter
  IFS='/' read -ra ADDR <<< "$path"

  # Handle the root directory case
  echo "/"
  prefix=""

  # Iterate through the parts of the path
  for i in "${!ADDR[@]}"; do
    # Skip empty strings (happens at the start of absolute paths)
    if [[ -n "${ADDR[$i]}" ]]; then
      # Add indentation for each level
      prefix+="  "
      # Print the tree branch and the directory name
      echo "${prefix}└── ${ADDR[$i]}"
    fi
  done
}

# fl() {
#     local selected_dir
#     selected_dir=$(fzf --reverse --height=50% < <(find . -type d))
#     if [[ -n "$selected_dir" ]]; then
#         cd "$selected_dir" && wl-copy "$selected_dir"
#     fi
# }
#
# # [F]ind [F]ile: Generate all files from current working directory and pipe to fzf, selecting in fzf utilizes xdg-open to access the file
# ff() {
#     local selected_file
#     selected_file=$(find . -type f | fzf --reverse --height=50%)
#     if [[ -n "$selected_file" ]]; then
#         xdg-open "$selected_file" && wl-copy "$selected_file"
#     fi
# }




find_excluding_dir() {
  # ... argument checking omitted for brevity ...
  local dir_path="$1"
  local exclude_name="$2"

  # The find command
  find "$dir_path" -not -path "*/$exclude_name*" -depth -print
}


# Opens an fzf serach of pdfs in the ghostnation pdfs directory
pdfs(){

    # Save the current directory and change to the new one
    pushd /run/media/firebat/ghostnation/repositories/pdf_data > /dev/null

    # Run the command
    local selected_file
    selected_file=$(find /run/media/firebat/ghostnation/repositories/pdf_data -type f | fzf --reverse --height=50%)
    if [[ -n "$selected_file" ]]; then
       sioyek "$selected_file" >/dev/null 2>&1 &
       
    fi

    # Return to the previous directory
    popd > /dev/null

}

alias gemini="node /home/firebat/lib/node_modules/@google/gemini-cli/dist/index.js"



if [ -n "$TMUX" ]; then
    echo "Reattaching to main session"
    return
fi

if tmux ls &>/dev/null; then
    tmux attach -t "$(tmux ls -F '#S' | head -n 1)"
else
  tmux new -s $(whoami)
fi



# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls -la'
alias grep='grep --color=auto'
alias n ='nvim'
PS1='[\u@\h \W]\$ '

# Autojumps test mechanism and initialization
# [[ -s /home/wytchfyre/.autojump/etc/profile.d/autojump.sh ]] && source /home/wytchfyre/.autojump/etc/profile.d/autojump.sh
export EDITOR="nvim"
export PATH="/home/firebat/.local/bin/:$PATH"
export PATH="/home/firebat/.cargo/bin:$PATH"

# >>> conda initialize >>>

# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/home/wytchfyre/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/home/wytchfyre/anaconda3/etc/profile.d/conda.sh" ]; then
#         . "/home/wytchfyre/anaconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/home/wytchfyre/anaconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup

# <<< conda initialize <<<

# alias ff="cd $(find /run/media/wytchfyre/ghostnation/ | fzf)"
# fl() { cd $(find /run/media/wytchfyre/ghostnation/ | fzf); }
# fl() { cd $(find . -type d | fzf); }
# ff() { xdg-open $(find /run/media/wytchfyre/ghostnation/ | fzf); }
 # ff() { xdg-open "$(find . -type f | fzf)"; }

# [F]ind [L]ocation: Generate all directories from current working directory and pipe to fzf, changing into the directory and copying the directory path to the buffer
# fl() {
#     local selected_dir
#     selected_dir=$(find . -type d | fzf --reverse --height=50%)
#     if [[ -n "$selected_dir" ]]; then
#         cd "$selected_dir" && wl-copy "$selected_dir"
#     fi
# }


# [F]ind [H]istory: Function to pipe history to fzf and execute on selection
fh() {
  selected=$(history | fzf --reverse --height=50% --preview "echo {} | cut -c 8- | bat --color=always --line-range :100" | cut -c 8-)
  # selected=$(history | fzf --reverse --height=50% --preview "echo {} | cut -c 8- | bat --color=always --line-range :100" | cut -c 8-)

  if [[ -n "$selected" ]]; then
    echo "$selected"
    eval "$selected"
  fi
}

# If keybind is desired, the following bind links to CTRL+H
# bind -x '"\C-h": fzf-history-search'

# Function to run Vieb
vieb() {
    # Save the current directory and change to the new one
    pushd /home/firebat/repositories/Vieb > /dev/null

    # Run the command
    npm start &

    # Return to the previous directory
    popd > /dev/null
}

# Function to attach to a tmux session
# Usage: attach <session_name_or_number>
attach() {
    tmux attach -t "$1"
}

# Function to create a new tmux session
tm() {
    if [ -n "$TMUX" ]; then
        echo "Already inside tmux."
        return
    fi

    if tmux ls &>/dev/null; then
        tmux attach -t "$(tmux ls -F '#S' | head -n 1)"
    else
        tmux new -s main
    fi
}









# Generates the default git commit text

  
# Auto-execute commnds here
# tm





source /home/firebat/.config/broot/launcher/bash/br

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/home/firebat/.juliaup/bin:*)
        ;;

    *)
        export PATH=/home/firebat/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<
