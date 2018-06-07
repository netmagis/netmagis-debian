#!/bin/sh

#
# Command to run inside a Docker image
# This command must be refered as the "CMD" in the Dockerfile
# so that it is run with "docker run"
#

set -e			# exit on first error
set -u			# exit on uninitialized variable

DEBDIR=/nmdeb		# debian package directory (from netmagis-debian repo)

#
# Particular case for rancid3, which insist to interactively
# ask the user for manual configuration.
#

echo "rancid rancid/go_on boolean true" | debconf-set-selections

#
# Install all packages, except netmagis-P-dbgsym_* packages.
# Side effect: we install packages in lexicographic order, so
# netmagis-common.... is installed before other packages.
#

for p in $(ls $DEBDIR/*.deb | grep -v dbgsym_)
do
    gdebi -n $p
done

#
# Packages netmagis-P-*-dbgsym_* depend upon each corresponding
# netmagis-P regular package. Install them after the regular packages.
#

for p in $(ls $DEBDIR/*.deb | grep dbgsym_)
do
    gdebi -n $p
done
