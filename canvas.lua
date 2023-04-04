function paint8Bit(r, g, b, a)
    --[[
    Uses 0-255 rgba inputs to create paint color instead of the built-in
    0-1 rgba that color_paint{} uses. Alpha value is optional.

    Arguments:
    - r (number: 0 to 255): red value
    - g (number: 0 to 255): green value
    - b (number: 0 to 255): blue value
    - a (number: 0 to 255): alpha value (optional)

    Returns:
    - paint (paint): paint color
    ]]
    local a = a or 255
    return color_paint{r/255, g/255, b/255, a/255}
end

function textColor8Bit(r, g, b, a)
    --[[
    Uses 0-255 rgba inputs to create text color instead of the built-in
    0-1 rgba that text() uses. Alpha value is optional.

    Arguments:
    - r (number: 0 to 255): red value
    - g (number: 0 to 255): green value
    - b (number: 0 to 255): blue value
    - a (number: 0 to 255): alpha value (optional)

    Returns:
    - paint (paint): text color
    ]]
    local a = a or 255
    return {r/255, g/255, b/255, a/255}
end

function paintLinearGradient(x1, y1, x2, y2, paint1, paint2)
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

function drawText(x, y, string, options)
    --[[
    Draws text at a given position.

    Arguments:
    - x (number): x coordinate of text
    - y (number): y coordinate of text
    - string (string): text to draw
    - options (table): table of optional arguments with default values
        - rotation(number): rotation of text where 0 is no
            rotation and 1 is a full rotation, defaults to 0.
        - size (number): size of text, defaults to 1
        - width (number): width multiplier of text, defaults to 1
        - height (number): height multiplier of text, defaults to 1
        - color (table): color of text, defaults to theme.text
            NB: Cannot use paint here, only text color!

    Returns:
    - None
    ]]

    local options = options or {}
    local rotation = options.rotation or 0
    local size = options.size or 1
    local width = options.widthFactor or 1
    local height = options.heightFactor or 1
    local color = options.color or theme.text

    save()
    translate{x, y}
    rotate(rotation * 2 * math.pi)
    scale{size * width, size * height}
    text(string, color)
    restore()
end


function drawSquare(x, y, size, options)
    local function getSquareCoords(x, y, size, origin)
        local origins = {
            ["n"] = function() return {{x - size/2, y - size}, {x + size/2, y}} end,
            ["ne"] = function() return {{x - size, y - size}, {x, y}} end,
            ["e"] = function() return {{x - size, y - size / 2}, {x, y + size / 2}} end,
            ["se"] = function() return {{x - size, y}, {x, y + size}} end,
            ["s"] = function() return {{x - size /2, y}, {x + size/2, y + size}} end,
            ["sw"] = function() return {{x, y}, {x + size, y + size}} end,
            ["w"] = function() return {{x, y - size/2}, {x + size, y + size/2}} end,
            ["nw"] = function() return {{x, y - size}, {x + size, y}} end,
            ["c"] = function() return {{x - size/2, y - size/2}, {x + size/2, y + size/2}} end,
        }
        return origins[origin]()
    end

    local options = options or {}
    local fill = options.fill
    if fill == nil then fill = true end
    local cornerRadius = options.cornerRadius or 0
    local proportionalRadius = options.proportionalRadius or false
    local paint = options.paint or color_paint{1, 1, 1, 1}
    local origin = options.origin or "sw"
    local rotation = options.rotation or 0
    local coords = getSquareCoords(x, y, size, origin)
    local border = options.border or false
    local borderWidth = options.borderWidth or size/50
    local borderPaint = options.borderPaint or color_paint{theme.text[1], theme.text[2], theme.text[3], theme.text[4]}

    if proportionalRadius then
        cornerRadius = cornerRadius * size * 0.01
    end

    rotate(rotation * 2 * math.pi)

    if fill then fill_rect(coords[1], coords[2], cornerRadius, paint) end

    if border then stroke_rect(coords[1], coords[2], cornerRadius, borderWidth, borderPaint) end
end

function drawCircle(x, y, radius, options)
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
    local origin = options.origin or "c"
    local rotation = options.rotation or 0
    local coordOffset = getCircleOrigin(radius, origin)
    local border = options.border or false
    local borderWidth = options.borderWidth or radius/50
    local borderPaint = options.borderPaint or color_paint{theme.text[1], theme.text[2], theme.text[3], theme.text[4]}

    rotate(rotation * 2 * math.pi)

    save()

    translate{coordOffset[1], coordOffset[2]}

    if fill then fill_circle({x, y}, radius, paint) end

    if border then stroke_circle({x, y}, radius, borderWidth, borderPaint) end

    restore()
end