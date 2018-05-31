#!/bin/sh

#
# Command to run inside a Docker image
# This command must be refered as the "CMD" in the Dockerfile
# so that it is run with "docker run"
#

set -e			# exit on first error
set -u			# exit on uninitialized variable

SRCDIR=/nmsrc		# netmagis source directory (from netmagis repo)
DEBDIR=/nmdeb		# debian package directory (from netmagis-debian repo)
DSTDIR=/nmvar		# destination for Debian packages

VERSION=$(cd "$SRCDIR" ; make version)

TGZ="$SRCDIR/netmagis-$VERSION.tar.gz"
if [ ! -f "$TGZ" ]
then
    echo "The file '$TGZ' does not exist in netmagis source directory" >&2
    exit 1
fi

cd $DEBDIR/debian
cp $TGZ .

#
# Generate Debian packages
#

./gendeb "$VERSION"

#
# Copy generated packages
#

cp *.deb $DSTDIR
