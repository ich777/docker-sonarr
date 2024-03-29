#!/bin/bash
if [ "$SONARR_REL" == "latest" ]; then
    LAT_V="$(wget -qO- https://github.com/ich777/versions/raw/master/Sonarr | grep LATEST | cut -d '=' -f2)"
elif [ "$SONARR_REL" == "nightly" ]; then
    LAT_V="$(wget -qO- https://github.com/ich777/versions/raw/master/Sonarr | grep NIGHTLY | cut -d '=' -f2)"
else
    echo "---Version manually set to: v$SONARR_REL---"
    LAT_V="$SONARR_REL"
fi

if [ ! -f ${DATA_DIR}/Sonarr/release_info ]; then
    CUR_V=""
else
    CUR_V="$(cat ${DATA_DIR}/Sonarr/release_info | grep "ReleaseVersion" | cut -d '=' -f2)"
fi

if [ -z $LAT_V ]; then
    if [ -z $CUR_V ]; then
        echo "---Can't get latest version of Sonarr, putting container into sleep mode!---"
        sleep infinity
    else
        echo "---Can't get latest version of Sonarr, falling back to v$CUR_V---"
        LAT_V="$CUR_V"
    fi
fi

rm ${DATA_DIR}/Sonarr-v*.tar.gz

echo "---Version Check---"
if [ "$SONARR_REL" == "nightly" ]; then
    if [ -z "$CUR_V" ]; then
        echo "---Sonarr not found, downloading and installing v$LAT_V...---"
        cd ${DATA_DIR}
        if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz "https://github.com/Sonarr/Sonarr/releases/download/v${LAT_V}/Sonarr.develop.${LAT_V}.linux-x64.tar.gz" ; then
            echo "---Successfully downloaded Sonarr v$LAT_V---"
        else
            rm ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz
            echo "---Something went wrong, can't download Sonarr v$LAT_V, putting container into sleep mode!---"
            sleep infinity
        fi
        mkdir ${DATA_DIR}/Sonarr
        tar -C ${DATA_DIR}/Sonarr --strip-components=1 -xf ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz
        if [ ! -f ${DATA_DIR}/Sonarr/release_info ]; then
            echo "ReleaseVersion=$LAT_V" > ${DATA_DIR}/Sonarr/release_info
        fi
        rm ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz
    elif [ "$CUR_V" != "$LAT_V" ]; then
        echo "---Version missmatch, installed v$CUR_V, downloading and installing latest v$LAT_V...---"
        cd ${DATA_DIR}
        if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz "https://github.com/Sonarr/Sonarr/releases/download/v${LAT_V}/Sonarr.develop.${LAT_V}.linux-x64.tar.gz" ; then
            echo "---Successfully downloaded Sonarr v$LAT_V---"
        else
            rm ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz
            echo "---Something went wrong, can't download Sonarr v$LAT_V, falling back to v$CUR_V!---"
            EXIT_STATUS=1
        fi
        if [ "${EXIT_STATUS}" != "1" ]; then
            rm -R ${DATA_DIR}/Sonarr
            mkdir ${DATA_DIR}/Sonarr
            tar -C ${DATA_DIR}/Sonarr --strip-components=1 -xf ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz
            if [ ! -f ${DATA_DIR}/Sonarr/release_info ]; then
                echo "ReleaseVersion=$LAT_V" > ${DATA_DIR}/Sonarr/release_info
            elif [ "$(cat ${DATA_DIR}/Sonarr/release_info | grep "ReleaseVersion" | cut -d '=' -f2)" != "${LAT_V}" ]; then
                sed -i "/^ReleaseVersion=/c\ReleaseVersion=$LAT_V" ${DATA_DIR}/Sonarr/release_info
            fi
            rm ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz
        fi
    elif [ "$CUR_V" == "$LAT_V" ]; then
        echo "---Sonarr v$CUR_V up-to-date---"
    fi
else
    if [ -z "$CUR_V" ]; then
        echo "---Sonarr not found, downloading and installing v$LAT_V...---"
        cd ${DATA_DIR}
        if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz "https://github.com/Sonarr/Sonarr/releases/download/v${LAT_V}/Sonarr.main.${LAT_V}.linux-x64.tar.gz" ; then
            echo "---Successfully downloaded Sonarr v$LAT_V---"
        else
            echo "---Something went wrong, can't download Sonarr v$LAT_V, putting container into sleep mode!---"
            sleep infinity
        fi
        mkdir ${DATA_DIR}/Sonarr
        tar -C ${DATA_DIR}/Sonarr --strip-components=1 -xf ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz
        if [ ! -f ${DATA_DIR}/Sonarr/release_info ]; then
            echo "ReleaseVersion=$LAT_V" > ${DATA_DIR}/Sonarr/release_info
        fi
        rm ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz
    elif [ "$CUR_V" != "$LAT_V" ]; then
        echo "---Version missmatch, installed v$CUR_V, downloading and installing latest v$LAT_V...---"
        cd ${DATA_DIR}
        if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz "https://github.com/Sonarr/Sonarr/releases/download/v${LAT_V}/Sonarr.main.${LAT_V}.linux-x64.tar.gz" ; then
            echo "---Successfully downloaded Sonarr v$LAT_V---"
        else
            rm ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz
            echo "---Something went wrong, can't download Sonarr v$LAT_V, falling back to v$CUR_V!---"
            EXIT_STATUS=1
        fi
        if [ "${EXIT_STATUS}" != "1" ]; then
            rm -R ${DATA_DIR}/Sonarr
            mkdir ${DATA_DIR}/Sonarr
            tar -C ${DATA_DIR}/Sonarr --strip-components=1 -xf ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz
            if [ ! -f ${DATA_DIR}/Sonarr/release_info ]; then
                echo "ReleaseVersion=$LAT_V" > ${DATA_DIR}/Sonarr/release_info
            elif [ "$(cat ${DATA_DIR}/Sonarr/release_info | grep "ReleaseVersion" | cut -d '=' -f2)" != "${LAT_V}" ]; then
                sed -i "/^ReleaseVersion=/c\ReleaseVersion=$LAT_V" ${DATA_DIR}/Sonarr/release_info
            fi
            rm ${DATA_DIR}/Sonarr-v$LAT_V.tar.gz
        fi
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
if [ -f ${DATA_DIR}/Sonarr/Sonarr.exe ]; then
  /usr/bin/mono ${MONO_START_PARAMS} ${DATA_DIR}/Sonarr/Sonarr.exe -nobrowser -data=${DATA_DIR} ${START_PARAMS}
elif [ -f ${DATA_DIR}/Sonarr/Sonarr ]; then
  ${DATA_DIR}/Sonarr/Sonarr -nobrowser -data=${DATA_DIR} ${START_PARAMS}
else
  echo "---Something went wrong, can't find executable, putting container into sleep mode!"
  sleep infinity
fi