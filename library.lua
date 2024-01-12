-- SCROLL TO BOTTOM ----------------------------------------------------

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
ColorTables = {}

ColorTables.htmlColors = { indianred = { 205, 92, 92, 1 }, lightcoral = { 240, 128, 128, 1 }, salmon = { 250, 128, 114, 1 }, darksalmon = { 233, 150, 122, 1 }, lightsalmon = { 255, 160, 122, 1 }, crimson = { 220, 20, 60, 1 }, red = { 255, 0, 0, 1 }, firebrick = { 178, 34, 34, 1 }, darkred = { 139, 0, 0, 1 }, pink = { 255, 192, 203, 1 }, lightpink = { 255, 182, 193, 1 }, hotpink = { 255, 105, 180, 1 }, deeppink = { 255, 20, 147, 1 }, mediumvioletred = { 199, 21, 133, 1 }, palevioletred = { 219, 112, 147, 1 }, coral = { 255, 127, 80, 1 }, tomato = { 255, 99, 71, 1 }, orangered = { 255, 69, 0, 1 }, darkorange = { 255, 140, 0, 1 }, orange = { 255, 165, 0, 1 }, gold = { 255, 215, 0, 1 }, yellow = { 255, 255, 0, 1 }, lightyellow = { 255, 255, 224, 1 }, lemonchiffon = { 255, 250, 205, 1 }, lightgoldenrodyellow = { 250, 250, 210, 1 }, papayawhip = { 255, 239, 213, 1 }, moccasin = { 255, 228, 181, 1 }, peachpuff = { 255, 218, 185, 1 }, palegoldenrod = { 238, 232, 170, 1 }, khaki = { 240, 230, 140, 1 }, darkkhaki = { 189, 183, 107, 1 }, lavender = { 230, 230, 250, 1 }, thistle = { 216, 191, 216, 1 }, plum = { 221, 160, 221, 1 }, violet = { 238, 130, 238, 1 }, orchid = { 218, 112, 214, 1 }, fuchsia = { 255, 0, 255, 1 }, magenta = { 255, 0, 255, 1 }, mediumorchid = { 186, 85, 211, 1 }, mediumpurple = { 147, 112, 219, 1 }, rebeccapurple = { 102, 51, 153, 1 }, blueviolet = { 138, 43, 226, 1 }, darkviolet = { 148, 0, 211, 1 }, darkorchid = { 153, 50, 204, 1 }, darkmagenta = { 139, 0, 139, 1 }, purple = { 128, 0, 128, 1 }, indigo = { 75, 0, 130, 1 }, slateblue = { 106, 90, 205, 1 }, darkslateblue = { 72, 61, 139, 1 }, mediumslateblue = { 123, 104, 238, 1 }, greenyellow = { 173, 255, 47, 1 }, chartreuse = { 127, 255, 0, 1 }, lawngreen = { 124, 252, 0, 1 }, lime = { 0, 255, 0, 1 }, limegreen = { 50, 205, 50, 1 }, palegreen = { 152, 251, 152, 1 }, lightgreen = { 144, 238, 144, 1 }, mediumspringgreen = { 0, 250, 154, 1 }, springgreen = { 0, 255, 127, 1 }, mediumseagreen = { 60, 179, 113, 1 }, seagreen = { 46, 139, 87, 1 }, forestgreen = { 34, 139, 34, 1 }, green = { 0, 128, 0, 1 }, darkgreen = { 0, 100, 0, 1 }, yellowgreen = { 154, 205, 50, 1 }, olivedrab = { 107, 142, 35, 1 }, olive = { 128, 128, 0, 1 }, darkolivegreen = { 85, 107, 47, 1 }, mediumaquamarine = { 102, 205, 170, 1 }, darkseagreen = { 143, 188, 139, 1 }, lightseagreen = { 32, 178, 170, 1 }, darkcyan = { 0, 139, 139, 1 }, teal = { 0, 128, 128, 1 }, aqua = { 0, 255, 255, 1 }, cyan = { 0, 255, 255, 1 }, lightcyan = { 224, 255, 255, 1 }, paleturquoise = { 175, 238, 238, 1 }, aquamarine = { 127, 255, 212, 1 }, turquoise = { 64, 224, 208, 1 }, mediumturquoise = { 72, 209, 204, 1 }, darkturquoise = { 0, 206, 209, 1 }, cadetblue = { 95, 158, 160, 1 }, steelblue = { 70, 130, 180, 1 }, lightsteelblue = { 176, 196, 222, 1 }, powderblue = { 176, 224, 230, 1 }, lightblue = { 173, 216, 230, 1 }, skyblue = { 135, 206, 235, 1 }, lightskyblue = { 135, 206, 250, 1 }, deepskyblue = { 0, 191, 255, 1 }, dodgerblue = { 30, 144, 255, 1 }, cornflowerblue = { 100, 149, 237, 1 }, royalblue = { 65, 105, 225, 1 }, blue = { 0, 0, 255, 1 }, mediumblue = { 0, 0, 205, 1 }, darkblue = { 0, 0, 139, 1 }, navy = { 0, 0, 128, 1 }, midnightblue = { 25, 25, 112, 1 }, cornsilk = { 255, 248, 220, 1 }, blanchedalmond = { 255, 235, 205, 1 }, bisque = { 255, 228, 196, 1 }, navajowhite = { 255, 222, 173, 1 }, wheat = { 245, 222, 179, 1 }, burlywood = { 222, 184, 135, 1 }, tan = { 210, 180, 140, 1 }, rosybrown = { 188, 143, 143, 1 }, sandybrown = { 244, 164, 96, 1 }, goldenrod = { 218, 165, 32, 1 }, darkgoldenrod = { 184, 134, 11, 1 }, peru = { 205, 133, 63, 1 }, chocolate = { 210, 105, 30, 1 }, saddlebrown = { 139, 69, 19, 1 }, sienna = { 160, 82, 45, 1 }, brown = { 165, 42, 42, 1 }, maroon = { 128, 0, 0, 1 }, white = { 255, 255, 255, 1 }, snow = { 255, 250, 250, 1 }, honeydew = { 240, 255, 240, 1 }, mintcream = { 245, 255, 250, 1 }, azure = { 240, 255, 255, 1 }, aliceblue = { 240, 248, 255, 1 }, ghostwhite = { 248, 248, 255, 1 }, whitesmoke = { 245, 245, 245, 1 }, seashell = { 255, 245, 238, 1 }, beige = { 245, 245, 220, 1 }, oldlace = { 253, 245, 230, 1 }, floralwhite = { 255, 250, 240, 1 }, ivory = { 255, 255, 240, 1 }, antiquewhite = { 250, 235, 215, 1 }, linen = { 250, 240, 230, 1 }, lavenderblush = { 255, 240, 245, 1 }, mistyrose = { 255, 228, 225, 1 }, gainsboro = { 220, 220, 220, 1 }, lightgray = { 211, 211, 211, 1 }, silver = { 192, 192, 192, 1 }, darkgray = { 169, 169, 169, 1 }, gray = { 128, 128, 128, 1 }, dimgray = { 105, 105, 105, 1 }, lightslategray = { 119, 136, 153, 1 }, slategray = { 112, 128, 144, 1 }, darkslategray = { 47, 79, 79, 1 }, black = { 0, 0, 0, 1 } }
ColorUtils = {}

