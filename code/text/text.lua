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
    --]]

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
