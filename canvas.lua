twoPi = math.pi * 2

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
    - text (string): text to draw
    - options (table): table of optional arguments with default values
        - size (number): size of text, defaults to 1
        - color (table): color of text, defaults to theme.text
            NB: Cannot use paint color here, only text color!
        - rotationFactor (number): rotation of text where 0 is no
            rotation and 1 is a full rotation, defaults to 0.

    Returns:
    - None
    ]]

    options = options or {}
    local size = options.size or 1
    local color = options.color or theme.text
    local rotation = options.rotation or 0

    save()
    translate{x, y}
    scale{size, size}
    rotate(rotationFactor * twoPi)
    text(string, color)
    restore()
end