-- TODO Refactor the print method

Line = {}
Line.__index = Line

Line.id = 1

Line.attrs = {
    color = theme.text
}

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

        local attr = Line.attrs[key]
        if attr ~= nil then
            return attr
        end
    end

    return Line[key]
end

function Line.new(vec2_a, vec2_b, options)
    local invalid_args = not Vec2.is_vec2(vec2_a) or not Vec2.is_vec2(vec2_b)

    if invalid_args then
        error("The first two arguments to Line.new must be Vec2s.")
    end

    local self = setmetatable({}, Line)
    self.element_id = Element.id
    Element.id = Element.id + 1
    self.class_id = Line.id
    Line.id = Line.id + 1

    self.vec2_a = vec2_a or Vec2.new(0, 0)
    self.vec2_b = vec2_b or Vec2.new(0, 0)
    self.o = options or {}

    self.style = self.o.style or "normal"
    self.color = self.o.color or Point.attrs.color

    for key, value in pairs(self.o) do
        self[key] = value
    end

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

        local paint = color_paint(self.color)
        stroke_segment(
            { start_dash.x, start_dash.y },
            { end_dash.x, end_dash.y },
            self.width, paint
        )

        current_distance = current_distance + self.space_length
    end
end

function Line:draw_dotted()
    local total_distance = self.vec2_a:distance(self.vec2_b)
    local direction = self.vec2_b:sub(self.vec2_a):normalize()

    local current_distance = 0
    while current_distance <= total_distance do
        local dot_position = self.vec2_a:add(direction:mult(current_distance))
        local paint = color_paint(self.color)

        fill_circle({ dot_position.x, dot_position.y }, self.dot_radius, paint)

        current_distance = current_distance + self.space_length
    end
end

function Line:draw_char()
    if #self.char > 1 or #self.char_vertex > 1 then
        error("char and char_vertex must be single characters.")
    end

    local char_scale_factor = self.char_size / 12
    local total_distance = self.vec2_a:distance(self.vec2_b)
    local direction = self.vec2_b:sub(self.vec2_a):normalize()

    save()
    translate {
        self.vec2_a.x + self.char_vertex_nudge[1],
        self.vec2_a.y + self.char_vertex_nudge[2]
    }
    scale { char_scale_factor, char_scale_factor }
    text(self.char_vertex, self.color)
    restore()

    local current_distance = self.space_length
    while current_distance < total_distance do
        local char_position = self.vec2_a:add(direction:mult(current_distance))

        save()
        translate { char_position.x, char_position.y }
        scale { char_scale_factor, char_scale_factor }
        text(self.char, self.color)
        restore()

        current_distance = current_distance + self.space_length
    end

    if total_distance > 0 then
        save()
        translate {
            self.vec2_b.x + self.char_vertex_nudge[1],
            self.vec2_b.y + self.char_vertex_nudge[2]
        }
        scale { char_scale_factor, char_scale_factor }
        text(self.char_vertex, self.color)
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
        (self.vec2_a.x + self.vec2_b.x) / 2,
        (self.vec2_a.y + self.vec2_b.y) / 2
    )
end

function Line:rotate(angle, pivot)
    pivot = pivot or self:get_center()

    local new_vec2_a = self.vec2_a:rotate(angle, pivot)
    local new_vec2_b = self.vec2_b:rotate(angle, pivot)

    return Line.new(new_vec2_a, new_vec2_b, self.o)
end

function Line:Rotate(angle, pivot)
    pivot = pivot or self:get_center()

    self.vec2_a:Rotate(angle, pivot)
    self.vec2_b:Rotate(angle, pivot)

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
        self.vec2_a:add(translation),
        self.vec2_b:add(translation),
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

    self.vec2_a:Add(translation)
    self.vec2_b:Add(translation)
end

function Line:scale(scaleFactor)
    local center = self:get_center()
    local translated_a = self.vec2_a:sub(center)
    local translated_b = self.vec2_b:sub(center)
    translated_a:Mult(scaleFactor):Add(center)
    translated_b:Mult(scaleFactor):Add(center)

    return Line.new(translated_a, translated_b, self.o)
end

function Line:Scale(scaleFactor)
    local center = self:get_center()
    local translated_a = self.vec2_a:sub(center)
    local translated_b = self.vec2_b:sub(center)
    translated_a:Mult(scaleFactor):Add(center)
    translated_b:Mult(scaleFactor):Add(center)

    self.vec2_a = translated_a
    self.vec2_b = translated_b
end

function Line:Mirror_Across_Origin()
    self.vec2_a:Set(-self.vec2_a.x, -self.vec2_a.y)
    self.vec2_b:Set(-self.vec2_b.x, -self.vec2_b.y)
end

function Line:Mirror_Across_X()
    self.vec2_a:Set_Y(-self.vec2_a.y)
    self.vec2_b:Set_Y(-self.vec2_b.y)
end

function Line:Mirror_Across_Y()
    self.vec2_a:Set_X(-self.vec2_a.x)
    self.vec2_b:Set_X(-self.vec2_b.x)
end

