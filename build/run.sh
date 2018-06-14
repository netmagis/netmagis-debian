#!/bin/sh

#
# Command to run inside a Docker image
# This command must be refered as the "CMD" in the Dockerfile
# so that it is run with "docker run"
# This command runs as root, but we expect to DESTUID/DESTGID environment
# variables to contain the numeric uid/gid of the resulting packages
# and the KEYID environment variable to contain the GPG key id to sign with.
#

set -e			# exit on first error
set -u			# exit on uninitialized variable

SRCDIR=/nmsrc		# netmagis source directory (from netmagis repo)
DEBDIR=/nmdeb		# debian package directory (from netmagis-debian repo)

DESTDIR=$DEBDIR/tmp
BUILDDIR=/var/tmp/debian

DUID=${DESTUID:-0}	# give default values just in case
DGID=${DESTGID:-0}

#
# Get Netmagis version from source directory and check that the
# distribution tgz file is present
#

VERSION=$(cd "$SRCDIR" ; make version)

TGZ="$SRCDIR/netmagis-$VERSION.tar.gz"
if [ ! -f "$TGZ" ]
then
    echo "The file '$TGZ' does not exist in netmagis source directory" >&2
    exit 1
fi

#
# Import GPG public/private keys
#

gpg --import $DESTDIR/pub.key
gpg --import $DESTDIR/priv.key

#
# Remove any other file or directory in $DESTDIR
#

for f in $(ls "$DESTDIR" | grep -v '\.key$')
do
    rm -rf "$DESTDIR/$f"
done

#
# Copy $DEBDIR/debian/ into a temporary directory in order to
# not leave unwanted files.
#

rm -rf $BUILDDIR
mkdir $BUILDDIR
tar cf - -C $DEBDIR/debian . | tar xvf - -C $BUILDDIR

cd $BUILDDIR
cp $TGZ .

#
# Generate Debian packages
#

./gendeb "$VERSION"

#
# Get result in $DESTDIR
#

mv $BUILDDIR/repo  $DESTDIR
chown -R $DESTUID:$DESTGID $DESTDIR/repo
