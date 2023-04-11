function bezierHelper(ax, ay, bx, by, cx, cy, options)
    local function drawText(x, y, string, options)
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


    options = options or {}
    local aPaint = color_paint(theme.greenHighlight)    
    local bPaint = color_paint(theme.azureHighlight)
    local cPaint = color_paint(theme.redHighlight)
    local paint = options.paint or linear_gradient({ax, ay}, {cx, cy}, theme.greenHighlight, theme.redHighlight)
    local dottedPaint = options.dottedPaint or color_paint(theme.azureHighlightDark)
    local width = options.width or 1
    local dottedWidth = options.dottedWidth or 2
    local dottedSpace = options.dottedSpace or 2

    local function drawDottedLine(startX, startY, endX, endY)
        local dist = math.sqrt((endX - startX) ^ 2 + (endY - startY) ^ 2)
        local segments = math.floor(dist / (dottedWidth + dottedSpace))
        local segmentLen = dist / segments
        local angle = math.atan2(endY - startY, endX - startX)

        for i = 0, segments - 1 do
            local x1 = startX + math.cos(angle) * (i * segmentLen)
            local y1 = startY + math.sin(angle) * (i * segmentLen)
            local x2 = startX + math.cos(angle) * ((i * segmentLen) + dottedWidth)
            local y2 = startY + math.sin(angle) * ((i * segmentLen) + dottedWidth)
            stroke_segment({x1, y1}, {x2, y2}, width, dottedPaint)
        end
    end
	
	translate{50, 50}
    drawDottedLine(ax, ay, bx, by)
    drawDottedLine(bx, by, cx, cy)
    stroke_bezier({ax, ay}, {bx, by}, {cx, cy}, width, paint)
    fill_circle({ax, ay}, width * 3, aPaint)
    fill_circle({bx, by}, width * 3, bPaint)
    fill_circle({cx, cy}, width * 3, cPaint)
    drawText(ax - 50, ay, "(ax, ay)")
    drawText(bx - 19, by + 10, "(bx, by)")
    drawText(cx + 10, cy, "(cx, cy)")
end


size = 100

ax = ax * size
ay = ay * size
bx = bx * size
by = by * size
cx = cx * size
cy = cy * size


bezierHelper(ax, ay, bx, by, cx, cy)

