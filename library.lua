-- SCROLL TO BOTTOM ----------------------------------------------------

Color = {}
C = Color
Color.__index = Color

Color.id = 1

function Color.new(...)
    local self = setmetatable({}, Color)
    local args = { ... }

    Utils.assign_ids(self)
    -- TODO do we need this intermediary private table?
    self.__color_table = Color.args_to_color_table(args)
    self.r = self.__color_table[1]
    self.g = self.__color_table[2]
    self.b = self.__color_table[3]
    self.a = self.__color_table[4]

    return self
end

function Color.args_to_color_table(args)
    if Color.args_are_color_table(args) then
        return args[1]
    elseif Color.args_are_rgba(args) then
        return { args[1], args[2], args[3], args[4] }
    elseif Color.args_are_rgb(args) then
        return { args[1], args[2], args[3], 1 }
    elseif Color.args_are_hex_code(args) then
        return Color.hex_to_color_table(args[1])
    else
        return theme.text
    end
end

function Color.args_are_rgb(args)
    return #args == 3 and
        type(args[1]) == "number" and
        type(args[2]) == "number" and
        type(args[3]) == "number"
end

function Color.args_are_rgba(args)
    return #args == 4 and
        type(args[1]) == "number" and
        type(args[2]) == "number" and
        type(args[3]) == "number" and
        type(args[4]) == "number"
end

function Color.args_are_color_table(args)
    return #args == 1 and
        type(args[1]) == "table" and
        type(args[1][1]) == "number" and
        type(args[1][2]) == "number" and
        type(args[1][3]) == "number" and
        type(args[1][4]) == "number"
end

function Color.args_are_hex_code(args)
    return Color.is_hex_code(args[1])
end

function Color.__add(self, other)
    return self:clone():add(other)
end

function Color.__sub(self, other)
    return self:clone():sub(other)
end

function Color.__mul(self, other)
    return self:clone():mult(other)
end

function Color.__div(self, other)
    return self:clone():div(other)
end

function Color.__unm(self)
    return self:clone():invert()
end

function Color.is_color(obj)
    return getmetatable(obj) == Color
end

function Color.is_hex_code(hex_code)
    local s = tostring(hex_code):gsub("#", "")
    local invalidChars = string.match(s, "[^0-9a-fA-F]+")
    local hasValidChars = invalidChars == nil
    local isValidLen = #s == 3 or #s == 4 or #s == 6 or #s == 8
    return hasValidChars and isValidLen
end

