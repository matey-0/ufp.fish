function __ufp_query
    set -l pkgs $argv
    set -l os_env (__get_os_info)
    switch "$os_env"
        case arch CachyOS
            command pacman -Qi $pkgs 2>/dev/null || command pacman -Si $pkgs
        case fedora
            command dnf info $pkgs
        case gentoo
            command emerge -pv $pkgs
        case debian kali ubuntu
            command apt show $pkgs
        case suse
            command zypper info $pkgs
        case alpine
            command apk info -a $pkgs
        case macos
            command brew info $pkgs
        case unknown "*"
            echo "Use a supported OS (Fedora, Arch, CachyOS, Debian, Kali, Ubuntu, Gentoo, SUSE, Alpine, or MacOS)"
            return 1
    end
end
