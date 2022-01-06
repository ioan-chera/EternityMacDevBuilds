#!/bin/bash

path=$(mktemp -d eternity-temp-XXXXXXXX)
touch githash.txt
readhash="$(cat githash.txt)"

pushd "$path"

git clone https://github.com/team-eternity/eternity.git

pushd eternity

githash=$(git rev-parse --short=8 HEAD)
if [ "$githash" = "$readhash" ]; then
    echo "Hash $githash already done"
    popd
    popd
    rm -rf "$path"
    exit 0
fi
echo "$githash" > ../../githash.txt
git submodule update --init --recursive
mkdir build

pushd build

cmake .. -G Xcode
cmake --build . --config Release

pushd macosx/launcher/Release

nowtime=$(date -u +"%Y%m%d-%H%M%S")

arname="EternityEngine-$nowtime-$githash.tar.gz"
tar -czvf "$arname" "Eternity Engine.app"
mv "$arname" ~/Dropbox/Doom/eternity-release/devbuild

popd
popd
popd
popd

rm -rf "$path"