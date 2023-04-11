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