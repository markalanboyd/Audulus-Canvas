Graph = {}
Graph.__index = Graph

function Graph.new(x_max, y_max, step, color)
    local self = setmetatable({}, Graph)
    self.x_max = x_max or 100
    self.y_max = y_max or 100
    self.step = step or 10
    self.color = color or { 0.4, 0.4, 0.4, 1 }
    return self
end

function Graph:draw()
    local paint = color_paint(self.color)

    for i = 0, self.step * self.step * 2, self.step do
        stroke_segment({ -self.x_max, -self.y_max + i }, { self.x_max, -self.y_max + i }, 1, paint)
        stroke_segment({ -self.x_max + i, -self.y_max }, { -self.x_max + i, self.y_max }, 1, paint)
    end

    stroke_segment({ -self.x_max, 0 }, { self.x_max, 0 }, 2, paint)
    stroke_segment({ 0, self.y_max }, { 0, -self.y_max }, 2, paint)
end
