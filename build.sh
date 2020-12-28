#!/usr/bin/env bash
target=${PWD##*/}
cd src
zip -r ../$target.love *
cd ..
echo "love-js -c -m $1 -t \"$target\" $target.love out"
love-js -c -m $1 -t "$target" $target.love docs
rm docs/theme/*
cp index.html docs/index.html
cp index.css docs/theme/index.css