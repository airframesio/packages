#!/bin/bash
# shellcheck disable=SC2086

# Common format is two-three ID letters, 4-5 closest airport letters, and then "VDLM2".  Separated by a dash.
VDLM2DEC_STATION_ID='ZZ-ZZZZ-VDLM2'
# This should be the device index, or better yet the serial number of the SDR
VDLM2DEC_RECEIVER='0'
# Common frequencies for the US are listed here.  These must be within 2MHz of each other.
VDLM2DEC_FREQUENCIES='136.650 136.700 136.800 136.725 136.775 136.825 136.875 136.975'
# This gain is in tenths of a dB.  So, the example "280" means 28.0dB.  Valid vaules are between 10 and 500 (1dB and 50dB)
VDLM2DEC_GAIN='280'
# Port 5555 is for VDLM2 data
VDLM2DEC_INGRESS='feed.acars.io:5555'

# Full path to the vdlm2dec binary
VDLM2DEC_BIN="/usr/local/airframes/vdlm2dec"

if [[ -z $VDLM2DEC_STATION_ID ]] || [[ $VDLM2DEC_STATION_ID = "ZZ-ZZZZ-VDLM2" ]]; then
  echo "Edit $0 and set VDLM2DEC_STATION_ID"
  exit 1
fi

if [[ -z $VDLM2DEC_FREQUENCIES ]]; then
  echo "Edit $0 and set VDLM2DEC_FREQUENCIES"
  exit 1
fi

if [[ $VDLM2DEC_GAIN -lt 10 ]] || [[ $VDLM2DEC_GAIN -gt 500 ]]; then
  echo "You've set the gain to something illegal.  Please edit $0 and set the gain between 10 and 500"
  exit 1
fi

if [[ $VDLM2DEC_GAIN -lt 100 ]]; then
  echo "*** Warning, you've set the gain very low. Remember: gain is in tenths of a dB!"
fi


if [[ -z $VDLM2DEC_INGRESS ]]; then
  echo "Edit $0 and set VDLM2DEC_INGRESS"
fi
if [[ -z $VDLM2DEC_RECEIVER ]]; then
  echo "Edit $0 and set VDLM2DEC_RECEIVER"
fi

if [[ ! -x $VDLM2DEC_BIN ]]; then
  echo "$VDLM2DEC_BIN either doesn't exist or isn't executable, aborting."
  exit 50
fi

$VDLM2DEC_BIN -J -j ${VDLM2DEC_INGRESS} -i ${VDLM2DEC_STATION_ID} -v -G -E -U -g ${VDLM2DEC_GAIN} -r ${VDLM2DEC_RECEIVER} ${VDLM2DEC_FREQUENCIES} &
