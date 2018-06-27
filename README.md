Tools for Netmagis Debian package creation
==========================================

Principles and prerequisites
----------------------------

### Prerequisites

Tools in this directory make the following assumptions:

  - Docker is installed
  - you must belong to the `docker` Unix group
  - Netmagis source directory must be available (e.g. in `../netmagis/`)
  - the Netmagis source directory must contains the netmagis-_version_.tar.gz
    generated by `make distrib` at Netmagis top level (e.g. in `../netmagis/`)
  - you don't need to be `root` to use these tools

### Directories

This repository contains the following directories:

  - `build`: Docker environment to build Debian packages
  - `test`: Docker environment to test generated packages
  - `debian`: set of script/configuration files to create Debian packages

### The main command

The `mkpkg` command is the main tool, which uses 2 Docker images.


Step by step instructions
-------------------------

How to release Debian packages for a given Netmagis version?

1. create a PGP key for testing (or distribution) purpose:

    ```
    gpg --quick-gen-key --batch --passphrase "" "Joe USER <joe@example.com>"
    ```

    Check this key:

    ```
    gpg --list-keys
    ```

2. check that the Netmagis source directory is up-to-date and version
    is expected:

    ```
    cd ../netmagis
    git pull --all
    git checkout ....        # use the appropriate branch (X.Y) or tag (vX.Y.Z)
    make version
    ```

3. provide the hooks for X.Y.Z Netmagis version: provide a shell script
    named `netmagis-debian/debian/gendeb-X.Y.Z`. See next section for
    details.

4. build packages and test a pseudo-installation with PGP public key

    ```
    cd ../netmagis-debian
    ./mkpkg ../netmagis . joe@example.com image run clean
    ```

    Built packages and repository are located in `tests` subdirectory.

5. transfer the repository to the distribution server

    ```
    cd ../netmagis-debian/tmp
    tar cf - repo | ssh netmagis.org tar xvf - -C FIXME
    ```

6. remove temporary directory

    ```
    cd ../../netmagis-debian
    rm -r tmp
    ```

Script modifications for a new Netmagis release
-----------------------------------------------

The debian machinery is located in the `netmagis-debian/debian/gendeb`
bash script. If the Netmagis version is X.Y.Z, `gendeb` starts by
sourcing the `gendeb-X.Y.Z` file. This file must provide (for the 2.3.*
releases) some shell variables and functions:
  
| Object | Type | Description |
|--------|------|-------------|
| `TCLCONF` | variable | location of `tclConfig.sh` file |
| `PKGLIST` | variable | list of Debian packages to build |
| `PLIST[p]` | array | each element of this array must contain the list of files provided by the package *p* |
| `hook_patch` | function | called after `unpack` and `dh_make`, to customize files from source distribution |
