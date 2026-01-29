**ufp -- a unified package manager for Linux, written in Fish**

Note: I haven't tested this on systems that aren't mine, so use this function at your own risk, especially the non-package-manager-based functions. I can't guarantee that this won't break your computer somehow (though it shouldn't).

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

It can be described simply by its help function:

```
Unified Fish Packager - Simple front end to popular package managers, written in Fish

  ufp -h         Get help: print this dialogue
  ufp -i         Install one or more packages
  ufp -r         Remove one or more packages
  ufp -e         Reinstall one or more packages
  ufp -f         Refresh cached packages, then install one or more packages
  ufp -q         Query to get detailed information about a given package
  ufp -c         Clean up, and auto-remove packages
  ufp -s         Search for a package
  ufp -b         Undo the last transaction in history (only supported on Fedora)
  ufp -u         Perform a system upgrade
  ufp -m         Update firmware on fwupdmgr-supported systems
  ufp -u ufp     Update the ufp plugin itself through Fisher

Supports: Fedora, Arch, CachyOS, Debian, Kali, Ubuntu, Gentoo, SUSE, Alpine, and macOS
```
