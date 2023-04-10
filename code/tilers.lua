function tileColRow(x, y, cols, rows, drawFunc, drawFuncArgs, options)
    local size = drawFuncArgs[1]
    local options = drawFuncArgs[2]
    local tileWidth = size + options.borderWidth * 2
    local tileHeight = size + options.borderWidth * 2
    local padding = options.padding or 0
    
    for row = 0, rows - 1 do
        for col = 0, cols - 1 do
            local xPos = x + col * tileWidth + padding
            local yPos = y + row * tileHeight + padding
            drawFunc(xPos, yPos, size, options)
        end
    end
end