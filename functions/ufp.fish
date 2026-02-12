function ufp
    if test (count $argv) -lt 1
        __ufp_help; return 0
    end
    set -l action $argv[1]
    set -l args $argv[2..-1]
    switch "$action"
        case "-i"
            if test (count $args) -eq 0; echo "Error: input contains no packages"; __ufp_help; return 1; end
            __ufp_install $args

        case "-r"
            if test (count $args) -eq 0; echo "Error: input contains no packages"; __ufp_help; return 1; end
            __ufp_remove $args

        case "-e"
            if test (count $args) -eq 0; echo "Error: input contains no packages"; __ufp_help; return 1; end
            __ufp_reinstall $args

        case "-f"
            if test (count $args) -eq 0; echo "Error: input contains no packages"; __ufp_help; return 1; end
            __ufp_refresh $args

        case "-q"
            if test (count $args) -eq 0; echo "Error: input contains no packages"; __ufp_help; return 1; end
            __ufp_query $args

        case "-s"
            if test (count $args) -eq 0; echo "Error: input contains no packages"; __ufp_help; return 1; end
            __ufp_find $args
        
        case "-m"
            __ufp_firmware
        case "-g"
            __ufp_ghostty
        case "-l"
            __ufp_ladybird
        case "-c"
            __ufp_clean
        case "-p"
            __ufp_repos
        case "-u"
            if contains -- "ufp" $args
                fisher update matey-0/ufp.fish
            else
                __ufp_upgrade $args
            end
        case "-U"
                __ufp_fullupgrade
        case "-b" 
            __ufp_rollback
        case "-h" "--help" ""
            __ufp_help
        case "-v" "--version" 
            echo "Mateo Grgic's ufp, version 1.0.8"
        case "*"
            echo "Unknown command '$action'"
            __ufp_help
            return 1
    end
    return $status
end
