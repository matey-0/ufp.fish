function __ufp_fullupgrade
    sudo -v
    set -l os_env (__get_os_info)
    set -l main_upgrade_status 0
    switch "$os_env"
        case macos
            command softwareupdate -i -a
            if command -v brew > /dev/null
                set_color purple; echo "Upgrading native packages"; set_color normal
                command brew upgrade
                set_color purple; echo "Autoremoving packages & various caches"; set_color normal
                command brew cleanup
            else
                echo "No brew found"
            end

        case arch CachyOS
            set_color purple; echo "Upgrading native packages"; set_color normal
            command sudo pacman -Syyu --noconfirm
            set -l orphans (pacman -Qdtq)
            if test -n "$orphans"
                set_color purple; echo "Removing orphans"; set_color normal
                command sudo pacman -Rns $orphans
            end
            if command -v paru > /dev/null
                set_color purple; echo "Paru found: upgrading"; set_color normal
                command paru -Syu --noconfirm
            else if command -v yay > /dev/null
                set_color purple; echo "Yay found: upgrading"; set_color normal
                command yay -Syu --noconfirm
            end

        case fedora
            set_color purple; echo "Cleaning up & purging DNF cache"; set_color normal
            command sudo dnf clean all
            set_color purple; echo "Upgrading native packages"; set_color normal
            command sudo dnf upgrade -y --refresh
            set_color purple; echo "Autoremoving packages"; set_color normal
            command sudo dnf autoremove -y

        case debian kali ubuntu
            set_color purple; echo "Updating cache & upgrading packages"; set_color normal
            command sudo apt update
            command sudo apt full-upgrade -y
            set_color purple; echo "Autoremoving packages"; set_color normal
            command sudo apt autoremove -y

        case alpine
            set_color purple; echo "Updating cache & upgrading packages"; set_color normal
            command sudo apk update
            command sudo apk upgrade

        case gentoo
            set_color purple; echo "Syncing repositories"; set_color normal
            command sudo emerge --sync
            set_color purple; echo "Upgrading everything (@world)"; set_color normal
            command sudo emerge -vuDN --with-bdeps=y @world
            set_color purple; echo "Handling config files"; set_color normal
            command sudo dispatch-conf
            set_color purple; echo "Autoremoving packages"; set_color normal
            command sudo emerge --depclean
            set_color purple; echo "Cleaning up source distribution files"; set_color normal
            command sudo eclean-dist
            command sudo eselect news read

        case suse
            set_color purple; echo "Updating cache & upgrading packages"; set_color normal
            command sudo zypper refresh
            command sudo zypper dup

        case unknown "*"
            echo "Unsupported OS for native package upgrade."
            return 1
    end
    __ufp_extras
    return $main_upgrade_status
end
