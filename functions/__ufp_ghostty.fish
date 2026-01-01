function __ensure_deps -a os
    set -l needs_install 0
    
    if not command -v mold >/dev/null
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
                set_color red; echo "Use a supported distro (Fedora, Arch, CachyOS, Debian, Kali, Ubuntu, Gentoo, SUSE, or Alpine)"; set_color normal
                return 1
        end
    else
        set_color blue; echo "Dependencies verified."; set_color normal
    end
end

function __ufp_ghostty
    set -l os_env (__get_os_info)
    if test "$os_env" = "macos"
        set_color red; echo "This is for Linux, use Brew on macOS"; set_color normal
        return 1
    end

    __ensure_deps $os_env
    if test $status -ne 0
        return 1
    end

    set -l threads (nproc)
    set -l arch (uname -m)
    
    set_color purple
    read -P "Enter desired Ghostty version: " ghostty_version
    read -P "Enter required Zig version for desired Ghostty version: " zig_version
    set_color normal

    if test -z "$ghostty_version"; or test -z "$zig_version"
        set_color red; echo "Version cannot be empty."; set_color normal
        return 1
    end

    if not test -d /mnt/ramdisk
        sudo mkdir -p /mnt/ramdisk
    end
    sudo umount /mnt/ramdisk 2>/dev/null
    sudo mount -t tmpfs -o size=10g tmpfs /mnt/ramdisk
    cd /mnt/ramdisk/

    set_color purple; echo "Fetching Zig $zig_version..."; set_color normal
    set -l zig_url "https://ziglang.org/download/$zig_version/zig-$arch-linux-$zig_version.tar.xz"
    if curl -L "$zig_url" | tar -xJ
    else
        set_color red; echo "Zig download failed."; set_color normal
        prevd; sudo umount /mnt/ramdisk; return 1
    end

    set_color purple; echo "Fetching Ghostty $ghostty_version..."; set_color normal
    set -l ghostty_url "https://release.files.ghostty.org/$ghostty_version/ghostty-$ghostty_version.tar.gz"
    if curl -LO "$ghostty_url"
        tar -xzf "ghostty-$ghostty_version.tar.gz"
    else
        set_color red; echo "Ghostty download failed."; set_color normal
        prevd; sudo umount /mnt/ramdisk; return 1
    end

    cd "/mnt/ramdisk/ghostty-$ghostty_version/"
    
    set_color purple; echo "Compiling Ghostty..."; set_color normal
    mold -run /mnt/ramdisk/zig-$arch-linux-$zig_ver/zig build -p $HOME/.local \
        -Doptimize=ReleaseFast \
        -Dcpu=native \
        -fno-sys=gtk4-layer-shell \
        -j$threads

    prevd
    sudo umount /mnt/ramdisk 2>/dev/null

    set_color green; echo "Successfully updated to Ghostty $ghostty_version"; set_color normal
    $HOME/.local/bin/ghostty --version
end

