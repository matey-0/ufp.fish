function __ufp_remove
    set -l pkgs $argv
    set -l os_env (__get_os_info)
    switch "$os_env"
        case arch CachyOS
            command sudo pacman -Rs $pkgs || command yay -Rs $pkgs
        case fedora
            command sudo dnf remove $pkgs
        case gentoo
            command sudo emerge --unmerge $pkgs
        case debian kali ubuntu
            command sudo apt remove $pkgs
        case suse
            command sudo zypper remove $pkgs
        case alpine
            command sudo apk del $pkgs
        case macos
            command brew remove $pkgs
        case unknown "*"
            echo "Use a supported OS (Fedora, Arch, CachyOS, Debian, Kali, Ubuntu, Gentoo, SUSE, Alpine, or MacOS)"
            return 1
    end
end
