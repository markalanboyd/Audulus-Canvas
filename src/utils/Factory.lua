Factory = {}
Factory.__index = Factory
F = Factory

function Factory.new(class, items, options)
    local result = {}
    for i = 1, #items do
        if type(items[i]) == "table" and not getmetatable(items[i]) then
            if options then
                local args_with_options = { unpack(items[i]) }
                table.insert(args_with_options, options)
                result[i] = class.new(unpack(args_with_options))
            else
                result[i] = class.new(unpack(items[i]))
            end
        else
            result[i] = class.new(items[i], options)
        end
    end
    return result
end

function Factory.Iter(instances, method, ...)
    local args = { ... } or nil
    for i = 1, #instances do
        if args then
            if type(args) == "table" and not getmetatable(args) then
                instances[i][method](instances[i], unpack(args))
            else
                instances[i][method](instances[i], args)
            end
        else
            instances[i][method](instances[i])
        end
    end
end

function Factory.iter(instances, method, ...)
    local args = { ... } or nil
    local results = {}

    for i = 1, #instances do
        local result
        if args then
            if type(args) == "table" and not getmetatable(args) then
                result = instances[i][method](instances[i], unpack(args))
            else
                result = instances[i][method](instances[i], args)
            end
        else
            result = instances[i][method](instances[i])
        end
        table.insert(results, result)
    end

    return results
end

function Factory.clone(input)
    if getmetatable(input) then
        local class = getmetatable(input)
        local new_instance = class.new()
        for key, value in pairs(input) do
            if key ~= "element_id" and key ~= "class_id" then
                new_instance[key] = value
            end
        end
        return new_instance
    end

    return Factory.iter(input, "clone", input)
end
