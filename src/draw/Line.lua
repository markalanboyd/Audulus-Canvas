-- TODO Add dotted
-- TODO Add alpha?

Line = {}
Line.__index = Line

function Line.new(vec2_a, vec2_b, options)
    local invalid_args = not Vec2.is_vec2(vec2_a) or not Vec2.is_vec2(vec2_b)

    if invalid_args then
        error("The first two arguments to Line.new must be Vec2s.")
    end

    local self = setmetatable({}, Line)
    self.type = "Line"
    self.o = options or {}
    self.vec2_a = vec2_a or { 0, 0 }
    self.vec2_b = vec2_b or { 0, 0 }
    self.color = self.o.color or theme.text
    self.width = self.o.width or 1
    self.style = self.o.style or "normal"
    self.dash_length = self.o.dash_length or 5
    self.space_length = self.o.space_length or self.dash_length
    return self
end

function Line:draw_normal()
    local paint = color_paint(self.color)
    stroke_segment(
        { self.vec2_a.x, self.vec2_a.y },
        { self.vec2_b.x, self.vec2_b.y },
        self.width, paint
    )
end

function Line:draw_dashed()
    local total_distance = self.vec2_a:distance(self.vec2_b)
    local direction = self.vec2_b:sub(self.vec2_a):normalize()

    local current_distance = 0
    while current_distance < total_distance do
        local start_dash = self.vec2_a:add(direction:mult(current_distance))
        current_distance = math.min(current_distance + self.dash_length, total_distance)
        local end_dash = self.vec2_a:add(direction:mult(current_distance))

        local temp_line = Line.new(start_dash, end_dash, { color = self.color, width = self.width })
        temp_line:draw_normal()

        current_distance = current_distance + self.space_length
    end
end

function Line:draw()
    if self.style == "normal" then
        self:draw_normal()
    elseif self.style == "dashed" then
        self:draw_dashed()
    end
end

LineGroup = {}

LineGroup.__index = LineGroup

function LineGroup.new(vec2s, options)
    for _, vec2 in ipairs(vec2s) do
        if not Vec2.is_vec2(vec2) then
            error("All elements in vec2s must be Vec2 instances.")
        end
    end

    local self = setmetatable({}, LineGroup)
    self.type = "LineGroup"
    self.vec2s = vec2s
    self.len_vec2s = #vec2s
    self.o = options or {}
    self.color = self.o.color or theme.text
    self.width = self.o.width or 1
    self.style = self.o.style or "normal"
    self.dash_length = self.o.dash_length or 5
    self.space_length = self.o.space_length or self.dash_length
    self.method = self.o.method or "between"
    return self
end

function LineGroup:draw_between()
    for i = 1, self.len_vec2s do
        for j = i + 1, self.len_vec2s do
            local line = Line.new(self.vec2s[i], self.vec2s[j], self.o)
            if self.style == "normal" then
                line:draw_normal()
            elseif self.style == "dashed" then
                line:draw_dashed()
            end
        end
    end
end

function LineGroup:draw_from_to()
    for i = 1, self.len_vec2s do
        local line = Line.new(self.vec2s[1], self.vec2s[i])
        if self.style == "normal" then
            line:draw_normal()
        elseif self.style == "dashed" then
            line:draw_dashed()
        end
    end
end

function LineGroup:draw()
    if self.method == "between" then
        self:draw_between()
    elseif self.method == "from-to" then
        self:draw_from_to()
    end
end
