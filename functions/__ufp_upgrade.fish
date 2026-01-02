function __ufp_upgrade
    set -l os_env (__get_os_info)
    set -l main_upgrade_status 0
    switch "$os_env"
        case macos
            command softwareupdate -i -a
            if command -v brew > /dev/null
                command brew upgrade
                command brew cleanup
            else
                echo "No brew found"
            end

        case arch CachyOS
            command sudo pacman -Syu --noconfirm
            # command sudo pacman -Rns $(pacman -Qdtq)
            set -l orphans (pacman -Qdtq)
            if test -n "$orphans"
                command sudo pacman -Rns $orphans
            end
            if command -v paru > /dev/null
                command paru -Syu --noconfirm
            else if command -v yay > /dev/null
                command yay -Syu --noconfirm
            end

        case fedora
            command sudo dnf clean all
            command sudo dnf clean dbcache
            command sudo dnf upgrade -y --refresh
            command sudo dnf autoremove -y

        case debian kali ubuntu
            command sudo apt update
            command sudo apt full-upgrade -y
            command sudo apt autoremove -y

        case alpine
            command sudo apk update
            command sudo apk upgrade

        case gentoo
            command sudo emerge --sync
            command sudo emerge -vuDN --with-bdeps=y @world
            command sudo emerge --depclean
            command sudo eclean-dist

        case suse
            command sudo zypper refresh
            command sudo zypper dup

        case unknown "*"
            echo "Unsupported OS for native package upgrade."
            return 1
    end
    __ufp_extras
    return $main_upgrade_status
end
