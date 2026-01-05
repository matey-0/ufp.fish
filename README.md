**ufp -- a unified package manager for linux, written in fish**


## Compatibility

| **System**          | **Backend** | **Status**       |
| ------------------- | ----------- | ---------------- |
| **Fedora**          | `dnf`       | Fully Tested     |
| **Arch / Cachy**    | `pacman`    | Fully Tested     |
| **Debian / Ubuntu** | `apt`       | Distrobox Tested |
| **openSUSE**        | `zypper`    | Distrobox Tested |
| **Alpine**          | `apk`       | Distrobox Tested |
| **macOS**           | `brew`      | Experimental     |  

Installation with Fisher:  
```
fisher install matey-0/ufp.fish
```

It can be described simply by its help function:

```
Unified Fish Packager - Simple front end to popular package managers, written in Fish

  ufp -h         Get help: print this dialogue
  ufp -i         Install one or more packages
  ufp -r         Remove one or more packages
  ufp -e         Reinstall one or more packages
  ufp -f         Refresh cached packages, then install one or more packages
  ufp -q         Query to get detailed information about a given package
  ufp -c         Clean-up & auto-remove packages
  ufp -s         Search for a package
  ufp -b         Undo the last transaction in history (Only supported on Fedora)
  ufp -u         Perform a system upgrade
  ufp -m         Update firmware on fwupdmgr supported systems
  ufp -g         Compile desired version of the Ghostty terminal emulator (Linux only)

Supports: Fedora, Arch, CachyOS, Debian, Kali, Ubuntu, Gentoo, SUSE, Alpine, & MacOS
```
