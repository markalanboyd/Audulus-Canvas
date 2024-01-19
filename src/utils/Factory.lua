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
