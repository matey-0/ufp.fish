function __ufp_ghostty
    sudo -v 
    set -l os_env (__get_os_info)
    if test "$os_env" = "macos"
        set_color red; echo "This is for Linux, use Brew on macOS"; set_color normal
        return 1
    end

    switch $os_env
        case arch CachyOS
            sudo pacman -Syu --needed --noconfirm gtk4 libadwaita gettext mold
        case debian ubuntu kali
            sudo apt update && sudo apt install -y libgtk-4-dev libadwaita-1-dev gettext libxml2-utils mold
        case fedora
            sudo dnf install -y gtk4-devel libadwaita-devel gettext mold
        case gentoo
            sudo emerge -av libadwaita gtk blueprint-compiler gettext sys-devel/mold
        case suse
            sudo zypper install -y gtk4-devel libadwaita-devel pkgconf ncurses-devel gettext mold
        case alpine
            sudo apk add gtk4.0-dev libadwaita-dev pkgconf ncurses gettext mold
        case '*'
            set_color red; echo "Unsupported distro"; set_color normal
            return 1
    end

    set -l threads (nproc)
    set -l arch (uname -m)

    set_color purple
    read -P "Enter desired Ghostty version: " ghostty_version
    read -P "Enter required Zig version for your desired Ghostty version: " zig_version
    set_color normal

    if test -z "$ghostty_version"; or test -z "$zig_version"
        set_color red; echo "Version cannot be empty"; set_color normal
        return 1
    end

    set -l total_mem (free -g | awk '/^Mem:/ {print $2}')
    if test $total_mem -lt 48
        set_color yellow; echo "Only $total_mem"GB" RAM detected. Reducing ramdisk to 4GB."; set_color normal
        set ram_size 8g
    else
        set ram_size 32g
    end

    if not test -d /mnt/ramdisk
        sudo mkdir -p /mnt/ramdisk
    end
    sudo umount /mnt/ramdisk 2>/dev/null
    sudo mount -t tmpfs -o size=$ram_size tmpfs /mnt/ramdisk
    
    set -l build_root /mnt/ramdisk
    pushd $build_root

    set ghostty_version (string trim "$ghostty_version")
    set_color purple; echo "Fetching Ghostty $ghostty_version..."; set_color normal
    if test "$ghostty_version" = "tip"
        set ghostty_url "https://github.com/ghostty-org/ghostty/releases/download/tip/ghostty-source.tar.gz"
    else
        set ghostty_url "https://release.files.ghostty.org/$ghostty_version/ghostty-$ghostty_version.tar.gz"
    end
    if curl -Lf "$ghostty_url" | tar -xz
        echo "Ghostty extracted."
    else
        set_color red; echo "Ghostty download failed."; set_color normal
        popd; sudo umount /mnt/ramdisk; return 1
    end

    set zig_version (string trim "$zig_version")
    set_color purple; echo "Fetching Zig $zig_version..."; set_color normal
    set -l zig_url "https://ziglang.org/download/$zig_version/zig-$arch-linux-$zig_version.tar.xz"
    if curl -Lf "$zig_url" | tar -xJ
        echo "Zig extracted."
    else
        set_color red; echo "Zig download failed."; set_color normal
        popd; sudo umount /mnt/ramdisk; return 1
    end

    set -l ghostty_url ""
    set -l extract_dir ""

    if test "$ghostty_version" = "tip"
        set ghostty_url "https://github.com/ghostty-org/ghostty/releases/download/tip/ghostty-source.tar.gz"
        set extract_dir "ghostty-source"
    else
        set ghostty_url "https://release.files.ghostty.org/$ghostty_version/ghostty-$ghostty_version.tar.gz"
        set extract_dir "ghostty-$ghostty_version"
    end
    # --- N

    cd "ghostty-$ghostty_version/"
    set_color purple; echo "Compiling Ghostty..."; set_color normal
    
    if mold -run $build_root/zig-$arch-linux-$zig_version/zig build -p $HOME/.local \
        -Doptimize=ReleaseFast \
        -Dcpu=native \
        -fno-sys=gtk4-layer-shell \
        -j$threads
        
        set_color green; echo "Successfully updated to Ghostty $ghostty_version"; set_color normal
    else
        set_color red; echo "Build failed!"; set_color normal
    end

    popd
    sudo umount /mnt/ramdisk 2>/dev/null
    $HOME/.local/bin/ghostty --version
end
