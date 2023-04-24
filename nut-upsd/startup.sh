#!/bin/sh
#
#  Provided to you under the terms of the Simplified BSD License.
#  
#  Copyright (c) 2019. Gianpaolo Del Matto, https://github.com/gpdm, <delmatto _ at _ phunsites _ dot _ net>
#  Copyright (c) 2023. Zarklord https://github.com/zarklord
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

OIFS=$IFS
IFS=$'\n'

echo <<EOF >/etc/nut/ups.conf
pollinterval = 1
maxretry = 3

EOF

for I_CONF in $(env | grep '^UPS_')
do
UPS_NAME=$(echo "$I_CONF" | sed 's/^UPS_//g' | sed 's/=.*//g')
UPS_CONF=$(echo "$I_CONF" | sed 's/^[^=]*=//g')
cat <<EOF >>/etc/nut/ups.conf
[${UPS_NAME}]
EOF
printf "\n\t$UPS_CONF\n" | sed 's/;/\n\t/g' >>/etc/nut/ups.conf
done

IFS=$OIFS

cat <<EOF >/etc/nut/upsd.users
[$API_USER]
    password = $API_PASSWORD
	actions = set
	actions = fsd
	instcmds = all
	upsmon primary
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
exec /usr/sbin/upsd -u $USER || { printf "ERROR on daemon startup.\n"; exit; }
