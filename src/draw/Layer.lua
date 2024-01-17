-- TODO - Set a background that is always the lowest layer
-- TODO - Set a foreground that is always the highest layer
-- TODO - Attach origin to background/foreground based on preference
-- TODO - Global layer system vs local layer system - objects can have their own layers
Layer = {}
Layer.__index = Layer
Layer.layers = {}

function Layer.new(z_index)
    local self = setmetatable({}, Layer)
    self.z_index = z_index or 0
    self.objects = {}
    table.insert(Layer.layers, self)
    return self
end

function Layer.draw_all()
    table.sort(Layer.layers, function(a, b) return a.z_index < b.z_index end)
    for _, layer in ipairs(Layer.layers) do
        layer:draw()
    end
end

function Layer:add(object, draw_function_name)
    draw_function_name = draw_function_name or "draw"
    table.insert(self.objects, { object = object, draw_function = draw_function_name })
end

function Layer:draw()
    for _, item in ipairs(self.objects) do
        local obj = item.object
        local draw_function = item.draw_function
        if obj[draw_function] then
            obj[draw_function](obj)
        end
    end
end
