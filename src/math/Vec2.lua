-- TODO file structure like printing for method

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
    return Vec2.new(a.x ^ b.x, a.y ^ b.y)
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

-- Static Methods --

function Vec2.is_single_num(a, b)
    return type(a) == "number" and not b
end

function Vec2.is_vec2(obj)
    return obj.type == "Vec2"
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
    if Vec2.is_single_num(a, b) then
        return Vec2.new(self.x + a, self.y + b)
    elseif Vec2.is_xy_pair(a, b) then
        return Vec2.new(self.x + a, self.y + b)
    elseif Vec2.is_vec2(a) then
        return Vec2.new(self.x + a.x, self.y + a.y)
    else
        error("Invalid arguments for Vec2:add")
    end
end

function Vec2:Add(a, b)
    if Vec2.is_single_num(a, b) then
        self.x = self.x + a
        self.y = self.y + a
    elseif Vec2.is_vec2(a) then
        self.x = self.x + a.x
        self.y = self.y + a.y
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

    if Vec2.is_single_num(a, b) then
        dx = self.x - a
        dy = self.y - a
    elseif Vec2.is_xy_pair(a, b) then
        dx = self.x - a
        dy = self.y - b
    elseif Vec2.is_vec2(a) then
        dx = self.x - a.x
        dy = self.y - a.y
    else
        error("Incorrect arguments to Vec2:distance")
    end

    return math.sqrt(dx * dx + dy * dy)
end

function Vec2:div(a, b)
    if Vec2.is_single_num(a, b) then
        return Vec2.new(
            MathUtils.div(self.x, a),
            MathUtils.div(self.y, a)
        )
    elseif Vec2.is_xy_pair(a, b) then
        return Vec2.new(
            MathUtils.div(self.x, a),
            MathUtils.div(self.y, b)
        )
    elseif Vec2.is_vec2(a) then
        return Vec2.new(
            MathUtils.div(self.x, a.x),
            MathUtils.div(self.y, a.y)
        )
    else
        error("Invalid arguments for Vec2:div")
    end
end

function Vec2:Div(a, b)
    if Vec2.is_single_num(a, b) then
        self.x = MathUtils.div(self.x, a)
        self.y = MathUtils.div(self.y, a)
    elseif Vec2.is_xy_pair(a, b) then
        self.x = MathUtils.div(self.x, a)
        self.y = MathUtils.div(self.y, b)
    elseif Vec2.is_vec2(a) then
        self.x = MathUtils.div(self.x, a.x)
        self.y = MathUtils.div(self.y, a.y)
    else
        error("Invalid arguments for Vec2:Div")
    end
    return self
end

function Vec2:dot(a, b)
    if Vec2.is_single_num(a, b) then
        return self.x * a + self.y * a
    elseif Vec2.is_xy_pair(a, b) then
        return self.x * a + self.y * b
    elseif Vec2.is_vec2(a) then
        return self.x * a.x + self.y * a.y
    else
        error("Invalid arguments to Vec2:dot")
    end
end

function Vec2:magnitude()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vec2:mod(a, b)
    if Vec2.is_single_num(a, b) then
        return Vec2.new(
            MathUtils.mod(self.x, a),
            MathUtils.mod(self.y, a)
        )
    elseif Vec2.is_xy_pair(a, b) then
        return Vec2.new(
            MathUtils.mod(self.x, a),
            MathUtils.mod(self.y, b)
        )
    elseif Vec2.is_vec2(a) then
        return Vec2.new(
            MathUtils.mod(self.x, a.x),
            MathUtils.mod(self.y, a.y)
        )
    else
        error("Invalid arguments for Vec2:mod")
    end
end

function Vec2:Mod(a, b)
    if Vec2.is_single_num(a, b) then
        self.x = MathUtils.mod(self.x, a)
        self.y = MathUtils.mod(self.y, a)
    elseif Vec2.is_xy_pair(a, b) then
        self.x = MathUtils.mod(self.x, a)
        self.y = MathUtils.mod(self.y, b)
    elseif Vec2.is_vec2(a) then
        self.x = MathUtils.mod(self.x, a.x)
        self.y = MathUtils.mod(self.y, a.y)
    else
        error("Invalid arguments for Vec2:mod")
    end
end

function Vec2:mult(a, b)
    if Vec2.is_single_num(a, b) then
        return Vec2.new(self.x * a, self.y * a)
    elseif Vec2.is_xy_pair(a, b) then
        return Vec2.new(self.x * a, self.y * b)
    elseif Vec2.is_vec2(a) then
        return Vec2.new(self.x * a.x, self.y * a.y)
    else
        error("Invalid arguments for Vec2:mult")
    end
