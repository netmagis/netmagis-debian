#!/bin/sh

#
# Manage and run Docker image
#
# - build: build the Docker image and store image id SOMEWHERE
# - run: run the Docker image, which in turn will run the ./run script
#	note: the netmagis-<version>.tar.gz must already be generated
# - clean: remove the Docker image
#

#
# Memo for essential Docker commands
#   docker build <dir>
#   docker container ls -a
#   docker container stop <cont-id>
#   docker image ls
#   docker image rm <img-id>
#

TAG=nmdeb

#################XXXX FIXME paramétrer les répertoires ET ajouter /nmvar
NMSRC=/home/pda/nm23
NMDEB=/home/pda/netmagis-debian
NMVAR=/var/tmp

case x"$1" in
    xbuild)
	# Use the file "Dockerfile" in directory "."
	# and build an image labelled with a tag so that
	# we can find it easily
	docker build --tag=$TAG .
	;;
    xrun)
	docker run \
		--rm=true \
		--mount type=bind,source=$NMSRC,target=/nmsrc \
		--mount type=bind,source=$NMDEB,target=/nmdeb \
		--mount type=bind,source=$NMVAR,target=/nmvar \
		$TAG
	if [ $? != 0 ]
	then echo "Abort" >&2 ; exit 1
	fi
	####################XXXX FIXME récupérer les paquets générés
	;;
    xclean)
	docker image rm $TAG
	;;
    *)
esac
