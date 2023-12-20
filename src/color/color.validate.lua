--- Functions to validate the form of color strings and numbers
-- @submodule color

--- Checks if a CSS hex code is formatted properly.
-- Uses character and length matching to assert that the hex code is
-- formatted correctly. Works for rgb, rgba, rrggbb, and rrggbbaa hex
-- codes. Outputs true if correct and false if malformed.
-- @tparam string s A hex code formatted as #rgb, #rgba, #rrggbb, or
-- #rrggbbaa with or without the leading # symbol
-- @treturn boolean true if correctly formatted, false if not.
-- @usage
-- print(is_valid_hex_code(FFF)) -- true
--
-- print(is_valid_hex_code(#J37N)) -- false
function is_valid_hex_code(s)
    s = s:gsub("#", "")
    local invalidChars = string.match(s, "[^0-9a-fA-F]+")
    local hasValidChars = invalidChars == nil
    local isValidLen = #s == 3 or #s == 4 or #s == 6 or #s == 8
    return hasValidChars and isValidLen
end
