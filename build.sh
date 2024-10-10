#!/bin/bash

echo "Message from build.sh"

mkdir -p artifacts
cd artifacts

echo "AAAAAAAAAAAA" > my_artifact.txt

TIME_STAMP=$(date +'%Y%m%d_%H%M%S')
zip my_artifact_${TIME_STAMP}.zip  my_artifact.txt

rm -f my_artifact.txt

cd ..
echo "Directory contents post build phase: "
ls -R .
