Line = {}
L = Line
Line.__index = Line

Line.id = 1

Line.styles = {
    normal = {
        width = 1,
    },
    dashed = {
        width = 1,
        dash_length = 5,
        space_length = 5,
    },
    dotted = {
        dot_radius = 1,
        space_length = 5,
    },
    char = {
        char = "+",
        char_vertex = "+",
        char_vertex_nudge = { 0, 0 },
        char_size = 12,
        space_length = 5,
    },
}

Line.__index = function(instance, key)
    local value = rawget(instance, key)
    if value ~= nil then
        return value
    else
        local style = rawget(instance, "style") or "normal"
        local style_val = Line.styles[style][key]
        if style_val ~= nil then
            return style_val
        end
    end

    return Line[key]
end

function Line.new(vec2a, vec2b, options)
    local self = setmetatable({}, Line)
    self.element_id = Element.id
    Element.id = Element.id + 1
    self.class_id = Line.id
    Line.id = Line.id + 1

    self.vec2a = vec2a or Vec2.new(0, 0)
    self.vec2b = vec2b or Vec2.new(0, 0)
    self.o = options or {}

    self.style = self.o.style or "normal"
    local c = self.o.color or Color.new()
    self.color = Color.assign_color(c)

    for key, value in pairs(self.o) do
        self[key] = value
    end

    return self
end

function Line:clone()
    return Factory.clone_one(Line, self)
end

function Line:draw_normal()
    local paint = Paint.create(self.color, self.gradient)
    stroke_segment(
        { self.vec2a.x, self.vec2a.y },
        { self.vec2b.x, self.vec2b.y },
        self.width, paint
    )
end

function Line:draw_dashed()
    local total_distance = self.vec2a:distance(self.vec2b)
    local direction = self.vec2b:sub(self.vec2a):normalize()

    local current_distance = 0
    while current_distance < total_distance do
        local start_dash = self.vec2a:add(direction:mult(current_distance))
        current_distance = math.min(current_distance + self.dash_length, total_distance)
        local end_dash = self.vec2a:add(direction:mult(current_distance))

        local paint = Paint.create(self.color, self.gradient)
        stroke_segment(
            { start_dash.x, start_dash.y },
            { end_dash.x, end_dash.y },
            self.width, paint
        )

        current_distance = current_distance + self.space_length
    end
end

function Line:draw_dotted()
    local total_distance = self.vec2a:distance(self.vec2b)
    local direction = self.vec2b:sub(self.vec2a):normalize()

    local current_distance = 0
    while current_distance <= total_distance do
        local dot_position = self.vec2a:add(direction:mult(current_distance))
        local paint = Paint.create(self.color, self.gradient)

        fill_circle({ dot_position.x, dot_position.y }, self.dot_radius, paint)

        current_distance = current_distance + self.space_length
    end
end

function Line:draw_char()
    if #self.char > 1 or #self.char_vertex > 1 then
        error("char and char_vertex must be single characters.")
    end

    local char_scale_factor = self.char_size / 12
    local total_distance = self.vec2a:distance(self.vec2b)
    local direction = self.vec2b:sub(self.vec2a):normalize()

    save()
    translate {
        self.vec2a.x + self.char_vertex_nudge[1],
        self.vec2a.y + self.char_vertex_nudge[2]
    }
    scale { char_scale_factor, char_scale_factor }
    text(self.char_vertex, self.color:table())
    restore()

    local current_distance = self.space_length
    while current_distance < total_distance do
        local char_position = self.vec2a:add(direction:mult(current_distance))

        save()
        translate { char_position.x, char_position.y }
        scale { char_scale_factor, char_scale_factor }
        text(self.char, self.color:table())
        restore()

        current_distance = current_distance + self.space_length
    end

    if total_distance > 0 then
        save()
        translate {
            self.vec2b.x + self.char_vertex_nudge[1],
            self.vec2b.y + self.char_vertex_nudge[2]
        }
        scale { char_scale_factor, char_scale_factor }
        text(self.char_vertex, self.color:table())
        restore()
    end
end

function Line:draw()
    if self.style == "normal" then
        self:draw_normal()
    elseif self.style == "dashed" then
        self:draw_dashed()
    elseif self.style == "dotted" then
        self:draw_dotted()
    elseif self.style == "char" then
        self:draw_char()
    end
end

function Line:get_center()
    return Vec2.new(
        (self.vec2a.x + self.vec2b.x) / 2,
        (self.vec2a.y + self.vec2b.y) / 2
    )
end

function Line:reflect(axis)
    local new_line = self:clone()
    new_line.vec2a:Reflect(axis)
    new_line.vec2b:Reflect(axis)
    return new_line
