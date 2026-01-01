function __ufp_reinstall
    set -l pkgs $argv
    set -l os_env (__get_os_info)
    switch "$os_env"
        case arch CachyOS
            command sudo pacman -S --noconfirm --overwrite '*' $pkgs
        case fedora
            command sudo dnf reinstall -y $pkgs
        case gentoo
            command sudo emerge --oneshot $pkgs
        case debian kali ubuntu
            command sudo apt install --reinstall -y $pkgs
        case suse
            command sudo zypper install -f -y $pkgs
        case alpine
            command sudo apk fix $pkgs
        case macos
            command brew reinstall $pkgs
        case unknown "*"
            echo "Use a supported OS (Fedora, Arch, CachyOS, Debian, Kali, Ubuntu, Gentoo, SUSE, Alpine, or MacOS)"
            return 1
    end
end
