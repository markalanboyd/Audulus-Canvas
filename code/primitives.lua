-- Description: Contains functions for drawing basic shapes.

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
        - rotation (number): normalized rotation of triangle, 
            defaults to 0
            - 0: no rotation
            - 0.25: 90 degrees counter-clockwise
            - 0.5: 180 degrees counter-clockwise
            - 0.75: 270 degrees counter-clockwise
        
    Returns:
    - nil
    ]]

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
        local function vertexError()
            return error("Vertex coordinates cannot be negative", 3)
        end

        local function getScaleneX()
            if vertices[3][1] >= 0 then
            	return math.max(vertices[2][1], vertices[3][1]) / 2
            else
            	vertexError()
            end
        end

        local function getX()
            local xValues = {
                ["equilateral"] = function() return vertices[3][1] end,
                ["isosceles"] = function() return vertices[3][1] end,
                ["right"] = function() return vertices[2][1] / 2 end,
                ["scalene"] = function() return getScaleneX() end,
            }
            return xValues[triangleType]()
        end

        local x = getX()
        local y = vertices[3][2] > 0 and vertices[3][2] or vertexError()
        
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
    local origin = options.origin or "sw"
    local originOffset = getOriginOffset(origin, vertices, triangleType)
    local rotation = options.rotation or 0

    save()
    translate(x + originOffset[1], y + originOffset[2])
    rotate(rotation * 2 * math.pi)
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
        - rotation (number): normalized rotation of square, 
            defaults to 0
            - 0: no rotation
            - 0.25: 90 degrees counter-clockwise
            - 0.5: 180 degrees counter-clockwise
            - 0.75: 270 degrees counter-clockwise

    Returns:
    - None
    ]]

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
    local paint = options.paint or color_paint{1, 1, 1, 1}
    local fill = options.fill
    if fill == nil then fill = true end
    local cornerRadius = options.cornerRadius or 0
    local proportionalRadius = options.proportionalRadius or false
    local border = options.border or false
    local borderWidth = options.borderWidth or size / 50
    local borderPaint = options.borderPaint or color_paint{0.8, 0.8, 0.8, 1}
    local origin = options.origin or "sw"
    local coords = getSquareCoords(x, y, size, origin)
    local rotation = options.rotation or 0

    if proportionalRadius then
        cornerRadius = cornerRadius * size * 0.01
    end

    save()
    rotate(rotation * 2 * math.pi)

    if fill then
        fill_rect(coords[1], coords[2], cornerRadius, paint)
    end

    if border then
        stroke_rect(coords[1], coords[2], cornerRadius, borderWidth, borderPaint)
    end
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
        - origin (string): origin of rectangle, defaults to "sw"
        - rotation (number): rotation of rectangle where 0 is no
            rotation and 1 is a full rotation, defaults to 0.
        - border (boolean): whether to draw a border, defaults to false
        - borderWidth (number): width of border, defaults to size/50
        - borderPaint (paint): paint color of border, defaults
            to theme.text

    Returns:
    - None
    ]]
    
    local function getRectangleCoords(x, y, width, height, origin)
        local origins = {
            ["n"] = function() return {{x - width/2, y - height}, {x + width/2, y}} end,
            ["ne"] = function() return {{x - width, y - height}, {x, y}} end,
            ["e"] = function() return {{x - width, y - height/2}, {x, y + height/2}} end,
            ["se"] = function() return {{x - width, y}, {x, y + height}} end,
            ["s"] = function() return {{x - width/2, y}, {x + width/2, y + height}} end,
            ["sw"] = function() return {{x, y}, {x + width, y + height}} end,
            ["w"] = function() return {{x, y - height/2}, {x + width, y + height/2}} end,
            ["nw"] = function() return {{x, y - height}, {x + width, y}} end,
            ["c"] = function() return {{x - width/2, y - height/2}, {x + width/2, y + height/2}} end,
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
    local coords = getRectangleCoords(x, y, width, height, origin)
    local border = options.border or false
    local borderWidth = options.borderWidth or width/50
    local borderPaint = options.borderPaint or color_paint{theme.text[1], theme.text[2], theme.text[3], theme.text[4]}

    if proportionalRadius then
        cornerRadius = cornerRadius * width * 0.01
    end

    save()
    rotate(rotation * 2 * math.pi)
    if fill then fill_rect(coords[1], coords[2], cornerRadius, paint) end
    if border then stroke_rect(coords[1], coords[2], cornerRadius, borderWidth, borderPaint) end
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
        - origin (string): origin of circle, defaults to "sw"
        - rotation (number): rotation of circle where 0 is no
            rotation and 1 is a full rotation, defaults to 0.
        - border (boolean): whether to draw a border, defaults to false
        - borderWidth (number): width of border, defaults to radius/50
        - borderPaint (paint): paint color of border, defaults
            to theme.text

    Returns:
    - None
    ]]

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

    save()
    rotate(rotation * 2 * math.pi)
    translate{coordOffset[1], coordOffset[2]}
    if fill then fill_circle({x, y}, radius, paint) end
    if border then stroke_circle({x, y}, radius, borderWidth, borderPaint) end
    restore()
end