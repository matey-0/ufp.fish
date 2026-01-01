function __ufp_clean
    set -l os_env (__get_os_info)
    switch "$os_env"
        case fedora
            command sudo dnf autoremove -y
        case arch CachyOS
            set -l orphans (pacman -Qdtq)
            if test -n "$orphans"
                command sudo pacman -Rns $orphans
            else
                echo "No orphans to reside."
            end
        case debian kali ubuntu
            command sudo apt autoremove -y
        case gentoo
            command sudo emerge --depclean
        case macos
            command brew cleanup
        case "*"
            echo "Use a supported OS (Fedora, Arch, CachyOS, Debian, Kali, Ubuntu, Gentoo, SUSE, Alpine, or MacOS)"
    end
end
