Point = {}
Point.__index = Point

function Point.new(vec2, color, size)
    local self = setmetatable({}, Point)
    self.vec2 = vec2 or { x = 0, y = 0 }
    self.color = color or { 1, 1, 1, 1 }
    self.size = size or 2
    return self
end

local function process_args(class_meta, ...)
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

function Point.draw_all(...)
    local points = process_args(Point, ...)

    for _, point in ipairs(points) do
        if getmetatable(point) == Point then
            point:draw()
        else
            error("Invalid argument to Point.draw_all:" ..
                "Expected a Point instance or a table of Point instances")
        end
    end
end

function Point:draw()
    fill_circle({ self.vec2.x, self.vec2.y },
        self.size,
        color_paint(self.color)
    )
end
