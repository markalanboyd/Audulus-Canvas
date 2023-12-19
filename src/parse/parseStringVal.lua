function parseStringVal(s, key, valType)
    local function escapeDashes(s)
        return (s:gsub("%-", "%%-"))
    end

    local function tobool(s)
        if s == "true" then
            return true
        elseif s == "false" then
            return false
        else
            error("TypeError: Cannot convert " .. s .. " to boolean.")
        end
    end

    local pattern = escapeDashes(key) .. '="([^"]+)"'
    local value = string.match(s, pattern)

    if valType == "number" then
        return tonumber(value)
    elseif valType == "string" then
        return value
    elseif valType == "bool" then
        return tobool(value)
    else
        error("TypeError: Invalid type. Options are 'number', 'string', or 'bool'.")
    end
end
