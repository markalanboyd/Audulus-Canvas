--- Functions to convert various color types into one another\
-- Dependencies: `color.validate`
-- @submodule color

--- Converts a hex code string to a color table.
-- Takes a string representation of a CSS hex value and converts it into
-- an `{r, g, b, a}` color table. The function ignores the leading #
-- symbol if present and will parse a 3 (rgb), 4 (rgba), 6 (rrggbb), or
-- 8 (rrggbbaa) character-long hex value into a normalized (0 to 1) rgba
-- color table. Sets a to 1 if not present in the hex code.
-- @tparam string s A hex code formatted as #rgb, #rgba, #rrggbb, or
-- #rrggbbaa with or without the leading # symbol
-- @treturn table A color table in the format {r, g, b, a}
-- @raise ValueError if hex code is malformed
-- @usage
-- white = hex_code_to_color("#FFF")
-- print(white) -- {1, 1, 1, 1}
--
-- black = hex_code_to_color("000F")
-- print(black) -- {0, 0, 0, 1}
--
-- orange = hex_code_to_color("#FFA500")
-- print(orange) -- {0.9450..., 0.7686..., 0.0588..., 1}
--
-- blue_transparent = hex_code_to_color("0000FF33")
-- print(blue_transparent) -- {0, 0, 1, 0.2}
--
-- malformed_hex = hex_code_to_color("#G09F3")
-- -- ValueError: Not a valid hex code.
function hex_code_to_color(s)
    if not is_valid_hex_code(s) then
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
