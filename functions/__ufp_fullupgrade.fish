function __ufp_fullupgrade
    sudo -v
    set -l os_env (__get_os_info)
    set -l main_upgrade_status 0
    __ufp_upgrade
    __ufp_extras
    return $main_upgrade_status
end
