#
# Docker file to create an image in order to test generated
# Netmagis Debian packages.
#

FROM debian:stretch
RUN apt update
RUN apt upgrade -y
RUN apt install -y gnupg

#
# This command assumes that the following directories are bind-mounted
# when this image is run:
#	/nmdeb:		debian package directory (from netmagis-debian repo)
#

CMD sh /nmdeb/test/run.sh
