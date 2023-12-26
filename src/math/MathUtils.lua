MathUtils = {}

function MathUtils.round(n, places)
    local s = "%." .. places .. "f"
    return tonumber(string.format(s, n))
end

function MathUtils.truncate(n, places)
    return math.floor(n * 10 ^ places) / 10 ^ places
end

function MathUtils.is_positive_int(n)
    return n == math.floor(n) and n >= 0
end
