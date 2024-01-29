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
