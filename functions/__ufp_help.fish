function __ufp_help
    set -l os_env (__get_os_info)
    echo "Unified Fish Packager - Simple front end to popular package managers, written in Fish"
    echo ""
    echo "  ufp -h         Get help: print this dialogue"
    echo "  ufp -i         Install one or more packages"
    echo "  ufp -r         Remove one or more packages"
    echo "  ufp -e         Reinstall one or more packages"
    echo "  ufp -f         Refresh cached packages, then install one or more packages"
    echo "  ufp -q         Query to get detailed information about a given package"
    echo "  ufp -c         Clean-up & auto-remove packages"
    echo "  ufp -s         Search for a package"
    echo "  ufp -b         Undo the last transaction in history (Only supported on Fedora)"
    echo "  ufp -u         Perform a system upgrade"
    echo "  ufp -m         Update firmware on fwupdmgr supported systems"
    echo ""
    echo "Supports: Fedora, Arch, CachyOS, Debian, Kali, Ubuntu, Gentoo, SUSE, Alpine, & MacOS"
    echo "Current Operating System: "(string upper (string sub -l 1 -- $os_env))(string sub -s 2 -- $os_env)""
end
