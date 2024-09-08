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

utils_wget_download \
    https://dr-download.ti.com/software-development/software-development-kit-sdk/MD-ymP4CVsxJr/08.06.01.02/ti-processor-sdk-linux-rt-j7-evm-08_06_01_02-Linux-x86-Install.bin \
    || utils_check_ret $? "wget the ti-processor-sdk-linux-rt-j7-evm-08_06_01_02-Linux-x86-Install.bin"

chmod +x ti-processor-sdk-linux-rt-j7-evm-08_06_01_02-Linux-x86-Install.bin

./ti-processor-sdk-linux-rt-j7-evm-08_06_01_02-Linux-x86-Install.bin --prefix . --mode unattended