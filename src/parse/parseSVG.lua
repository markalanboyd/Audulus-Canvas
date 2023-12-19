function parseSVG(s)
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

    local function parseRect(sub)
        local x1 = parseVal(sub, "x", "number")
        local y1 = parseVal(sub, "y", "number")
        local width = parseVal(sub, "width", "number")
        local height = parseVal(sub, "height", "number")
        local x2 = x1 + width
        local y2 = y1 + height
        local coordA = { x1, y1 }
        local coordB = { x2, y2 }
        local fill = parseVal(sub, "fill", "string")
        if fill ~= nil then fill = color_paint(colors[fill]) end
        local stroke = parseVal(sub, "stroke", "string")
        if stroke ~= nil then stroke = color_paint(colors[stroke]) end
        local strokeWidth = parseVal(sub, "stroke-width", "number")

        if fill ~= "none" then
            fill_rect(coordA, coordB, 0, fill)
        end

        if stroke ~= "none" then
            stroke_rect(coordA, coordB, -strokeWidth / 2, strokeWidth, stroke)
        end
    end

    for rect in s:gmatch("<rect%s+([^>]+)/>") do
        parseRect(rect)
    end
end
