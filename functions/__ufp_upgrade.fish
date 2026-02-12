function __ufp_upgrade
    sudo -v
    set -l pkgs $argv
    set -l os_env (__get_os_info)
    set -l main_upgrade_status 0

    switch "$os_env"
        case macos
            if test -n "$pkgs"
                if command -v brew > /dev/null
                    set_color purple; echo "Upgrading specific brew package(s)"; set_color normal
                    command brew upgrade $pkgs
                else
                    echo "No brew found"
                end
            else
                command softwareupdate -i -a
                if command -v brew > /dev/null
                    set_color purple; echo "Upgrading native package(s)"; set_color normal
                    command brew upgrade
                    set_color purple; echo "Autoremoving packages & various caches"; set_color normal
                    command brew cleanup
                else
                    echo "No brew found"
                end
            end

        case arch CachyOS
            if test -n "$pkgs"
                set_color purple; echo "Upgrading specific package(s)"; set_color normal
                command sudo pacman -S --noconfirm $pkgs
                or command paru -S --noconfirm $pkgs
                or command yay -S --noconfirm $pkgs
            else
                set_color purple; echo "Upgrading native package(s)"; set_color normal
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
            end

        case fedora
            if test -n "$pkgs"
                set_color purple; echo "Upgrading specific package(s)"; set_color normal
                command sudo dnf upgrade -y $pkgs
            else
                set_color purple; echo "Cleaning up & purging DNF cache"; set_color normal
                command sudo dnf clean all
                set_color purple; echo "Upgrading native package(s)"; set_color normal
                command sudo dnf upgrade -y --refresh
                set_color purple; echo "Autoremoving package(s)"; set_color normal
                command sudo dnf autoremove -y
            end

        case debian kali ubuntu
            if test -n "$pkgs"
                set_color purple; echo "Upgrading specific package(s)"; set_color normal
                command sudo apt install --only-upgrade -y $pkgs
            else
                set_color purple; echo "Updating cache & upgrading package(s)"; set_color normal
                command sudo apt update
                command sudo apt full-upgrade -y
                set_color purple; echo "Autoremoving package(s)"; set_color normal
                command sudo apt autoremove -y
            end

        case alpine
            if test -n "$pkgs"
                set_color purple; echo "Upgrading specific package(s)"; set_color normal
                command sudo apk upgrade $pkgs
            else
                set_color purple; echo "Updating cache & upgrading package(s)"; set_color normal
                command sudo apk update
                command sudo apk upgrade
            end

        case gentoo
            if test -n "$pkgs"
                set_color purple; echo "Upgrading specific package(s)"; set_color normal
                command sudo emerge --update --oneshot $pkgs
            else
                set_color purple; echo "Syncing repositories"; set_color normal
                command sudo emerge --sync
                set_color purple; echo "Upgrading everything (@world)"; set_color normal
                command sudo emerge -vuDN --with-bdeps=y @world
                set_color purple; echo "Handling config files"; set_color normal
                command sudo dispatch-conf
                set_color purple; echo "Autoremoving package(s)"; set_color normal
                command sudo emerge --depclean
                set_color purple; echo "Cleaning up source distribution files"; set_color normal
                command sudo eclean-dist
                command sudo eselect news read
            end

        case suse
            if test -n "$pkgs"
                set_color purple; echo "Upgrading specific package(s)"; set_color normal
                command sudo zypper update -y $pkgs
            else
                set_color purple; echo "Updating cache & upgrading package(s)"; set_color normal
                command sudo zypper refresh
                command sudo zypper dup
            end

        case unknown "*"
            echo "Unsupported OS for native package upgrade."
            return 1
    end
    
    if test -z "$pkgs"
        __ufp_extras
        __ufp_repos
    end
    
    return $main_upgrade_status
end
