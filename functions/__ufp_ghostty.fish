function __ufp_ghostty
    set -l os_env (__get_os_info)
    if test "$os_env" = "macos"
        set_color red; echo "Error: This build script is for Linux. Please use 'brew install ghostty' on macOS."; set_color normal
        return 1
    end

    __ensure_deps $os_env
    if test $status -ne 0
        return 1
    end

    set -l threads (nproc)
    set -l arch (uname -m)

    set_color purple
    echo "Starting Unified Ghostty Build"
    echo "System: "(string upper (string sub -l 1 -- $os_env))(string sub -s 2 -- $os_env)""
    echo "Architecture: $arch | Threads: $threads"
    set_color normal

    set_color purple
    read -P "Enter Ghostty version: " g_ver
    read -P "Enter required Zig version: " z_ver
    set_color normal

    if test -z "$g_ver"; or test -z "$z_ver"
        set_color red; echo "Error: Version strings cannot be empty."; set_color normal
        return 1
    end

    if not test -d /mnt/ramdisk
        sudo mkdir -p /mnt/ramdisk
    end
    sudo umount /mnt/ramdisk 2>/dev/null
    sudo mount -t tmpfs -o size=10g tmpfs /mnt/ramdisk
    cd /mnt/ramdisk/

    set_color purple; echo "Fetching Zig $z_ver..."; set_color normal
    set -l zig_url "https://ziglang.org/download/$z_ver/zig-$arch-linux-$z_ver.tar.xz"
    if curl -L "$zig_url" | tar -xJ
        set -l zig_folder (ls -d zig-linux-$arch-$z_ver)
        set -l zig_bin (pwd)/$zig_folder/zig
    else
        set_color red; echo "Zig download failed."; set_color normal
        prevd; sudo umount /mnt/ramdisk; return 1
    end

    set_color purple; echo "Fetching Ghostty $g_ver..."; set_color normal
    set -l g_url "https://release.files.ghostty.org/$g_ver/ghostty-$g_ver.tar.gz"
    if curl -LO "$g_url"
        tar -xzf "ghostty-$g_ver.tar.gz"
    else
        set_color red; echo "Ghostty download failed."; set_color normal
        prevd; sudo umount /mnt/ramdisk; return 1
    end

    cd "ghostty-$g_ver"
    
    set_color purple; echo "Compiling Ghostty..."; set_color normal
    mold -run $zig_bin build -p $HOME/.local \
        -Doptimize=ReleaseFast \
        -Dcpu=native \
        -fno-sys=gtk4-layer-shell \
        -j$threads

    prevd
    sudo umount /mnt/ramdisk 2>/dev/null

    set_color green; echo "Successfully updated to Ghostty $g_ver"; set_color normal
    $HOME/.local/bin/ghostty --version
end

function __ensure_deps -a os
    set -l needs_install 0
    
    if not command -v mold >/dev/null; or not command -v pkg-config >/dev/null
        set needs_install 1
    end

    if test $needs_install -eq 1
        set_color yellow; echo "Dependencies missing. Installing for $os..."; set_color normal
        switch $os
            case arch CachyOS
                sudo pacman -Syu --needed --noconfirm gtk4 gtk4-layer-shell libadwaita gettext mold
            case debian ubuntu kali
                sudo apt update && sudo apt install -y libgtk-4-dev libgtk4-layer-shell-dev libadwaita-1-dev gettext libxml2-utils mold
            case fedora
                sudo dnf install -y gtk4-devel gtk4-layer-shell-devel libadwaita-devel gettext mold
            case gentoo
                sudo emerge -av libadwaita gtk blueprint-compiler gettext sys-devel/mold
            case suse
                sudo zypper install -y gtk4-devel libadwaita-devel pkgconf ncurses-devel gettext mold
            case alpine
                sudo apk add gtk4.0-dev libadwaita-dev pkgconf ncurses gettext mold
            case '*'
                set_color red; echo "Unsupported OS for auto-dependency install."; set_color normal
                return 1
        end
    else
        set_color blue; echo "Dependencies verified."; set_color normal
    end
end