function Color.hex_to_color_table(hex_code)
    local s = tostring(hex_code):gsub("#", "")

    local hex_table = {}
    if #s == 3 or #s == 4 then
        hex_table[1] = s:sub(1, 1):rep(2)
        hex_table[2] = s:sub(2, 2):rep(2)
        hex_table[3] = s:sub(3, 3):rep(2)
        hex_table[4] = (#s == 4) and s:sub(4, 4):rep(2) or "FF"
    elseif #s == 6 or #s == 8 then
        hex_table[1] = s:sub(1, 2)
        hex_table[2] = s:sub(3, 4)
        hex_table[3] = s:sub(5, 6)
        hex_table[4] = (#s == 8) and s:sub(7, 8) or "FF"
    end

    local color_table = {}
    for i = 1, #hex_table do
        color_table[i] = tonumber(hex_table[i], 16) / 255
    end

    return color_table
end

function Color.is_color_table(table)
    return type(table) == "table" and
        #table == 4 and
        type(table[1]) == "number" and
        type(table[2]) == "number" and
        type(table[3]) == "number" and
        type(table[4]) == "number"
end

function Color.assign_color(object, options)
    local c = options.color or Color.new()
    if Color.is_color(c) then
        object.color = c:clone()
    elseif Color.is_color_table(c) then
        object.color = Color.new(c)
    else
        error("Expected a Color instance or a color table.")
    end
end

function Color.rgba_to_hsla(color_table)
    local r = color_table[1]
    local g = color_table[2]
    local b = color_table[3]
    local a = color_table[4]

    local cmin = math.min(r, g, b)
    local cmax = math.max(r, g, b)
    local delta = cmax - cmin

    local l = (cmax + cmin) / 2

    local s
    if delta == 0 then
        s = 0
    elseif l < 0.5 then
        s = delta / (cmax + cmin)
    else
        s = delta / (2 - cmax - cmin)
    end

    local h
    if delta == 0 then
        h = 0
    elseif cmax == r then
        h = (g - b) / delta
        if g < b then h = h + 6 end
    elseif cmax == g then
        h = (b - r) / delta + 2
    elseif cmax == b then
        h = (r - g) / delta + 4
    end
    h = h * 60

    return { h, s, l, a }
end

function Color.hsla_to_rgba(hsla_table)
    local h = hsla_table[1]
    local s = hsla_table[2]
    local l = hsla_table[3]
    local a = hsla_table[4]

    if s == 0 then
        return { l, l, l, a }
    end

    local function hue_to_rgb(p, q, t)
        if t < 0 then t = t + 1 end
        if t > 1 then t = t - 1 end
        if t < 1 / 6 then return p + (q - p) * 6 * t end
        if t < 1 / 2 then return q end
        if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
        return p
    end

    local q
    if l < 0.5 then
        q = l * (1 + s)
    else
        q = l + s - l * s
    end
    local p = 2 * l - q

    local r = hue_to_rgb(p, q, h / 360 + 1 / 3)
    local g = hue_to_rgb(p, q, h / 360)
    local b = hue_to_rgb(p, q, h / 360 - 1 / 3)

    return { r, g, b, a }
end

function Color.print_swatches(colors)
    local size = 10
    for i, color in ipairs(colors) do
        local x = -i * size
        fill_rect({ x, 0 }, { x + size, size }, 0, color:to_paint())
    end
end

-- TODO Black, grey, white, etc?

function Color.red()
    return Color.new({ 1, 0, 0, 1 })
end

function Color.orange()
    return Color.new({ 1, 0.647, 0, 1 })
end

function Color.yellow()
    return Color.new({ 1, 1, 0, 1 })
end

function Color.green()
    return Color.new({ 0, 1, 0, 1 })
end

function Color.purple()
    return Color.new({ 0.5, 0, 0.5, 1 })
end

function Color.blue()
    return Color.new({ 0, 0, 1, 1 })
end

function Color:add(color)
    local t = Math.vmap(self:table(), color:table(), Math.add)
    local color_table = Math.map(t, Math.clamp_normal)
    return Color.new(color_table)
end

function Color:sub(color)
    local t = Math.vmap(self:table(), color:table(), Math.sub)
    local color_table = Math.map(t, Math.clamp_normal)
    return Color.new(color_table)
end

function Color:mult(color)
    local t = Math.vmap(self:table(), color:table(), Math.mult)
    local color_table = Math.map(t, Math.clamp_normal)
    return Color.new(color_table)
end

function Color:div(color)
    local t = Math.vmap(self:table(), color:table(), Math.div)
    local color_table = Math.map(t, Math.clamp_normal)
    return Color.new(color_table)
end

function Color:analogous(offset_degrees)
    local offset = offset_degrees or 30
    local hsla = Color.rgba_to_hsla(self:table())

    local hsla1 = { (hsla[1] - offset) % 360, hsla[2], hsla[3], hsla[4] }
    local rgba1 = Color.hsla_to_rgba(hsla1)
    local color1 = Color.new(rgba1)

    local hsla2 = { (hsla[1] + offset) % 360, hsla[2], hsla[3], hsla[4] }
    local rgba2 = Color.hsla_to_rgba(hsla2)
    local color2 = Color.new(rgba2)

    return color1, color2
end

function Color:brightness(brightness)
    local r = self.r * brightness
    local g = self.g * brightness
    local b = self.b * brightness
    return Color.new({ r, g, b, self.a })
end

function Color:Brightness(brightness)
    self.r = self.r * brightness
    self.g = self.g * brightness
    self.b = self.b * brightness
    return self
end

function Color:clone()
    return Color.new({ self.r, self.g, self.b, self.a })
end

function Color:complementary()
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[1] = (hsla[1] + 180) % 360
    local rgba = Color.hsla_to_rgba(hsla)
    return Color.new(rgba)
end

function Color:Complimentary()
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[1] = (hsla[1] + 180) % 360
    local rgba = Color.hsla_to_rgba(hsla)
    self:Set(rgba)
    return self
end

function Color:lerp(color2, t)
    local interpolated_color = {}
    interpolated_color[1] = self.r + (color2.r - self.r) * t
    interpolated_color[2] = self.g + (color2.g - self.g) * t
    interpolated_color[3] = self.b + (color2.b - self.b) * t
    interpolated_color[4] = self.a + (color2.a - self.a) * t
    return Color.new(interpolated_color)
end

function Color:hue(hue_normalized)
    local h = hue_normalized * 360
    return self:rotate(h)
end

function Color:Hue(hue_normalized)
    local h = hue_normalized * 360
    self:Rotate(h)
    return self
end

function Color:offset_hue(offset_normalized)
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[1] = hsla[1] + offset_normalized * 360
    local rgba = Color.hsla_to_rgba(hsla)
    return Color.new(rgba)
end

function Color:Offset_Hue(offset_normalized)
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[1] = hsla[1] + offset_normalized * 360
    local rgba = Color.hsla_to_rgba(hsla)
    self:Set(rgba)
    return self
end

function Color:invert()
    local r = 1 - self.r
    local g = 1 - self.g
    local b = 1 - self.b
    return Color.new({ r, g, b, self.a })
end

function Color:Invert()
    self.r = 1 - self.r
    self.g = 1 - self.g
    self.b = 1 - self.b
    return self
end

function Color:lightness(lightness)
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[3] = lightness
    local rgba = Color.hsla_to_rgba(hsla)
    return Color.new(rgba)
end

function Color:Lightness(lightness)
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[3] = lightness
    local rgba = Color.hsla_to_rgba(hsla)
    self:Set(rgba)
    return self
end

function Color:opacity(opacity)
    local a = self.a * opacity
    return Color.new({ self.r, self.g, self.b, a })
end

function Color:Opacity(opacity)
    self.a = self.a * opacity
    return self
end

function Color:rotate(degrees)
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[1] = degrees
    local rgba = Color.hsla_to_rgba(hsla)
    return Color.new(rgba)
end

function Color:Rotate(degrees)
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[1] = degrees
    local rgba = Color.hsla_to_rgba(hsla)
    self:Set(rgba)
    return self
end

function Color:saturation(saturation)
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[2] = saturation
    local rgba = Color.hsla_to_rgba(hsla)
    return Color.new(rgba)
end

function Color:Saturation(saturation)
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[2] = saturation
    local rgba = Color.hsla_to_rgba(hsla)
    self:Set(rgba)
    return self
end

function Color:Set(color_table)
    self.r = color_table[1]
    self.g = color_table[2]
    self.b = color_table[3]
    self.a = color_table[4]
    return self
end

function Color:split_complementary(offset_degrees)
    local offset = offset_degrees or 30
    local complementary = self:complementary()
    return complementary:analogous(offset)
end

function Color:square()
    local left, right = self:analogous(90)
    return right, self:complementary(), left
end

function Color:table()
    return { self.r, self.g, self.b, self.a }
end

function Color:to_paint()
    return color_paint(self:table())
end

function Color:triadic()
    return self:analogous(120)
end

function Color:tetradic()
    local analogous = self:rotate(-60)
    return analogous:complementary(), self:complementary(), analogous
end

function Color:print_schemes(origin)
    origin = origin or { 0, 0 }

    save()
    translate(origin)

    local vec2 = Vec2.new(5, 2.5)

    Text.new("Complementary", { size = 8, vec2 = vec2 }):draw()
    local complementary = { self, self:complementary() }
    Color.print_swatches(complementary)

    translate { 0, -12 }

    Text.new("Analogous", { size = 8, vec2 = vec2 }):draw()
    local analogous = { self, self:analogous() }
    Color.print_swatches(analogous)

    translate { 0, -12 }

    Text.new("Split Complementary", { size = 8, vec2 = vec2 }):draw()
    local split_complementary = { self, self:split_complementary() }
    Color.print_swatches(split_complementary)

    translate { 0, -12 }

    Text.new("Triadic", { size = 8, vec2 = vec2 }):draw()
    local triadic = { self, self:triadic() }
    Color.print_swatches(triadic)

    translate { 0, -12 }

    Text.new("Tetradic", { size = 8, vec2 = vec2 }):draw()
    local tetradic = { self, self:tetradic() }
    Color.print_swatches(tetradic)

    translate { 0, -12 }

    Text.new("Square", { size = 8, vec2 = vec2 }):draw()
    local square = { self, self:square() }
    Color.print_swatches(square)


    restore()
end

function Color:print(places)
    places = places or 2

    local element_id = tostring(self.element_id)
    local class_id = tostring(self.class_id)
    local color_table = tostring(Utils.table_to_string(self.color_table, true, places))
    local r = tostring(Math.truncate(self.r, places))
    local g = tostring(Math.truncate(self.g, places))
    local b = tostring(Math.truncate(self.b, places))
    local a = tostring(Math.truncate(self.a, places))

    print("-- Color " .. element_id .. ":" .. class_id .. " --")
    print("  element_id: " .. element_id)
    print("  class_id: " .. class_id)
    print("  color_table: " .. color_table)
    print("  r: " .. r)
    print("  g: " .. g)
    print("  b: " .. b)
    print("  a: " .. a)
    print("")
end


Line = {}
L = Line

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

Line.__index = Utils.resolve_property

function Line.new(vec2a, vec2b, options)
    local self = setmetatable({}, Line)
    self.vec2a = vec2a or Vec2.new(0, 0)
    self.vec2b = vec2b or Vec2.new(0, 0)
    self.options = options or {}

    Utils.assign_ids(self)
    Utils.assign_options(self, self.options)
    Color.assign_color(self, self.options)

    self.name = tostring(self.name) or ("Line " .. self.element_id .. ":" .. self.class_id)
    self.z_index = self.options.z_index or 0
    self.style = self.options.style or "normal"

    return self
end

function Line:clone()
    return Factory.clone(self)
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
    local paint = Paint.create(self.color, self.gradient)
    local current_distance = 0

    while current_distance < total_distance do
        local start_dash = self.vec2a:add(direction:mult(current_distance))
        current_distance = math.min(current_distance + self.dash_length, total_distance)
        local end_dash = self.vec2a:add(direction:mult(current_distance))

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
    local paint = Paint.create(self.color, self.gradient)
    local current_distance = 0

    while current_distance <= total_distance do
        local dot_position = self.vec2a:add(direction:mult(current_distance))

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
    local color_table = self.color:table()

    save()
    translate {
        self.vec2a.x + self.char_vertex_nudge[1],
        self.vec2a.y + self.char_vertex_nudge[2]
    }
    scale { char_scale_factor, char_scale_factor }
    text(self.char_vertex, color_table)
    restore()

    local current_distance = self.space_length
    while current_distance < total_distance do
        local char_position = self.vec2a:add(direction:mult(current_distance))

        save()
        translate { char_position.x, char_position.y }
        scale { char_scale_factor, char_scale_factor }
        text(self.char, color_table)
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
        text(self.char_vertex, color_table)
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
    local args = { ... }
    local translation

    if #args == 1 and Vec2.is_vec2(args[1]) then
        translation = args[1]
    elseif #args == 2 and Vec2.is_xy_pair(args[1], args[2]) then
        translation = Vec2.new(args[1], args[2])
    elseif #args == 1 and Vec2.is_single_num() then
        error("Invalid arguments for Translate. Expected Vec2 or two numbers.")
    end

    return Line.new(
        self.vec2a:add(translation),
        self.vec2b:add(translation),
        self.o
    )
end

function Line.parse_args(args)
    if #args == 1 and Vec2.is_vec2(args[1]) then
        return args[1]
    elseif #args == 2 and Vec2.is_xy_pair(args[1], args[2]) then
        return Vec2.new(args[1], args[2])
    else
        error("Invalid arguments for Translate. Expected Vec2 or two numbers.")
    end
end

function Line:Translate(...)
    local args = { ... }
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
    local z_index = tostring(self.z_index)
    local style = self.style
    local gradient = self.gradient


    print("-- Line " .. element_id .. ":" .. class_id .. " --")
    print("  element_id: " .. element_id)
    print("  class_id: " .. class_id)
    print("  vec2_a: { x = " .. ax .. ", y = " .. ay .. " }")
    print("  vec2_b: { x = " .. bx .. ", y = " .. by .. " }")
    print("  z_index: " .. z_index)

    if gradient == nil then
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


Set = {}

Set.__index = Set

function Set.new()
    local self = setmetatable({}, Set)
    self.set = {}
    return self
end

function Set:add(key)
    self.set[key] = true
end

function Set:remove(key)
    self.set[key] = nil
end

function Set:sorted()
    local elements = {}
    for element in pairs(self.set) do
        table.insert(elements, element)
    end
    table.sort(elements)
    return elements
end


Tree = {}

Tree.__index = Tree

function Tree.new(value)
    local self = setmetatable({}, Tree)
    self.val = value

    self.parent = nil
    self.children = {}
    return self
end

function Tree:__call(...)
    local nodes = { ... }

    for _, node in ipairs(nodes) do
        self:add_child(node)
    end
end

function Tree:__tostring()
    local function tostring_r(node, depth, childNumber)
        local indent = (depth > 0) and string.rep("    ", depth - 1) .. "    |- " or ""
        local prefix = (depth > 0) and ("Child" .. childNumber .. ": ") or "Root: "
        local str = indent .. prefix .. "val = " .. tostring(node.val)

        for i, child in ipairs(node.children) do
            str = str .. "\n" .. tostring_r(child, depth + 1, i)
        end

        return str
    end

    return tostring_r(self, 0, 0)
end

function Tree:add_child(node)
    node.parent = self
    table.insert(self.children, node)
    return self
end

-- TODO Should this return self or the child or both?
function Tree:remove_child(node)
    local index
    for i, v in ipairs(self.children) do
        if v == node then
            index = i
            break
        end
    end
    if index == nil then return end
    table.remove(self.children, index)
    return self
end

function Tree:dfs_pre(t)
    if not t then t = {} end

    table.insert(t, self)

    for _, node in ipairs(self.children) do
        node:dfs_pre(t)
    end

    return t
end

function Tree:dfs_post(t)
    if not t then t = {} end

    for _, node in ipairs(self.children) do
        node:dfs_post(t)
    end

    table.insert(t, self)

    return t
end

function Tree:bfs()
    local function dequeue(t)
        return table.remove(t, 1)
    end
    local visited = {}
    local to_visit = {}
    table.insert(to_visit, self)
    while #to_visit ~= 0 do
        local node = dequeue(to_visit)
        table.insert(visited, node)
        if node.children then
            for _, child in ipairs(node.children) do
                table.insert(to_visit, child)
            end
        end
    end
    return visited
end

function Tree:add_structure(tree_structure)
    for _, v in ipairs(tree_structure) do
        local node = Tree.new(v.val)
        self:add_child(node)
        if v.children then
            node:add_structure(v.children)
        end
    end

    return self
end


Gradient = {}
G = Gradient
Gradient.__index = Gradient

Gradient.id = 1

function Gradient.new(vec2a, vec2b, color1, color2)
    local self = setmetatable({}, Gradient)
    self.element_id = Element.id
    Element.id = Element.id + 1
    self.class_id = Gradient.id
    Gradient.id = Gradient.id + 1

    self.vec2a = vec2a or Vec2.new()
    self.vec2b = vec2b or Vec2.new()
    self.color1 = color1 or Color.new()
    self.color2 = color2 or Color.new()
    return self
end

function Gradient.__add(self, other)
    return self:clone():add(other)
end

function Gradient.__sub(self, other)
    return self:clone():sub(other)
end

function Gradient.__mul(self, other)
    return self:clone():mult(other)
end

function Gradient.__div(self, other)
    return self:clone():div(other)
end

function Gradient.__unm(self)
    return self:clone():invert()
end

function Gradient:add(gradient)
    local color1 = self.color1:add(gradient.color1)
    local color2 = self.color2:add(gradient.color2)
    return Gradient.new(self.vec2a, self.vec2b, color1, color2)
end

function Gradient:Add(gradient)
    self.color1:Add(gradient.color1)
    self.color2:Add(gradient.color2)
    return self
end

function Gradient:sub(gradient)
    local color1 = self.color1:sub(gradient.color1)
    local color2 = self.color2:sub(gradient.color2)
    return Gradient.new(self.vec2a, self.vec2b, color1, color2)
end

function Gradient:Sub(gradient)
    self.color1:Sub(gradient.color1)
    self.color2:Sub(gradient.color2)
    return self
end

function Gradient:mult(gradient)
    local color1 = self.color1:mult(gradient.color1)
    local color2 = self.color2:mult(gradient.color2)
    return Gradient.new(self.vec2a, self.vec2b, color1, color2)
end

function Gradient:Mult(gradient)
    self.color1:Mult(gradient.color1)
    self.color2:Mult(gradient.color2)
    return self
end

function Gradient:div(gradient)
    local color1 = self.color1:div(gradient.color1)
    local color2 = self.color2:div(gradient.color2)
    return Gradient.new(self.vec2a, self.vec2b, color1, color2)
end

function Gradient:Div(gradient)
    self.color1:Div(gradient.color1)
    self.color2:Div(gradient.color2)
    return self
end

function Gradient:invert()
    local color1 = self.color1:invert()
    local color2 = self.color2:invert()
    return Gradient.new(self.vec2a, self.vec2b, color1, color2)
end

function Gradient:Invert()
    self.color1:Invert()
    self.color2:Invert()
    return self
end

function Gradient:clone()
    return Factory.clone(self)
end

function Gradient:to_paint()
    return linear_gradient(
        self.vec2a:to_xy_table(),
        self.vec2b:to_xy_table(),
        self.color1:table(),
        self.color2:table()
    )
end


Paint = {}

function Paint.create(color, gradient)
    if gradient ~= nil then
        return gradient:to_paint()
    else
        return color:to_paint()
    end
end


Color = {}
C = Color
Color.__index = Color

Color.id = 1

function Color.new(...)
    local self = setmetatable({}, Color)
    local args = { ... }

    Utils.assign_ids(self)
    -- TODO do we need this intermediary private table?
    self.__color_table = Color.args_to_color_table(args)
    self.r = self.__color_table[1]
    self.g = self.__color_table[2]
    self.b = self.__color_table[3]
    self.a = self.__color_table[4]

    return self
end

function Color.args_to_color_table(args)
    if Color.args_are_color_table(args) then
        return args[1]
    elseif Color.args_are_rgba(args) then
        return { args[1], args[2], args[3], args[4] }
    elseif Color.args_are_rgb(args) then
        return { args[1], args[2], args[3], 1 }
    elseif Color.args_are_hex_code(args) then
        return Color.hex_to_color_table(args[1])
    else
        return theme.text
    end
end

function Color.args_are_rgb(args)
    return #args == 3 and
        type(args[1]) == "number" and
        type(args[2]) == "number" and
        type(args[3]) == "number"
end

function Color.args_are_rgba(args)
    return #args == 4 and
        type(args[1]) == "number" and
        type(args[2]) == "number" and
        type(args[3]) == "number" and
        type(args[4]) == "number"
end

function Color.args_are_color_table(args)
    return #args == 1 and
        type(args[1]) == "table" and
        type(args[1][1]) == "number" and
        type(args[1][2]) == "number" and
        type(args[1][3]) == "number" and
        type(args[1][4]) == "number"
end

function Color.args_are_hex_code(args)
    return Color.is_hex_code(args[1])
end

function Color.__add(self, other)
    return self:clone():add(other)
end

function Color.__sub(self, other)
    return self:clone():sub(other)
end

function Color.__mul(self, other)
    return self:clone():mult(other)
end

function Color.__div(self, other)
    return self:clone():div(other)
end

function Color.__unm(self)
    return self:clone():invert()
end

function Color.is_color(obj)
    return getmetatable(obj) == Color
end

function Color.is_hex_code(hex_code)
    local s = tostring(hex_code):gsub("#", "")
    local invalidChars = string.match(s, "[^0-9a-fA-F]+")
    local hasValidChars = invalidChars == nil
    local isValidLen = #s == 3 or #s == 4 or #s == 6 or #s == 8
    return hasValidChars and isValidLen
end

function Color.hex_to_color_table(hex_code)
    local s = tostring(hex_code):gsub("#", "")

    local hex_table = {}
    if #s == 3 or #s == 4 then
        hex_table[1] = s:sub(1, 1):rep(2)
        hex_table[2] = s:sub(2, 2):rep(2)
        hex_table[3] = s:sub(3, 3):rep(2)
        hex_table[4] = (#s == 4) and s:sub(4, 4):rep(2) or "FF"
    elseif #s == 6 or #s == 8 then
        hex_table[1] = s:sub(1, 2)
        hex_table[2] = s:sub(3, 4)
        hex_table[3] = s:sub(5, 6)
        hex_table[4] = (#s == 8) and s:sub(7, 8) or "FF"
    end

    local color_table = {}
    for i = 1, #hex_table do
        color_table[i] = tonumber(hex_table[i], 16) / 255
    end

    return color_table
end

function Color.is_color_table(table)
    return type(table) == "table" and
        #table == 4 and
        type(table[1]) == "number" and
        type(table[2]) == "number" and
        type(table[3]) == "number" and
        type(table[4]) == "number"
end

function Color.assign_color(object, options)
    local c = options.color or Color.new()
    if Color.is_color(c) then
        object.color = c:clone()
    elseif Color.is_color_table(c) then
        object.color = Color.new(c)
    else
        error("Expected a Color instance or a color table.")
    end
end

function Color.rgba_to_hsla(color_table)
    local r = color_table[1]
    local g = color_table[2]
    local b = color_table[3]
    local a = color_table[4]

    local cmin = math.min(r, g, b)
    local cmax = math.max(r, g, b)
    local delta = cmax - cmin

    local l = (cmax + cmin) / 2

    local s
    if delta == 0 then
        s = 0
    elseif l < 0.5 then
        s = delta / (cmax + cmin)
    else
        s = delta / (2 - cmax - cmin)
    end

    local h
    if delta == 0 then
        h = 0
    elseif cmax == r then
        h = (g - b) / delta
        if g < b then h = h + 6 end
    elseif cmax == g then
        h = (b - r) / delta + 2
    elseif cmax == b then
        h = (r - g) / delta + 4
    end
    h = h * 60

    return { h, s, l, a }
end

function Color.hsla_to_rgba(hsla_table)
    local h = hsla_table[1]
    local s = hsla_table[2]
    local l = hsla_table[3]
    local a = hsla_table[4]

    if s == 0 then
        return { l, l, l, a }
    end

    local function hue_to_rgb(p, q, t)
        if t < 0 then t = t + 1 end
        if t > 1 then t = t - 1 end
        if t < 1 / 6 then return p + (q - p) * 6 * t end
        if t < 1 / 2 then return q end
        if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
        return p
    end

    local q
    if l < 0.5 then
        q = l * (1 + s)
    else
        q = l + s - l * s
    end
    local p = 2 * l - q

    local r = hue_to_rgb(p, q, h / 360 + 1 / 3)
    local g = hue_to_rgb(p, q, h / 360)
    local b = hue_to_rgb(p, q, h / 360 - 1 / 3)

    return { r, g, b, a }
end

function Color.print_swatches(colors)
    local size = 10
    for i, color in ipairs(colors) do
        local x = -i * size
        fill_rect({ x, 0 }, { x + size, size }, 0, color:to_paint())
    end
end

-- TODO Black, grey, white, etc?

function Color.red()
    return Color.new({ 1, 0, 0, 1 })
end

function Color.orange()
    return Color.new({ 1, 0.647, 0, 1 })
end

function Color.yellow()
    return Color.new({ 1, 1, 0, 1 })
end

function Color.green()
    return Color.new({ 0, 1, 0, 1 })
end

function Color.purple()
    return Color.new({ 0.5, 0, 0.5, 1 })
end

function Color.blue()
    return Color.new({ 0, 0, 1, 1 })
end

function Color:add(color)
    local t = Math.vmap(self:table(), color:table(), Math.add)
    local color_table = Math.map(t, Math.clamp_normal)
    return Color.new(color_table)
end

function Color:sub(color)
    local t = Math.vmap(self:table(), color:table(), Math.sub)
    local color_table = Math.map(t, Math.clamp_normal)
    return Color.new(color_table)
end

function Color:mult(color)
    local t = Math.vmap(self:table(), color:table(), Math.mult)
    local color_table = Math.map(t, Math.clamp_normal)
    return Color.new(color_table)
end

function Color:div(color)
    local t = Math.vmap(self:table(), color:table(), Math.div)
    local color_table = Math.map(t, Math.clamp_normal)
    return Color.new(color_table)
end

function Color:analogous(offset_degrees)
    local offset = offset_degrees or 30
    local hsla = Color.rgba_to_hsla(self:table())

    local hsla1 = { (hsla[1] - offset) % 360, hsla[2], hsla[3], hsla[4] }
    local rgba1 = Color.hsla_to_rgba(hsla1)
    local color1 = Color.new(rgba1)

    local hsla2 = { (hsla[1] + offset) % 360, hsla[2], hsla[3], hsla[4] }
    local rgba2 = Color.hsla_to_rgba(hsla2)
    local color2 = Color.new(rgba2)

    return color1, color2
end

function Color:brightness(brightness)
    local r = self.r * brightness
    local g = self.g * brightness
    local b = self.b * brightness
    return Color.new({ r, g, b, self.a })
end

function Color:Brightness(brightness)
    self.r = self.r * brightness
    self.g = self.g * brightness
    self.b = self.b * brightness
    return self
end

function Color:clone()
    return Color.new({ self.r, self.g, self.b, self.a })
end

function Color:complementary()
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[1] = (hsla[1] + 180) % 360
    local rgba = Color.hsla_to_rgba(hsla)
    return Color.new(rgba)
end

function Color:Complimentary()
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[1] = (hsla[1] + 180) % 360
    local rgba = Color.hsla_to_rgba(hsla)
    self:Set(rgba)
    return self
end

function Color:lerp(color2, t)
    local interpolated_color = {}
    interpolated_color[1] = self.r + (color2.r - self.r) * t
    interpolated_color[2] = self.g + (color2.g - self.g) * t
    interpolated_color[3] = self.b + (color2.b - self.b) * t
    interpolated_color[4] = self.a + (color2.a - self.a) * t
    return Color.new(interpolated_color)
end

function Color:hue(hue_normalized)
    local h = hue_normalized * 360
    return self:rotate(h)
end

function Color:Hue(hue_normalized)
    local h = hue_normalized * 360
    self:Rotate(h)
    return self
end

function Color:offset_hue(offset_normalized)
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[1] = hsla[1] + offset_normalized * 360
    local rgba = Color.hsla_to_rgba(hsla)
    return Color.new(rgba)
end

function Color:Offset_Hue(offset_normalized)
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[1] = hsla[1] + offset_normalized * 360
    local rgba = Color.hsla_to_rgba(hsla)
    self:Set(rgba)
    return self
end

function Color:invert()
    local r = 1 - self.r
    local g = 1 - self.g
    local b = 1 - self.b
    return Color.new({ r, g, b, self.a })
end

function Color:Invert()
    self.r = 1 - self.r
    self.g = 1 - self.g
    self.b = 1 - self.b
    return self
end

function Color:lightness(lightness)
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[3] = lightness
    local rgba = Color.hsla_to_rgba(hsla)
    return Color.new(rgba)
end

function Color:Lightness(lightness)
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[3] = lightness
    local rgba = Color.hsla_to_rgba(hsla)
    self:Set(rgba)
    return self
end

function Color:opacity(opacity)
    local a = self.a * opacity
    return Color.new({ self.r, self.g, self.b, a })
end

function Color:Opacity(opacity)
    self.a = self.a * opacity
    return self
end

function Color:rotate(degrees)
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[1] = degrees
    local rgba = Color.hsla_to_rgba(hsla)
    return Color.new(rgba)
end

function Color:Rotate(degrees)
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[1] = degrees
    local rgba = Color.hsla_to_rgba(hsla)
    self:Set(rgba)
    return self
end

function Color:saturation(saturation)
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[2] = saturation
    local rgba = Color.hsla_to_rgba(hsla)
    return Color.new(rgba)
end

function Color:Saturation(saturation)
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[2] = saturation
    local rgba = Color.hsla_to_rgba(hsla)
    self:Set(rgba)
    return self
end

function Color:Set(color_table)
    self.r = color_table[1]
    self.g = color_table[2]
    self.b = color_table[3]
    self.a = color_table[4]
    return self
end

function Color:split_complementary(offset_degrees)
    local offset = offset_degrees or 30
    local complementary = self:complementary()
    return complementary:analogous(offset)
end

function Color:square()
    local left, right = self:analogous(90)
    return right, self:complementary(), left
end

function Color:table()
    return { self.r, self.g, self.b, self.a }
end

function Color:to_paint()
    return color_paint(self:table())
end

function Color:triadic()
    return self:analogous(120)
end

function Color:tetradic()
    local analogous = self:rotate(-60)
    return analogous:complementary(), self:complementary(), analogous
end

function Color:print_schemes(origin)
    origin = origin or { 0, 0 }

    save()
    translate(origin)

    local vec2 = Vec2.new(5, 2.5)

    Text.new("Complementary", { size = 8, vec2 = vec2 }):draw()
    local complementary = { self, self:complementary() }
    Color.print_swatches(complementary)

    translate { 0, -12 }

    Text.new("Analogous", { size = 8, vec2 = vec2 }):draw()
    local analogous = { self, self:analogous() }
    Color.print_swatches(analogous)

    translate { 0, -12 }

    Text.new("Split Complementary", { size = 8, vec2 = vec2 }):draw()
    local split_complementary = { self, self:split_complementary() }
    Color.print_swatches(split_complementary)

    translate { 0, -12 }

    Text.new("Triadic", { size = 8, vec2 = vec2 }):draw()
    local triadic = { self, self:triadic() }
    Color.print_swatches(triadic)

    translate { 0, -12 }

    Text.new("Tetradic", { size = 8, vec2 = vec2 }):draw()
    local tetradic = { self, self:tetradic() }
    Color.print_swatches(tetradic)

    translate { 0, -12 }

    Text.new("Square", { size = 8, vec2 = vec2 }):draw()
    local square = { self, self:square() }
    Color.print_swatches(square)


    restore()
end

function Color:print(places)
    places = places or 2

    local element_id = tostring(self.element_id)
    local class_id = tostring(self.class_id)
    local color_table = tostring(Utils.table_to_string(self.color_table, true, places))
    local r = tostring(Math.truncate(self.r, places))
    local g = tostring(Math.truncate(self.g, places))
    local b = tostring(Math.truncate(self.b, places))
    local a = tostring(Math.truncate(self.a, places))

    print("-- Color " .. element_id .. ":" .. class_id .. " --")
    print("  element_id: " .. element_id)
    print("  class_id: " .. class_id)
    print("  color_table: " .. color_table)
    print("  r: " .. r)
    print("  g: " .. g)
    print("  b: " .. b)
    print("  a: " .. a)
    print("")
end


ColorTables = {}

ColorTables.theme = { yellow = { 0.83, 1, 0, 1 } }

ColorTables.html = { indianred = { 205, 92, 92, 1 }, lightcoral = { 240, 128, 128, 1 }, salmon = { 250, 128, 114, 1 }, darksalmon = { 233, 150, 122, 1 }, lightsalmon = { 255, 160, 122, 1 }, crimson = { 220, 20, 60, 1 }, red = { 255, 0, 0, 1 }, firebrick = { 178, 34, 34, 1 }, darkred = { 139, 0, 0, 1 }, pink = { 255, 192, 203, 1 }, lightpink = { 255, 182, 193, 1 }, hotpink = { 255, 105, 180, 1 }, deeppink = { 255, 20, 147, 1 }, mediumvioletred = { 199, 21, 133, 1 }, palevioletred = { 219, 112, 147, 1 }, coral = { 255, 127, 80, 1 }, tomato = { 255, 99, 71, 1 }, orangered = { 255, 69, 0, 1 }, darkorange = { 255, 140, 0, 1 }, orange = { 255, 165, 0, 1 }, gold = { 255, 215, 0, 1 }, yellow = { 255, 255, 0, 1 }, lightyellow = { 255, 255, 224, 1 }, lemonchiffon = { 255, 250, 205, 1 }, lightgoldenrodyellow = { 250, 250, 210, 1 }, papayawhip = { 255, 239, 213, 1 }, moccasin = { 255, 228, 181, 1 }, peachpuff = { 255, 218, 185, 1 }, palegoldenrod = { 238, 232, 170, 1 }, khaki = { 240, 230, 140, 1 }, darkkhaki = { 189, 183, 107, 1 }, lavender = { 230, 230, 250, 1 }, thistle = { 216, 191, 216, 1 }, plum = { 221, 160, 221, 1 }, violet = { 238, 130, 238, 1 }, orchid = { 218, 112, 214, 1 }, fuchsia = { 255, 0, 255, 1 }, magenta = { 255, 0, 255, 1 }, mediumorchid = { 186, 85, 211, 1 }, mediumpurple = { 147, 112, 219, 1 }, rebeccapurple = { 102, 51, 153, 1 }, blueviolet = { 138, 43, 226, 1 }, darkviolet = { 148, 0, 211, 1 }, darkorchid = { 153, 50, 204, 1 }, darkmagenta = { 139, 0, 139, 1 }, purple = { 128, 0, 128, 1 }, indigo = { 75, 0, 130, 1 }, slateblue = { 106, 90, 205, 1 }, darkslateblue = { 72, 61, 139, 1 }, mediumslateblue = { 123, 104, 238, 1 }, greenyellow = { 173, 255, 47, 1 }, chartreuse = { 127, 255, 0, 1 }, lawngreen = { 124, 252, 0, 1 }, lime = { 0, 255, 0, 1 }, limegreen = { 50, 205, 50, 1 }, palegreen = { 152, 251, 152, 1 }, lightgreen = { 144, 238, 144, 1 }, mediumspringgreen = { 0, 250, 154, 1 }, springgreen = { 0, 255, 127, 1 }, mediumseagreen = { 60, 179, 113, 1 }, seagreen = { 46, 139, 87, 1 }, forestgreen = { 34, 139, 34, 1 }, green = { 0, 128, 0, 1 }, darkgreen = { 0, 100, 0, 1 }, yellowgreen = { 154, 205, 50, 1 }, olivedrab = { 107, 142, 35, 1 }, olive = { 128, 128, 0, 1 }, darkolivegreen = { 85, 107, 47, 1 }, mediumaquamarine = { 102, 205, 170, 1 }, darkseagreen = { 143, 188, 139, 1 }, lightseagreen = { 32, 178, 170, 1 }, darkcyan = { 0, 139, 139, 1 }, teal = { 0, 128, 128, 1 }, aqua = { 0, 255, 255, 1 }, cyan = { 0, 255, 255, 1 }, lightcyan = { 224, 255, 255, 1 }, paleturquoise = { 175, 238, 238, 1 }, aquamarine = { 127, 255, 212, 1 }, turquoise = { 64, 224, 208, 1 }, mediumturquoise = { 72, 209, 204, 1 }, darkturquoise = { 0, 206, 209, 1 }, cadetblue = { 95, 158, 160, 1 }, steelblue = { 70, 130, 180, 1 }, lightsteelblue = { 176, 196, 222, 1 }, powderblue = { 176, 224, 230, 1 }, lightblue = { 173, 216, 230, 1 }, skyblue = { 135, 206, 235, 1 }, lightskyblue = { 135, 206, 250, 1 }, deepskyblue = { 0, 191, 255, 1 }, dodgerblue = { 30, 144, 255, 1 }, cornflowerblue = { 100, 149, 237, 1 }, royalblue = { 65, 105, 225, 1 }, blue = { 0, 0, 255, 1 }, mediumblue = { 0, 0, 205, 1 }, darkblue = { 0, 0, 139, 1 }, navy = { 0, 0, 128, 1 }, midnightblue = { 25, 25, 112, 1 }, cornsilk = { 255, 248, 220, 1 }, blanchedalmond = { 255, 235, 205, 1 }, bisque = { 255, 228, 196, 1 }, navajowhite = { 255, 222, 173, 1 }, wheat = { 245, 222, 179, 1 }, burlywood = { 222, 184, 135, 1 }, tan = { 210, 180, 140, 1 }, rosybrown = { 188, 143, 143, 1 }, sandybrown = { 244, 164, 96, 1 }, goldenrod = { 218, 165, 32, 1 }, darkgoldenrod = { 184, 134, 11, 1 }, peru = { 205, 133, 63, 1 }, chocolate = { 210, 105, 30, 1 }, saddlebrown = { 139, 69, 19, 1 }, sienna = { 160, 82, 45, 1 }, brown = { 165, 42, 42, 1 }, maroon = { 128, 0, 0, 1 }, white = { 255, 255, 255, 1 }, snow = { 255, 250, 250, 1 }, honeydew = { 240, 255, 240, 1 }, mintcream = { 245, 255, 250, 1 }, azure = { 240, 255, 255, 1 }, aliceblue = { 240, 248, 255, 1 }, ghostwhite = { 248, 248, 255, 1 }, whitesmoke = { 245, 245, 245, 1 }, seashell = { 255, 245, 238, 1 }, beige = { 245, 245, 220, 1 }, oldlace = { 253, 245, 230, 1 }, floralwhite = { 255, 250, 240, 1 }, ivory = { 255, 255, 240, 1 }, antiquewhite = { 250, 235, 215, 1 }, linen = { 250, 240, 230, 1 }, lavenderblush = { 255, 240, 245, 1 }, mistyrose = { 255, 228, 225, 1 }, gainsboro = { 220, 220, 220, 1 }, lightgray = { 211, 211, 211, 1 }, silver = { 192, 192, 192, 1 }, darkgray = { 169, 169, 169, 1 }, gray = { 128, 128, 128, 1 }, dimgray = { 105, 105, 105, 1 }, lightslategray = { 119, 136, 153, 1 }, slategray = { 112, 128, 144, 1 }, darkslategray = { 47, 79, 79, 1 }, black = { 0, 0, 0, 1 } }


Factory = {}
Factory.__index = Factory
F = Factory

function Factory.new(class, items, options)
    local result = {}
    for i = 1, #items do
        if type(items[i]) == "table" and not getmetatable(items[i]) then
            if options then
                local args_with_options = { unpack(items[i]) }
                table.insert(args_with_options, options)
                result[i] = class.new(unpack(args_with_options))
            else
                result[i] = class.new(unpack(items[i]))
            end
        else
            result[i] = class.new(items[i], options)
        end
    end
    return result
end

function Factory.Iter(instances, method, ...)
    local args = { ... } or nil
    for i = 1, #instances do
        if args then
            if type(args) == "table" and not getmetatable(args) then
                instances[i][method](instances[i], unpack(args))
            else
                instances[i][method](instances[i], args)
            end
        else
            instances[i][method](instances[i])
        end
    end
end

function Factory.iter(instances, method, ...)
    local args = { ... } or nil
    local results = {}

    for i = 1, #instances do
        local result
        if args then
            if type(args) == "table" and not getmetatable(args) then
                result = instances[i][method](instances[i], unpack(args))
            else
                result = instances[i][method](instances[i], args)
            end
        else
            result = instances[i][method](instances[i])
        end
        table.insert(results, result)
    end

    return results
end

function Factory.clone(input)
    if getmetatable(input) then
        local class = getmetatable(input)
        local new_instance = class.new()
        for key, value in pairs(input) do
            if key ~= "element_id" and key ~= "class_id" then
                new_instance[key] = value
            end
        end
        return new_instance
    end

    return Factory.iter(input, "clone", input)
end


-- TODO Create method that will force numbers as strings to keep zeros to x place

Utils = {}

function Utils.has_non_integer_keys(t)
    for k, _ in pairs(t) do
        if type(k) ~= "number" or k ~= math.floor(k) or k < 1 then
            return true
        end
    end
    return false
end

-- TODO Refactor this to be more generic

function Utils.deep_copy_color(color_table)
    local copy = {}
    for i = 1, #color_table do
        copy[i] = color_table[i]
    end
    return copy
end

function Utils.table_to_string(t, truncate, places)
    truncate = truncate or false
    places = places or 0

    local parts = {}
    local function process_value(v)
        if truncate and type(v) == "number" then
            return Math.truncate(v, places)
        elseif type(v) == "table" then
            return Utils.table_to_string(v, truncate, places)
        else
            return tostring(v)
        end
    end

    if Utils.has_non_integer_keys(t) then
        for k, v in pairs(t) do
            v = process_value(v)
            parts[#parts + 1] = tostring(k) .. " = " .. v
        end
    else
        for _, v in ipairs(t) do
            v = process_value(v)
            parts[#parts + 1] = v
        end
    end
    return "{ " .. table.concat(parts, ", ") .. " }"
end

function Utils.get_peak_memory(interval)
    if _PeakMemory == nil then
        _PeakMemory = math.floor(collectgarbage("count"))
    end

    if Time == nil then Time = 0 end
    local current_memory_usage = math.floor(collectgarbage("count"))
    local truncated_time = math.floor(Time * 100) / 100

    if _PeakMemory < current_memory_usage then
        _PeakMemory = current_memory_usage
    end

    if truncated_time % interval == 0 then _PeakMemory = 0 end

    return _PeakMemory
end

function Utils.assign_options(instance, options)
    for key, value in pairs(options) do
        instance[key] = value
    end
end

function Utils.resolve_property(instance, key)
    local class = getmetatable(instance)
    local value = rawget(instance, key)
    if value ~= nil then return value end
    if class.styles then
        local style = rawget(instance, "style") or "normal"
        local style_val = class.styles[style][key]
        if style_val ~= nil then return style_val end
    end
    if class.methods then
        local method = rawget(instance, "method")
        if method ~= nil and class.methods[method] then
            local method_val = class.methods[method][key]
            if method_val ~= nil then return method_val end
        end
    end
    if class.attrs then
        local attr = class.attrs[key]
        if attr ~= nil then return attr end
    end
    return class[key]
end

function Utils.assign_ids(instance)
    instance.element_id = Element.id
    Element.id = Element.id + 1
    instance.class_id = instance.id
    getmetatable(instance).id = instance.id + 1
end

function Utils.has_substring(str, substr)
    return string.find(str, substr) ~= nil
end

function Utils.get_names(t)
    local names = {}
    for _, obj in ipairs(t) do
        table.insert(names, obj.name)
    end
    return "{ " .. table.concat(names, ", ") .. " }"
end


Vec2 = {}
V = Vec2
Vec2.__index = Vec2

Vec2.id = 1

function Vec2.new(x, y)
    local self = setmetatable({}, Vec2)
    self.x = x or 0
    self.y = y or 0

    Utils.assign_ids(self)

    return self
end

-- Metamethods --

function Vec2.__add(self, other)
    return self:add(other)
end

function Vec2.__sub(self, other)
    return self:sub(other)
end

function Vec2.__mul(self, other)
    return self:mult(other)
end

function Vec2.__div(self, other)
    return self:div(other)
end

function Vec2.__mod(self, other)
    return self:mod(other)
end

function Vec2.__unm(self)
    return self:reflect()
end

function Vec2.__pow(self, other)
    return self:pow(other)
end

function Vec2.__eq(self, other)
    return self.x == other.x and self.y == other.y
end

function Vec2.__lt(self, other)
    return self:magnitude() < other:magnitude()
end

function Vec2.__le(self, other)
    return self:magnitude() <= other:magnitude()
end

function Vec2.__tostring(self)
    return "{ x = " .. self.x .. ", y = " .. self.y .. " }"
end

function Vec2.args_are_vec2(args)
    return #args == 1 and
        getmetatable(args[1]) == Vec2
end

function Vec2.args_are_xy_pair(args)
    return #args == 2 and
        type(args[1]) == "number" and
        type(args[2]) == "number"
end

function Vec2.args_are_single_number(args)
    return #args == 1 and
        type(args[1]) == "number"
end

function Vec2.args_to_vec2(args)
    if Vec2.args_are_vec2(args) then
        return args[1]
    elseif Vec2.args_are_xy_pair(args) then
        return Vec2.new(args[1], args[2])
    elseif Vec2.args_are_single_number(args) then
        return Vec2.new(args[1], args[1])
    end
end

function Vec2.args_to_xy_table(args)
    if Vec2.args_are_vec2(args) then
        return { args[1].x, args[1].y }
    elseif Vec2.args_are_xy_pair(args) then
        return { args[1], args[2] }
    elseif Vec2.args_are_single_number(args) then
        return { args[1], args[1] }
    end
end

-- Instance Methods --

function Vec2:add(...)
    local args = { ... }
    local other = Vec2.args_to_xy_table(args)
    return Vec2.new(self.x + other[1], self.y + other[2])
end

function Vec2:Add(...)
    local args = { ... }
    local other = Vec2.args_to_xy_table(args)
    self.x = self.x + other[1]
    self.y = self.y + other[2]
    return self
end

function Vec2:angle(...)
    local args = { ... }
    local other = Vec2.args_to_vec2(args)
    local dot_product = self:dot(other)
    local mag_product = self:magnitude() * other:magnitude()
    if mag_product > 0 then
        return math.acos(dot_product / mag_product)
    else
        return 0
    end
end

function Vec2:clone()
    return Vec2.new(self.x, self.y)
end

function Vec2:distance(...)
    local args = { ... }
    local other = Vec2.args_to_xy_table(args)
    local dx = self.x - other[1]
    local dy = self.y - other[2]
    return math.sqrt(dx * dx + dy * dy)
end

function Vec2:div(...)
    local args = { ... }
    local other = Vec2.args_to_xy_table(args)
    return Vec2.new(
        Math.div(self.x, other[1]),
        Math.div(self.x, other[2])
    )
end

function Vec2:Div(...)
    local args = { ... }
    local other = Vec2.args_to_xy_table(args)
    self.x = Math.div(self.x, other[1])
    self.y = Math.div(self.y, other[2])
    return self
end

function Vec2:dot(...)
    local args = { ... }
    local other = Vec2.args_to_xy_table(args)
    return self.x * other[1] + self.y * other[2]
end

function Vec2:lerp(t, ...)
    local args = { ... }
    local other = Vec2.args_to_xy_table(args)
    return Vec2.new(
        (1 - t) * self.x + t * other[1],
        (1 - t) * self.y + t * other[2]
    )
end

function Vec2:lerp_clamped(t, ...)
    t = Math.clamp(t, 0, 1)
    local args = { ... }
    local other = Vec2.args_to_xy_table(args)
    return Vec2.new(
        (1 - t) * self.x + t * other[1],
        (1 - t) * self.y + t * other[2]
    )
end

function Vec2:magnitude()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vec2:mod(...)
    local args = { ... }
    local other = Vec2.args_to_xy_table(args)
    return Vec2.new(
        Math.mod(self.x, other[1]),
        Math.mod(self.y, other[2])
    )
end

function Vec2:Mod(...)
    local args = { ... }
    local other = Vec2.args_to_xy_table(args)
    self.x = Math.mod(self.x, other[1])
    self.y = Math.mod(self.y, other[2])
    return self
end

function Vec2:mult(...)
    local args = { ... }
    local other = Vec2.args_to_xy_table(args)
    return Vec2.new(
        self.x * other[1],
        self.y * other[2]
    )
end

function Vec2:Mult(...)
    local args = { ... }
    local other = Vec2.args_to_xy_table(args)
    self.x = self.x * other[1]
    self.y = self.y * other[2]
    return self
end

function Vec2:neg()
    return Vec2.new(-self.x, -self.y)
end

function Vec2:Neg()
    self.x = -self.x
    self.y = -self.y
    return self
end

function Vec2:normalize()
    local mag = self:magnitude()
    if mag > 0 then
        return Vec2.new(self.x / mag, self.y / mag)
    else
        return Vec2.new(0, 0)
    end
end

function Vec2:pow(...)
    local args = { ... }
    local other = Vec2.args_to_xy_table(args)
    return Vec2.new(
        self.x ^ other[1],
        self.y ^ other[2]
    )
end

function Vec2:Pow(...)
    local args = { ... }
    local other = Vec2.args_to_xy_table(args)
    self.x = self.x ^ other[1]
    self.y = self.y ^ other[2]
    return self
end

function Vec2:print(places)
    places = places or 2

    local element_id = tostring(self.element_id)
    local class_id = tostring(self.class_id)
    local x = tostring(Math.truncate(self.x, places))
    local y = tostring(Math.truncate(self.y, places))

    print("-- Vec2 " .. element_id .. ":" .. class_id .. " --")
    print("  element_id: " .. element_id)
    print("  class_id: " .. class_id)
    print("  x = " .. x)
    print("  y = " .. y)
    print("")
end

function Vec2:reflect(axis)
    if axis == "x" or axis == "X" then
        return Vec2.new(self.x, -self.y)
    elseif axis == "y" or axis == "Y" then
        return Vec2.new(-self.x, self.y)
    else
        return Vec2.new(-self.x, -self.y)
    end
end

function Vec2:Reflect(axis)
    if axis == "x" or axis == "X" then
        self.y = -self.y
    elseif axis == "y" or axis == "Y" then
        self.x = -self.x
    else
        self.y = -self.y
        self.x = -self.x
    end
    return self
end

function Vec2:rotate(angle, pivot)
    pivot = pivot or Vec2.new(0, 0)
    local translated = self:sub(pivot)

    local cos_theta = math.cos(angle)
    local sin_theta = math.sin(angle)

    return Vec2.new(
        translated.x * cos_theta - translated.y * sin_theta,
        translated.x * sin_theta + translated.y * cos_theta
    ):add(pivot)
end

function Vec2:Rotate(angle, pivot)
    pivot = pivot or Vec2.new(0, 0)
    local translated = self:sub(pivot)

    local cos_theta = math.cos(angle)
    local sin_theta = math.sin(angle)

    self.x = translated.x * cos_theta - translated.y * sin_theta
    self.y = translated.x * sin_theta + translated.y * cos_theta

    self:Add(pivot)
    return self
end

function Vec2:scale_about(scalar, ...)
    local args = { ... }
    local other = Vec2.args_to_xy_table(args)
    return Vec2.new(
        other[1] + (self.x - other[1]) * scalar,
        other[2] + (self.y - other[2]) * scalar
    )
end

function Vec2:Scale_about(scalar, ...)
    local args = { ... }
    local other = Vec2.args_to_xy_table(args)
    self.x = other[1] + (self.x - other[1]) * scalar
    self.y = other[2] + (self.y - other[2]) * scalar
    return self
end

function Vec2:Set(...)
    local args = { ... }
    local other = Vec2.args_to_xy_table(args)
    self.x = other[1]
    self.y = other[2]
    return self
end

function Vec2:Set_x(x)
    self.x = x
    return self
end

function Vec2:Set_y(y)
    self.y = y
    return self
end

function Vec2:sub(...)
    local args = { ... }
    local other = Vec2.args_to_xy_table(args)
    return Vec2.new(
        self.x - other[1],
        self.y - other[2]
    )
end

function Vec2:Sub(...)
    local args = { ... }
    local other = Vec2.args_to_xy_table(args)
    self.x = self.x - other[1]
    self.y = self.y - other[2]
    return self
end

function Vec2:squared_magnitude()
    return self.x * self.x + self.y * self.y
end

function Vec2:to_xy_table()
    return { self.x, self.y }
end

function Vec2.docs()
    local docstring = [[
-- Vec2 Class Documentation --
Represents a 2D vector or coordinate pair {x, y}. Commonly used
in 2D graphics, game development, and physics simulations.

:: Attributes ::
.type (string)
    'Vec2'
.element_id (number)
    A globally unique integer id incremented from Element.id.
.class_id: (number)
    A unique class id incremented from Vec2.id.
.x (number)
    x coordinate
.y (number)
    y coordinate

:: Static Methods ::
.is_single_num(a, b)
    param a (number)
        The value to check as a potential sole numeric argument.
    param b (number | nil)
        An optional second number or nil, to confirm if 'a' stands alone.
    Returns
        true if 'a' is a number and 'b' is not provided (nil).
.is_vec2(obj)
    param obj (table)
        The object to be checked if it is an instance of Vec2.
    Returns
        true if obj is of type Vec2.
.is_xy_pair(x, y)
    param x (number)
        The x component of the pair to be checked.
    param y (number)
        The y component of the pair to be checked.
    Returns
        true if x and y are both numbers.
.parse_other(a, b, func_name)
    param a (number | Vec2)
        The first number or Vec2 object to be parsed.
    param b (number | nil)
        The second number or nil if not applicable.
    param func_name (string)
        The name of the function calling for context in error messages.
    Returns
        A new Vec2 instance from the arguments {a, b}.

:: Instance Methods ::
:add(a, b)
    param a (number | Vec2)
        The value or Vec2 to be added to this vector.
    param b (number | nil)
        The value to be added to the y component or nil if not applicable.
    Returns
        A new Vec2 with added values.
:Add(a, b)
    param a (number | Vec2)
        The value or Vec2 to be added to this vector's components.
    param b (number | nil)
        The value to be added to the y component or nil if not applicable.
    Returns
        self, after adding the given values.
:angle(a, b)
    param a (number | Vec2)
        The x component of the Vec2 or the Vec2 itself to find the angle with.
    param b (number | nil)
        The y component of the Vec2 or nil if 'a' is a Vec2.
    Returns
        The angle in radians between this vector and another Vec2 or point.
:distance(a, b)
    param a (number | Vec2)
        The x component of the Vec2 or the Vec2 itself to calculate distance from.
    param b (number | nil)
        The y component of the Vec2 or nil if 'a' is a Vec2.
    Returns
        The distance as a number from this vector to another Vec2 or point.
:div(a, b)
    param a (number | Vec2)
        The divisor, a number or Vec2's x component.
    param b (number | nil)
        The divisor for the y component or nil if 'a' is a Vec2.
    Returns
        A new Vec2 resulting from the division.
:Div(a, b)
    param a (number | Vec2)
        The divisor, a number or Vec2's x component.
    param b (number | nil)
        The divisor for the y component or nil if 'a' is a Vec2.
    Returns
        self, after dividing its components by the given values.
:dot(a, b)
    param a (number | Vec2)
        The x component of the Vec2 or the Vec2 itself to dot with.
    param b (number | nil)
        The y component of the Vec2 or nil if 'a' is a Vec2.
    Returns
        The dot product as a number with another Vec2 or point.
:lerp(t, a, b)
    param t (number)
        The interpolation parameter between 0 and 1.
    param a (number | Vec2)
        The target value to interpolate towards. Can be a single number or a Vec2's x component.
    param b (number | nil)
        The target value for the y component if 'a' is a number; ignored if 'a' is a Vec2.
    Returns
        A new Vec2 resulting from linear interpolation. If 't' is 0, the result is the original Vec2. If 't' is 1, the result is the target Vec2 or number. For values of 't' between 0 and 1, the result is a Vec2 linearly interpolated between the original Vec2 and the target. 't' values beyond 0 and 1 will continue along the line drawn between the Vec2 and its target.

:magnitude()
    Returns
        The magnitude (length) of the vector as a number.
:mod(a, b)
    param a (number | Vec2)
        The modulus, a number or Vec2's x component.
    param b (number | nil)
        The modulus for the y component or nil if 'a' is a Vec2.
    Returns
        A new Vec2 resulting from the modulus operation.
:Mod(a, b)
    param a (number | Vec2)
        The modulus, a number or Vec2's x component.
    param b (number | nil)
        The modulus for the y component or nil if 'a' is a Vec2.
    Returns
        self, after applying the modulus operation to its components.
:mult(a, b)
    param a (number | Vec2)
        The multiplier, a number or Vec2's x component.
    param b (number | nil)
        The multiplier for the y component or nil if 'a' is a Vec2.
    Returns
        A new Vec2 resulting from the multiplication.
:Mult(a, b)
    param a (number | Vec2)
        The value to multiply the x component by, or a Vec2 whose x component
        to multiply with this vector's x component.
    param b (number | nil)
        The value to multiply the y component by if 'a' is a number;
        ignored if 'a' is a Vec2.
    Multiplies the vector's components by the specified values or vector.
    Modifies the vector in place.
    Returns self for method chaining.
:neg()
    Returns a new Vec2 instance with both x and y components negated.
:Neg()
    Negates both x and y components of the vector in place.
    Returns self for method chaining.
:normalize()
    Creates a new Vec2 instance with the vector normalized to unit length.
:Normalize()
    Normalizes the vector in place to unit length.
    Returns self for method chaining.
:reflect(axis)
    param axis (string)
        The axis of reflection. Can be 'x', 'X', 'y', 'Y', or any other value for both axes.
    Returns
        A new Vec2 object. Reflects the vector along the specified axis.
        If 'x' or 'X' is specified, the y component is negated.
        If 'y' or 'Y' is specified, the x component is negated.
        For any other value, both x and y components are negated.
:Reflect(axis)
    param axis (string)
        The axis of reflection. Can be 'x', 'X', 'y', 'Y', or any other value for both axes.
    Returns
        self (Vec2), after reflecting the vector along the specified axis.
        If 'x' or 'X' is specified, the y component of the vector is negated.
        If 'y' or 'Y' is specified, the x component of the vector is negated.
        For any other value, both x and y components of the vector are negated.
:rotate(angle)
    param angle (number)
        The angle in radians to rotate the vector by.
    Returns a new Vec2 instance representing the rotated vector.
:Rotate(angle)
    param angle (number)
        The angle in radians to rotate the vector by.
    Rotates the vector in place by the given angle.
    Returns self for method chaining.
:scale(factor)
    param factor (number)
        The factor by which to scale the vector's components.
    Returns a new Vec2 instance with the vector scaled.
:Scale(factor)
    param factor (number)
        The factor by which to scale the vector's components.
    Scales the vector in place by the given factor.
    Returns self for method chaining.
:Set(a, b)
    param a (number | Vec2)
        The value to set the x component to or a Vec2 whose x component is used.
    param b (number | nil)
        The value to set the y component to if a is a number; ignored if a is Vec2.
    Sets the vector's components and returns self for method chaining.
:Set_X(x)
    param x (number)
        The value to set the x component to.
    Sets the x component of the vector and returns self for method chaining.
:Set_Y(y)
    param y (number)
        The value to set the y component to.
    Sets the y component of the vector and returns self for method chaining.
:sub(a, b)
    param a (number | Vec2)
        The number to subtract from x or a Vec2 whose x component is subtracted.
    param b (number | nil)
        The number to subtract from y if a is a number; ignored if a is Vec2.
    Returns a new Vec2 instance with the result of the subtraction.
:Sub(a, b)
    param a (number | Vec2)
        The number to subtract from x or a Vec2 whose x component is subtracted.
    param b (number | nil)
        The number to subtract from y if a is a number; ignored if a is Vec2.
    Subtracts from the vector's components in place and returns self for chaining.

:squared_magnitude()
Calculates the squared magnitude of the vector.
Returns
    The squared magnitude of the vector, calculated as the sum of the squares of its x and y components (self.x * self.x + self.y * self.y).
    This method avoids the computational cost of a square root operation and is useful for comparing vector lengths or performing threshold checks.
]]

    Debug.print_docstring(docstring)
end


Math = {}
M = Math

function Math.clamp(value, min, max)
    return math.min(math.max(value, min), max)
end

function Math.clamp_normal(value)
    return math.min(math.max(value, 0), 1)
end

function Math.deg_to_rad(degrees)
    return degrees * math.pi / 180
end

function Math.div(a, b)
    return b ~= 0 and a / b or 0
end

function Math.is_positive_int(n)
    return n == math.floor(n) and n >= 0
end

function Math.mod(a, b)
    return b ~= 0 and a % b or 0
end

function Math.mod_to_theta(mod)
    return mod * math.pi * 2
end

function Math.pow(base, exponent)
    if base < 0 and exponent ~= math.floor(exponent) then
        return 0
    else
        return base ^ exponent
    end
end

function Math.round(n, places)
    local s = "%." .. places .. "f"
    return tonumber(string.format(s, n))
end

function Math.soft_clamp(value, min, max)
    local mid = (min + max) / 2
    local range = (max - min) / 2
    return mid + range * math.tanh(2 * (value - mid) / range)
end

function Math.truncate(n, places)
    local factor = 10 ^ places
    return math.floor(n * factor) / factor
end

function Math.map(array, func, args)
    if #array == 0 then return {} end
    if type(array[1]) ~= "table" then
        local result = {}
        for i = 1, #array do
            result[i] = args and func(array[i], args) or func(array[i])
        end
        return result
    end

    local result = {}
    for i = 1, #array do
        result[i] = {}
        for j = 1, #array[i] do
            result[i][j] = args and func(array[i][j], args) or func(array[i][j])
        end
    end
    return result
end

function Math.vmap(array1, array2, func)
    if #array1 ~= #array2 then
        error("Arrays must be of equal length")
    end

    local result = {}
    for i = 1, #array1 do
        table.insert(result, func(array1[i], array2[i]))
    end
    return result
end

function Math.add(x, y)
    return x + y
end

function Math.sub(x, y)
    return x - y
end

function Math.mult(x, y)
    return x * y
end

function Math.docs()
    local docstring = [[
-- Math Class Documentation --
A collection of mathematical utility functions extending Lua's built-in math module.

:: Static Methods ::
.clamp(value, min, max)
    param value (number)
        The number to clamp.
    param min (number)
        The minimum value.
    param max (number)
        The maximum value.
    Returns
        The clamped value within the range [min, max].

.deg_to_rad(degrees)
    param degrees (number)
        The angle in degrees.
    Returns
        The angle in radians.

.div(a, b)
    param a (number)
        The dividend.
    param b (number)
        The divisor.
    Returns
        The result of division a/b, or 0 if b is 0.

.is_positive_int(n)
    param n (number)
        The number to check.
    Returns
        true if 'n' is a positive integer, false otherwise.

.mod(a, b)
    param a (number)
        The dividend.
    param b (number)
        The divisor.
    Returns
        The remainder of a/b, or 0 if b is 0.

.mod_to_theta(mod)
    param mod (number)
        A 0 to 1 modulation signal.
    Returns
        The equivalent theta value in radians.

.pow(base, exponent)
    param base (number)
        The base number to be raised to a power.
    param exponent (number)
        The exponent to which the base number is raised.
    Returns
        The result of raising 'base' to the power of 'exponent'. If 'base' is negative and 'exponent' is not an integer, returns 0 to prevent NaN results.

.round(n, places)
    param n (number)
        The number to round.
    param places (number)
        The number of decimal places to round to.
    Returns
        The number 'n' rounded to 'places' decimal places.

.soft_clamp(value, min, max)
    param value (number)
        The number to soft clamp.
    param min (number)
        The minimum value.
    param max (number)
        The maximum value.
    Returns
        The softly clamped value within the range [min, max].

.truncate(n, places)
    param n (number)
        The number to truncate.
    param places (number)
        The number of decimal places to keep.
    Returns
        The number 'n' truncated to 'places' decimal places.
]]

    Debug.print_docstring(docstring)
end


Element = {}

Element.__index = Element

Element.id = 1


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


Triangle = {}
T = Triangle
Triangle.__index = Triangle

function Triangle.new(vec2_a, vec2_b, vec2_c, color)
    local self = setmetatable({}, Triangle)
    self.vec2_a = vec2_a or { x = 0, y = 0 }
    self.vec2_b = vec2_b or { x = 0, y = 0 }
    self.vec2_c = vec2_c or { x = 0, y = 0 }

    self.z_index = self.options.z_index or 0
    self.color = color or theme.text

    return self
end

function Triangle:draw()
    local paint = color_paint(self.color)
    move_to { self.vec2_a.x, self.vec2_a.y }
    line_to { self.vec2_b.x, self.vec2_b.y }
    line_to { self.vec2_c.x, self.vec2_c.y }
    line_to { self.vec2_a.x, self.vec2_a.y }
    fill(paint)
end

function Triangle:get_vec2s()
    return { vec2_a = self.vec2_a, vec2_b = self.vec2_b, vec2_c = self.vec2_c }
end

function Triangle:get_vec2_a()
    return self.vec2_a
end

function Triangle:get_vec2_b()
    return self.vec2_b
end

function Triangle:get_vec2_c()
    return self.vec2_c
end

function Triangle:Set_vec2s(...)
end

function Triangle:Set_vec2_a(x, y)
    self.vec2_a:Set(x, y)
    return self
end

function Triangle:Set_vec2_b(x, y)
    self.vec2_b:Set(x, y)
    return self
end

function Triangle:Set_vec2_c(x, y)
    self.vec2_c:Set(x, y)
    return self
end

function Triangle:centroid()
    local cx = (self.vec2_a.x + self.vec2_b.x + self.vec2_c.x) / 3
    local cy = (self.vec2_a.y + self.vec2_b.y + self.vec2_c.y) / 3
    return Vec2.new(cx, cy)
end

function Triangle:area()
    local a = self.vec2_a
    local b = self.vec2_b
    local c = self.vec2_c

    local area = 0.5 * math.abs(
        a.x * (b.y - c.y) +
        b.x * (c.y - a.y) +
        c.x * (a.y - b.y)
    )
    return area
end

function Triangle:perimeter()
    local a_b = self.vec2_a:distance(self.vec2_b)
    local b_c = self.vec2_b:distance(self.vec2_c)
    local c_a = self.vec2_c:distance(self.vec2_a)

    local perimeter = a_b + b_c + c_a
    return perimeter
end

function Triangle:type()
    local tolerance = 0.00001
    local a_b = self.vec2_a:distance(self.vec2_b)
    local b_c = self.vec2_b:distance(self.vec2_c)
    local c_a = self.vec2_c:distance(self.vec2_a)

    local ab_bc = math.abs(a_b - b_c) < tolerance
    local ab_ca = math.abs(a_b - c_a) < tolerance
    local bc_ca = math.abs(b_c - c_a) < tolerance

    if ab_bc and ab_ca then
        return "equilateral"
    elseif ab_bc or ab_ca or bc_ca then
        return "isosceles"
    else
        return "scalene"
    end
end

function Triangle:angle_type()
    local vec_a_b = self.vec2_b:sub(self.vec2_a)
    local vec_a_c = self.vec2_c:sub(self.vec2_a)
    local vec_b_a = self.vec2_a:sub(self.vec2_b)
    local vec_b_c = self.vec2_c:sub(self.vec2_b)
    local vec_c_a = self.vec2_a:sub(self.vec2_c)
    local vec_c_b = self.vec2_b:sub(self.vec2_c)

    local dot_a = vec_a_b:dot(vec_a_c)
    local dot_b = vec_b_a:dot(vec_b_c)
    local dot_c = vec_c_a:dot(vec_c_b)

    local isRight = dot_a == 0 or dot_b == 0 or dot_c == 0
    local isObtuse = dot_a < 0 or dot_b < 0 or dot_c < 0

    if isRight then
        return "right"
    elseif isObtuse then
        return "obtuse"
    else
        return "acute"
    end
end

function Triangle:scale(scalar)
    local centroid = self:centroid()

    return Triangle.new(
        self.vec2_a:scale_about(scalar, centroid),
        self.vec2_b:scale_about(scalar, centroid),
        self.vec2_c:scale_about(scalar, centroid)
    )
end

function Triangle:Scale(scalar)
    local centroid = self:centroid()

    self.vec2_a:Scale_about(scalar, centroid)
    self.vec2_b:Scale_about(scalar, centroid)
    self.vec2_c:Scale_about(scalar, centroid)
    return self
end

function Triangle:rotate(angle)
    local centroid = self:centroid()

    local rotate_vertex = function(vertex)
        local translated_vertex = vertex:sub(centroid)
        local rotated_vertex = translated_vertex:rotate(angle)
        return rotated_vertex:add(centroid)
    end

    return Triangle.new(
        rotate_vertex(self.vec2_a),
        rotate_vertex(self.vec2_b),
        rotate_vertex(self.vec2_c)
    )
end

function Triangle:Rotate(angle)
    local centroid = self:centroid()

    local rotate_vertex = function(vertex)
        local translated_vertex = vertex:sub(centroid)
        local rotated_vertex = translated_vertex:rotate(angle)
        return rotated_vertex:add(centroid)
    end

    self.vec2_a = rotate_vertex(self.vec2_a)
    self.vec2_b = rotate_vertex(self.vec2_b)
    self.vec2_c = rotate_vertex(self.vec2_c)
    return self
end

function Triangle:translate(vec2)
    return Triangle.new(
        self.vec2_a:add(vec2),
        self.vec2_b:add(vec2),
        self.vec2_c:add(vec2)
    )
end

function Triangle:Translate(vec2)
    self.vec2_a:add(vec2)
    self.vec2_b:add(vec2)
    self.vec2_c:add(vec2)
    return self
end

function Triangle:bounding_box()
    local min_x = math.min(self.vec2_a.x, self.vec2_b.x, self.vec2_c.x)
    local max_x = math.max(self.vec2_a.x, self.vec2_b.x, self.vec2_c.x)
    local min_y = math.min(self.vec2_a.y, self.vec2_b.y, self.vec2_c.y)
    local max_y = math.max(self.vec2_a.y, self.vec2_b.y, self.vec2_c.y)
    return Vec2.new(min_x, min_y), Vec2.new(max_x, max_y)
end

function Triangle:incircle()
    local a = self.vec2_b:distance(self.vec2_c)
    local b = self.vec2_c:distance(self.vec2_a)
    local c = self.vec2_a:distance(self.vec2_b)
    local s = (a + b + c) / 2
    local area = math.sqrt(s * (s - a) * (s - b) * (s - c))
    local incenterX = (a * self.vec2_a.x + b * self.vec2_b.x + c * self.vec2_c.x) / (a + b + c)
    local incenterY = (a * self.vec2_a.y + b * self.vec2_b.y + c * self.vec2_c.y) / (a + b + c)
    local radius = area / s
    return Vec2.new(incenterX, incenterY), radius
end

function Triangle:circumcircle()
    local a = self.vec2_b:distance(self.vec2_c)
    local b = self.vec2_c:distance(self.vec2_a)
    local c = self.vec2_a:distance(self.vec2_b)
    local s = (a + b + c) / 2
    local area = math.sqrt(s * (s - a) * (s - b) * (s - c))
    local radius = (a * b * c) / (4 * area)
    local ax, ay = self.vec2_a.x, self.vec2_a.y
    local bx, by = self.vec2_b.x, self.vec2_b.y
    local cx, cy = self.vec2_c.x, self.vec2_c.y
    local D = 2 * (
        ax * (by - cy) +
        bx * (cy - ay) +
        cx * (ay - by)
    )
    local Ux = (
        (ax ^ 2 + ay ^ 2) * (by - cy) +
        (bx ^ 2 + by ^ 2) * (cy - ay) +
        (cx ^ 2 + cy ^ 2) * (ay - by)) / D
    local Uy = (
        (ax ^ 2 + ay ^ 2) * (cx - bx) +
        (bx ^ 2 + by ^ 2) * (ax - cx) +
        (cx ^ 2 + cy ^ 2) * (bx - ax)) / D
    return Vec2.new(Ux, Uy), radius
end


-- TODO: triangulation

LineGroup = {}
LG = LineGroup

LineGroup.id = 1

LineGroup.styles = Line.styles

LineGroup.methods = {
    grid = {
        lines = nil,
        v_lines = 10,
        h_lines = 10,
    }
}

LineGroup.__index = Utils.resolve_property

function LineGroup.new(vec2s, options)
    local self = setmetatable({}, LineGroup)
    self.vec2s = vec2s or { Vec2.new(0, 0) }
    self.options = options or {}

    Utils.assign_ids(self)
    Utils.assign_options(self, self.options)
    Color.assign_color(self, self.options)

    self.name = self.name or ("LineGroup " .. self.element_id .. ":" .. self.class_id)
    self.z_index = self.options.z_index or 0
    self.method = self.options.method or "graph"
    self.style = self.options.style or "normal"

    self.__len_vec2s = #self.vec2s

    return self
end

function LineGroup:draw()
    if self.method == "graph" then
        self:graph()
    elseif self.method == "star" then
        self:star()
    elseif self.method == "polyline" then
        self:polyline()
    elseif self.method == "grid" then
        self:grid()
    end
end

function LineGroup:draw_line(line)
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

function LineGroup:graph()
    for i = 1, self.__len_vec2s do
        for j = i + 1, self.__len_vec2s do
            local line = Line.new(self.vec2s[i], self.vec2s[j], self.options)
            self:draw_line(line)
        end
    end
end

function LineGroup:grid()
    local vec2a = self.vec2s[1]
    local vec2b = self.vec2s[2]
    local xd = vec2b.x - vec2a.x
    local yd = vec2b.y - vec2a.y
    local v_iters = self.lines ~= nil and self.lines or self.v_lines
    local h_iters = self.lines ~= nil and self.lines or self.h_lines
    local x_space = xd / v_iters
    local y_space = yd / h_iters
    for i = 0, v_iters do
        local v1 = Vec2.new(vec2a.x + x_space * i, vec2a.y)
        local v2 = Vec2.new(vec2a.x + x_space * i, vec2b.y)
        local v_line = Line.new(v1, v2, self.options)
        self:draw_line(v_line)
    end
    for i = 0, h_iters do
        local h1 = Vec2.new(vec2a.x, vec2a.y + y_space * i)
        local h2 = Vec2.new(vec2b.x, vec2a.y + y_space * i)
        local h_line = Line.new(h1, h2, self.options)
        self:draw_line(h_line)
    end
end

function LineGroup:polyline()
    for i = 2, self.__len_vec2s do
        local line = Line.new(self.vec2s[i - 1], self.vec2s[i], self.options)
        self:draw_line(line)
    end
end

function LineGroup:star()
    for i = 2, self.__len_vec2s do
        local line = Line.new(self.vec2s[1], self.vec2s[i], self.o)
        self:draw_line(line)
    end
end

function LineGroup:print(places)
    places = places or 2

    local element_id = tostring(self.element_id)
    local class_id = tostring(self.class_id)
    local z_index = tostring(self.z_index)
    local style = self.style
    local method = self.method

    print("-- LineGroup " .. element_id .. ":" .. class_id .. " --")
    print("  element_id: " .. element_id)
    print("  class_id: " .. class_id)
    print("  z_index: " .. z_index)
    print("  len_vec2s: " .. tostring(self.__len_vec2s))
    for i, vec2 in ipairs(self.vec2s) do
        local x = tostring(Math.truncate(vec2.x, places))
        local y = tostring(Math.truncate(vec2.y, places))
        print("  vec2_" .. i .. ": { x = " .. x .. ", y = " .. y .. " }")
    end
    print("  method: " .. method)
    if method == "grid" then
        if self.lines ~= nil then
            print("  lines: " .. tostring(self.lines))
        else
            print("  v_lines: " .. tostring(self.v_lines))
            print("  h_lines: " .. tostring(self.h_lines))
        end
    end
    print("  style: " .. style)
    if style == "normal" then
        print("  width: " .. tostring(Math.truncate(self.width, places)))
    elseif style == "dashed" then
        print("  width: " .. tostring(Math.truncate(self.width, places)))
        print("  dash_length: " .. tostring(Math.truncate(self.dash_length, places)))
        print("  space_length: " .. tostring(Math.truncate(self.space_length, places)))
    elseif style == "dotted" then
        print("  dot_radius: " .. tostring(Math.truncate(self.dot_radius, places)))
        print("  space_length: " .. tostring(Math.truncate(self.space_length, places)))
    elseif style == "char" then
        print("  char: " .. self.char)
        print("  char_vertex: " .. self.char_vertex)
        print("  char_vertex nudge: " .. Utils.table_to_string(self.char_vertex_nudge, true, places))
        print("  char_size: " .. tostring(Math.truncate(self.char_size, places)))
        print("  space_length: " .. tostring(Math.truncate(self.space_length, places)))
    end
    if self.gradient == nil then
        print("  color: " .. tostring(Utils.table_to_string(self.color, true, places)))
    else
        print("  gradient: " .. tostring(Utils.table_to_string(self.gradient.color1:table(), true, places))
            .. " → " .. tostring(Utils.table_to_string(self.gradient.color2:table(), true, places)))
    end
    print("")
end


-- TODO - Implement transforms
-- TODO - Implement bounding_box
-- TODO - Ability to reassign objects from one layer to another

Layer = {}
La = Layer

Layer.id = 1

Layer.__index = Layer


function Layer.new(options)
    local self = setmetatable({}, Layer)
    self.options = options or {}

    Utils.assign_ids(self)
    Utils.assign_options(self, self.options)

    self.name = self.name or ("Layer " .. self.element_id .. ":" .. self.class_id)
    self.z_index = options.z_index or 0
    self.contents = options.contents or {}
    self.opacity = options.opacity or 1
    self.hue = options.hue or 0
    self.saturation = options.saturation or 1
    self.lightness = options.lightness or 0.5

    self.superlayer = nil
    self.sublayers = {}

    return self
end

function Layer:__call(...)
    local args = { ... }

    if #args == 1 then
        local arg = args[1]
        if type(arg) == "table" and arg.contents then
            self:add_sublayer(arg)
        else
            self:add_tree(arg)
        end
        return self
    end

    for _, layer in ipairs(args) do
        self:add_sublayer(layer)
    end
    return self
end

-- TODO Inline mode vs expanded
-- TODO fewer decimals
-- TODO print hue
function Layer:__tostring()
    local function tostring_r(layer, depth)
        local indent = (depth > 0) and string.rep("  ", depth - 1) .. "  |- " or ""
        local prefix = (depth > 0) and (layer.name .. ": ") or layer.name .. ": "
        local contents
        if layer.contents.name then
            contents = tostring(layer.contents)
        else
            contents = Utils.get_names(layer.contents)
        end
        local str = indent ..
            prefix ..
            "z_index = " .. tostring(layer.z_index) ..
            ", opacity = " .. tostring(layer.opacity) ..
            ", contents = " .. tostring(contents)

        for _, sublayer in ipairs(layer.sublayers) do
            str = str .. "\n" .. tostring_r(sublayer, depth + 1)
        end

        return str
    end

    return tostring_r(self, 0)
end

function Layer:add_sublayer(layer)
    layer.superlayer = self
    table.insert(self.sublayers, layer)
    return self
end

function Layer:remove_sublayer(layer)
    local index
    for i, v in ipairs(self.sublayers) do
        if v == layer then
            index = i
            break
        end
    end
    if index == nil then return end
    table.remove(self.sublayers, index)
    return self
end

function Layer:sort_sublayers()
    if self.sublayers then
        table.sort(self.sublayers, function(a, b)
            return a.z_index < b.z_index
        end)
    end
end

function Layer:sort_contents()
    if self.contents then
        table.sort(self.contents, function(a, b)
            return a.z_index < b.z_index
        end)
    end
end

function Layer:add_tree(tree)
    for _, l in ipairs(tree) do
        local name = l.name or l.n
        local z_index = l.z_index or l.z
        local contents = l.contents or l.c
        local opacity = l.opacity or l.o
        local hue = l.hue or l.h
        local saturation = l.saturation or l.s
        local lightness = l.lightness or l.l
        local options = {
            name = name,
            z_index = z_index,
            contents = contents,
            opacity = opacity,
            hue = hue,
            saturation = saturation,
            lightness = lightness,
        }
        local layer = Layer.new(options)

        local sublayers = l.sublayers or l.sl
        self:add_sublayer(layer)
        if sublayers then
            layer:add_tree(sublayers)
        end
    end

    return self
end

function Layer:_dfs_sort_and_collect(t)
    if not t then t = {} end
    self:sort_contents()
    self:sort_sublayers()
    for _, layer in ipairs(self.sublayers) do
        layer:_dfs_sort_and_collect(t)
    end
    table.insert(t, self)
    return t
end

function Layer:draw(options)
    options = options or {}
    local sl_opacity = options.sl_opacity or 1
    local opacity = sl_opacity * self.opacity
    local sl_saturation = options.sl_saturation or 1
    local saturation = sl_saturation * self.saturation

    local to_draw = self:_dfs_sort_and_collect()
    for _, layer in ipairs(to_draw) do
        if #layer.contents > 0 then
            if layer.contents.draw then
                layer.contents.color:Opacity(opacity)
                layer.contents.color:Offset_Hue(self.hue)
                layer.contents.color:Saturation(saturation)
                layer.contents:draw()
            else
                for _, obj in ipairs(layer.contents) do
                    obj.color:Opacity(opacity)
                    obj.color:Offset_Hue(self.hue)
                    obj.color:Saturation(saturation)
                    obj:draw()
                end
            end
        end
        if #layer.sublayers > 0 then
            for _, sublayer in ipairs(layer.sublayers) do
                options = {
                    sl_opacity = opacity,
                    sl_hue = self.hue,
                    sl_saturation = saturation
                }
                sublayer:draw(options)
            end
        end
    end
end


Overlay = {}
O = Overlay

Overlay.id = 1

Overlay.__index = Utils.resolve_property

function Overlay.new(origin, options)
    local self = setmetatable({}, Overlay)
    self.origin = origin
    self.options = options or {}

    Utils.assign_ids(self)
    Utils.assign_options(self, self.options)
    Color.assign_color(self, self.options)

    self.name = self.name or ("Overlay " .. self.element_id .. ":" .. self.class_id)
    self.z_index = self.options.z_index or 0
    self.vec2a = self.origin.bottom_left
    self.vec2b = self.origin.top_right
    self.rounded = self.options.rounded or true

    return self
end

function Overlay:draw()
    local paint = Paint.create(self.color, self.gradient)
    local x1, y1, x2, y2, corner_radius

    if self.rounded == true then
        x1 = self.vec2a.x - 10
        y1 = self.vec2a.y - 9.5
        x2 = self.vec2b.x + 9
        y2 = self.vec2b.y + 10
        corner_radius = 6
    else
        x1 = self.vec2a.x - 11
        y1 = self.vec2a.y - 11
        x2 = self.vec2b.x + 11
        y2 = self.vec2b.y + 11
        corner_radius = 0
    end
    fill_rect({ x1, y1 }, { x2, y2 }, corner_radius, paint)
end


Line = {}
L = Line

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

Line.__index = Utils.resolve_property

function Line.new(vec2a, vec2b, options)
    local self = setmetatable({}, Line)
    self.vec2a = vec2a or Vec2.new(0, 0)
    self.vec2b = vec2b or Vec2.new(0, 0)
    self.options = options or {}

    Utils.assign_ids(self)
    Utils.assign_options(self, self.options)
    Color.assign_color(self, self.options)

    self.name = tostring(self.name) or ("Line " .. self.element_id .. ":" .. self.class_id)
    self.z_index = self.options.z_index or 0
    self.style = self.options.style or "normal"

    return self
end

function Line:clone()
    return Factory.clone(self)
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
    local paint = Paint.create(self.color, self.gradient)
    local current_distance = 0

    while current_distance < total_distance do
        local start_dash = self.vec2a:add(direction:mult(current_distance))
        current_distance = math.min(current_distance + self.dash_length, total_distance)
        local end_dash = self.vec2a:add(direction:mult(current_distance))

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
    local paint = Paint.create(self.color, self.gradient)
    local current_distance = 0

    while current_distance <= total_distance do
        local dot_position = self.vec2a:add(direction:mult(current_distance))

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
    local color_table = self.color:table()

    save()
    translate {
        self.vec2a.x + self.char_vertex_nudge[1],
        self.vec2a.y + self.char_vertex_nudge[2]
    }
    scale { char_scale_factor, char_scale_factor }
    text(self.char_vertex, color_table)
    restore()

    local current_distance = self.space_length
    while current_distance < total_distance do
        local char_position = self.vec2a:add(direction:mult(current_distance))

        save()
        translate { char_position.x, char_position.y }
        scale { char_scale_factor, char_scale_factor }
        text(self.char, color_table)
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
        text(self.char_vertex, color_table)
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
    local args = { ... }
    local translation

    if #args == 1 and Vec2.is_vec2(args[1]) then
        translation = args[1]
    elseif #args == 2 and Vec2.is_xy_pair(args[1], args[2]) then
        translation = Vec2.new(args[1], args[2])
    elseif #args == 1 and Vec2.is_single_num() then
        error("Invalid arguments for Translate. Expected Vec2 or two numbers.")
    end

    return Line.new(
        self.vec2a:add(translation),
        self.vec2b:add(translation),
        self.o
    )
end

function Line.parse_args(args)
    if #args == 1 and Vec2.is_vec2(args[1]) then
        return args[1]
    elseif #args == 2 and Vec2.is_xy_pair(args[1], args[2]) then
        return Vec2.new(args[1], args[2])
    else
        error("Invalid arguments for Translate. Expected Vec2 or two numbers.")
    end
end

function Line:Translate(...)
    local args = { ... }
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
    local z_index = tostring(self.z_index)
    local style = self.style
    local gradient = self.gradient


    print("-- Line " .. element_id .. ":" .. class_id .. " --")
    print("  element_id: " .. element_id)
    print("  class_id: " .. class_id)
    print("  vec2_a: { x = " .. ax .. ", y = " .. ay .. " }")
    print("  vec2_b: { x = " .. bx .. ", y = " .. by .. " }")
    print("  z_index: " .. z_index)

    if gradient == nil then
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


-- TODO Add methods for distorting height and width separately
-- TODO Add style for orientation
-- TODO Add style for circular
-- TODO Maybe this is overkill but would be cool to be able to autosize text

Text = {}
Tx = Text
Text.__index = Text

Text.id = 1

function Text.new(string, options)
    local self = setmetatable({}, Text)
    self.string = string or ""
    self.options = options or {}

    Utils.assign_ids(self)

    self.name = self.name or ("Text " .. self.element_id .. ":" .. self.class_id)
    self.vec2 = self.options.vec2 or Vec2.new()
    self.size = self.options.size or 12
    self.color = self.options.color or Color.new(theme.text)

    return self
end

function Text:draw()
    local scale_factor = self.size / 12
    save()
    translate(self.vec2:to_xy_table())
    scale { scale_factor, scale_factor }
    text(self.string, self.color:table())
    restore()
end


function button(x, y, width, options)
    -- Error Handling
    local function checkMutuallyExclusiveArgs(arg1Name, arg1, arg2Name, arg2)
        local e = "MutuallyExclusiveArgError: '%s' and '%s' cannot be used" ..
            "together. Remove one or the other."
        if arg1 and arg2 then
            error(string.format(e, arg1Name, arg2Name))
        end
    end

    -- Optional Keyword Arguments
    local o = options or {}
    local height = o.height or width
    local id = o.id or 0
    local c = o.color or { 1, 1, 1, 1 }

    -- Corner Radius
    local r = o.radius or nil
    local pRadius = o.pRadius or false
    if pRadius then
        checkMutuallyExclusiveArgs("radius", r, "pRadius", pRadius)
        local pRadiusPercent = math.min(o.pRadiusPercent or 10, 50)
        r = width * (pRadiusPercent / 100)
    else
        if r ~= nil and r > width then
            error(string.format("ValueError: Radius cannot exceed size." ..
                "Max: %d, " ..
                "Provided: %d",
                width, r))
        end
    end
    local radius = r or 0

    -- Border
    local border = o.border or false
    local borderWidth = o.borderWidth or 1
    local borderColor = o.borderColor or
        { c[1] * 0.75, c[2] * 0.75, c[3] * 0.75, c[4] }

    -- Initialize coordinates
    local x1 = x
    local y1 = y
    local x2 = x + width
    local y2 = y + height

    -- Touch detector
    local btnTouched = tX >= x1 and tX <= x2 and tY >= y1 and tY <= y2 and t > 0

    -- Shrink on press
    local shrinkOnPress = o.shrinkOnPress or false
    if shrinkOnPress and btnTouched then
        local shrinkPercent = o.shrinkPercent or 90
        local sP = shrinkPercent / 100
        local dX = (x2 - x1) * (1 - sP) / 2
        local dY = (y2 - y1) * (1 - sP) / 2
        x1 = x1 + dX
        y1 = y1 + dY
        x2 = x2 - dX
        y2 = y2 - dY
    end

    -- Padding
    local p = o.pad or nil
    local pPad = o.pPad or false
    if pPad then
        checkMutuallyExclusiveArgs("pad", p, "pPad", pPad)
        local pPadPercent = o.pPadPercent or 5
        p = width * (pPadPercent / 100)
    end
    local pad = p or 0
    x1 = x1 + pad
    y1 = y1 + pad
    x2 = x2 - pad
    y2 = y2 - pad

    -- Pack coordinates
    local pA = { x1, y1 }
    local pB = { x2, y2 }

    -- Draw
    local function drawButton()
        local br = btnTouched and 1 or 0
        local st = grid[id] * 0.5
        local f = math.max(0, math.min(br + st, 1))
        local paint = color_paint(
            { c[1] * f, c[2] * f, c[3] * f, c[4] }
        )
        if not border then
            fill_rect(pA, pB, radius, paint)
        else
            -- Border
            fill_rect(pA, pB, radius, color_paint(borderColor))

            -- Adjust the radius as border gets thicker
            local innerWidth = x2 - x1 - borderWidth
            local innerHeight = y2 - y1 - borderWidth
            local scaleFactor = math.min(innerWidth / (x2 - x1),
                innerHeight / (y2 - y1))
            local adjustedRadius = radius * scaleFactor

            -- Inner rectangle
            local hBW = borderWidth / 2
            local pAB = { x1 + hBW, y1 + hBW }
            local pBB = { x2 - hBW, y2 - hBW }
            fill_rect(pAB, pBB, adjustedRadius, paint)
        end
    end

    drawButton()
end

function tile_button_fn(func, r, c)
    return function(x, y, w, o)
        local h = o.height or w
        for i = 0, c - 1 do
            for j = 0, r - 1 do
                o.id = i + 1 + j * c
                func(x + i * w, y + j * h, w, o)
            end
        end
    end
end


-- TODO Add automatic line breaking
-- TODO Add a way to parse parameters for a Class.docs("short")
-- TODO Add automatic tostring

Debug = {}

function Debug.Logger()
    local queue = {}

    local function add_to_queue(...)
        local statements = {}

        for i = 1, select("#", ...) do
            local arg = select(i, ...)
            if arg == nil then
                statements[i] = "nil"
            elseif arg.__tostring then
                statements[i] = tostring(arg)
            else
                statements[i] = (type(arg) == "table")
                    and Utils.table_to_string(arg) or tostring(arg)
            end
        end

        table.insert(queue, table.concat(statements, ", "))
    end

    local function truncate_and_add_to_queue(places, ...)
        if not Math.is_positive_int(places) then
            error("Error: First argument 'places' must be a positive integer")
        end
        local statements = {}

        for i = 1, select("#", ...) do
            local arg = select(i, ...)
            if arg == nil then
                statements[i] = "nil"
            else
                statements[i] = (type(arg) == "table")
                    and Utils.table_to_string(arg, true, places)
                    or tostring(Math.truncate(arg, places))
            end
        end

        table.insert(queue, table.concat(statements, ", "))
    end

    local function print_queue()
        translate { 0, -30 }
        text(_VERSION, theme.azureHighlight)
        translate { 0, -20 }
        text("Memory Usage: " .. Utils.get_peak_memory(10) .. "KB", theme.text)
        translate { 0, -20 }
        text("Print Queue Output", theme.text)
        translate { 0, -4 }
        text("_________________", theme.text)
        translate { 0, -20 }

        for _, s in ipairs(queue) do
            if s:sub(1, 3) == "-- " or s:sub(1, 1) == "." then
                text("> " .. s, theme.greenHighlight)
            elseif s:sub(1, 3) == ":: " then
                text("> " .. s, theme.azureHighlight)
            elseif string.match(s, "^:%S") then
                text("> " .. s, ColorTables.theme.yellow)
            elseif s:sub(1, 9) == "    param" then
                local scale_factor = 0.75
                local dim_green = {
                    theme.greenHighlight[1] * scale_factor,
                    theme.greenHighlight[2] * scale_factor,
                    theme.greenHighlight[3] * scale_factor,
                    theme.greenHighlight[4]
                }
                text("> " .. s, dim_green)
            elseif s:sub(1, 11) == "    Returns" then
                local scale_factor = 0.8
                local dim_red = {
                    theme.redHighlight[1] * scale_factor,
                    theme.redHighlight[2] * scale_factor,
                    theme.redHighlight[3] * scale_factor,
                    theme.redHighlight[4]
                }
                text("> " .. s, dim_red)
            elseif Utils.has_substring(s, "\n") then
                for line in string.gmatch(s, "([^\n]+)") do
                    text("> " .. line, theme.text)
                    translate { 0, -14 }
                end
            else
                text("> " .. s, theme.text)
            end
            translate { 0, -14 }
        end
    end

    return add_to_queue, truncate_and_add_to_queue, print_queue
end

print, tprint, print_all = Debug.Logger()

function Debug.print_docstring(docstring)
    local newline = "\n"
    local buffer = ""
    for i = 1, #docstring do
        if docstring:sub(i, i) == newline then
            print(buffer)
            buffer = ""
        else
            buffer = buffer .. docstring:sub(i, i)
        end
    end
end


Origin = {}

Origin.id = 1
Origin.created = false

Origin.__index = Utils.resolve_property

function Origin.new(options)
    if Origin.created == true then
        error("Only one instance of Origin is permitted.")
    end

    local self = setmetatable({}, Origin)
    self.options = options or {}

    Utils.assign_ids(self)
    Color.assign_color(self, self.options)

    self.z_index = self.options.z_index or math.huge
    self.direction = self.options.direction or "c"
    self.type = self.options.type or "stroke"
    self.width = self.options.width or 4

    Origin.created = true

    self._offset = Origin._calculate_offset(self.direction)
    self:_calc_and_assign_corners(self.direction)

    translate(self._offset)

    return self
end

function Origin:_assign_corners(t)
    self.top_left = Vec2.new(t[1][1], t[1][2])
    self.top_right = Vec2.new(t[2][1], t[2][2])
    self.bottom_right = Vec2.new(t[3][1], t[3][2])
    self.bottom_left = Vec2.new(t[4][1], t[4][2])
end

function Origin:_calc_and_assign_corners(direction)
    local w = canvas_width
    local h = canvas_height
    local hw = w * 0.5
    local hh = h * 0.5

    local coords = {
        nw = { { 0, 0 }, { w, 0 }, { w, -h }, { 0, -h } },
        n  = { { -hw, 0 }, { hw, 0 }, { hw, -h }, { -hw, -h } },
        ne = { { -w, 0 }, { 0, 0 }, { 0, -h }, { -w, -h } },
        e  = { { -w, hh }, { 0, hh }, { 0, -hh }, { -w, -hh } },
        se = { { -w, h }, { 0, h }, { 0, 0 }, { -w, 0 } },
        s  = { { -hw, h }, { hw, h }, { hw, 0 }, { -hw, 0 } },
        sw = { { 0, h }, { w, h }, { w, 0 }, { 0, 0 } },
        w  = { { 0, hh }, { w, hh }, { w, -hh }, { 0, -hh } },
        c  = { { -hw, hh }, { hw, hh }, { hw, -hh }, { -hw, -hh } }
    }

    self:_assign_corners(coords[direction])
end

function Origin._calculate_offset(direction)
    local w = canvas_width
    local h = canvas_height
    local hw = w / 2
    local hh = h / 2
    local origin_offsets = {
        sw = { 0, 0 },
        w  = { 0, hh },
        nw = { 0, h },
        n  = { hw, h },
        ne = { w, h },
        e  = { w, hh },
        se = { w, 0 },
        s  = { hw, 0 },
        c  = { hw, hh }
    }
    local offset = origin_offsets[direction]
    if type(offset) == nil then
        error("Invalid direction. Must be 'n', 'ne', 'e', 'se', 's', 'sw', 'w', or 'nw'")
    end
    return offset
end

function Origin:draw()
    local paint = Paint.create(self.color, self.gradient)
    if self.type == "stroke" then
        stroke_circle({ 0, 0 }, self.width, 1, paint)
    elseif self.type == "dot" then
        fill_circle({ 0, 0 }, self.width, paint)
    elseif self.type == "crosshair" then
        stroke_segment({ 0, -self.width }, { 0, self.width }, 1, paint)
        stroke_segment({ -self.width, 0 }, { self.width, 0 }, 1, paint)
    end
end

function Origin:reset()
    translate { -self._offset[1], -self._offset[2] }
end


-- TODO Rewrite graph so that it uses the LineGroup function but just draws a thicker line across axes

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


-- AUDULUS-CANVAS LIBRARY ----------------------------------------------
-- Version: 0.0.3-alpha
-- Updated: 2024.01.29
-- URL: https://github.com/markalanboyd/Audulus-Canvas

----- Instructions -----
-- 1. Create 'Time' input (case-sensitive)
-- 2. Attach Timer node to the 'Time' input
-- 3. Select 'Save Data' at the bottom of the inspector panel
-- 4. Set a custom W(idth) and H(eight) in the inspector panel
-- 5. Write your code in the CODE block below

origin = Origin.new({
	direction = "c",
	type = "crosshair",
	width = 4,
	color = theme.text
})

root = Layer.new({name = "ROOT"})
bg = Overlay.new(origin, {name = "Background", color=Color.new(theme.modules)})

-- CODE ----------------------------------------------------------------





-- PRINT CONSOLE -------------------------------------------------------


layer_tree = {
	{name = "BACKGROUND",
	 	z_index = -math.huge,
		contents = {bg}},
	{name = "FOREGROUND",
	 	z_index = math.huge,
		contents = {origin}},
	{name = "LAYER1",
		z_index = 0,
		contents = {},
		sublayers = {
			{name = "NESTED LAYER",
				z_index = 0,
				contents = {},
				sublayers = {} }
		}},
	{name = "LAYER2",
		z_index = 0,
		contents = {},
		sublayers = {} },
		
}

root(layer_tree):draw()
origin:reset()
print(root)
print_all()
