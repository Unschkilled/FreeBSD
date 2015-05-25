#! /usr/local/bin/zsh

# script to update the whole system
echo FULL SYSTEM UPDATE

#update the ports collection
portsnap fetch
portsnap update

#update packages and pkg
pkg upgrade &&  echo Y
pkg update  &&  echo Y
pkg clean   &&  echo Y

#update FreeBSD
freebsd-update fetch
freebsd-update install

echo UPDATES FINISHED
