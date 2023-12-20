--- Converts a hex code string to a color table.
-- Takes a string representation of a CSS hex value and converts it into
-- an {r, g, b, a} color table. The function ignores the leading #
-- symbol if present and will parse an 3 (rgb), 4 (rgba), 6 (rrggbb), or
-- 8 (rrggbbaa) character-long hex value into a normalized (0 to 1) rgba
-- color table. Sets a to 1 if not present in the hex code.

-- @tparam string s A hex code formatted as #rgb, #rgba, #rrggbb, or
-- #rrggbbaa with or without the leading # symbol
-- @treturn table color A color table in the format {r, g, b, a}
-- @error ValueError if hex code is malformed
-- @see isValidHexCode Depends on this validator
-- @see hexToColor If you want to convert a hexidecimal number to
-- a color table.
local function hexCodeStrToColor(s)
    if not isValidHexCode(s) then
        error("ValueError: Not a valid hex code.")
    end

    s = tostring(s):gsub("#", "")
    local color = {}
    if #s == 3 or #s == 4 then
        table.insert(color, tonumber(s:sub(1, 1):rep(2), 16) / 255)
        table.insert(color, tonumber(s:sub(2, 2):rep(2), 16) / 255)
        table.insert(color, tonumber(s:sub(3, 3):rep(2), 16) / 255)
        table.insert(color, (#s == 4) and tonumber(s:sub(4, 4):rep(2), 16) / 255 or 1)
    elseif #s == 6 or #s == 8 then
        table.insert(color, tonumber(s:sub(1, 2), 16) / 255)
        table.insert(color, tonumber(s:sub(3, 4), 16) / 255)
        table.insert(color, tonumber(s:sub(5, 6), 16) / 255)
        table.insert(color, (#s == 8) and tonumber(s:sub(7, 8), 16) / 255 or 1)
    end

    return color
end
