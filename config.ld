-- config.ld
project = "Audulus-Canvas"
title = "Audulus-Canvas Docs"
description = "Audulus-Canvas Libraries v0.0.1-alpha"
all = true
file = {
    "src/color/color.lua",
    "src/color/color.convert.lua",
    "src/color/color.tables.lua",
    "src/color/color.validate.lua",
    "src/debug/debug.lua",
    "src/builtins/builtins.lua",
    "src/draw/draw.lua",
    "src/draw/draw.button.lua"
}
style = "!fixed"
sort_modules=true
kind_names={module='Libraries'}
dir = "docs"