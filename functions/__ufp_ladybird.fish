function __ufp_ladybird
    set -l repo_dir "$HOME/Development/Repos/ladybird.git"
    
    if not test -d "$repo_dir"
        set_color red; echo "Ladybird repo not found at $repo_dir"; set_color normal
        return 1
    end

    pushd "$repo_dir"
    git pull

    if type -q mold
        set -x LDFLAGS "-fuse-ld=mold"
        echo "Linking with mold..."
    end

    set -x CXXFLAGS "-march=native"
    set -x CFLAGS "-march=native"
    
    set -l jobs (nproc)

    set_color purple; echo "Building Ladybird with $jobs threads..."; set_color normal

    # Use 'build' to keep the binary stable for the desktop app entry
    ./Meta/ladybird.py build -j $jobs

    if test $status -eq 0
        set_color green; echo "Update complete. Binary at: $repo_dir/Build/release/bin/Ladybird"; set_color normal
    else
        set_color red; echo "Build failed!"; set_color normal
    end

    popd
end
