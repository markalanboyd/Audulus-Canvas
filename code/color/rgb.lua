function rgb(r, g, b, options)
    --[[
    Original Author: Mark Boyd
    Description: Uses either normalized or 8-bit values to create a
    paint or table color using the RGB color model.

    Arguments:
    - r (number): red value
    - g (number): green value
    - b (number): blue value
    - options (table): table of optional arguments with default values
        - a (number): alpha value, defaults to 1
        - type (string): type of color, defaults to "paint"
            - "paint": paint color
            - "table": table color (e.g., for text)
        - is8bit (boolean): whether the values are 8-bit (0-255),
        defaults to false

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