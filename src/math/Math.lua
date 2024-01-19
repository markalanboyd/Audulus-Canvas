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
    return math.floor(n * 10 ^ places) / 10 ^ places
end

function Math.map(array, func)
    local result = {}
    for i = 1, #array do
        table.insert(result, func(array[i]))
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