end

function Line:rotate(angle, pivot)
    pivot = pivot or self:get_center()

    local new_vec2a = self.vec2a:rotate(angle, pivot)
    local new_vec2b = self.vec2b:rotate(angle, pivot)

    return Line.new(new_vec2a, new_vec2b, self.o)
end

function Line:Rotate(angle, pivot)
    pivot = pivot or self:get_center()

    self.vec2a:Rotate(angle, pivot)
    self.vec2b:Rotate(angle, pivot)

    return self
end

function Line:translate(...)
    local args = Utils.process_args(Vec2, ...)
    local translation

    if #args == 1 and Vec2.is_vec2(args[1]) then
        translation = args[1]
    elseif #args == 2 and Vec2.is_xy_pair(args[1], args[2]) then
        translation = Vec2.new(args[1], args[2])
    else
        error("Invalid arguments for Translate. Expected Vec2 or two numbers.")
    end

    return Line.new(
        self.vec2a:add(translation),
        self.vec2b:add(translation),
        self.o
    )
end

function Line:Translate(...)
    local args = Utils.process_args(Vec2, ...)
    local translation

    if #args == 1 and Vec2.is_vec2(args[1]) then
        translation = args[1]
    elseif #args == 2 and Vec2.is_xy_pair(args[1], args[2]) then
        translation = Vec2.new(args[1], args[2])
    else
        error("Invalid arguments for Translate. Expected Vec2 or two numbers.")
    end

    self.vec2a:Add(translation)
    self.vec2b:Add(translation)
end

function Line:scale(scaleFactor)
    local center = self:get_center()
    local translated_a = self.vec2a:sub(center)
    local translated_b = self.vec2b:sub(center)
    translated_a:Mult(scaleFactor):Add(center)
    translated_b:Mult(scaleFactor):Add(center)

    return Line.new(translated_a, translated_b, self.o)
end

function Line:Scale(scaleFactor)
    local center = self:get_center()
    self.vec2a = self.vec2a:sub(center):Mult(scaleFactor):Add(center)
    self.vec2b = self.vec2b:sub(center):Mult(scaleFactor):Add(center)
end

function Line:print(places)
    places = places or 2

    local element_id = tostring(self.element_id)
    local class_id = tostring(self.class_id)
    local ax = tostring(Math.truncate(self.vec2a.x, places))
    local ay = tostring(Math.truncate(self.vec2a.y, places))
    local bx = tostring(Math.truncate(self.vec2b.x, places))
    local by = tostring(Math.truncate(self.vec2b.y, places))

    local style = self.style

    print("-- Line " .. element_id .. ":" .. class_id .. " --")
    print("  element_id: " .. element_id)
    print("  class_id: " .. class_id)
    print("  vec2_a: { x = " .. ax .. ", y = " .. ay .. " }")
    print("  vec2_b: { x = " .. bx .. ", y = " .. by .. " }")

    if self.gradient == nil then
        local color = tostring(Utils.table_to_string(
            self.color:table(), true, places
        ))
        print("  color: " .. color)
    else
        local c1 = tostring(Utils.table_to_string(
            self.gradient.color1:table(), true, places
        ))
        local c2 = tostring(Utils.table_to_string(
            self.gradient.color2:table(), true, places
        ))
        print("  gradient: " .. c1 .. " → " .. c2)
    end

    print("  style: " .. style)

    if style == "normal" then
        local width = tostring(Math.truncate(self.width, places))
        print("  width: " .. width)
    elseif style == "dashed" then
        local width = tostring(Math.truncate(self.width, places))
        local dash_length = tostring(Math.truncate(self.dash_length, places))
        local space_length = tostring(Math.truncate(self.space_length, places))
        print("  width: " .. width)
        print("  dash_length: " .. dash_length)
        print("  space_length: " .. space_length)
    elseif style == "dotted" then
        local dot_radius = tostring(Math.truncate(self.dot_radius, places))
        local space_length = tostring(Math.truncate(self.space_length, places))
        print("  dot_radius: " .. dot_radius)
        print("  space_length: " .. space_length)
    elseif style == "char" then
        local char = self.char
        local char_vertex = self.char_vertex
        local char_vertex_nudge = tostring(Utils.table_to_string(self.char_vertex_nudge, true, places))
        local char_size = tostring(Math.truncate(self.char_size, places))
        local space_length = tostring(Math.truncate(self.space_length, places))
        print("  char: " .. char)
        print("  char_vertex: " .. char_vertex)
        print("  char_vertex nudge: " .. char_vertex_nudge)
        print("  char_size: " .. char_size)
        print("  space_length: " .. space_length)
    end
    print("")
end
