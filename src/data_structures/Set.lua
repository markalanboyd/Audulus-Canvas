Set = {}

Set.__index = Set

function Set.new()
    local self = setmetatable({}, Set)
    self.set = {}
    return self
end

function Set:add(key)
    self.set[key] = true
end

function Set:remove(key)
    self.set[key] = nil
end

function Set:sorted()
    local elements = {}
    for element in pairs(self.set) do
        table.insert(elements, element)
    end
    table.sort(elements)
    return elements
end
