#!/bin/bash
if [ "$SONARR_REL" == "latest" ]; then
    LAT_V="$(wget -qO- https://github.com/ich777/versions/raw/master/Sonarr | grep LATEST | cut -d '=' -f2)"
elif [ "$SONARR_REL" == "nightly" ]; then
    LAT_V="$(wget -qO- https://github.com/ich777/versions/raw/master/Sonarr | grep NIGHTLY | cut -d '=' -f2)"
else
    echo "---Version manually set to: v$SONARR_REL---"
    LAT_V="$SONARR_REL"
fi

if [ ! -f ${DATA_DIR}/logs/sonarr.txt ]; then
    CUR_V=""
else
    CUR_V="$(cat ${DATA_DIR}/logs/sonarr.txt | grep Version | tail -1 | rev | cut -d ' ' -f1 | rev)"
fi

if [ -z $LAT_V ]; then
    if [ -z $CUR_V ]; then
        echo "---Can't get latest version of Sonarr, putting container into sleep mode!---"
        sleep infinity
    else
        echo "---Can't get latest version of Sonarr, falling back to v$CUR_V---"
    fi
fi

echo "---Version Check---"
if [ "$SONARR_REL" == "nightly" ]; then
    if [ -z "$CUR_V" ]; then
        echo "---Sonarr not found, downloading and installing v$LAT_V...---"
        cd ${DATA_DIR}
        if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz "https://download.sonarr.tv/v3/phantom-develop/${LAT_V}/Sonarr.phantom-develop.${LAT_V}.linux.tar.gz" ; then
            echo "---Successfully downloaded Sonarr v$LAT_V---"
        else
            echo "---Something went wrong, can't download Sonarr v$LAT_V, putting container into sleep mode!---"
            sleep infinity
        fi
        mkdir ${DATA_DIR}/Sonarr
        tar -C ${DATA_DIR}/Sonarr --strip-components=1 -xf ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz
        rm ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz
    elif [ "$CUR_V" != "$LAT_V" ]; then
        echo "---Version missmatch, installed v$CUR_V, downloading and installing latest v$LAT_V...---"
        cd ${DATA_DIR}
        if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz "https://download.sonarr.tv/v3/phantom-develop/${LAT_V}/Sonarr.phantom-develop.${LAT_V}.linux.tar.gz" ; then
            echo "---Successfully downloaded Sonarr v$LAT_V---"
        else
            echo "---Something went wrong, can't download Sonarr v$LAT_V, putting container into sleep mode!---"
            sleep infinity
        fi
        rm -R ${DATA_DIR}/Sonarr
        mkdir ${DATA_DIR}/Sonarr
        tar -C ${DATA_DIR}/Sonarr --strip-components=1 -xf ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz
        rm ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz
    elif [ "$CUR_V" == "$LAT_V" ]; then
        echo "---Sonarr v$CUR_V up-to-date---"
    fi
else
    if [ -z "$CUR_V" ]; then
        echo "---Sonarr not found, downloading and installing v$LAT_V...---"
        cd ${DATA_DIR}
        if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz "https://download.sonarr.tv/v2/master/mono/NzbDrone.master.${LAT_V}.mono.tar.gz" ; then
            echo "---Successfully downloaded Sonarr v$LAT_V---"
        else
            echo "---Something went wrong, can't download Sonarr v$LAT_V, putting container into sleep mode!---"
            sleep infinity
        fi
        mkdir ${DATA_DIR}/Sonarr
        tar -C ${DATA_DIR}/Sonarr --strip-components=1 -xf ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz
        rm ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz
    elif [ "$CUR_V" != "$LAT_V" ]; then
        echo "---Version missmatch, installed v$CUR_V, downloading and installing latest v$LAT_V...---"
        cd ${DATA_DIR}
        if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz "https://download.sonarr.tv/v2/master/mono/NzbDrone.master.${LAT_V}.mono.tar.gz" ; then
            echo "---Successfully downloaded Sonarr v$LAT_V---"
        else
            echo "---Something went wrong, can't download Sonarr v$LAT_V, putting container into sleep mode!---"
            sleep infinity
        fi
        rm -R ${DATA_DIR}/Sonarr
        mkdir ${DATA_DIR}/Sonarr
        tar -C ${DATA_DIR}/Sonarr --strip-components=1 -xf ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz
        rm ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz
    elif [ "$CUR_V" == "$LAT_V" ]; then
        echo "---Sonarr v$CUR_V up-to-date---"
    fi
fi

echo "---Preparing Server---"
if [ ! -f ${DATA_DIR}/config.xml ]; then
    echo "<Config>
  <LaunchBrowser>False</LaunchBrowser>
</Config>" > ${DATA_DIR}/config.xml
fi
if [ -f ${DATA_DIR}/nzbdrone.pid ]; then
    rm ${DATA_DIR}/nzbdrone.pid
elif [ -f ${DATA_DIR}/sonarr.pid ]; then
    rm ${DATA_DIR}/sonarr.pid
fi
chmod -R ${DATA_PERM} ${DATA_DIR}

echo "---Starting Sonarr---"
cd ${DATA_DIR}
if [ "$SONARR_REL" == "nightly" ]; then
    /usr/bin/mono ${MONO_START_PARAMS} ${DATA_DIR}/Sonarr/Sonarr.exe -nobrowser -data=${DATA_DIR} ${START_PARAMS}
else
    /usr/bin/mono ${MONO_START_PARAMS} ${DATA_DIR}/Sonarr/NzbDrone.exe -nobrowser -data=${DATA_DIR} ${START_PARAMS}
fi