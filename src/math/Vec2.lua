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
    if type(obj) == "table" then
        return obj.type == "Vec2"
    else
        return false
    end
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
    local docstring =
        "-- Vec2 Class Documentation -- \n" ..
        "Represents a 2D vector or coordinate pair {x, y}. Commonly used\n" ..
        "in 2D graphics, game development, and physics simulations.\n" ..
        "\n" ..
        ":: Attributes ::\n" ..
        ".type (string)\n" ..
        "    'Vec2'\n" ..
        ".element_id (number)\n" ..
        "    A globally unique integer id incremented from Element.id.\n" ..
        ".class_id: (number)\n" ..
        "    A unique class id incremented from Vec2.id.\n" ..
        ".x (number)\n" ..
        "    x coordinate\n" ..
        ".y (number)\n" ..
        "    y coordinate\n" ..
        "\n" ..
        ":: Static Methods ::\n" ..
        ".is_single_num(a, b)\n" ..
        "    param a (number)\n" ..
        "        The value to check as a potential sole numeric argument.\n" ..
        "    param b (number | nil)\n" ..
        "        An optional second number or nil, to confirm if 'a' stands alone.\n" ..
        "    Returns\n" ..
        "        true if 'a' is a number and 'b' is not provided (nil).\n" ..
        ".is_vec2(obj)\n" ..
        "    param obj (table)\n" ..
        "        The object to be checked if it is an instance of Vec2.\n" ..
        "    Returns\n" ..
        "        true if obj is of type Vec2.\n" ..
        ".is_xy_pair(x, y)\n" ..
        "    param x (number)\n" ..
        "        The x component of the pair to be checked.\n" ..
        "    param y (number)\n" ..
        "        The y component of the pair to be checked.\n" ..
        "    Returns\n" ..
        "        true if x and y are both numbers.\n" ..
        ".parse_other(a, b, func_name)\n" ..
        "    param a (number | Vec2)\n" ..
        "        The first number or Vec2 object to be parsed.\n" ..
        "    param b (number | nil)\n" ..
        "        The second number or nil if not applicable.\n" ..
        "    param func_name (string)\n" ..
        "        The name of the function calling for context in error messages.\n" ..
        "    Returns\n" ..
        "        A new Vec2 instance from the arguments {a, b}.\n" ..
        "\n" ..
        ":: Instance Methods ::\n" ..
        ":add(a, b)\n" ..
        "    param a (number | Vec2)\n" ..
        "        The value or Vec2 to be added to this vector.\n" ..
        "    param b (number | nil)\n" ..
        "        The value to be added to the y component or nil if not applicable.\n" ..
        "    Returns\n" ..
        "        A new Vec2 with added values.\n" ..
        ":Add(a, b)\n" ..
        "    param a (number | Vec2)\n" ..
        "        The value or Vec2 to be added to this vector's components.\n" ..
        "    param b (number | nil)\n" ..
        "        The value to be added to the y component or nil if not applicable.\n" ..
        "    Returns\n" ..
        "        self, after adding the given values.\n" ..
        ":angle(a, b)\n" ..
        "    param a (number | Vec2)\n" ..
        "        The x component of the Vec2 or the Vec2 itself to find the angle with.\n" ..
        "    param b (number | nil)\n" ..
        "        The y component of the Vec2 or nil if 'a' is a Vec2.\n" ..
        "    Returns\n" ..
        "        The angle in radians between this vector and another Vec2 or point.\n" ..
        ":distance(a, b)\n" ..
        "    param a (number | Vec2)\n" ..
        "        The x component of the Vec2 or the Vec2 itself to calculate distance from.\n" ..
        "    param b (number | nil)\n" ..
        "        The y component of the Vec2 or nil if 'a' is a Vec2.\n" ..
        "    Returns\n" ..
        "        The distance as a number from this vector to another Vec2 or point.\n" ..
        ":div(a, b)\n" ..
        "    param a (number | Vec2)\n" ..
        "        The divisor, a number or Vec2's x component.\n" ..
        "    param b (number | nil)\n" ..
        "        The divisor for the y component or nil if 'a' is a Vec2.\n" ..
        "    Returns\n" ..
        "        A new Vec2 resulting from the division.\n" ..
        ":Div(a, b)\n" ..
        "    param a (number | Vec2)\n" ..
        "        The divisor, a number or Vec2's x component.\n" ..
        "    param b (number | nil)\n" ..
        "        The divisor for the y component or nil if 'a' is a Vec2.\n" ..
        "    Returns\n" ..
        "        self, after dividing its components by the given values.\n" ..
        ":dot(a, b)\n" ..
        "    param a (number | Vec2)\n" ..
        "        The x component of the Vec2 or the Vec2 itself to dot with.\n" ..
        "    param b (number | nil)\n" ..
        "        The y component of the Vec2 or nil if 'a' is a Vec2.\n" ..
        "    Returns\n" ..
        "        The dot product as a number with another Vec2 or point.\n" ..
        ":magnitude()\n" ..
        "    Returns\n" ..
        "        The magnitude (length) of the vector as a number.\n" ..
        ":mod(a, b)\n" ..
        "    param a (number | Vec2)\n" ..
        "        The modulus, a number or Vec2's x component.\n" ..
        "    param b (number | nil)\n" ..
        "        The modulus for the y component or nil if 'a' is a Vec2.\n" ..
        "    Returns\n" ..
        "        A new Vec2 resulting from the modulus operation.\n" ..
        ":Mod(a, b)\n" ..
        "    param a (number | Vec2)\n" ..
        "        The modulus, a number or Vec2's x component.\n" ..
        "    param b (number | nil)\n" ..
        "        The modulus for the y component or nil if 'a' is a Vec2.\n" ..
        "    Returns\n" ..
        "        self, after applying the modulus operation to its components.\n" ..
        ":mult(a, b)\n" ..
        "    param a (number | Vec2)\n" ..
        "        The multiplier, a number or Vec2's x component.\n" ..
        "    param b (number | nil)\n" ..
        "        The multiplier for the y component or nil if 'a' is a Vec2.\n" ..
        "    Returns\n" ..
        "        A new Vec2 resulting from the multiplication.\n" ..
        ":Mult(a, b)\n" ..
        "    param a (number | Vec2)\n" ..
        "        The value to multiply the x component by, or a Vec2 whose x component\n" ..
        "        to multiply with this vector's x component.\n" ..
        "    param b (number | nil)\n" ..
        "        The value to multiply the y component by if 'a' is a number;\n" ..
        "        ignored if 'a' is a Vec2.\n" ..
        "    Multiplies the vector's components by the specified values or vector.\n" ..
        "    Modifies the vector in place.\n" ..
        "    Returns self for method chaining.\n" ..
        ":neg()\n" ..
        "    Returns a new Vec2 instance with both x and y components negated.\n" ..
        ":Neg()\n" ..
        "    Negates both x and y components of the vector in place.\n" ..
        "    Returns self for method chaining.\n" ..
        ":normalize()\n" ..
        "    Creates a new Vec2 instance with the vector normalized to unit length.\n" ..
        ":Normalize()\n" ..
        "    Normalizes the vector in place to unit length.\n" ..
        "    Returns self for method chaining.\n" ..
        ":rotate(angle)\n" ..
        "    param angle (number)\n" ..
        "        The angle in radians to rotate the vector by.\n" ..
        "    Returns a new Vec2 instance representing the rotated vector.\n" ..
        ":Rotate(angle)\n" ..
        "    param angle (number)\n" ..
        "        The angle in radians to rotate the vector by.\n" ..
        "    Rotates the vector in place by the given angle.\n" ..
        "    Returns self for method chaining.\n" ..
        ":scale(factor)\n" ..
        "    param factor (number)\n" ..
        "        The factor by which to scale the vector's components.\n" ..
        "    Returns a new Vec2 instance with the vector scaled.\n" ..
        ":Scale(factor)\n" ..
        "    param factor (number)\n" ..
        "        The factor by which to scale the vector's components.\n" ..
        "    Scales the vector in place by the given factor.\n" ..
        "    Returns self for method chaining.\n" ..
        ":Set(a, b)\n" ..
        "    param a (number | Vec2)\n" ..
        "        The value to set the x component to or a Vec2 whose x component is used.\n" ..
        "    param b (number | nil)\n" ..
        "        The value to set the y component to if a is a number; ignored if a is Vec2.\n" ..
        "    Sets the vector's components and returns self for method chaining.\n" ..
        ":Set_X(x)\n" ..
        "    param x (number)\n" ..
        "        The value to set the x component to.\n" ..
        "    Sets the x component of the vector and returns self for method chaining.\n" ..
        ":Set_Y(y)\n" ..
        "    param y (number)\n" ..
        "        The value to set the y component to.\n" ..
        "    Sets the y component of the vector and returns self for method chaining.\n" ..
        ":sub(a, b)\n" ..
        "    param a (number | Vec2)\n" ..
        "        The number to subtract from x or a Vec2 whose x component is subtracted.\n" ..
        "    param b (number | nil)\n" ..
        "        The number to subtract from y if a is a number; ignored if a is Vec2.\n" ..
        "    Returns a new Vec2 instance with the result of the subtraction.\n" ..
        ":Sub(a, b)\n" ..
        "    param a (number | Vec2)\n" ..
        "        The number to subtract from x or a Vec2 whose x component is subtracted.\n" ..
        "    param b (number | nil)\n" ..
        "        The number to subtract from y if a is a number; ignored if a is Vec2.\n" ..
        "    Subtracts from the vector's components in place and returns self for chaining.\n" ..
        "\n" ..
        ":squared_magnitude()\n" ..
        "    Calculates the squared magnitude of the vector.\n" ..
        "    Returns\n" ..
        "        The squared magnitude of the vector, calculated as the sum of the squares of its x and y components (self.x * self.x + self.y * self.y).\n" ..
        "        This method avoids the computational cost of a square root operation and is useful for comparing vector lengths or performing threshold checks.\n" ..
        "\n"

    Debug.print_docstring(docstring)
end
