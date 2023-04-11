function rectangle(x, y, width, height, options)
    --[[
    Original Author: Mark Boyd
    Description: Draws a rectangle at a given position.

    Arguments:
    - x (number): x coordinate of rectangle
    - y (number): y coordinate of rectangle
    - width (number): width of rectangle
    - height (number): height of rectangle
    - options (table): table of optional arguments with default values
        - fill (boolean): whether to fill the rectangle, defaults
            to true
        - cornerRadius (number): radius of corners, defaults to 0
        - proportionalRadius (boolean): whether to use a proportional
            radius, defaults to false
        - paint (paint): paint color of rectangle, defaults to white
        - border (boolean): whether to draw a border, defaults to false
        - borderWidth (number): width of border, defaults to size/50
        - borderPaint (paint): paint color of border, defaults
            to theme.text
        - rotation (number): normalized rotation of rectangle, 
            defaults to 0
            - 0: no rotation
            - 0.25: 90 degrees counter-clockwise
            - 0.5: 180 degrees counter-clockwise
            - 0.75: 270 degrees counter-clockwise
        - origin (string): origin of rectangle, defaults to "sw"
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

    local function getOriginOffset(origin, width, height)
        local origins = {
            ["n"] = function() return {-width / 2, -height} end,
            ["ne"] = function() return {-width, -height} end,
            ["e"] = function() return {-width, -height / 2} end,
            ["se"] = function() return {-width, 0} end,
            ["s"] = function() return {-width / 2, 0} end,
            ["sw"] = function() return {0, 0} end,
            ["w"] = function() return {0, -height / 2} end,
            ["nw"] = function() return {0, -height} end,
            ["c"] = function() return {-width / 2, -height / 2} end,
        }
        return origins[origin]()
    end

    local function getRectangleCoords(width, height)
        return {{0, 0}, {width, height}}
    end

    local function drawRectangleShape(coords, cornerRadius, paint, fill, border, borderWidth, borderPaint)
        if fill then
            fill_rect(coords[1], coords[2], cornerRadius, paint)
        end
    
        if border then
            stroke_rect(coords[1], coords[2], cornerRadius, borderWidth, borderPaint)
        end
    end

    local options = options or {}
    local paint = options.paint or color_paint{1, 1, 1, 1}
    local fill = options.fill
    if fill == nil then fill = true end
    local cornerRadius = options.cornerRadius or 0
    local proportionalRadius = options.proportionalRadius or false
    if proportionalRadius then
        cornerRadius = cornerRadius * width * 0.01
    end
    local border = options.border or false
    local borderWidth = options.borderWidth or width/50
    local borderPaint = options.borderPaint or color_paint{theme.text[1], theme.text[2], theme.text[3], theme.text[4]}
    local origin = options.origin or "sw"
    local originOffset = getOriginOffset(origin, width, height)
    local coords = getRectangleCoords(width, height)
    local rotation = options.rotation or 0

    save()
    translate{x, y}
    rotate(rotation * 2 * math.pi)
    translate{originOffset[1], originOffset[2]}
    drawRectangleShape(coords, cornerRadius, paint, fill, border, borderWidth, borderPaint)
    restore()
end