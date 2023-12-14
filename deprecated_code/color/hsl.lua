function hsl(h, s, l, options)
    --[[
    Original Author: Mark Boyd
    Description: Uses either normalized or HSL values to create a 
    paint or table color using the HSL color model.

    Arguments:
    - h (number): hue value (0-360 or 0-1)
    - s (number): saturation value (0-100 or 0-1)
    - l (number): lightness value (0-100 or 0-1)
    - options (table): table of optional arguments with default values
        - a (number): alpha value, defaults to 1
        - type (string): type of color, defaults to "paint"
            - "paint": paint color
            - "table": table color (e.g., for text)
        - normalize (boolean): whether the values are normalized to
            0 to 1, defaults to false

    Returns:
    - color (paint or table): paint or text color
    --]]

    local function hslToRGB(h, s, l)
        if s == 0 then
            return l, l, l
        end

        h = h % 360 / 360
        s = s / 100
        l = l / 100

        local function hueToRGB(p, q, t)
            if t < 0 then t = t + 1 end
            if t > 1 then t = t - 1 end
            if t < 1/6 then return p + (q - p) * 6 * t end
            if t < 1/2 then return q end
            if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
            return p
        end

        local q = l < 0.5 and l * (1 + s) or l + s - l * s
        local p = 2 * l - q
        local r = hueToRGB(p, q, h + 1/3)
        local g = hueToRGB(p, q, h)
        local b = hueToRGB(p, q, h - 1/3)

        return r, g, b
    end

    local options = options or {}
    local a = options.a or 1
    local normalize = options.normalize
    if normalize == nil then normalize = true end
    local paintType = options.type or "paint"
    if normalize then
        h = h * 360
        s = s * 100
        l = l * 100
    end
    local r, g, b = hslToRGB(h, s, l)

    if paintType == "paint" then
        return color_paint{r, g, b, a}
    elseif paintType == "table" then
        return {r, g, b, a}
    end
end
