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
    local docstring =
        "-- Math Class Documentation -- \n" ..
        "A collection of mathematical utility functions extending Lua's built-in math module.\n" ..
        "\n" ..
        ":: Static Methods ::\n" ..
        ".clamp(value, min, max)\n" ..
        "    param value (number)\n" ..
        "        The number to clamp.\n" ..
        "    param min (number)\n" ..
        "        The minimum value.\n" ..
        "    param max (number)\n" ..
        "        The maximum value.\n" ..
        "    Returns\n" ..
        "        The clamped value within the range [min, max].\n" ..
        "\n" ..
        ".deg_to_rad(degrees)\n" ..
        "    param degrees (number)\n" ..
        "        The angle in degrees.\n" ..
        "    Returns\n" ..
        "        The angle in radians.\n" ..
        "\n" ..
        ".div(a, b)\n" ..
        "    param a (number)\n" ..
        "        The dividend.\n" ..
        "    param b (number)\n" ..
        "        The divisor.\n" ..
        "    Returns\n" ..
        "        The result of division a/b, or 0 if b is 0.\n" ..
        "\n" ..
        ".is_positive_int(n)\n" ..
        "    param n (number)\n" ..
        "        The number to check.\n" ..
        "    Returns\n" ..
        "        true if 'n' is a positive integer, false otherwise.\n" ..
        "\n" ..
        ".mod(a, b)\n" ..
        "    param a (number)\n" ..
        "        The dividend.\n" ..
        "    param b (number)\n" ..
        "        The divisor.\n" ..
        "    Returns\n" ..
        "        The remainder of a/b, or 0 if b is 0.\n" ..
        "\n" ..
        ".mod_to_theta(mod)\n" ..
        "    param mod (number)\n" ..
        "        A 0 to 1 modulation signal.\n" ..
        "    Returns\n" ..
        "        The equivalent theta value in radians.\n" ..
        "\n" ..
        ".round(n, places)\n" ..
        "    param n (number)\n" ..
        "        The number to round.\n" ..
        "    param places (number)\n" ..
        "        The number of decimal places to round to.\n" ..
        "    Returns\n" ..
        "        The number 'n' rounded to 'places' decimal places.\n" ..
        "\n" ..
        ".soft_clamp(value, min, max)\n" ..
        "    param value (number)\n" ..
        "        The number to soft clamp.\n" ..
        "    param min (number)\n" ..
        "        The minimum value.\n" ..
        "    param max (number)\n" ..
        "        The maximum value.\n" ..
        "    Returns\n" ..
        "        The softly clamped value within the range [min, max].\n" ..
        "\n" ..
        ".truncate(n, places)\n" ..
        "    param n (number)\n" ..
        "        The number to truncate.\n" ..
        "    param places (number)\n" ..
        "        The number of decimal places to keep.\n" ..
        "    Returns\n" ..
        "        The number 'n' truncated to 'places' decimal places.\n"

    Debug.print_docstring(docstring)
end
