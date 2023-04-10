--[[

Canvas Node Colors
v1.0.0
April 10, 2023
by Mark Boyd

This file contains functions for creating paint colors and gradients.

The rgb() and hsl() functions can output either paints or color tables.

--]]

function rgb(r, g, b, options)
    --[[
    Uses either 0 to 1 or 0 to 255 values to create a paint or table
    color using the RGB color model.

    Arguments:
    - r (number): red value
    - g (number): green value
    - b (number): blue value
    - options (table): table of optional arguments with default values
        - a (number): alpha value, defaults to 1
        - type (string): type of color, defaults to "paint"
            - "paint": paint color
            - "table": table color (e.g., for text)
        - is8bit (boolean): whether the values are 8-bit, defaults
        to false

    Returns:
    - color (paint or table): paint or table color
    --]]

    local options = options or {}
    local a = options.a or 1
    local type = options.type or "paint"
    local factor = options.is8bit and 1/255 or 1
    
    if type == "paint" then
        return color_paint{r*factor, g*factor, b*factor, a}
    elseif type == "table" then
        return {r*factor, g*factor, b*factor, a}
    end
end

function hsl(h, s, l, options)
    --[[
    Uses either 360/100/100 or normalized 0 to 1 values to create a 
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
    local normalize = options.normalize or false
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

function gradient(x1, y1, x2, y2, color1, options)
    --[[
    Creates a linear gradient between two points.

    Arguments:
    - x1 (number): x-coordinate of first point
    - y1 (number): y-coordinate of first point
    - x2 (number): x-coordinate of second point
    - y2 (number): y-coordinate of second point
    - color1 (table): {r, g, b, a} table color
    - options (table): table of optional arguments with default values
        - color2 (table): {r, g, b, a} table color, defaults to
            fadeTo color
        - fadeTo (string): color to fade to, defaults to "clear"
            - "clear": {0, 0, 0, 0}
            - "black": {0, 0, 0, 1}
            - "white": {1, 1, 1, 1}

    Returns:
    - gradient (paint): linear gradient paint
    --]]

    local fadeToColors = {
        ["clear"] = {0, 0, 0, 0},
        ["black"] = {0, 0, 0, 1},
        ["white"] = {1, 1, 1, 1},
    }

    options = options or {}
    local fadeToColor = fadeToColors[options.fadeTo] or fadeToColors["clear"]
    local color2 = options.color2 or fadeToColor

    return linear_gradient({x1, y1}, {x2, y2}, color1, color2) 
end
