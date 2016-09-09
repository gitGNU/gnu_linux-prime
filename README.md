SUSEPrime port for all dibrrutions
==================================

Assumptions
-----------
* You don't have bumblebee installed

Installation/usage
------------------

1. Run this command: sh installer.sh
2. Add the following lines 

    if [ -f /etc/X11/xinit/xinitrc.d/prime-offload.sh ];
    then
        . /etc/X11/xinit/xinitrc.d/prime-offload.sh
    fi

    To /etc/X11/xdm/Xsetup after the line ". /etc/sysconfig/displaymanager"

3. Run "prime-select nvidia" log out and login again, hopefully you are
   using nvidia GPU. To switch back to intel GPU run "prime-select intel"
   Remember to run as root.
