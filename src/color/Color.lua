Color = {}
Color.__index = Color

Color.id = 1

function Color.new(color_table)
    local self = setmetatable({}, Color)
    self.element_id = Element.id
    Element.id = Element.id + 1
    self.class_id = Color.id
    Color.id = Color.id + 1

    self.color_table = color_table or theme.text
    self.r = self.color_table[1]
    self.g = self.color_table[2]
    self.b = self.color_table[3]
    self.a = self.color_table[4]
    return self
end

function Color.is_color(obj)
    return getmetatable(obj) == Color
end

function Color.is_color_table(table)
    return type(table) == "table" and
        #table == 4 and
        type(table[1]) == "number" and
        type(table[2]) == "number" and
        type(table[3]) == "number" and
        type(table[4]) == "number"
end

function Color.assign_color(input)
    if Color.is_color(input) then
        return input:clone()
    elseif Color.is_color_table(input) then
        return Color.new(input)
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
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[1] = h
    local rgba = Color.hsla_to_rgba(hsla)
    return Color.new(rgba)
end

function Color:Hue(hue_normalized)
    local h = hue_normalized * 360
    local hsla = Color.rgba_to_hsla(self:table())
    hsla[1] = h
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
