--[[

Canvas Node Primitives
v1.0.0
April 7, 2023
by Mark Boyd

These are basic shapes you can draw in the Canvas node.

Each function has no dependencies, meaning you can copy/paste just the
functions you need into your own code.

--]]

function drawTriangle(x, y, base, options)
    --[[
    Draws a triangle at a given position.

    Arguments:
    - x (number): x coordinate of triangle
    - y (number): y coordinate of triangle
    - base (number): base length of triangle
    - options (table): table of optional arguments with default values
        - paint (table): paint to fill the triangle with,
            defaults to white
        - type (string): type of triangle, defaults to "equilateral".
            - "equilateral": all sides are equal
            - "isosceles": two sides are equal
                - height argument defaults to base if not provided
            - "right": one angle is 90 degrees
                - height argument defaults to base if not provided
            - "scalene": no sides are equal
                - requires vertex argument
        - height (number): height of triangle, defaults to base
            - only used if type is "isosceles" or "right"
        - vertex (table): coordinates of vertex, defaults to {200, 100}
            - only used if type is "scalene"
        - rotation (number): normalized rotation of triangle, 
            defaults to 0
            - 0: no rotation
            - 0.25: 90 degrees counter-clockwise
            - 0.5: 180 degrees counter-clockwise
            - 0.75: 270 degrees counter-clockwise
        - origin (string): origin of triangle, defaults to "sw"
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

    local function getVertices(triangleType, base, height, vertex)
        local origin = {0, 0}
        local baseLength = {base, 0}
        local types = {
            ["equilateral"] = function() return {origin, baseLength, {base / 2, base}, origin} end,
            ["isosceles"] = function() return {origin, baseLength, {base / 2, height}, origin} end,
            ["right"] = function() return {origin, baseLength, {0, height}, origin} end,
            ["scalene"] = function() return {origin, baseLength, vertex, origin} end,
        }
        return types[triangleType]()
    end

    local function getOriginOffset(origin, vertices, triangleType)
        local function getScaleneCoords()
            if vertices[3][1] <= 0 or vertices[3][2] <= 0 then
                return error("Vertex coordinates cannot be negative", 3)
            else
                return {math.max(vertices[2][1], vertices[3][1]) / 2, vertices[3][2]}
            end
        end

        local function getXY()
            if triangleType == "equilateral" or triangleType == "isosceles" then
                return vertices[3][1], vertices[3][2]
            elseif triangleType == "right" then
                return vertices[2][1] / 2, vertices[3][2]
            elseif triangleType == "scalene" then
                return getScaleneCoords()
            end
        end

        local x, y = getXY()

        local origins = {
            ["n"] = function() return {-x, -y} end,
            ["ne"] = function() return {-x * 2, -y} end,
            ["e"] = function() return {-x * 2, -y / 2} end,
            ["se"] = function() return {-x * 2, 0} end,
            ["s"] = function() return {-x, 0} end,
            ["sw"] = function() return {0, 0} end,
            ["w"] = function() return {0, -y / 2} end,
            ["nw"] = function() return {0, -y} end,
            ["c"] = function() return {-x, -y / 2} end,
        }
            return origins[origin]()
    end

    local function lineToVertex(vertices)
        move_to{vertices[1][1], vertices[1][2]}
        for _, vertex in ipairs(vertices) do
            line_to(vertex)
        end
    end
    
    local options = options or {}
    local paint = options.paint or color_paint{1, 1, 1, 1}
    local triangleType = options.type or "equilateral"
    local height = options.height or base
    local vertex = options.vertex or {200, 100}
    local vertices = getVertices(triangleType, base, height, vertex)
    local rotation = options.rotation or 0
    local origin = options.origin or "sw"
    local originOffset = getOriginOffset(origin, vertices, triangleType)

    save()
    translate{x, y}
    rotate(rotation * 2 * math.pi)
    translate{originOffset[1], originOffset[2]}
    lineToVertex(vertices)
    fill(paint)
    restore()
end

function drawSquare(x, y, size, options)
    --[[
    Draws a square at a given position.

    Arguments:
    - x (number): x coordinate of square
    - y (number): y coordinate of square
    - size (number): length of square's sides
    - options (table): table of optional arguments with default values
        - paint (table): paint to fill the square with,
            defaults to white
        - border (boolean): whether or not to draw a border around 
            the square, defaults to false
        - borderWidth (number): width of border, defaults to size / 50
        - borderPaint (table): paint to draw the border with, 
            defaults to gray
        - rotation (number): normalized rotation of square, 
            defaults to 0
            - 0: no rotation
            - 0.25: 90 degrees counter-clockwise
            - 0.5: 180 degrees counter-clockwise
            - 0.75: 270 degrees counter-clockwise
        - origin (string): origin of square, defaults to "sw"
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

    local function getOriginOffset(origin, size)
        local origins = {
            ["n"] = function() return {-size / 2, -size} end,
            ["ne"] = function() return {-size, -size} end,
            ["e"] = function() return {-size, -size / 2} end,
            ["se"] = function() return {-size, 0} end,
            ["s"] = function() return {-size / 2, 0} end,
            ["sw"] = function() return {0, 0} end,
            ["w"] = function() return {0, -size / 2} end,
            ["nw"] = function() return {0, -size} end,
            ["c"] = function() return {-size / 2, -size / 2} end,
        }
        return origins[origin]()
    end

    local function getSquareCoords(size)
        return {{0, 0}, {size, size}}
    end

    local function drawSquareShape(coords, cornerRadius, paint, fill, border, borderWidth, borderPaint)
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
        cornerRadius = cornerRadius * size * 0.01
    end
    local border = options.border or false
    local borderWidth = options.borderWidth or size / 50
    local borderPaint = options.borderPaint or color_paint{0.8, 0.8, 0.8, 1}
    local origin = options.origin or "sw"
    local originOffset = getOriginOffset(origin, size)
    local coords = getSquareCoords(size)
    local rotation = options.rotation or 0

    save()
    rotate(rotation * 2 * math.pi)
    translate{x + originOffset[1], y + originOffset[2]}
    drawSquareShape(coords, cornerRadius, paint, fill, border, borderWidth, borderPaint)
    restore()
end

function drawRectangle(x, y, width, height, options)
    --[[
    Draws a rectangle at a given position.

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

function drawPolygon(x, y, diameter, sides, options)
    --[[
    Draws a polygon at a given position.

    Arguments:
    - x (number): x coordinate of polygon
    - y (number): y coordinate of polygon
    - diameter (number): diameter of polygon
    - sides (number): number of sides of polygon
    - options (table): table of optional arguments with default values
        - paint (paint): paint color of polygon, defaults to white
        - rotation (number): normalized rotation of polygon, 
            defaults to 0
            - 0: no rotation
            - 0.25: 90 degrees counter-clockwise
            - 0.5: 180 degrees counter-clockwise
            - 0.75: 270 degrees counter-clockwise
        - origin (string): origin of polygon, defaults to "sw"
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

    local function getOriginOffset(origin, diameter)
        local origins = {
            ["n"] = function() return {0, -diameter/2} end,
            ["ne"] = function() return {-diameter/2, -diameter/2} end,
            ["e"] = function() return {-diameter/2, 0} end,
            ["se"] = function() return {-diameter/2, diameter/2} end,
            ["s"] = function() return {0, diameter/2} end,
            ["sw"] = function() return {diameter/2, diameter/2} end,
            ["w"] = function() return {diameter/2, 0} end,
            ["nw"] = function() return {diameter/2, -diameter/2} end,
            ["c"] = function() return {0, 0} end,
        }
        return origins[origin]()
    end

    local function getVertices(diameter, sides)
        local sides = math.floor(sides)
        local vertices = {}
        local angle = 2 * math.pi / sides
        for i = 1, sides + 1 do
            vertices[i] = {diameter / 2 * math.cos((i - 1) * angle), diameter / 2 * math.sin((i - 1) * angle)}
        end
        return vertices
    end

    local function lineToVertex(vertices)
        move_to{vertices[1][1], vertices[1][2]}
        for _, vertex in ipairs(vertices) do
            line_to(vertex)
        end
    end

    local options = options or {}
    local paint = options.paint or color_paint{1, 1, 1, 1}
    local rotation = options.rotation or 0
    local origin = options.origin or "sw"
    local originOffset = getOriginOffset(origin, diameter)
    local vertices = getVertices(diameter, sides)

    save()
    translate{x, y}
    translate{originOffset[1], originOffset[2]}
    rotate((rotation) * 2 * math.pi)
    lineToVertex(vertices)
    fill(paint)
    restore()
end

function drawCircle(x, y, radius, options)
    --[[
    Draws a circle at a given position.

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

function drawFreeform(x, y, path, options)
    
    local function drawOutline(vertices)
        for _, vertex in ipairs(vertices) do
            if vertex[1] == "move" then
                move_to{vertex[2], vertex[3]}
            elseif vertex[1] == "line" then
                line_to{vertex[2], vertex[3]}
            elseif vertex[1] == "quad" then
                quad_to({vertex[2], vertex[3]}, {vertex[4], vertex[5]})
            else
                error "Invalid vertex type. Must be move, line, or quad."
            end
        end
    end

    options = options or {}
    local paint = options.paint or color_paint{1, 1, 1, 1}

    drawOutline(path)
    fill(paint)

end