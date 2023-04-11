function circle(x, y, radius, options)
    --[[
    Original Author: Mark Boyd
    Description: Draws a circle at a given position.

    Arguments:
    - x (number): x coordinate of circle
    - y (number): y coordinate of circle
    - radius (number): radius of circle
    - options (table): table of optional arguments with default values
        - fill (boolean): whether to fill the circle, defaults to true
        - paint (paint): paint color of circle, defaults to white
        - border (boolean): whether to draw a border, defaults to false
        - borderWidth (number): width of border, defaults to radius/50
        - borderPaint (paint): paint color of border, defaults
            to theme.text
        - rotation (number): normalized rotation of the circle 
            defaults to 0
            - 0: no rotation
            - 0.25: 90 degrees counter-clockwise
            - 0.5: 180 degrees counter-clockwise
            - 0.75: 270 degrees counter-clockwise
        - origin (string): origin of circle, defaults to "sw"
            - "n": north
            - "ne": northeast
            - "e": east
            - "se": southeast
            - "s": south
            - "sw": southwest
            - "w": west
            - "nw": northwest
            - "c": center

    Returns:
    - None
    --]]

    local function getCircleOrigin(radius, origin)
        local origins = {
            ["n"] = function() return {0, radius} end,
            ["ne"] = function() return {radius, radius} end,
            ["e"] = function() return {radius, 0} end,
            ["se"] = function() return {radius, -radius} end,
            ["s"] = function() return {0, -radius} end,
            ["sw"] = function() return {-radius, -radius} end,
            ["w"] = function() return {-radius, 0} end,
            ["nw"] = function() return {-radius, radius} end,
            ["c"] = function() return {0, 0} end,
        }
        return origins[origin]()
    end

    local options = options or {}
    local fill = options.fill
    if fill == nil then fill = true end
    local paint = options.paint or color_paint{1, 1, 1, 1}
    local origin = options.origin or "sw"
    local rotation = options.rotation or 0
    local coordOffset = getCircleOrigin(radius, origin)
    local border = options.border or false
    local borderWidth = options.borderWidth or radius/50
    local borderPaint = options.borderPaint or color_paint{theme.text[1], theme.text[2], theme.text[3], theme.text[4]}

    save()
    rotate(rotation * 2 * math.pi)
    translate{coordOffset[1], coordOffset[2]}
    if fill then fill_circle({x, y}, radius, paint) end
    if border then stroke_circle({x, y}, radius, borderWidth, borderPaint) end
    restore()
end
