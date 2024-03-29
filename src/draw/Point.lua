-- TODO Add docs

Point = {}
P = Point

Point.id = 1

Point.attrs = {
    show_coords = false,
    coords_nudge = { 0, 0 },
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
        char_size = 12,
        char_nudge = { 0, 0 },
        radius = 7,
    },
}

Point.__index = Utils.resolve_property

function Point.new(vec2, options)
    local self = setmetatable({}, Point)
    self.vec2 = vec2 or Vec2.new(0, 0)
    self.options = options or {}

    Utils.assign_ids(self)
    Utils.assign_options(self, self.options)
    Color.assign_color(self, self.options)

    self.name = self.name or ("Point " .. self.element_id .. ":" .. self.class_id)
    self.z_index = self.options.z_index or 0
    self.style = self.style or "normal"

    return self
end

function Point:__tostring()
    return self.name
end

function Point:clone()
    return Factory.clone(self)
end

function Point:draw_coords()
    local x = Math.truncate(self.vec2.x, 0)
    local y = Math.truncate(self.vec2.y, 0)
    local coordinate = "(" .. x .. ", " .. y .. ")"
    local offset = self.radius * 1.5

    save()
    translate {
        self.vec2.x + offset + self.coords_nudge[1],
        self.vec2.y + offset + self.coords_nudge[2]
    }
    text(coordinate, self.color:table())
    restore()
end

function Point:draw_normal()
    local paint = Paint.create(self.color, self.gradient)
    fill_circle(
        { self.vec2.x, self.vec2.y },
        self.radius,
        paint
    )
end

function Point:draw_stroke()
    local paint = Paint.create(self.color, self.gradient)
    stroke_circle(
        { self.vec2.x, self.vec2.y },
        self.radius,
        self.stroke_width,
        paint)
end

function Point:draw_char()
    if #self.char > 1 then
        error("char must be single characters.")
    end

    local char_scale_factor = self.char_size / 12

    save()
    translate {
        self.vec2.x + self.char_nudge[1],
        self.vec2.y + self.char_nudge[2]
    }
    scale { char_scale_factor, char_scale_factor }
    text(self.char, self.color:table())
    restore()
end

function Point:draw()
    if self.show_coords then
        self:draw_coords()
    end

    if self.style == "normal" then
        self:draw_normal()
    elseif self.style == "stroke" then
        self:draw_stroke()
    elseif self.style == "char" then
        self:draw_char()
    end
end

function Point:reflect(axis)
    local new_point = self:clone()
    new_point.vec2:Reflect(axis)
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

function Point:print(places)
    places = places or 2

    local element_id = tostring(self.element_id)
    local class_id = tostring(self.class_id)
    local x = tostring(Math.truncate(self.vec2.x, places))
    local y = tostring(Math.truncate(self.vec2.y, places))
    local z_index = tostring(self.z_index)
    local color = tostring(Utils.table_to_string(self.color:table(), true, places))
    local style = self.style

    print("-- Point " .. element_id .. ":" .. class_id .. " --")
    print("  element_id: " .. element_id)
    print("  class_id: " .. class_id)
    print("  vec2: { x = " .. x .. ", y = " .. y .. " }")
    print("  z_index: " .. z_index)
    print("  color: " .. color)
    print("  style: " .. style)
    if style == "normal" then
        local radius = tostring(self.radius)
        print("  radius: " .. radius)
    elseif style == "stroke" then
        local radius = tostring(self.radius)
        local stroke_width = tostring(self.radius)
        print("  radius: " .. radius)
        print("  stroke_width: " .. stroke_width)
    elseif style == "char" then
        local char = self.char
        local char_size = self.char_size
        local char_nudge = tostring(Utils.table_to_string(self.char_nudge, true, places))
        print("  char: " .. char)
        print("  char_size: " .. char_size)
        print("  char_nudge: " .. char_nudge)
    end
    print("")
end
