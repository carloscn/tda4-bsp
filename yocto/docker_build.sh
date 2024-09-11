# !/bin/bash

./oe-layertool-setup.sh -f configs/processor-sdk-analytics/processor-sdk-analytics-09.02.00-config.txt
cd build
. conf/setenv
echo 'ARAGO_BRAND = "adas"' >> conf/local.conf
MACHINE="j721e-evm" bitbake -k tisdk-adas-image
