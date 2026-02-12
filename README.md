**ufp -- a unified package manager for Linux, written in Fish**

Note: I haven't tested this on systems that aren't mine, so use this function at your own risk, especially the non-package-manager-based functions; I can't guarantee that this won't break your computer somehow (though it shouldn't).

## Compatibility

| **System**          | **Backend** | **Status**       |
| ------------------- | ----------- | ---------------- |
| **Fedora**          | `dnf`       | Fully tested     |
| **Arch / Cachy**    | `pacman`, `yay/paru`    | Fully tested     |
| **Debian / Ubuntu / Kali** | `apt`       | Distrobox tested |
| **Gentoo** | `emerge` | Distrobox tested|
| **openSUSE**        | `zypper`    | Distrobox tested |
| **Alpine**          | `apk`       | Distrobox tested |
| **macOS**           | `brew`      | Experimental     |  

Since this is a Fish plugin, you do need to be using the Fish shell for this to work. You can use Fisher to install this plugin.  

Installation with Fisher:  
```
fisher install matey-0/ufp.fish
```

It can be described somewhat simply by its help function:

```
Unified Fish Packager - Simple front end to popular package managers, written in Fish

  Features that take arguments:
  ufp -h         Get help: print this dialogue
  ufp -i         Install one or more packages
  ufp -r         Remove one or more packages
  ufp -e         Reinstall one or more packages
  ufp -f         Refresh cached packages, then install one or more packages
  ufp -q         Query to get detailed information about a given package
  ufp -s         Search for a package
  ufp -b         Undo the last transaction in history (Only supported on Fedora)
  ufp -c         Clean-up & auto-remove packages
  ufp -m         Update firmware on fwupdmgr supported systems
  ufp -p         Update git repos en-mass
  ufp -l         Compile and update the Ladybird browser
  ufp -g         Compile and update the Ghostty terminal
  ufp -u         Perform standard system packages upgrade if no arg is given; update given package(s) otherwise
  ufp -U         Perform a full system upgrade (updates everything; which means everything)

  ufp -u ufp     Update ufp itself
  ufp -v         Display current ufp version

Supports: Fedora, Arch, CachyOS, Debian, Kali, Ubuntu, Gentoo, SUSE, Alpine, & MacOS
Current Operating System: Fedora
```
