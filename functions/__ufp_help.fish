function __ufp_help
    set -l os_env (__get_os_info)
    echo "Unified Fish Packager - Simple front end to popular package managers, written in Fish"
    echo ""
    echo "  ufp -h         Get help: print this dialogue"
    echo "  ufp -i         Install one or more packages"
    echo "  ufp -r         Remove one or more packages"
    echo "  ufp -q         Query to get detailed information about a given package"
    echo "  ufp -s         Search for a package"
    echo "  ufp -m         Update firmware on fwupdmgr supported systems"
    echo "  ufp -u         Perform standard system packages upgrade if no arg is given; update given package(s) otherwise"
    echo "  ufp -U         Perform a full system upgrade (updates everything; which means everything)"
    echo ""
    echo "Supports: Fedora, Arch, CachyOS, Debian, Kali, Ubuntu, Gentoo, SUSE, Alpine, & MacOS"
    echo "Current Operating System: "(string upper (string sub -l 1 -- $os_env))(string sub -s 2 -- $os_env)""
end
