#!/bin/sh
if [ -z "$1" ] ; then
    echo Usage:$0 targetname [image_name] [os] 
    exit 0
fi
m_src=`dirname $0`
m_target=$1
m_img=$2
m_os=$3
if [ -z "$m_img" ] ; then m_img=$m_src/build/$m_target.img ; fi
if [ -n "$m_os" ] ; then 
    exec bfd -w $m_src -o $m_os -i $m_img  $m_target 
else
    exec bfd -w $m_src -i $m_img  $m_target 
fi
