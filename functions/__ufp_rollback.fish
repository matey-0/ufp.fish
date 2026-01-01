function __ufp_rollback
    set -l os_env (__get_os_info)
    switch "$os_env"
        case fedora
            command sudo dnf history undo last
        case unknown "*"
            echo "Rollback is only supported on Fedora; DNF is the best :)"
    end
end
