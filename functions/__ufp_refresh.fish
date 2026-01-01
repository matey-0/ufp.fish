function __ufp_refresh
    set -l pkgs $argv
    set -l os_env (__get_os_info)
    switch "$os_env"
        case arch CachyOS
            command sudo pacman -Syu --noconfirm $pkgs
        case fedora
            command sudo dnf install --refresh -y $pkgs
        case gentoo
            command sudo emerge --sync
            command sudo emerge --ask $pkgs
        case debian kali ubuntu
            command sudo apt update
            command sudo apt install -y $pkgs
        case suse
            command sudo zypper refresh
            command sudo zypper install -y $pkgs
        case alpine
            command sudo apk update
            command sudo apk add $pkgs
        case macos
            command brew update
            command brew install $pkgs
        case unknown "*"
            echo "Use a supported OS (Fedora, Arch, CachyOS, Debian, Kali, Ubuntu, Gentoo, SUSE, Alpine, or MacOS)"
            return 1
    end
    return $status
end
