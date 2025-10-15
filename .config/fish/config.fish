function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive # Commands to run in interactive sessions can go here

    # fastfetch
    # No greeting
    set fish_greeting

    # Use starship
    starship init fish | source
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end

    # Aliases
    alias pamcan pacman
    alias ls 'eza --icons'
    alias clear "printf '\033[2J\033[3J\033[1;1H'"
    alias q 'qs -c ii'

    zoxide init fish | source
    
    
    alias cd z

    alias cp 'advcp -g'
    alias mv 'advmv -g'

    alias ls lsd

    if test -f /home/gal/apps/anaconda3/bin/conda
        eval /home/gal/apps/anaconda3/bin/conda "shell.fish" "hook" $argv | source
        conda deactivate >/dev/null 2>&1
    else
        if test -f "/home/gal/apps/anaconda3/etc/fish/conf.d/conda.fish"
            . "/home/gal/apps/anaconda3/etc/fish/conf.d/conda.fish"
        else
            set -x PATH "/home/gal/apps/anaconda3/bin" $PATH
        end
    end
    
end
