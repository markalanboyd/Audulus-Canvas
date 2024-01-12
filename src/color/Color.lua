Color = {}
Color.__index = Color

Color.id = 1

function Color.new(color_table)
    local self = setmetatable({}, Color)
    self.type = "Color"
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
    return type(obj) == "table" and obj.type == "Color"
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
        return input
    elseif Color.is_color_table(input) then
        return Color.new(input)
    else
        error("Expected a Color instance or color table.")
    end
end

function Color:Brightness(brightness)
    self.r = self.r * brightness
    self.g = self.g * brightness
    self.b = self.b * brightness
    return self
end

function Color:Invert()
    self.r = 1 - self.r
    self.g = 1 - self.g
    self.b = 1 - self.b
    return self
end

function Color:Opacity(opacity)
    self.a = self.a * opacity
    return self
end

function Color:table()
    return { self.r, self.g, self.b, self.a }
end

function Color:fade(color2, t)
    local new_color = {}
    new_color[1] = self.r + (color2.r - self.r) * t
    new_color[2] = self.g + (color2.g - self.g) * t
    new_color[3] = self.b + (color2.b - self.b) * t
    new_color[4] = self.a + (color2.a - self.a) * t
    return new_color
end
