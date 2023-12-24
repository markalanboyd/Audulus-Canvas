#!/bin/zsh
# Concatenate all Lua files in the current directory into one except for builtins.

temp_file="temp_library.lua"

# Add the top content
echo "-- SCROLL TO BOTTOM ----------------------------------------------------\n" > "$temp_file"

# Concatenate the Lua files
find . -name '*.lua' -not -name 'library.lua' -not -name 'builtins.lua' -not -name 'temp_library.lua' -exec sh -c 'cat {} && echo && echo' \; >> "$temp_file"

# Add the bottom content
echo -e "-- AUDULUS-CANVAS LIBRARY ----------------------------------------------\n\n----- Instructions -----\n-- 1. Create 'Time' input (case-sensitive)\n-- 2. Attach Timer node to the 'Time' input\n-- 3. Select 'Save Data' at the bottom of the inspector panel\n-- 4. Set a custom W(idth) and H(eight) in the inspector panel\n-- 5. Write your code below this line\n\n-- CODE ----------------------------------------------------------------\n\n\n\n\n\n-- PRINT CONSOLE -------------------------------------------------------\n\nprint_all()" >> "$temp_file"

# Rename the temporary file to library.lua
mv "$temp_file" "library.lua"
