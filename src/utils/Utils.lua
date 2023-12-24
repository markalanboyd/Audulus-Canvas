Utils = {}

function Utils.process_args(class_meta, ...)
    local args = { ... }
    local processed_args

    if type(args[1]) == "table" then
        if getmetatable(args[1]) == class_meta then
            processed_args = args
        else
            processed_args = args[1]
        end
    else
        processed_args = args
    end

    return processed_args
end

function Utils.has_non_integer_keys(t)
    for k, _ in pairs(t) do
        if type(k) ~= "number" or k ~= math.floor(k) or k < 1 then
            return true
        end
    end
    return false
end

function Utils.table_to_string(t)
    local parts = {}
    if Utils.has_non_integer_keys(t) then
        for k, v in pairs(t) do
            parts[#parts + 1] = tostring(k) .. " = " .. tostring(v)
        end
    else
        for _, v in ipairs(t) do
            parts[#parts + 1] = tostring(v)
        end
    end
    return "{ " .. table.concat(parts, ", ") .. " }"
end
