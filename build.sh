#!/usr/bin/env bash
target=${PWD##*/}
cd src
zip -r ../$target.love *
cd ..
echo "love-js -c -m $1 -t \"$target\" $target.love out"
love-js -c -m $1 -t "$target" $target.love docs
cp index.html docs/index.html
cp index.css docs/index.css
rm -rf docs/theme