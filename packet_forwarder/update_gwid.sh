#!/bin/sh





#This script is a helper to update the Gateway_ID field of given
# JSON configuration file, as a EUI-64 address generated from the 48-bits MAC
# address of the device it is run from.
#
# Usage examples:
#       ./update_gwid.sh ./local_conf.json

iot_sk_update_gwid() {
    # get gateway ID from its MAC address to generate an EUI-64 address
    GWID_MIDFIX="FFFE"
    GWID_BEGIN=$(ifconfig wlan0|grep ether|awk '{print $2}'| awk -F\: '{print $1$2$3}')
    GWID_END=$(ifconfig wlan0|grep ether|awk '{print $2}'| awk -F\: '{print $4$5$6}')
     NEW_GWID=$(echo $GWID_BEGIN$GWID_MIDFIX$GWID_END)
     OLD_GWID=$(cat $1 | grep gateway_ID | awk -F"\"" '{print $4}')
#     echo $OLD_GWID $NEW_GWID
    # replace last 8 digits of default gateway ID by actual GWID, in given JSON configuration file
    sed -i "s/${OLD_GWID}/${NEW_GWID}/g" $1

    echo "Gateway_ID set to "$GWID_BEGIN$GWID_MIDFIX$GWID_END" in file "$1
}

if [ $# -ne 1 ]
then
    echo "Usage: $0 [filename]"
    echo "  filename: Path to JSON file containing Gateway_ID for packet forwarder"
    exit 1
fi

iot_sk_update_gwid $1

exit 0
