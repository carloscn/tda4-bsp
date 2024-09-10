# !/bin/bash


function utils_check_ret()
{
	if [ $1 -eq 0 ]; then
        echo "[INFO] $2 done!"
    else
        echo "[ERR] Failed on $2!"
        exit -1
    fi
}

function utils_wget_download()
{
    URL=$1
    FILE=$(basename "$URL")

    if [ -f "$FILE" ]; then
        echo "$FILE already exists. Checking if it is complete..."

        if md5sum -c md5-hash.txt> /dev/null; then
            echo "$FILE is complete. Skipping download."
            return 0
        else
            echo "$FILE is incomplete. Deleting and re-downloading."
            rm "$FILE"
        fi
    fi

    echo "Downloading $FILE..."
    wget "$URL" -O "$FILE" --no-check-certificate

    if md5sum -c md5-hash.txt> /dev/null; then
        echo "$FILE downloaded and verified successfully."
    else
        echo "Failed to download a complete $FILE. Please try again."
        rm "$FILE"
        return 1
    fi
}

git clone https://git.ti.com/git/arago-project/oe-layersetup.git yocto-build

chmod a+rw -R yocto-build

pushd yocto-build
./oe-layertool-setup.sh -f configs/processor-sdk-analytics/processor-sdk-analytics-09.02.00-config.txt || utils_check_ret  $? "config yocto repo"
popd