#
# Docker file to create an image in order to build Netmagis Debian packages.
#

FROM debian:stretch
RUN apt update
RUN apt install -y quilt devscripts dh-make git wget tcl8.6-dev tcl

#
# This command assumes that the following directories are bind-mounted
# when this image is run:
#	/nmsrc:		netmagis source directory (from netmagis repo)
#	/nmdeb:		debian package directory (from netmagis-debian repo)
#	/nmvar:		output directory for packages
#

CMD sh /nmdeb/docker/run.sh
