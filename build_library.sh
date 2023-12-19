#!/bin/zsh
# Concatenate all Lua files in the current directory into one

find . -name '*.lua' -not -name 'library.lua' -exec sh -c 'cat {} && echo && echo' \; > library.lua