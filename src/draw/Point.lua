Point = {}

Point.id = 1

Point.attrs = {
    color = theme.text
}

Point.styles = {
    normal = {
        radius = 2,
    },
    stroke = {
        radius = 3,
        stroke_width = 1,
    },
    char = {
        char = "o",
        char_nudge = { 0, 0 },
        char_size = 12,
    },
}

Point.__index = function(instance, key)
    local value = rawget(instance, key)
    if value ~= nil then
        return value
    else
        local style = rawget(instance, "style") or "normal"
        local style_val = Point.styles[style][key]
        if style_val ~= nil then
            return style_val
        end

        local attr = Point.attrs[key]
        if attr ~= nil then
            return attr
        end
    end

    return Point[key]
end

function Point.new(vec2, options)
    local self = setmetatable({}, Point)
    self.type = "Point"
    self.element_id = Element.id
    Element.id = Element.id + 1
    self.class_id = Point.id
    Point.id = Point.id + 1

    self.vec2 = vec2 or Vec2.new(0, 0)
    self.o = options or {}

    self.style = self.o.style or "normal"
    self.color = self.color.size or Point.attrs.color

    for key, value in pairs(self.o) do
        self[key] = value
    end

    return self
end

-- Instance Methods --

function Point:clone()
    local new_point = Point.new(self.vec2)
    for key, value in pairs(self) do
        if key ~= "vec2" then
            new_point[key] = value
        end
    end
    return new_point
end

function Point:draw_normal()
    fill_circle(
        { self.vec2.x, self.vec2.y },
        self.radius,
        color_paint(self.color)
    )
end

function Point:draw_stroke()
    stroke_circle(
        { self.vec2.x, self.vec2.y },
        self.radius,
        self.stroke_width,
        color_paint(self.color))
end

function Point:draw()
    if self.style == "normal" then
        self:draw_normal()
    elseif self.style == "stroke" then
        self:draw_stroke()
    end
end

function Point:reflect(axis)
    local new_vec2 = self.vec2:reflect(axis)
    local new_point = self:clone()
    new_point.vec2 = new_vec2
    return new_point
end

function Point:Reflect(axis)
    self.vec2:Reflect(axis)
    return self
end

function Point:rotate(angle, pivot)
    local new_vec2 = self.vec2:rotate(angle, pivot)
    local new_point = self:clone()
    new_point.vec2 = new_vec2
    return new_point
end

function Point:Rotate(angle, pivot)
    self.vec2:Rotate(angle, pivot)
    return self
end

function Point:scale(scalar)
    local new_vec2 = self.vec2:mult(scalar)
    local new_point = self:clone()
    new_point.vec2 = new_vec2
    return new_point
end

function Point:Scale(scalar)
    self.vec2:Mult(scalar)
end

function Point:translate(a, b)
    local new_vec2 = self.vec2:add(a, b)
    local new_point = self:clone()
    new_point.vec2 = new_vec2
    return new_point
end

function Point:Translate(a, b)
    self.vec2:Add(a, b)
    return self
end
