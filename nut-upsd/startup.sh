#!/bin/sh
#
#  Provided to you under the terms of the Simplified BSD License.
#  
#  Copyright (c) 2019. Gianpaolo Del Matto, https://github.com/gpdm, <delmatto _ at _ phunsites _ dot _ net>
#  All rights reserved.
#  
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
#  
#  1. Redistributions of source code must retain the above copyright notice, this
#     list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright notice,
#     this list of conditions and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#  
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
#  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

echo "*** NUT upsd startup ***"

ups_conf="/etc/nut/ups.conf"
if [ ! -f ${ups_conf} ]; then
	printf "ERROR: '%s' does not exist. You should create one, have a look at the README.\n" ${ups_conf}
	exit
fi

cat <<EOF >/etc/nut/upsd.users
[$API_USER]
    password = $API_PASSWORD
	actions = set
	actions = fsd
	upsmon primary
EOF

cat /etc/nut/upsmon.conf.sys >/etc/nut/upsmon.conf
for I_CONF in $(env | grep '^MONITOR_')
do
MONITOR=$(echo "$I_CONF" | sed 's/^[^=]*=//g')
cat <<EOF >>/etc/nut/upsmon.conf
${MONITOR}
EOF
done
cat <<EOF >>/etc/nut/upsmon.conf
RUN_AS_USER ${USER}
EOF

chgrp $GROUP /etc/nut/*
chmod 640 /etc/nut/*
mkdir -p -m 2750 /dev/shm/nut
chown $USER.$GROUP /dev/shm/nut
[ -e /var/run/nut ] || ln -s /dev/shm/nut /var/run
echo 0 > /var/run/nut/upsd.pid && chown $USER.$GROUP /var/run/nut/upsd.pid
echo 0 > /var/run/upsmon.pid

printf "Starting up the UPS drivers...\n"
/usr/sbin/upsdrvctl -u root start || { printf "ERROR on driver startup.\n"; exit; }

printf "Starting up the UPS daemon...\n"
/usr/sbin/upsd -u $USER || { printf "ERROR on daemon startup.\n"; exit; }

printf "Starting up the UPS monitor...\n"
exec /usr/sbin/upsmon -D || { printf "ERROR on monitor startup.\n"; exit; }
