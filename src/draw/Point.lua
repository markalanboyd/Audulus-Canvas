Point = {}
Point.__index = Point

function Point.new(vec2, color, size)
    local self = setmetatable({}, Point)
    self.vec2 = vec2 or { x = 0, y = 0 }
    self.color = color or { 1, 1, 1, 1 }
    self.size = size or 2
    return self
end

function Point.draw_all(...)
    local args = { ... }
    local points

    if type(args[1]) == "table" then
        if getmetatable(args[1]) == Point then
            points = args
        else
            points = args[1]
        end
    else
        points = args
    end

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