ColorUtils.theme_yellow = { 0.83, 1, 0, 1 }

function ColorUtils.is_valid_hex_code(s)
    s = s:gsub("#", "")
    local invalidChars = string.match(s, "[^0-9a-fA-F]+")
    local hasValidChars = invalidChars == nil
    local isValidLen = #s == 3 or #s == 4 or #s == 6 or #s == 8
    return hasValidChars and isValidLen
end

function ColorUtils.hex_code_to_color(s)
    if not ColorUtils.is_valid_hex_code(s) then
        error("ValueError: Not a valid hex code.")
    end

    s = tostring(s):gsub("#", "")
    local color = {}
    if #s == 3 or #s == 4 then
        table.insert(color, tonumber(s:sub(1, 1):rep(2), 16) / 255)
        table.insert(color, tonumber(s:sub(2, 2):rep(2), 16) / 255)
        table.insert(color, tonumber(s:sub(3, 3):rep(2), 16) / 255)
        table.insert(color, (#s == 4) and tonumber(s:sub(4, 4):rep(2), 16) / 255 or 1)
    elseif #s == 6 or #s == 8 then
        table.insert(color, tonumber(s:sub(1, 2), 16) / 255)
        table.insert(color, tonumber(s:sub(3, 4), 16) / 255)
        table.insert(color, tonumber(s:sub(5, 6), 16) / 255)
        table.insert(color, (#s == 8) and tonumber(s:sub(7, 8), 16) / 255 or 1)
    end

    return color
end
Utils = {}

function Utils.process_args(class_meta, ...)
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

function Utils.has_non_integer_keys(t)
    for k, _ in pairs(t) do
        if type(k) ~= "number" or k ~= math.floor(k) or k < 1 then
            return true
        end
    end
    return false
end

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
Vec2 = {}
Vec2.__index = Vec2

Vec2.id = 1

function Vec2.new(x, y)
    local self = setmetatable({}, Vec2)
    self.type = "Vec2"
    self.element_id = Element.id
    Element.id = Element.id + 1
    self.class_id = Vec2.id
    Vec2.id = Vec2.id + 1

    self.x = x or 0
    self.y = y or 0
    return self
end

-- Metamethods --

function Vec2.__add(a, b)
    return Vec2.new(a.x + b.x, a.y + b.y)
end

function Vec2.__sub(a, b)
    return Vec2.new(a.x - b.x, a.y - b.y)
end

function Vec2.__mul(a, b)
    return Vec2.new(a.x * b.x, a.y * b.y)
end

function Vec2.__div(a, b)
    local x = b.x ~= 0 and a.x / b.x or 0
    local y = b.y ~= 0 and a.y / b.y or 0
    return Vec2.new(x, y)
end

function Vec2.__mod(a, b)
    local x = b.x ~= 0 and a.x % b.x or 0
    local y = b.y ~= 0 and a.y % b.y or 0
    return Vec2.new(x, y)
end

function Vec2.__unm(a)
    return Vec2.new(-a.x, -a.y)
end

function Vec2.__pow(a, b)
    return Vec2.new(Math.pow(a.x, b.x), Math.pow(a.y, b.y))
end

function Vec2.__eq(a, b)
    return a.x == b.x and a.y == b.y
end

function Vec2.__lt(a, b)
    return a:magnitude() < b:magnitude()
end

function Vec2.__le(a, b)
    return a:magnitude() <= b:magnitude()
end

function Vec2.__tostring(a)
    return "{ x = " .. a.x .. ", y = " .. a.y .. " }"
end

function Vec2.__concat(a, b)
    local x = tonumber(tostring(a.x) .. tostring(b.x))
    local y = tonumber(tostring(a.y) .. tostring(b.y))
    return Vec2.new(x, y)
end

function Vec2.is_single_num(a, b)
    return type(a) == "number" and not b
end

function Vec2.is_vec2(obj)
    return type(obj) == "table" and obj.type == "Vec2"
end

function Vec2.is_xy_pair(x, y)
    return type(x) == "number" and type(y) == "number"
end

function Vec2.parse_other(a, b, func_name)
    if Vec2.is_single_num(a, b) then
        return Vec2.new(a, a)
    elseif Vec2.is_xy_pair(a, b) then
        return Vec2.new(a, b)
    elseif Vec2.is_vec2(a) then
        return a
    else
        error("Invalid arguments to " .. func_name)
    end
end

-- Instance Methods --

function Vec2:add(a, b)
    if Vec2.is_vec2(a) then
        return Vec2.new(self.x + a.x, self.y + a.y)
    elseif Vec2.is_single_num(a, b) then
        return Vec2.new(self.x + a, self.y + a)
    elseif Vec2.is_xy_pair(a, b) then
        return Vec2.new(self.x + a, self.y + b)
    else
        error("Invalid arguments for Vec2:add")
    end
end

function Vec2:Add(a, b)
    if Vec2.is_vec2(a) then
        self.x = self.x + a.x
        self.y = self.y + a.y
    elseif Vec2.is_single_num(a, b) then
        self.x = self.x + a
        self.y = self.y + a
    elseif Vec2.is_xy_pair(a, b) then
        self.x = self.x + a
        self.y = self.y + b
    else
        error("Invalid arguments for Vec2:Add")
    end
    return self
end

function Vec2:angle(a, b)
    local other = Vec2.parse_other(a, b, "Vec2:angle")
    local dot_product = self:dot(other)
    local mag_product = self:magnitude() * other:magnitude()
    if mag_product > 0 then
        return math.acos(dot_product / mag_product)
    else
        return 0
    end
end

function Vec2:distance(a, b)
    local dx
    local dy

    if Vec2.is_vec2(a) then
        dx = self.x - a.x
        dy = self.y - a.y
    elseif Vec2.is_single_num(a, b) then
        dx = self.x - a
        dy = self.y - a
    elseif Vec2.is_xy_pair(a, b) then
        dx = self.x - a
        dy = self.y - b
    else
        error("Incorrect arguments to Vec2:distance")
    end

    return math.sqrt(dx * dx + dy * dy)
end

function Vec2:div(a, b)
    if Vec2.is_vec2(a) then
        return Vec2.new(
            Math.div(self.x, a.x),
            Math.div(self.y, a.y)
        )
    elseif Vec2.is_single_num(a, b) then
        return Vec2.new(
            Math.div(self.x, a),
            Math.div(self.y, a)
        )
    elseif Vec2.is_xy_pair(a, b) then
        return Vec2.new(
            Math.div(self.x, a),
            Math.div(self.y, b)
        )
    else
        error("Invalid arguments for Vec2:div")
    end
end

function Vec2:Div(a, b)
    if Vec2.is_vec2(a) then
        self.x = Math.div(self.x, a.x)
        self.y = Math.div(self.y, a.y)
    elseif Vec2.is_single_num(a, b) then
        self.x = Math.div(self.x, a)
        self.y = Math.div(self.y, a)
    elseif Vec2.is_xy_pair(a, b) then
        self.x = Math.div(self.x, a)
        self.y = Math.div(self.y, b)
    else
        error("Invalid arguments for Vec2:Div")
    end
    return self
end

function Vec2:dot(a, b)
    if Vec2.is_vec2(a) then
        return self.x * a.x + self.y * a.y
    elseif Vec2.is_single_num(a, b) then
        return self.x * a + self.y * a
    elseif Vec2.is_xy_pair(a, b) then
        return self.x * a + self.y * b
    else
        error("Invalid arguments to Vec2:dot")
    end
end

function Vec2:lerp(t, a, b)
    if Vec2.is_vec2(a) then
        return Vec2.new(
            (1 - t) * self.x + t * a.x,
            (1 - t) * self.y + t * a.y
        )
    elseif Vec2.is_single_num(a, b) then
        return Vec2.new(
            (1 - t) * self.x + t * a,
            (1 - t) * self.y + t * a
        )
    elseif Vec2.is_xy_pair(a, b) then
        return Vec2.new(
            (1 - t) * self.x + t * a,
            (1 - t) * self.y + t * b
        )
    else
        error("Invalid arguments to Vec2:lerp")
    end
end

function Vec2:lerp_clamped(t, a, b)
    t = Math.clamp(t, 0, 1)
    if Vec2.is_vec2(a) then
        return Vec2.new(
            (1 - t) * self.x + t * a.x,
            (1 - t) * self.y + t * a.y
        )
    elseif Vec2.is_single_num(a, b) then
        return Vec2.new(
            (1 - t) * self.x + t * a,
            (1 - t) * self.y + t * a
        )
    elseif Vec2.is_xy_pair(a, b) then
        return Vec2.new(
            (1 - t) * self.x + t * a,
            (1 - t) * self.y + t * b
        )
    else
        error("Invalid arguments to Vec2:lerp_clamped")
    end
end

function Vec2:magnitude()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vec2:mod(a, b)
    if Vec2.is_vec2(a) then
        return Vec2.new(
            Math.mod(self.x, a.x),
            Math.mod(self.y, a.y)
        )
    elseif Vec2.is_single_num(a, b) then
        return Vec2.new(
            Math.mod(self.x, a),
            Math.mod(self.y, a)
        )
    elseif Vec2.is_xy_pair(a, b) then
        return Vec2.new(
            Math.mod(self.x, a),
            Math.mod(self.y, b)
        )
    else
        error("Invalid arguments for Vec2:mod")
    end
end

function Vec2:Mod(a, b)
    if Vec2.is_vec2(a) then
        self.x = Math.mod(self.x, a.x)
        self.y = Math.mod(self.y, a.y)
    elseif Vec2.is_single_num(a, b) then
        self.x = Math.mod(self.x, a)
        self.y = Math.mod(self.y, a)
    elseif Vec2.is_xy_pair(a, b) then
        self.x = Math.mod(self.x, a)
        self.y = Math.mod(self.y, b)
    else
        error("Invalid arguments for Vec2:mod")
    end
end

function Vec2:mult(a, b)
    if Vec2.is_vec2(a) then
        return Vec2.new(self.x * a.x, self.y * a.y)
    elseif Vec2.is_single_num(a, b) then
        return Vec2.new(self.x * a, self.y * a)
    elseif Vec2.is_xy_pair(a, b) then
        return Vec2.new(self.x * a, self.y * b)
    else
        error("Invalid arguments for Vec2:mult")
    end
end

function Vec2:Mult(a, b)
    if Vec2.is_vec2(a) then
        self.x = self.x * a.x
        self.y = self.y * a.y
    elseif Vec2.is_single_num(a, b) then
        self.x = self.x * a
        self.y = self.y * a
    elseif Vec2.is_xy_pair(a, b) then
        self.x = self.x * a
        self.y = self.y * b
    else
        error("Invalid arguments for Vec2:Mult")
    end
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

function Vec2:pow(a, b)
    if Vec2.is_vec2(a) then
        return Vec2.new(self.x ^ a.x, self.y ^ a.y)
    elseif Vec2.is_single_num(a, b) then
        return Vec2.new(self.x ^ a, self.y ^ a)
    elseif Vec2.is_xy_pair(a, b) then
        return Vec2.new(self.x ^ a, self.y ^ b)
    else
        error("Invalid arguments for Vec2:pow")
    end
end

function Vec2:Pow(a, b)
    if Vec2.is_vec2(a) then
        self.x = self.x ^ a.x
        self.y = self.y ^ a.y
    elseif Vec2.is_single_num(a, b) then
        self.x = self.x ^ a
        self.y = self.y ^ a
    elseif Vec2.is_xy_pair(a, b) then
        self.x = self.x ^ a
        self.y = self.y ^ b
    else
        error("Invalid arguments for Vec2:Pow")
    end
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

function Vec2:scale_about(scalar, a, b)
    if Vec2.is_vec2(a) then
        return Vec2.new(
            a.x + (self.x - a.x) * scalar,
            a.y + (self.y - a.y) * scalar
        )
    elseif Vec2.is_single_num(a, b) then
        return Vec2.new(
            a + (self.x - a) * scalar,
            a + (self.y - a) * scalar
        )
    elseif Vec2.is_xy_pair(a, b) then
        return Vec2.new(
            a + (self.x - a) * scalar,
            b + (self.y - b) * scalar
        )
    else
        error("Invalid arguments to Vec2:scale_about")
    end
end

function Vec2:Scale_about(scalar, a, b)
    if Vec2.is_vec2(a) then
        self.x = a.x + (self.x - a.x) * scalar
        self.y = a.y + (self.y - a.y) * scalar
    elseif Vec2.is_single_num(a, b) then
        self.x = a + (self.x - a) * scalar
        self.y = a + (self.y - a) * scalar
    elseif Vec2.is_xy_pair(a, b) then
        self.x = a + (self.x - a) * scalar
        self.y = b + (self.y - b) * scalar
    else
        error("Invalid arguments to Vec2:Scale_about")
    end
end

function Vec2:Set(a, b)
    if Vec2.is_vec2(a) then
        self.x = a.x
        self.y = a.y
    elseif Vec2.is_single_num(a, b) then
        self.x = a
        self.y = a
    elseif Vec2.is_xy_pair(a, b) then
        self.x = a
        self.y = b
    else
        error("Invalid arguments for Vec2:set")
    end
    return self
end

function Vec2:Set_X(x)
    self.x = x
    return self
end

function Vec2:Set_Y(y)
    self.y = y
    return self
end

function Vec2:sub(a, b)
    if Vec2.is_vec2(a) then
        return Vec2.new(self.x - a.x, self.y - a.y)
    elseif Vec2.is_single_num(a, b) then
        return Vec2.new(self.x - a, self.y - a)
    elseif Vec2.is_xy_pair(a, b) then
        return Vec2.new(self.x - a, self.y - b)
    else
        error("Invalid arguments for Vec2:sub")
    end
end

function Vec2:Sub(a, b)
    if Vec2.is_vec2(a) then
        self.x = self.x - a.x
        self.y = self.y - a.y
    elseif Vec2.is_single_num(a, b) then
        self.x = self.x - a
        self.y = self.y - a
    elseif Vec2.is_xy_pair(a, b) then
        self.x = self.x - a
        self.y = self.y - b
    else
        error("Invalid arguments for Vec2:Sub")
    end
    return self
end

function Vec2:squared_magnitude()
    return self.x * self.x + self.y * self.y
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

function Math.clamp(value, min, max)
    return math.min(math.max(value, min), max)
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
    return math.floor(n * 10 ^ places) / 10 ^ places
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
Point = {}

Point.id = 1

Point.attrs = {
    color = theme.text,
    show_coords = false,
    coords_nudge = { 0, 0 }
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

Point.__index = function(instance, key)
    local value = rawget(instance, key)
    if value ~= nil then
        return value
    end

    local style = rawget(instance, "style") or "normal"
    local style_val = Point.styles[style][key]
    if style_val ~= nil then
        return style_val
    end

    local attr = Point.attrs[key]
    if attr ~= nil then
        return attr
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

    for key, value in pairs(self.o) do
        self[key] = value
    end

    self.style = self.o.style or "normal"
    local c = self.o.color or Color.new()
    self.color = Color.assign_color(c)

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
    fill_circle(
        { self.vec2.x, self.vec2.y },
        self.radius,
        color_paint(self.color:table())
    )
end

function Point:draw_stroke()
    stroke_circle(
        { self.vec2.x, self.vec2.y },
        self.radius,
        self.stroke_width,
        color_paint(self.color:table()))
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

function Point:print(places)
    places = places or 2

    local element_id = tostring(self.element_id)
    local class_id = tostring(self.class_id)
    local x = tostring(Math.truncate(self.vec2.x, places))
    local y = tostring(Math.truncate(self.vec2.y, places))
    local color = tostring(Utils.table_to_string(self.color:table(), true, places))
    local style = self.style

    print("-- Point " .. element_id .. ":" .. class_id .. " --")
    print("  element_id: " .. element_id)
    print("  class_id: " .. class_id)
    print("  vec2: { x = " .. x .. ", y = " .. y .. " }")
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
-- TODO Add a method to force origin to stay on top

Origin = {}
Origin.__index = Origin

function Origin.new(direction, options)
    local self = setmetatable({}, Origin)
    local o = options or {}

    self.direction = direction or "sw"
    self.show = o.show or false
    self.type = string.lower(o.type) or "stroke"
    self.width = o.width or 4
    self.color = o.color or theme.text
    self.offset = self.calculate_offset(direction)

    translate(self.offset)

    if self.show then
        local paint = color_paint(self.color)
        if self.type == "stroke" or self.type == "outline" then
            stroke_circle({ 0, 0 }, self.width, 1, paint)
        elseif self.type == "fill" or self.type == "dot" then
            fill_circle({ 0, 0 }, self.width, paint)
        elseif self.type == "+" or self.type == "cross" then
            stroke_segment({ 0, -self.width }, { 0, self.width }, 1, paint)
            stroke_segment({ -self.width, 0 }, { self.width, 0 }, 1, paint)
        end
    end

    return self
end

function Origin.calculate_offset(direction)
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
        c  = { hw, hw }
    }
    local offset = origin_offsets[string.lower(direction)]
    if type(offset) == nil then
        error("Invalid direction. Must be 'n', 'ne', 'e', 'se', 's', 'sw', 'w', or 'nw'")
    end
    return offset
end

function Origin:reset()
    translate { -self.offset[1], -self.offset[2] }
end
Triangle = {}
Triangle.__index = Triangle

function Triangle.new(vec2_a, vec2_b, vec2_c, color)
    local self = setmetatable({}, Triangle)
    self.vec2_a = vec2_a or { x = 0, y = 0 }
    self.vec2_b = vec2_b or { x = 0, y = 0 }
    self.vec2_c = vec2_c or { x = 0, y = 0 }
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
-- TODO - Set a background that is always the lowest layer
-- TODO - Set a foreground that is always the highest layer
-- TODO - Attach origin to background/foreground based on preference
Layer = {}
Layer.__index = Layer
Layer.layers = {}

function Layer.new(z_index)
    local self = setmetatable({}, Layer)
    self.z_index = z_index or 0
    self.objects = {}
    table.insert(Layer.layers, self)
    return self
end

function Layer.draw_all()
    table.sort(Layer.layers, function(a, b) return a.z_index < b.z_index end)
    for _, layer in ipairs(Layer.layers) do
        layer:draw()
    end
end

function Layer:add(object, draw_function_name)
    draw_function_name = draw_function_name or "draw"
    table.insert(self.objects, { object = object, draw_function = draw_function_name })
end

function Layer:draw()
    for _, item in ipairs(self.objects) do
        local obj = item.object
        local draw_function = item.draw_function
        if obj[draw_function] then
            obj[draw_function](obj)
        end
    end
end
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
    self.type = "Line"
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
    self.type = "LineGroup"
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

Debug = {}

function Debug.Logger()
    local queue = {}

    local function add_to_queue(...)
        local statements = {}

        for i = 1, select("#", ...) do
            local arg = select(i, ...)
            if arg == nil then
                statements[i] = "nil"
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
                text("> " .. s, ColorUtils.theme_yellow)
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
-- Version: 0.0.2-alpha
-- Updated: 2023.12.26
-- URL: https://github.com/markalanboyd/Audulus-Canvas

----- Instructions -----
-- 1. Create 'Time' input (case-sensitive)
-- 2. Attach Timer node to the 'Time' input
-- 3. Select 'Save Data' at the bottom of the inspector panel
-- 4. Set a custom W(idth) and H(eight) in the inspector panel
-- 5. Write your code in the CODE block below

o = Origin.new(\"c\", {show = true, type = \"cross\", width = 4, color = theme.text})

-- CODE ----------------------------------------------------------------

-- PRINT CONSOLE -------------------------------------------------------

o:reset()
print_all()
