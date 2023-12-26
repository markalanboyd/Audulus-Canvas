MathUtils = {}

function MathUtils.truncate(n, places)
    local s = "%." .. places .. "f"
    return tonumber(string.format(s, n))
end

function MathUtils.is_positive_int(n)
    return n == math.floor(n) and n >= 0
end
