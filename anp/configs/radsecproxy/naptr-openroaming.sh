#! /bin/sh

# Example script!
# This script looks up radsec srv records in DNS for the one
# realm given as argument, and creates a server template based
# on that. It currently ignores weight markers, but does sort
# servers on priority marker, lowest number first.
# For host command this is column 5, for dig it is column 1.

usage() {
    echo "Usage: ${0} <realm>"
    exit 1
}

test -n "${1}" || usage

DIGCMD=$(command -v dig)
HOSTCMD=$(command -v host)
PRINTCMD=$(command -v printf)

validate_host() {
         echo ${@} | tr -d '\n\t\r' | grep -E '^[_0-9a-zA-Z][-._0-9a-zA-Z]*$'
}

validate_3gppnetwork() {
	echo ${@} |sed -E 's/^(.*)(\.3gppnetwork\.org)$/\1\.pub\2/g'
}

validate_port() {
         echo ${@} | tr -d '\n\t\r' | grep -E '^[0-9]+$'
}

dig_it_srv() {
    ${DIGCMD} +short srv $SRV_HOST | sort -n -k1 |
    while read line; do
        set $line ; PORT=$(validate_port $3) ; HOST=$(validate_host $4)
        if [ -n "${HOST}" ] && [ -n "${PORT}" ]; then
            $PRINTCMD "\thost ${HOST%.}:${PORT}\n"
        fi
    done
}

dig_it_naptr() {
    ${DIGCMD} +short naptr ${REALM} | grep aaa+auth:radius.tls.tcp | sort -n -k1 |
    while read line; do
        set $line ; TYPE=$3 ; HOST=$(validate_host $6)
        if ( [ "$TYPE" = "\"s\"" ] || [ "$TYPE" = "\"S\"" ] ) && [ -n "${HOST}" ]; then
            SRV_HOST=${HOST%.}
            dig_it_srv
        fi
    done
}

host_it_srv() {
    ${HOSTCMD} -t srv $SRV_HOST | sort -n -k5 |
    while read line; do
        set $line ; PORT=$(validate_port $7) ; HOST=$(validate_host $8)
        if [ -n "${HOST}" ] && [ -n "${PORT}" ]; then
            $PRINTCMD "\thost ${HOST%.}:${PORT}\n"
        fi
    done
}

host_it_naptr() {
    ${HOSTCMD} -t naptr ${REALM} | grep aaa+auth:radius.tls.tcp | sort -n -k5 |
    while read line; do
        set $line ; TYPE=$7 ; HOST=$(validate_host ${10})
        if ( [ "$TYPE" = "\"s\"" ] || [ "$TYPE" = "\"S\"" ] ) && [ -n "${HOST}" ]; then
            SRV_HOST=${HOST%.}
            host_it_srv
        fi
    done
}

ORIG_REALM=$(validate_host ${1})
if [ -z "${ORIG_REALM}" ]; then
    echo "Error: realm \"${1}\" failed validation"
    usage
fi

# for 3gppnetwork we have to do some messing about
if echo "${ORIG_REALM}" |grep -Eq '.(\.pub\.3gppnetwork\.org)$' ; then
    REALM="${ORIG_REALM}"
elif echo "${ORIG_REALM}" |grep -Eq '.(\.3gppnetwork\.org)$' ; then
    REALM=$(validate_3gppnetwork "${ORIG_REALM}")
else
    REALM="${ORIG_REALM}"
fi

if [ -x "${DIGCMD}" ]; then
    SERVERS=$(dig_it_naptr)
elif [ -x "${HOSTCMD}" ]; then
    SERVERS=$(host_it_naptr)
else
    echo "${0} requires either \"dig\" or \"host\" command."
    exit 1
fi

if [ -n "${SERVERS}" ]; then
    $PRINTCMD "server dynamic_radsec.${ORIG_REALM} {\n${SERVERS}\n\ttype TLS\n}\n"
    exit 0
fi

exit 10				# No server found.