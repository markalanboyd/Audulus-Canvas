function tileTable(x, y, cols, rows, drawFunc, args, options)

    local function getFunction(x, y, drawFunc, args)
        if drawFunc == drawTriangle then
            return drawTriangle(x, y, args[1], args[2])
        elseif drawFunc == drawSquare then
            return drawSquare(x, y, args[1], args[2])
        elseif drawFunc == drawRectangle then
            return drawRectangle, args[1], args[2], args[3]
        elseif drawFunc == drawPolygon then
            return drawPolygon, args[1], args[2], args[3]
        elseif drawFunc == drawCircle then
            return drawCircle, args[1], args[2]
        end
    end

    if drawFunc == drawTriangle then
        width = args[1]
        optionalArgs = args[2]
        height = options.height or width
    elseif drawFunc == drawSquare then
        width = args[1]
        args = args[2]
        height = width
    elseif drawFunc == drawRectangle then
        width = args[1]
        height = args[2]
        options = args[3]
    elseif drawFunc == drawPolygon then
        width = args[1]
        args = args[3]
        height = width
    elseif drawFunc == drawCircle then
        width = args[1]
        args = args[2]
        height = width
    end

    options = options or {}
    local padding = options.padding or 0
    
    for row = 0, rows - 1 do
        for col = 0, cols - 1 do
            local xPos = x + col * (width + padding)
            local yPos = y + row * (height + padding)
            drawFunc(xPos, yPos, width, height, optionalArgs)
        end
    end
end



triangleArgs = {50, {type="right", height=100}}
squareArgs = {50, {border=true, borderWidth=2, cornerRadius=10}}
rectangleArgs = {50, 100, {border=true, borderWidth=2, cornerRadius=10}}
polygonArgs = {50, 6, {rotation=0.25}}
circleArgs = {50, {border=true, borderWidth=2}}
