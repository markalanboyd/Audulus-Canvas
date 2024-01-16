-- TODO Combine this with Color class

ColorUtils = {}

ColorUtils.theme_yellow = { 0.83, 1, 0, 1 }

function ColorUtils.is_valid_hex_code(s)
    s = s:gsub("#", "")
    local invalidChars = string.match(s, "[^0-9a-fA-F]+")
    local hasValidChars = invalidChars == nil
    local isValidLen = #s == 3 or #s == 4 or #s == 6 or #s == 8
    return hasValidChars and isValidLen
end

function ColorUtils.hex_code_to_color(s)
    if not ColorUtils.is_valid_hex_code(s) then
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
