function triangle(x, y, base, options)
    --[[
    Original Author: Mark Boyd
    Description: Draws a triangle at a given position.

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