--[[
This file contains functions for creating paint colors and gradients.

The rgb() and hsl() functions can output either paint or text colors.
]]


function rgb(r, g, b, options)
    --[[
    Uses either 0 to 1 or 0 to 255 values to create a paint or text
    color using the RGB color model.

    Arguments:
    - r (number): red value
    - g (number): green value
    - b (number): blue value
    - options (table): table of optional arguments with default values
        - a (number): alpha value, defaults to 1
        - type (string): type of color, defaults to "paint"
        - is8bit (boolean): whether the values are 8-bit, defaults
        to false

    Returns:
    - color (paint or table): paint or text color
    ]]

    local options = options or {}
    local a = options.a or 1
    local type = options.type or "paint"
    local factor = options.is8bit and 1/255 or 1
    
    if type == "paint" then
        return color_paint{r*factor, g*factor, b*factor, a}
    elseif type == "text" then
        return {r*factor, g*factor, b*factor, a}
    end
end

function hsl(h, s, l, options)
    --[[
    Uses either 0 to 360 or 0 to 1 values to create a paint or text
    color using the HSL color model.

    Arguments:
    - h (number): hue value
    - s (number): saturation value
    - l (number): lightness value
    - options (table): table of optional arguments with default values
        - a (number): alpha value, defaults to 1
        - type (string): type of color, defaults to "paint"
        - normalize (boolean): whether the values are normalized to
            0 to 1, defaults to false

    Returns:
    - color (paint or table): paint or text color
    ]]

    local function hslToRGB(h, s, l)
        local c = (1 - math.abs(2 * l - 1)) * s
        local x = c * (1 - math.abs((h * 6) % 2 - 1))
        local m = l - c / 2
    
        local lookupTable = {
            [0] = {c, x, 0},
            [1] = {x, c, 0},
            [2] = {0, c, x},
            [3] = {0, x, c},
            [4] = {x, 0, c},
            [5] = {c, 0, x}
        }
    
        local index = math.floor(h * 6)
        local rgb = lookupTable[(index % 6 + 1) % #lookupTable]
    
        return {rgb[1] + m, rgb[2] + m, rgb[3] + m}
    end

    local options = options or {}
    local normalize = options.normalize or false
    local h = normalize and h or h / 360
    local s = normalize and s or s / 100
    local l = normalize and l or l / 100
    local a = options.a or 1
    local type = options.type or "paint"
    
    local rgb = hslToRGB(h, s, l)
    local r, g, b = rgb[1], rgb[2], rgb[3]
    
    if type == "paint" then
        return color_paint{r, g, b, a}
    elseif type == "text" then
        return {r, g, b, a}
    end
end

function paintGradient(x1, y1, x2, y2, paint1, paint2)
    --[[
    Streamlines the syntax for creating a linear gradient.

    Arguments:
    - x1 (number): x coordinate of start point
    - y1 (number): y coordinate of start point
    - x2 (number): x coordinate of end point
    - y2 (number): y coordinate of end point
    - paint1 (paint): paint color at start point
    - paint2 (paint): paint color at end point

    Returns:
    - gradient (paint): linear gradient
    ]]
    return linear_gradient({x1, y1}, {x2, y2}, paint1, paint2) 
end