#!/bin/bash
sleep infinity
if [ "$SONARR_REL" == "latest" ]; then
    LAT_V="$(wget -qO- https://git.minenet.at/ich777/versions/raw/branch/master/Sonarr | grep LATEST | cut -d '=' -f2)"
elif [ "$SONARR_REL" == "prerelease" ]; then
    LAT_V="$(wget -qO- https://git.minenet.at/ich777/versions/raw/branch/master/Sonarr | grep NIGHTLY | cut -d '=' -f2)"
else
    echo "---Version manually set to: v$SONARR_REL---"
    LAT_V="$SONARR_REL"
fi

