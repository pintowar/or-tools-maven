#!/bin/bash
BASEDIR=$(cd `dirname ${0}` && pwd)
BUILDDIR=$BASEDIR/build

URL=https://github.com/google/or-tools/releases/download/v7.1/or-tools_debian-9_v7.1.6720.tar.gz
OS=linux_64
VERSION=7.1

# BUILDDIR URL
download_extract () {
    echo "Download and extract file"
    AUX=$2
    FILENAME=${AUX##*/} # URL

    wget -P $1 $2

    mkdir -p $1/extract #BUILDDIR
    tar xzfv $1/$FILENAME -C $1/extract/
    rm -f $1/$FILENAME
}

# BUILDDIR OS
generate_jar () {
    echo "Generating JAR packages"
    [[ $2 = linux_64 ]] && EXT=so || EXT=dylib

    mkdir -p "$1/natives/$2"
    find $1/extract/*/lib -name "lib*.$EXT*" | xargs -I {} cp -f {} "$1/natives/$2"
    cd $1
    jar cf com.google.ortools.native-$2.jar natives
    cp extract/*/lib/com.google.ortools.jar .
    cd ..
}

# BUILDDIR OS VERSION
maven_install () {
    echo "Installing Maven Artifacts"

    mvn install:install-file -Dfile=$1/com.google.ortools.jar -DgroupId=com.google.ortools -DartifactId=ortools-core -Dversion=$3 -Dpackaging=jar -DgeneratePom=true
    mvn install:install-file -Dfile=$1/com.google.ortools.native-$2.jar -DgroupId=com.google.ortools -DartifactId=ortools-native -Dversion=$3-$2 -Dpackaging=jar -DgeneratePom=true
}

# download_extract $BUILDDIR $URL
# generate_jar $BUILDDIR $OS
maven_install $BUILDDIR $OS $VERSION