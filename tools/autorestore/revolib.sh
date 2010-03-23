# (c) 2010 Mandriva, http://www.mandriva.com
#
# $Id$
#
# This file is part of Pulse 2, http://pulse2.mandriva.org
#
# Pulse 2 is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# Pulse 2 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Pulse 2; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA.
#
# Factorization lib
#

pretty_print() {
    echo -en "$1"
}

pretty_white () {
    pretty_print "[1;37m"
    pretty_print "$1"
    pretty_print "[0m"
}

pretty_red () {
    pretty_print "[1;31m"
    pretty_print "$1"
    pretty_print "[0m"
}

pretty_green () {
    pretty_print "[1;32m"
    pretty_print "$1"
    pretty_print "[0m"
}

pretty_orange() {
    pretty_print "[1;33m"
    pretty_print "$1"
    pretty_print "[0m"
}

pretty_blue() {
    pretty_print "[1;34m"
    pretty_print "$1"
    pretty_print "[0m"
}

pretty_warn() {
    pretty_orange "==> $1\n"
}

pretty_info() {
    pretty_white "==> $1\n"
}

pretty_try() {
    pretty_white "==> $1 ... "
}

pretty_success() {
    pretty_green " OK\n"
}

pretty_failure() {
    pretty_red " KO\n"
}

return_success_or_failure() {
    if [ "$1" -eq "0" ]; then
	pretty_success
	return 0
    else
	pretty_failure
	return 1
    fi
}

probe_server() {
    srv=$1

    ret=0
    tries=10
    interval=1

    pretty_try "Probing server $srv"
    while [ "$tries" -ne "0" ]
    do
	ping -c 1 "$srv" -q 2>/dev/null 1>/dev/null
	[ "$?" -eq "0" ] && ret=0 && break
	echo -en "."
	tries=$(($tries - 1 ))
	sleep $interval
    done
    return_success_or_failure $ret
    return $ret
}

server_command_loop() {
    question=$1
    mac=$2
    srv=$3

    tries=60
    interval=1

    while [ "$tries" -ne "0" ]
    do
	ANSWER=`echo -en "$question\00Mc:$mac" | nc -p 1001 -w 1 $srv 1001 2>/dev/null`
	[ "$?" -eq "0" ] && [ ! -z "$ANSWER" ] && [ ! "$ANSWER" == "ERROR" ] && break
	echo -en "."
	tries=$(($tries - 1 ))
	sleep $interval
    done
    export ANSWER
}

get_image_uuid() {
    type="$1"
    mac=$2
    srv=$3

    pretty_try "Asking for an image UUID"
    server_command_loop "\354$type" $mac $srv
    return_success_or_failure $?
}

get_computer_hostname() {
    mac=$1
    srv=$2

    pretty_try "Asking for my hostname"
    server_command_loop "\032" $mac $srv
    return_success_or_failure $?
}

get_computer_uuid() {
    mac=$1
    srv=$2

    pretty_try "Asking for my UUID"
    server_command_loop "\033" $mac $srv
    return_success_or_failure $?
}

get_rdate() {
    srv=$1

    pretty_try "Getting current time from $SRV"
    rdate $srv 2>/dev/null 1>/dev/null
    return_success_or_failure $?
}

check_nfs() {
    sip=$1

    pretty_try "Checking NFS service on $sip"

    RPCINFO=`rpcinfo -p $sip`

    logger "rpcinfo:"
    logger "$RPCINFO"

    if echo "$RPCINFO" | grep -q nfs
    then
	pretty_success
	return 0
    else
	pretty_failure
	pretty_warning "The NFS service does not seem to work on $sip; IP configuration :"
	cat /etc/netinfo.log
	return 1
    fi
}