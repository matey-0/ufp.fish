function __ufp_firmware
    set -l os_env (__get_os_info)
    if test "$os_env" != "macos"; and command -v fwupdmgr >/dev/null
        set_color purple; echo "Attempting to update firmware via fwupdmgr..."; set_color normal
        command fwupdmgr refresh --force
        command fwupdmgr get-updates
        command fwupdmgr update
    else
        set_color red
        echo "Firmware updates via fwupdmgr are only available on Linux systems with the tool installed."
        set_color normal
        return 1
    end
end
