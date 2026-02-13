function __ufp_repos
    set -l default_path "$HOME/Development/Repos"

    if not set -q REPO_PATH; or not test -d "$REPO_PATH"
        echo "It looks like your repository directory isn't set or is invalid."
        
        read -P "Enter the path to your repos [$default_path]: " input_path

        if test -z "$input_path"
            set input_path $default_path
        end

        set -l expanded_path (string replace -r '^~' $HOME $input_path)
        
        if test -d "$expanded_path"
            set -U REPO_PATH $expanded_path
            echo "Path set to: $REPO_PATH"
        else
            set_color red; echo "Error: Directory '$expanded_path' does not exist."; set_color normal
            return 1
        end
    end

    set -l target_path (string trim --right --chars=/ $REPO_PATH)

    set_color purple; echo "Updating repos in $target_path"; set_color normal

    for d in $target_path/*
        if test -d "$d/.git"
            set_color cyan; echo "Checking "(basename "$d")"..." ; set_color normal

            if not git -C "$d" diff-index --quiet HEAD --
                set_color yellow; echo "Uncommitted changes found; skipping pull."; set_color normal
            else
                if git -C "$d" pull --ff-only > /dev/null 2>&1
                   set_color normal; echo "Updated successfully"; set_color normal
                else
                    set_color red; echo "Pull failed"; set_color normal
                end
            end
            echo ""
        end
    end
end
