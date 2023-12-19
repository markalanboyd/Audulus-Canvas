function isValidHexCode(hex)
    hex = hex:gsub("#", "")
    local invalidChars = string.match(hex, "[^0-9a-fA-F]+")
    local hasValidChars = invalidChars == nil
    local isValidLen = #hex == 3 or #hex == 4 or #hex == 6 or #hex == 8
    return hasValidChars and isValidLen
end
