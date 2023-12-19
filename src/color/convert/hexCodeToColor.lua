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
function hexCodeStrToColor(s)
    if not isValidHexCode(s) then
        error("ValueError: Not a valid hex code.")
    end

    s = tostring(s):gsub("#", "")
    local color = { r = "", g = "", b = "", a = "" }
    if #s == 3 or #s == 4 then
        color["r"] = s:sub(1, 1):rep(2)
        color["g"] = s:sub(2, 2):rep(2)
        color["b"] = s:sub(3, 3):rep(2)
        color["a"] = (#s == 4) and s:sub(4, 4):rep(2) or "FF"
    elseif #s == 6 or #s == 8 then
        color["r"] = s:sub(1, 2)
        color["g"] = s:sub(3, 4)
        color["b"] = s:sub(5, 6)
        color["a"] = (#s == 8) and s:sub(7, 8) or "FF"
    end

    for k, v in pairs(color) do
        color[k] = tonumber(v, 16) / 255
    end

    return color
end
