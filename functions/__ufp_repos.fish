function __ufp_repos
    set -l default_path "~/Development/Repos"

    if not set -q REPO_PATH; or not test -d "$REPO_PATH"
        echo "It looks like your repository directory isn't set or is invalid."
        
        read -P "Enter the path to your repos [$default_path]: " -D "$default_path" input_path

        set -l expanded_path (eval echo $input_path)
        set -U REPO_PATH $expanded_path
        
        echo "Path set to: $REPO_PATH"
    end

    set -l target_path (string trim --right --chars=/ $REPO_PATH)

    for d in $target_path/*
        if test -d "$d/.git"
            set_color blue; echo "Checking "(basename "$d")"..." ; set_color normal

            if not git -C "$d" diff-index --quiet HEAD --
                set_color yellow; echo "Uncommitted changes found. Skipping pull."; set_color normal
            else
                git -C "$d" pull
            end
            echo ""
        end
    end
end
