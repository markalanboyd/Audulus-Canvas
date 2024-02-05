-- TODO Create method that will force numbers as strings to keep zeros to x place

Utils = {}

function Utils.has_non_integer_keys(t)
    for k, _ in pairs(t) do
        if type(k) ~= "number" or k ~= math.floor(k) or k < 1 then
            return true
        end
    end
    return false
end

-- TODO Refactor this to be more generic

function Utils.deep_copy_color(color_table)
    local copy = {}
    for i = 1, #color_table do
        copy[i] = color_table[i]
    end
    return copy
end

function Utils.table_to_string(t, truncate, places)
    truncate = truncate or false
    places = places or 0

    local parts = {}
    local function process_value(v)
        if truncate and type(v) == "number" then
            return Math.truncate(v, places)
        elseif type(v) == "table" then
            return Utils.table_to_string(v, truncate, places)
        else
            return tostring(v)
        end
    end

    if Utils.has_non_integer_keys(t) then
        for k, v in pairs(t) do
            v = process_value(v)
            parts[#parts + 1] = tostring(k) .. " = " .. v
        end
    else
        for _, v in ipairs(t) do
            v = process_value(v)
            parts[#parts + 1] = v
        end
    end
    return "{ " .. table.concat(parts, ", ") .. " }"
end

function Utils.get_peak_memory(interval)
    if _PeakMemory == nil then
        _PeakMemory = math.floor(collectgarbage("count"))
    end

    if Time == nil then Time = 0 end
    local current_memory_usage = math.floor(collectgarbage("count"))
    local truncated_time = math.floor(Time * 100) / 100

    if _PeakMemory < current_memory_usage then
        _PeakMemory = current_memory_usage
    end

    if truncated_time % interval == 0 then _PeakMemory = 0 end

    return _PeakMemory
end

function Utils.assign_options(instance, options)
    for key, value in pairs(options) do
        instance[key] = value
    end
end

function Utils.resolve_property(instance, key)
    local class = getmetatable(instance)
    local value = rawget(instance, key)
    if value ~= nil then return value end
    if class.styles then
        local style = rawget(instance, "style") or "normal"
        local style_val = class.styles[style][key]
        if style_val ~= nil then return style_val end
    end
    if class.methods then
        local method = rawget(instance, "method")
        if method ~= nil and class.methods[method] then
            local method_val = class.methods[method][key]
            if method_val ~= nil then return method_val end
        end
    end
    if class.attrs then
        local attr = class.attrs[key]
        if attr ~= nil then return attr end
    end
    return class[key]
end

function Utils.assign_ids(instance)
    instance.element_id = Element.id
    Element.id = Element.id + 1
    instance.class_id = instance.id
    getmetatable(instance).id = instance.id + 1
end

function Utils.has_substring(str, substr)
    return string.find(str, substr) ~= nil
end

function Utils.get_names(t)
    local names = {}
    for _, obj in ipairs(t) do
        table.insert(names, obj.name)
    end
    return "{ " .. table.concat(names, ", ") .. " }"
end
