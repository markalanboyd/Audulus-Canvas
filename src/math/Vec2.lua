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

function Vec2.docs()
    local docstring =
        "-- Vec2 Class Documentation -- \n" ..
        "Represents a 2D vector or coordinate pair {x, y}. Commonly used\n" ..
        "in 2D graphics, game development, and physics simulations.\n" ..
        "\n" ..
        ":: Attributes ::\n" ..
        ":type (string)\n" ..
        "    'Vec2'\n" ..
        ":element_id (number)\n" ..
        "    A globally unique integer id incremented from Element.id.\n" ..
        ":class_id: (number)\n" ..
        "    A unique class id incremented from Vec2.id.\n" ..
        ":x (number)\n" ..
        "    x coordinate\n" ..
        ":y (number)\n" ..
        "    y coordinate\n" ..
        "\n" ..
        ":: Static Methods ::\n" ..
        ":is_single_num(a, b)\n" ..
        "     return true if a is a number and b is nil.\n" ..
        ":is_vec2(obj)\n" ..
        "     return true if obj is of type Vec2.\n" ..
        ":is_xy_pair(x, y)\n" ..
        "     return true if x and y are both numbers.\n" ..
        ":parse_other(a, b, func_name)\n" ..
        "    returns a Vec2 from the arguments {a, b}.\n" ..
        "    errors referencing func_name if invalid arguments\n" ..
        "\n" ..
        ":: Instance Methods ::\n" ..
        ":add(a, b)\n" ..
        "    Adds a given value or Vec2 to this vector.\n" ..
        "    If a is a number and b is nil, adds a to both x and y.\n" ..
        "    If a and b are numbers, adds them to x and y respectively.\n" ..
        "    If a is a Vec2, adds its x and y to this vector's x and y.\n" ..
        "    Returns a new Vec2.\n" ..
        ":Add(a, b)\n" ..
        "    Adds a given value or Vec2 to this vector, modifying it.\n" ..
        "    If a is a number and b is nil, adds a to both x and y.\n" ..
        "    If a and b are numbers, adds them to x and y respectively.\n" ..
        "    If a is a Vec2, adds its x and y to this vector's x and y.\n" ..
        "    Returns self.\n" ..
        ":angle(a, b)\n" ..
        "    Calculates the angle between this vector and another Vec2 or point.\n" ..
        "    The other vector or point is defined by a and b.\n" ..
        "    Returns the angle in radians.\n" ..
        ":distance(a, b)\n" ..
        "    Computes the distance from this vector to another Vec2 or point.\n" ..
        "    The other vector or point is defined by a and b.\n" ..
        "    Returns the distance as a number.\n" ..
        ":div(a, b)\n" ..
        "    Divides this vector by a given value or Vec2.\n" ..
        "    If a is a number and b is nil, divides both x and y by a.\n" ..
        "    If a and b are numbers, divides x by a and y by b respectively.\n" ..
        "    If a is a Vec2, divides x by a.x and y by a.y.\n" ..
        "    Returns a new Vec2.\n" ..
        ":Div(a, b)\n" ..
        "    Divides this vector by a given value or Vec2, modifying it.\n" ..
        "    If a is a number and b is nil, divides both x and y by a.\n" ..
        "    If a and b are numbers, divides x by a and y by b respectively.\n" ..
        "    If a is a Vec2, divides x by a.x and y by a.y.\n" ..
        "    Returns self.\n" ..
        ":dot(a, b)\n" ..
        "    Calculates the dot product with another Vec2 or point.\n" ..
        "    The other vector or point is defined by a and b.\n" ..
        "    Returns the dot product as a number.\n" ..
        ":magnitude()\n" ..
        "    Returns the magnitude (length) of the vector.\n" ..
        ":mod(a, b)\n" ..
        "    Applies modulus operation on the vector's components.\n" ..
        "    If a is a number and b is nil, applies modulus to both x and y.\n" ..
        "    If a and b are numbers, applies to x and y respectively.\n" ..
        "    If a is a Vec2, applies to x with a.x and y with a.y.\n" ..
        "    Returns a new Vec2.\n" ..
        ":Mod(a, b)\n" ..
        "    Modifies this vector by applying modulus operation.\n" ..
        "    Follows same rules as :mod(a, b) method.\n" ..
        "    Returns self.\n" ..
        ":mult(a, b)\n" ..
        "    Multiplies the vector by a given value or Vec2.\n" ..
        "    Follows same rules as :add(a, b) for multiplication.\n" ..
        "    Returns a new Vec2.\n" ..
        ":Mult(a, b)\n" ..
        "    Multiplies this vector, modifying its components.\n" ..
        "    Follows same rules as :Mult(a, b) for multiplication.\n" ..
        "    Returns self.\n" ..
        ":neg()\n" ..
        "    Returns a new Vec2 that is the negation of this vector.\n" ..
        ":Neg()\n" ..
        "    Negates this vector's components, modifying it.\n" ..
        "    Returns self.\n" ..
        ":normalize()\n" ..
        "    Returns a new Vec2 that is the normalized version of this vector.\n" ..
        "    Normalization adjusts the vector to unit length.\n" ..
        ":Normalize()\n" ..
        "    Normalizes this vector, modifying its components.\n" ..
        "    Adjusts the vector to unit length and returns self.\n" ..
        ":rotate(angle)\n" ..
        "    Rotates the vector by a given angle in radians.\n" ..
        "    Returns a new Vec2 representing the rotated vector.\n" ..
        ":Rotate(angle)\n" ..
        "    Rotates this vector by a given angle in radians, modifying it.\n" ..
        "    Returns self.\n" ..
        ":scale(factor)\n" ..
        "    Scales the vector by a given factor.\n" ..
        "    Returns a new Vec2 representing the scaled vector.\n" ..
        ":Scale(factor)\n" ..
        "    Scales this vector by a given factor, modifying its components.\n" ..
        "    Returns self.\n" ..
        ":sub(a, b)\n" ..
        "    Subtracts a given value or Vec2 from this vector.\n" ..
        "    Follows same rules as :add(a, b) for subtraction.\n" ..
        "    Returns a new Vec2.\n" ..
        ":Sub(a, b)\n" ..
        "    Subtracts a given value or Vec2 from this vector, modifying it.\n" ..
        "    Follows same rules as :Add(a, b) for subtraction.\n" ..
        "    Returns self.\n" ..
        "\n"
    Debug.print_docstring(docstring)
end

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
