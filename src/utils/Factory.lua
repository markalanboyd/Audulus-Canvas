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

function Factory.iter(objects, method, args)
    for i = 1, #objects do
        if args then
            if type(args) == "table" and not getmetatable(args) then
                objects[i][method](objects[i], unpack(args))
            else
                objects[i][method](objects[i], args)
            end
        else
            objects[i][method](objects[i])
        end
    end
end

function Factory.clone(objects)
    local result = {}
    for i = 1, #objects do
        result[i] = objects[i]:clone()
    end
    return result
end

function Factory.clone_one(class, object)
    local new_object = class.new()
    for key, value in pairs(object) do
        new_object[key] = value
    end
    return new_object
end
