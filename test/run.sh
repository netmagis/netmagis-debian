#!/bin/sh

#
# Command to run inside a Docker image
# This command must be refered as the "CMD" in the Dockerfile
# so that it is run with "docker run"
#

set -e			# exit on first error
set -u			# exit on uninitialized variable

DEBDIR=/nmdeb		# debian package directory (from netmagis-debian repo)

DESTDIR=$DEBDIR/tmp	# where "build" image left the "repo" dir

#
# Use GPG public key
#

apt-key add $DESTDIR/pub.key

#
# Particular case for rancid3, which insist to interactively
# ask the user for manual configuration.
#

echo "rancid rancid/go_on boolean true" | debconf-set-selections

#
# Add generated repo (in a local directory)
#

echo "deb file:$DESTDIR/repo stable main" > /etc/apt/sources.list.d/nm.list
apt update

#
# Install all Netmagis packages
#

apt install -y "netmagis-*"
