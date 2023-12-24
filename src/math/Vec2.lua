Vec2 = {}
Vec2.__index = Vec2

function Vec2.new(x, y)
    local self = setmetatable({}, Vec2)
    self.x = x or 0
    self.y = y or 0
    return self
end

function Vec2.is_vec2(obj)
    return type(obj) == "table" and obj.x and obj.y and not obj.z
end

function Vec2.is_xy_pair(x, y)
    return type(x) == "number" and type(y) == "number"
end

function Vec2:Set(x, y)
    if Vec2.is_vec2(x) then
        self.x = x.x
        self.y = x.y
        return self
    elseif Vec2.is_xy_pair(x, y) then
        self.x = x
        self.y = y
        return self
    else
        error("TypeError: Invalid arguments for Vec2:set")
    end
end

function Vec2:add(x, y)
    if Vec2.is_vec2(x) then
        return Vec2.new(self.x + x.x, self.y + x.y)
    elseif Vec2.is_xy_pair(x, y) then
        return Vec2.new(self.x + x, self.y + y)
    else
        error("TypeError: Invalid arguments for Vec2:add")
    end
end

function Vec2:Add(x, y)
    if Vec2.is_vec2(x) then
        self.x = self.x + x.x
        self.y = self.y + x.y
        return self
    elseif Vec2.is_xy_pair(x, y) then
        self.x = self.x + x
        self.y = self.y + y
        return self
    else
        error("TypeError: Invalid arguments for Vec2:Add")
    end
end

function Vec2:sub(x, y)
    if Vec2.is_vec2(x) then
        return Vec2.new(self.x - x.x, self.y - x.y)
    elseif Vec2.is_xy_pair(x, y) then
        return Vec2.new(self.x - x, self.y - y)
    else
        error("TypeError: Invalid arguments for Vec2:sub")
    end
end

function Vec2:Sub(x, y)
    if Vec2.is_vec2(x) then
        self.x = self.x - x.x
        self.y = self.y - y.y
        return self
    elseif Vec2.is_xy_pair(x, y) then
        self.x = self.x - x
        self.y = self.y - y
        return self
    else
        error("TypeError: Invalid arguments for Vec2:Sub")
    end
end

function Vec2:mult(scalar)
    return Vec2.new(self.x * scalar, self.y * scalar)
end

function Vec2:Mult(scalar)
    self.x = self.x * scalar
    self.y = self.y * scalar
    return self
end

function Vec2:magnitude()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vec2:normalize()
    local mag = self:magnitude()
    if mag > 0 then
        return Vec2.new(self.x / mag, self.y / mag)
    else
        return Vec2.new(0, 0)
    end
end

function Vec2:dot(other)
    return self.x * other.x + self.y * other.y
end

function Vec2:angle(other)
    local dot_product = self:dot(other)
    local mag_product = self:magnitude() * other:magnitude()
    if mag_product > 0 then
        return math.acos(dot_product / mag_product)
    else
        return 0
    end
end

function Vec2:rotate(angle)
    local cos_theta = math.cos(angle)
    local sin_theta = math.sin(angle)
    return Vec2.new(
        self.x * cos_theta - self.y * sin_theta,
        self.x * sin_theta + self.y * cos_theta
    )
end

function Vec2:Rotate(angle)
    local cos_theta = math.cos(angle)
    local sin_theta = math.sin(angle)
    self.x = self.x * cos_theta - self.y * sin_theta
    self.y = self.x * sin_theta + self.y * cos_theta
    return self
end

function Vec2:distance(other)
    if Vec2.is_vec2(other) then
        local dx = self.x - other.x
        local dy = self.y - other.y
        return math.sqrt(dx * dx + dy * dy)
    else
        error("TypeError: Argument for Vec2:distance must be a Vec2")
    end
end

function Vec2:scale_about(other, scalar)
    if Vec2.is_vec2(other) then
        return Vec2.new(
            other.x + (self.x - other.x) * scalar,
            other.y + (self.y - other.y) * scalar
        )
    else
        error("TypeError: First argument for Vec2:scale_about must be a Vec2")
    end
end
