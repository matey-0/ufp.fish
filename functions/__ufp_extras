function __ufp_extras

    set main_upgrade_status $status
    if command -v sbctl > /dev/null
        set_color purple; echo "Checking secureboot signatures"; set_color normal
        command sudo sbctl sign-all 2> /dev/null
        # command sudo sbctl sign -s /boot/vmlinuz-*-cachyos*.lto.* 2> /dev/null
    end

    if command -v distrobox > /dev/null
      # distrobox-upgrade --all
        if command -v flatpak > /dev/null
            command sudo flatpak upgrade -y && flatpak upgrade -y
        end
        if command -v hblock > /dev/null
            command sudo hblock -S ~/.config/hblock/deny.list
        end
        if functions -q fisher 
            fisher update
        end
    end

end
