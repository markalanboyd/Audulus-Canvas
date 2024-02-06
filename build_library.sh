#!/bin/zsh

library_file="library.lua"
dev_library_file="library-dev.lua"
build_order_file="build_order.txt"

# Delete the existing library files if they exist
[ -f "$library_file" ] && rm "$library_file"
[ -f "$dev_library_file" ] && rm "$dev_library_file"

# Add the top content to library.lua
echo "-- SCROLL TO BOTTOM ----------------------------------------------------\n" > "$library_file"

# Concatenate the Lua files in the order specified in build_order.txt
while IFS= read -r file; do
    # Check if the file exists and is not one of the special cases
    if [ -f "$file" ] && [ "$file" != "$library_file" ] && [ "$file" != "builtins.lua" ] && [ "$file" != "temp_library.lua" ]; then
        cat "$file" >> "$library_file"
        echo "\n" >> "$library_file" # Add a newline for separation
    fi
done < "$build_order_file"

# Find all Lua files that are not in build_order.txt and not excluded
find . -type f -name '*.lua' ! -name "$library_file" ! -name 'builtins.lua' ! -name 'temp_library.lua' ! -name "$(basename "$0")" | while read file; do
    if ! grep -Fxq "$file" "$build_order_file"; then
        cat "$file" >> "$library_file"
        echo "\n" >> "$library_file"
    fi
done

# Append the provided block of content to the end of library.lua
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

root = Layer.new({name = "ROOT"})
bg = Overlay.new(origin, {name = "Background", color=Color.new(theme.modules)})

-- CODE ----------------------------------------------------------------





-- PRINT CONSOLE -------------------------------------------------------


layer_tree = {
	{name = "BACKGROUND",
	 	z_index = -math.huge,
		contents = {bg}},
	{name = "FOREGROUND",
	 	z_index = math.huge,
		contents = {origin}},
	{name = "LAYER1",
		z_index = 0,
		contents = {},
		sublayers = {
			{name = "NESTED LAYER",
				z_index = 0,
				contents = {},
				sublayers = {} }
		}},
	{name = "LAYER2",
		z_index = 0,
		contents = {},
		sublayers = {} },
		
}

root(layer_tree):draw()
origin:reset()
print(root)
print_all()
EOF

# Create development version of the library file (library-dev.lua)
awk '/-- CODE ----------------------------------------------------------------/{print; exit} {print}' "$library_file" > "$dev_library_file"
