#!/bin/bash
BASEDIR=$(dirname "$0")

URL=https://github.com/google/or-tools/releases/download/v7.1/or-tools_debian-9_v7.1.6720.tar.gz
OS=linux_64
VERSION=7.1

FILENAME=${URL##*/}
[[ $OS = linux_64 ]] && EXT=so || EXT=dylib
BUILDDIR=$BASEDIR/build

echo "Download and extract file"

mkdir -p $BUILDDIR/extract
wget $URL
tar xzfv $FILENAME -C $BUILDDIR/extract/
rm -f $FILENAME

echo "Generating JAR packages"

mkdir -p "$BUILDDIR/natives/$OS"
find $BUILDDIR/extract/*/lib -name "lib*.$EXT*" | xargs -I {} cp -f {} "$BUILDDIR/natives/$OS"
cd $BUILDDIR
jar cf com.google.ortools.native-$OS.jar natives
cp extract/*/lib/com.google.ortools.jar .
cd ..

echo "Installing Maven Artifacts"

mvn install:install-file -Dfile=$BUILDDIR/com.google.ortools.jar -DgroupId=com.google.ortools -DartifactId=ortools-core -Dversion=$VERSION -Dpackaging=jar -DgeneratePom=true

mvn install:install-file -Dfile=$BUILDDIR/com.google.ortools.native-$OS.jar -DgroupId=com.google.ortools -DartifactId=ortools-native-$OS -Dversion=$VERSION -Dpackaging=jar -DgeneratePom=true

