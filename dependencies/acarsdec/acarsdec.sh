#!/bin/bash
# shellcheck disable=SC2086

# Common format is two-three ID letters, 4-5 closest airport letters, and then "ACARS".  Separated by a dash.
ACARSDEC_STATION_ID='ZZ-ZZZZ-ACARS'
# This should be the device index, or better yet the serial number of the SDR
ACARSDEC_RECEIVER='0'
# Common frequencies for the US are listed here.  These must be within 2MHz of each other.
ACARSDEC_FREQUENCIES='130.025 130.425 130.450 131.125 131.525 131.550 131.725 131.850'
# This gain is in tenths of a dB.  So, the example "280" means 28.0dB.  Valid vaules are between 10 and 500 (1dB and 50dB)
ACARSDEC_GAIN='280'
# Port 5550 is for ACARS data
ACARSDEC_INGRESS='feed.acars.io:5550'

# Full path to the acarsdec binary
ACARSDEC_BIN="/usr/local/airframes/acarsdec"

if [[ -z $ACARSDEC_STATION_ID ]] || [[ $ACARSDEC_STATION_ID = "ZZ-ZZZZ-ACARS" ]]; then
  echo "Edit $0 and set ACARSDEC_STATION_ID"
  exit 1
fi

if [[ -z $ACARSDEC_FREQUENCIES ]]; then
  echo "Edit $0 and set ACARSDEC_FREQUENCIES"
  exit 1
fi

if [[ $ACARSDEC_GAIN -lt 10 ]] || [[ $ACARSDEC_GAIN -gt 500 ]]; then
  echo "You've set the gain to something illegal.  Please edit $0 and set the gain between 10 and 500"
  exit 1
fi

if [[ $ACARSDEC_GAIN -lt 100 ]]; then
  echo "*** Warning, you've set the gain very low. Remember: gain is in tenths of a dB!"
fi


if [[ -z $ACARSDEC_INGRESS ]]; then
  echo "Edit $0 and set ACARSDEC_INGRESS"
fi
if [[ -z $ACARSDEC_RECEIVER ]]; then
  echo "Edit $0 and set ACARSDEC_RECEIVER"
fi

if [[ ! -x $ACARSDEC_BIN ]]; then
  echo "$ACARSDEC_BIN either doesn't exist or isn't executable, aborting."
  exit 50
fi

$ACARSDEC_BIN -v -o 4 -g ${ACARSDEC_GAIN} -i ${ACARSDEC_STATION_ID} -j ${ACARSDEC_INGRESS} -r ${ACARSDEC_RECEIVER} ${ACARSDEC_FREQUENCIES} &
