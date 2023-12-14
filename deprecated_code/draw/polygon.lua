function polygon(x, y, diameter, sides, options)
    --[[
    Original Author: Mark Boyd
    Description: Draws a polygon at a given position.

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
