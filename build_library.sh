#!/bin/zsh
# Concatenate all Lua files in the current directory into one except for builtins.

temp_file="temp_library.lua"

# Add the top content
echo "-- SCROLL TO BOTTOM ----------------------------------------------------\n" > "$temp_file"

# Concatenate the Lua files
find . -name '*.lua' -not -name 'library.lua' -not -name 'builtins.lua' -not -name 'temp_library.lua' -exec sh -c 'cat {} && echo && echo' \; >> "$temp_file"

# Add the bottom content
echo -e "
-- AUDULUS-CANVAS LIBRARY ----------------------------------------------
-- Version: 0.0.2-alpha
-- Updated: 2023.12.26
-- URL: https://github.com/markalanboyd/Audulus-Canvas

----- Instructions -----
-- 1. Create 'Time' input (case-sensitive)
-- 2. Attach Timer node to the 'Time' input
-- 3. Select 'Save Data' at the bottom of the inspector panel
-- 4. Set a custom W(idth) and H(eight) in the inspector panel
-- 5. Write your code in the CODE block below

o = Origin.new(\"c\", {show = true, type = \"cross\", width = 4, color = theme.text})

-- CODE ----------------------------------------------------------------






-- PRINT CONSOLE -------------------------------------------------------

o:reset()
print_all()
" >> "$temp_file"

# Rename the temporary file to library.lua
mv "$temp_file" "library.lua"
