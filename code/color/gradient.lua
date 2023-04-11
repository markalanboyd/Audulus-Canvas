function gradient(x1, y1, x2, y2, color1, options)
    --[[
    Original Author: Mark Boyd
    Description: Creates a linear gradient between two points.

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
