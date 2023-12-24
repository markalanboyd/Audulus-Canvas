Line = {}
Line.__index = Line

function Line.new(vec2_a, vec2_b)
    local self = setmetatable({}, Line)
    self.vec2_a = vec2_a or { 0, 0 }
    self.vec2_b = vec2_b or { 0, 0 }
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

function Line.draw_between_all(...)
    local vec2s = process_args(Line, ...)
    for i = 1, #vec2s do
        for j = i + 1, #vec2s do
            local line = Line.new(vec2s[i], vec2s[j])
            line:draw()
        end
    end
end

function Line.draw_from_to_all(vec2, ...)
    local vec2s = process_args(Line, ...)
    for i = 1, #vec2s do
        local line = Line.new(vec2, vec2s[i])
        line:draw()
    end
end

function Line:draw(color, width)
    color = color or theme.text
    width = width or 1
    local paint = color_paint(color)
    stroke_segment(
        { self.vec2_a.x, self.vec2_a.y },
        { self.vec2_b.x, self.vec2_b.y },
        width, paint
    )
end

function Line:dashed(color, width, dash_length, space_length)
    color = color or theme.text
    width = width or 1
    dash_length = dash_length or 5
    space_length = space_length or dash_length
    local paint = color_paint(color)

    local total_distance = self.vec2_a:distance(self.vec2_b)
    local direction = self.vec2_b:sub(self.vec2_a):normalize()

    local current_distance = 0
    while current_distance < total_distance do
        local start_dash = self.vec2_a:add(direction:mult(current_distance))
        current_distance = math.min(current_distance + dash_length, total_distance)
        local end_dash = self.vec2_a:add(direction:mult(current_distance))

        local temp_line = Line.new(start_dash, end_dash)
        temp_line:draw(color, width)

        current_distance = current_distance + space_length
    end
end