end

function Vec2:Mult(a, b)
    if Vec2.is_single_num(a, b) then
        self.x = self.x * a
        self.y = self.y * a
    elseif Vec2.is_xy_pair(a, b) then
        self.x = self.x * a
        self.y = self.y * b
    elseif Vec2.is_vec2(a) then
        self.x = self.x * a.x
        self.y = self.y * a.y
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
    if Vec2.is_single_num(a, b) then
        return Vec2.new(self.x ^ a, self.y ^ a)
    elseif Vec2.is_xy_pair(a, b) then
        return Vec2.new(self.x ^ a, self.y ^ b)
    elseif Vec2.is_vec2(a) then
        return Vec2.new(self.x ^ a.x, self.y ^ a.y)
    else
        error("Invalid arguments for Vec2:pow")
    end
end

function Vec2:Pow(a, b)
    if Vec2.is_single_num(a, b) then
        self.x = self.x ^ a
        self.y = self.y ^ a
    elseif Vec2.is_xy_pair(a, b) then
        self.x = self.x ^ a
        self.y = self.y ^ b
    elseif Vec2.is_vec2(a) then
        self.x = self.x ^ a.x
        self.y = self.y ^ a.y
    else
        error("Invalid arguments for Vec2:Pow")
    end
    return self
end

function Vec2:print(places)
    places = places or 2

    local element_id = tostring(self.element_id)
    local class_id = tostring(self.class_id)
    local x = tostring(MathUtils.truncate(self.x, places))
    local y = tostring(MathUtils.truncate(self.y, places))

    print("-- Vec2 " .. element_id .. ":" .. class_id .. " --")
    print("  element_id: " .. element_id)
    print("  class_id: " .. class_id)
    print("  x = " .. x)
    print("  y = " .. y)
    print("")
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
    if Vec2.is_single_num(a, b) then
        return Vec2.new(
            a + (self.x - a) * scalar,
            a + (self.y - a) * scalar
        )
    elseif Vec2.is_xy_pair(a, b) then
        return Vec2.new(
            a + (self.x - a) * scalar,
            b + (self.y - b) * scalar
        )
    elseif Vec2.is_vec2(a) then
        return Vec2.new(
            a.x + (self.x - a.x) * scalar,
            a.y + (self.y - a.x) * scalar
        )
    else
        error("Invalid arguments to Vec2:scale_about")
    end
end

function Vec2:Scale_about(scalar, a, b)
    if Vec2.is_single_num(a, b) then
        self.x = a + (self.x - a) * scalar
        self.y = a + (self.y - a) * scalar
    elseif Vec2.is_xy_pair(a, b) then
        self.x = a + (self.x - a) * scalar
        self.y = b + (self.y - b) * scalar
    elseif Vec2.is_vec2(a) then
        self.x = a.x + (self.x - a.x) * scalar
        self.y = a.y + (self.y - a.x) * scalar
    else
        error("Invalid arguments to Vec2:Scale_about")
    end
end

function Vec2:Set(a, b)
    if Vec2.is_single_num(a, b) then
        self.x = a
        self.y = a
    elseif Vec2.is_xy_pair(a, b) then
        self.x = a
        self.y = b
    elseif Vec2.is_vec2(a) then
        self.x = a.x
        self.y = a.y
    else
        error("Invalid arguments for Vec2:set")
    end
    return self
end

function Vec2:Set_x(a)
    self.x = a
    return self
end

function Vec2:Set_y(a)
    self.y = a
    return self
end

function Vec2:sub(a, b)
    if Vec2.is_single_num(a, b) then
        return Vec2.new(self.x - a, self.y - a)
    elseif Vec2.is_xy_pair(a, b) then
        return Vec2.new(self.x - a, self.y - b)
    elseif Vec2.is_vec2(a) then
        return Vec2.new(self.x - a.x, self.y - a.y)
    else
        error("Invalid arguments for Vec2:sub")
    end
end

function Vec2:Sub(a, b)
    if Vec2.is_single_num(a, b) then
        self.x = self.x - a
        self.y = self.y - a
    elseif Vec2.is_xy_pair(a, b) then
        self.x = self.x - a
        self.y = self.y - b
    elseif Vec2.is_vec2(a) then
        self.x = self.x - a.x
        self.y = self.y - a.y
    else
        error("Invalid arguments for Vec2:Sub")
    end
    return self
end
