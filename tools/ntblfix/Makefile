# (c) 2003-2007 Linbox FAS, http://linbox.com
# (c) 2008-2009 Mandriva, http://www.mandriva.com
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
# NT bootloader fix
#
topdir = $(abspath ../..)
include $(topdir)/common.mk

bin_all = ntblfix

CFLAGS=-Os -Wall -fpic

CLEANFILES = $(bin_all)

all-local: $(bin_all)

ntblfix: ntblfix.c vm86.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -DNOT_IN_X_SERVER -o $@ $^

install-local:
	mkdir -p $(DESTDIR)$(bindir)
	$(install_BIN) ntblfix $(DESTDIR)$(bindir)/
