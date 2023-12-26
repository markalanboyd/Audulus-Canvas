Line = {}
Line.__index = Line

function Line.new(vec2_a, vec2_b, color, width)
    local self = setmetatable({}, Line)
    self.vec2_a = vec2_a or { 0, 0 }
    self.vec2_b = vec2_b or { 0, 0 }
    self.color = color or theme.text
    self.width = width or 1
    return self
end

function Line.draw_between_all(...)
    local vec2s = Utils.process_args(Line, ...)
    for i = 1, #vec2s do
        for j = i + 1, #vec2s do
            local line = Line.new(vec2s[i], vec2s[j])
            line:draw()
        end
    end
end

function Line.dash_between_all(...)
    local vec2s = Utils.process_args(Line, ...)
    for i = 1, #vec2s do
        for j = i + 1, #vec2s do
            local line = Line.new(vec2s[i], vec2s[j])
            line:dashed()
        end
    end
end

function Line.draw_from_to_all(vec2, ...)
    local vec2s = Utils.process_args(Line, ...)
    for i = 1, #vec2s do
        local line = Line.new(vec2, vec2s[i])
        line:draw()
    end
end

function Line.dash_from_to_all(vec2, ...)
    local vec2s = Utils.process_args(Line, ...)
    for i = 1, #vec2s do
        local line = Line.new(vec2, vec2s[i])
        line:dashed()
    end
end

function Line:draw()
    local paint = color_paint(self.color)
    stroke_segment(
        { self.vec2_a.x, self.vec2_a.y },
        { self.vec2_b.x, self.vec2_b.y },
        self.width, paint
    )
end

function Line:dashed(dash_length, space_length)
    dash_length = dash_length or 5
    space_length = space_length or dash_length

    local total_distance = self.vec2_a:distance(self.vec2_b)
    local direction = self.vec2_b:sub(self.vec2_a):normalize()

    local current_distance = 0
    while current_distance < total_distance do
        local start_dash = self.vec2_a:add(direction:mult(current_distance))
        current_distance = math.min(current_distance + dash_length, total_distance)
        local end_dash = self.vec2_a:add(direction:mult(current_distance))

        local temp_line = Line.new(start_dash, end_dash, self.color, self.width)
        temp_line:draw()

        current_distance = current_distance + space_length
    end
end