function Line:print(places)
    places = places or 2

    local element_id = tostring(self.element_id)
    local class_id = self.class_id
    local ax = tostring(Math.truncate(self.vec2_a.x, places))
    local ay = tostring(Math.truncate(self.vec2_a.y, places))
    local bx = tostring(Math.truncate(self.vec2_b.x, places))
    local by = tostring(Math.truncate(self.vec2_b.y, places))
    local color = tostring(Utils.table_to_string(self.color, true, places))
    local width = tostring(Math.truncate(self.width, places))
    local style = self.style
    local dash_length = tostring(Math.truncate(self.dash_length, places))
    local dot_radius = tostring(Math.truncate(self.dot_radius, places))
    local char = self.char
    local char_vertex = self.char_vertex
    local char_vertex_nudge = self.char_vertex_nudge
    local char_size = tostring(Math.truncate(self.char_size, places))
    local space_length = tostring(Math.truncate(self.space_length, places))

    print("-- Line " .. element_id .. ":" .. class_id .. " --")
    print("  element_id: " .. element_id)
    print("  class_id: " .. class_id)
    print("  vec2_a: { x = " .. ax .. ", y = " .. ay .. " }")
    print("  vec2_b: { x = " .. bx .. ", y = " .. by .. " }")
    print("  color: " .. color)
    print("  width: " .. width)
    print("  style: " .. style)
    print("  dash_length: " .. dash_length)
    print("  dot_radius: " .. dot_radius)
    print("  char: " .. char)
    print("  char_vertex: " .. char_vertex)
    print("  char_vertex nudge:" .. char_vertex_nudge)
    print("  char_size: " .. char_size)
    print("  space_length: " .. space_length)
    print("  ")
end

LineGroup = {}

LineGroup.__index = LineGroup

LineGroup.id = 1

function LineGroup.new(vec2s, options)
    for _, vec2 in ipairs(vec2s) do
        if not Vec2.is_vec2(vec2) then
            error("All elements in vec2s must be Vec2 instances.")
        end
    end

    local self = setmetatable({}, LineGroup)
    self.element_id = Element.id
    Element.id = Element.id + 1
    self.class_id = LineGroup.id
    LineGroup.id = LineGroup.id + 1

    self.vec2s = vec2s or { Vec2.new(0, 0) }
    self.o = options or {}

    self.len_vec2s = #vec2s
    self.color = self.o.color or theme.text
    self.width = self.o.width or 1
    self.style = self.o.style or "normal"
    self.dash_length = self.o.dash_length or 5
    self.dot_radius = self.o.dot_radius or 1
    self.char = self.o.char or "+"
    self.char_vertex = self.o.char_vertex or self.char
    self.char_vertex_nudge = self.o.char_vertex_nudge or { 0, 0 }
    self.char_size = self.o.char_size or 12
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
            elseif self.style == "dotted" then
                line:draw_dotted()
            elseif self.style == "char" then
                line:draw_char()
            end
        end
    end
end

function LineGroup:draw_from_to()
    for i = 1, self.len_vec2s do
        local line = Line.new(self.vec2s[1], self.vec2s[i], self.o)
        if self.style == "normal" then
            line:draw_normal()
        elseif self.style == "dashed" then
            line:draw_dashed()
        elseif self.style == "dotted" then
            line:draw_dotted()
        elseif self.style == "char" then
            line:draw_char()
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

function LineGroup:print(places)
    places = places or 2

    local element_id = tostring(self.element_id)
    local class_id = tostring(self.class_id)
    local len_vec2s = tostring(self.len_vec2s)
    local color = tostring(Utils.table_to_string(self.color, true, places))
    local width = tostring(Math.truncate(self.width, places))
    local style = self.style
    local dash_length = tostring(Math.truncate(self.dash_length, places))
    local dot_radius = tostring(Math.truncate(self.dot_radius, places))
    local char = self.char
    local char_vertex = self.char_vertex
    local char_vertex_nudge = Utils.table_to_string(self.char_vertex_nudge, true, places)
    local char_size = tostring(Math.truncate(self.char_size, places))
    local space_length = tostring(Math.truncate(self.space_length, places))

    print("-- LineGroup " .. element_id .. ":" .. class_id .. " --")
    print("  element_id: " .. element_id)
    print("  class_id: " .. class_id)
    print("  len_vec2s: " .. len_vec2s)
    for i, vec2 in ipairs(self.vec2s) do
        local x = tostring(Math.truncate(vec2.x, places))
        local y = tostring(Math.truncate(vec2.y, places))
        print("vec2_" .. i .. ": " .. x .. ", y = " .. y .. " }")
    end
    print("  color: " .. color)
    print("  width: " .. width)
    print("  style: " .. style)
    print("  dash_length: " .. dash_length)
    print("  dot_radius: " .. dot_radius)
    print("  char: " .. char)
    print("  char_vertex: " .. char_vertex)
    print("  char_vertex nudge:" .. char_vertex_nudge)
    print("  char_size: " .. char_size)
    print("  space_length: " .. space_length)
    print("")
end
