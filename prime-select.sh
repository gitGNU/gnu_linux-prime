#!/bin/bash
#    This file is part of linux-prime.
#
#    linux-prime is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    linux-prime is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with linux-prime.  If not, see <http://www.gnu.org/licenses/>.
type=$1

xorg_conf="/etc/prime/xorg.conf"
offload="/etc/prime/prime-offload.sh"

function clean_files {
      rm -f /etc/X11/xinit/xinitrc.d/prime-offload.sh
      rm -f /etc/X11/xorg.conf.d/90-nvidia.conf
      rm -f /etc/ld.so.conf.d/nvidia-libs.conf 

      # Initial file provided by nvidia libs
      rm -f /etc/ld.so.conf.d/nvidia-gfxG0*.conf   
}

case $type in
  nvidia)
      clean_files 

      gpu_info=`nvidia-xconfig --query-gpu-info`
      nvidia_busid=`echo "$gpu_info" |grep -i "PCI BusID"|sed 's/PCI BusID ://'|sed 's/ //g'`
      libglx_nvidia=`update-alternatives --list libglx.so|grep nvidia-libglx.so`

      update-alternatives --set libglx.so $libglx_nvidia

      ln -s $offload /etc/X11/xinit/xinitrc.d/prime-offload.sh

      cat $xorg_conf | sed 's/PCI:X:X:X/'${nvidia_busid}'/' > /etc/X11/xorg.conf.d/90-nvidia.conf

      echo "/usr/X11R6/lib64" > /etc/ld.so.conf.d/nvidia-libs.conf
      echo "/usr/X11R6/lib" >> /etc/ld.so.conf.d/nvidia-libs.conf

      echo "Running ldconfig"

      ldconfig
  ;;
  intel)
      clean_files

      libglx_xorg=`update-alternatives --list libglx.so|grep xorg-libglx.so`

      update-alternatives --set libglx.so $libglx_xorg

      echo "Running ldconfig"

      ldconfig
  ;;
  *)
      echo "prime-select nvidia|intel"
      exit
  ;;
esac


