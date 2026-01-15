function __get_os_info
    if string match Darwin (uname)
        echo "macos"
        return 0
    end
    if test -f /etc/os-release
        set -l os_id (grep '^ID=' /etc/os-release | string sub -s 4 | string trim -c '"')
        switch $os_id
            case gentoo
                echo "gentoo"
                return 0
            case arch
                echo "arch"
                return 0
            case cachyos
                echo "CachyOS"
                return 0
            case debian
                echo "debian"
                return 0
            case ubuntu
                echo "ubuntu"
                return 0
            case kali
                echo "kali"
                return 0
            case opensuse-tumbleweed opensuse-leap suse
                echo "suse"
                return 0
            case alpine
                echo "alpine"
                return 0
            case fedora
                echo "fedora"
                return 0
            case '*'
                echo "unknown"
                return 0
        end
    end
    echo "unknown"
    return 1
end
