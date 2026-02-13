function __ufp_find_helper
    set -l pkgs $argv
    set -l os_env (__get_os_info)
    switch "$os_env"
        case arch CachyOS
            if command -v yay > /dev/null
                command sudo pacman -Ss --noconfirm $pkgs || command yay -Ss $pkgs
            else if command -v paru > /dev/null
                command sudo pacman -Ss --noconfirm $pkgs || command paru -Ss $pkgs
            else
                command sudo pacman -Ss --noconfirm $pkgs
            end
        case fedora
            command dnf search $pkgs
        case gentoo
            command emerge --search $pkgs
        case debian kali ubuntu
            command apt search $pkgs
        case suse
            command zypper search $pkgs
        case alpine
            command apk search $pkgs
        case macos
            command brew search $pkgs
        case unknown "*"
            echo "Use a supported OS (Fedora, Arch, CachyOS, Debian, Kali, Ubuntu, Gentoo, SUSE, Alpine, or MacOS)"
            return 1
    end
end

function __ufp_find
    set -l pkgs $argv
    set -l os_env (__get_os_info)
    set_color purple && echo "Searching Native Packages"
    set_color normal
    __ufp_find_helper $pkgs
    echo ""
    set_color purple && echo "Searching Flathub repositories"
    set_color normal
    flatpak search $pkgs
end
