function __ufp_ladybird
    if contains -- --reset $argv
        set -e LADYBIRD_PATH
        echo "Path configuration cleared. Run the function again to set a new path."
        return 0
    end

    if not set -q LADYBIRD_PATH
        echo "Ladybird repository path is not set."
        read -P 'Enter path to Ladybird (default: ~/Development/Repos/ladybird.git): ' input_path

        if test -z "$input_path"
            set -U LADYBIRD_PATH "$HOME/Development/Repos/ladybird.git"
        else
            set -U LADYBIRD_PATH (eval echo $input_path)
        end

        echo "Saved! Ladybird path set to: $LADYBIRD_PATH"
        echo "Use '--reset' flag to change this later."
        echo ""
    end

    if not test -f "$LADYBIRD_PATH/Meta/ladybird.py"
        set_color red; echo "Error: 'Meta/ladybird.py' not found in $LADYBIRD_PATH"
        echo "Are you sure this is the correct directory?"; set_color normal
        echo "Run with --reset to fix the path."
        return 1
    end

    pushd "$LADYBIRD_PATH"

        echo "Pulling latest changes..."
        if not git pull
            set_color red; echo "Git pull failed! Aborting build."; set_color normal
            popd
            return 1
        end

        if type -q mold
            set -x LDFLAGS "-fuse-ld=mold"
            set_color blue; echo "Linking with mold..."; set_color normal
        end

        set -x CXXFLAGS "-march=native"
        set -x CFLAGS "-march=native"
        
        set -l jobs (nproc)
        set_color purple; echo "Building Ladybird with $jobs threads..."; set_color normal

        ./Meta/ladybird.py build -j $jobs

        if test $status -eq 0
            set_color green
            echo "Update complete."
            echo "Binary at: $LADYBIRD_PATH/Build/release/bin/Ladybird"
            set_color normal
        else
            set_color red; echo "Build failed!"; set_color normal
        end

    popd
end
