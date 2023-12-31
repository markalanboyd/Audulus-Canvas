Math = {}

function Math.round(n, places)
    local s = "%." .. places .. "f"
    return tonumber(string.format(s, n))
end

function Math.truncate(n, places)
    return math.floor(n * 10 ^ places) / 10 ^ places
end

function Math.is_positive_int(n)
    return n == math.floor(n) and n >= 0
end

function Math.div(a, b)
    return b ~= 0 and a / b or 0
end

function Math.mod(a, b)
    return b ~= 0 and a % b or 0
end

function Math.mod_to_theta(mod)
    return mod * math.pi * 2
end

function Math.docs()
    local docstring =
        "-- Math Class Documentation -- \n" ..
        "A collection of mathematical utility functions extending Lua's built-in math module.\n" ..
        "\n" ..
        ":: Static Methods ::\n" ..
        ".round(n, places)\n" ..
        "    param n (number)\n" ..
        "        The number to round.\n" ..
        "    param places (number)\n" ..
        "        The number of decimal places to round to.\n" ..
        "    Returns\n" ..
        "        The number 'n' rounded to 'places' decimal places.\n" ..
        "\n" ..
        ".truncate(n, places)\n" ..
        "    param n (number)\n" ..
        "        The number to truncate.\n" ..
        "    param places (number)\n" ..
        "        The number of decimal places to keep.\n" ..
        "    Returns\n" ..
        "        The number 'n' truncated to 'places' decimal places.\n" ..
        "\n" ..
        ".is_positive_int(n)\n" ..
        "    param n (number)\n" ..
        "        The number to check.\n" ..
        "    Returns\n" ..
        "        true if 'n' is a positive integer, false otherwise.\n" ..
        "\n" ..
        ".div(a, b)\n" ..
        "    param a (number)\n" ..
        "        The dividend.\n" ..
        "    param b (number)\n" ..
        "        The divisor.\n" ..
        "    Returns\n" ..
        "        The result of division a/b, or 0 if b is 0.\n" ..
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
        "        The equivalent theta value in radians.\n"

    Debug.print_docstring(docstring)
end
