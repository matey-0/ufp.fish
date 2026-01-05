function __is_container
    test -f /run/.containerenv; or test -f /.dockerenv
end

function __ufp_extras
    set main_upgrade_status $status

    if not __is_container
        if command -v sbctl >/dev/null
            set_color purple; echo "Checking secureboot signatures"; set_color normal
            command sudo sbctl sign-all 2>/dev/null
        end

        if command -v distrobox >/dev/null
            for box in (distrobox list | awk 'NR>1 {print $3}')
                set_color purple; echo "Upgrading $box distrobox"; set_color normal
                distrobox-enter -n $box -- fish -c "ufp -u" | sed 's/^/    /'
            end
            set_color purple; echo "Finished upgrading all distroboxes found"; set_color normal
        end

        if command -v flatpak >/dev/null
            set_color purple; echo "Upgrading system flatpaks"; set_color normal
            command sudo flatpak upgrade -y
            set_color purple; echo "Upgrading user flatpaks"; set_color normal
            flatpak upgrade -y
        end

        if command -v hblock >/dev/null
            set_color purple; echo "Upgrading hBlock filterlists"; set_color normal
            command sudo hblock -S ~/.config/hblock/deny.list
        end

        if functions -q fisher
            set_color purple; echo "Updating fisher plugins"; set_color normal
            fisher update
        end
    end
end
