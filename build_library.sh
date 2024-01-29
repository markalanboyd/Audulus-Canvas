#!/bin/zsh
# Concatenate all Lua files in the current directory into one except for builtins.

library_file="library.lua"
dev_library_file="library-dev.lua"

# Delete the existing library files if they exist
[ -f "$library_file" ] && rm "$library_file"
[ -f "$dev_library_file" ] && rm "$dev_library_file"

# Add the top content to library.lua
echo "-- SCROLL TO BOTTOM ----------------------------------------------------\n" > "$library_file"

# Concatenate the Lua files into library.lua using find
find . -name '*.lua' -not -name "$library_file" -not -name 'builtins.lua' -not -name 'temp_library.lua' -exec cat {} + >> "$library_file"
echo "\n" >> "$library_file" # Add a newline at the end

# Add the bottom content to library.lua
cat << EOF >> "$library_file"
-- AUDULUS-CANVAS LIBRARY ----------------------------------------------
-- Version: 0.0.3-alpha
-- Updated: 2024.01.29
-- URL: https://github.com/markalanboyd/Audulus-Canvas

----- Instructions -----
-- 1. Create 'Time' input (case-sensitive)
-- 2. Attach Timer node to the 'Time' input
-- 3. Select 'Save Data' at the bottom of the inspector panel
-- 4. Set a custom W(idth) and H(eight) in the inspector panel
-- 5. Write your code in the CODE block below

origin = Origin.new({
	direction = "c",
	type = "crosshair",
	width = 4,
	color = theme.text
})

origin:draw()


-- CODE ----------------------------------------------------------------

-- PRINT CONSOLE -------------------------------------------------------

origin:reset()
print_all()
EOF

# Create development version of the library file (library-dev.lua)
awk '/-- CODE ----------------------------------------------------------------/{print; exit} {print}' "$library_file" > "$dev_library_file"
