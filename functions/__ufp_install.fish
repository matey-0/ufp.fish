function __ufp_install_helper
    set -l pkgs $argv
    set -l os_env (__get_os_info)
    switch "$os_env"
        case arch CachyOS
            if command -v yay > /dev/null
                command sudo pacman -S --noconfirm $pkgs || command yay -S $pkgs
            else if command -v paru > /dev/null
                command sudo pacman -S --noconfirm $pkgs || command paru -S $pkgs
            else
                command sudo pacman -S --noconfirm $pkgs
            end
        case fedora
            command sudo dnf install -y $pkgs
        case gentoo
            command sudo emerge --ask $pkgs
        case debian kali ubuntu
            command sudo apt install -y $pkgs
        case suse
            command sudo zypper install -y $pkgs
        case alpine
            command sudo apk add $pkgs
        case macos
            command brew install $pkgs
        case unknown "*"
            echo "Use a supported OS (Fedora, Arch, CachyOS, Debian, Kali, Ubuntu, Gentoo, SUSE, Alpine, or MacOS)"
            return 1
    end
end

function __ufp_flatpak_install
    set -l pkgs $argv
    set_color purple
    echo ""
    echo "Couldn't find requested package(s) in main repositories, now checking Flatpak"
    set_color normal
    command flatpak install --user $pkgs
end

function __ufp_install
    set -l pkgs $argv
    set -l os_env (__get_os_info)
    __ufp_install_helper $pkgs || __ufp_flatpak_install $pkgs
end
