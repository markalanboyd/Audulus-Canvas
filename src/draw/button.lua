function button(x, y, width, options)
    -- Error Handling
    local function checkMutuallyExclusiveArgs(arg1Name, arg1, arg2Name, arg2)
        local e = "MutuallyExclusiveArgError: '%s' and '%s' cannot be used" ..
            "together. Remove one or the other."
        if arg1 and arg2 then
            error(string.format(e, arg1Name, arg2Name))
        end
    end

    -- Optional Keyword Arguments
    local o = options or {}
    local height = o.height or width
    local id = o.id or 0
    local c = o.color or { 1, 1, 1, 1 }

    -- Corner Radius
    local r = o.radius or nil
    local pRadius = o.pRadius or false
    if pRadius then
        checkMutuallyExclusiveArgs("radius", r, "pRadius", pRadius)
        local pRadiusPercent = math.min(o.pRadiusPercent or 10, 50)
        r = width * (pRadiusPercent / 100)
    else
        if r ~= nil and r > width then
            error(string.format("ValueError: Radius cannot exceed size." ..
                "Max: %d, " ..
                "Provided: %d",
                width, r))
        end
    end
    local radius = r or 0

    -- Border
    local border = o.border or false
    local borderWidth = o.borderWidth or 1
    local borderColor = o.borderColor or
        { c[1] * 0.75, c[2] * 0.75, c[3] * 0.75, c[4] }

    -- Initialize coordinates
    local x1 = x
    local y1 = y
    local x2 = x + width
    local y2 = y + height

    -- Touch detector
    local btnTouched = tX >= x1 and tX <= x2 and tY >= y1 and tY <= y2 and t > 0

    -- Shrink on press
    local shrinkOnPress = o.shrinkOnPress or false
    if shrinkOnPress and btnTouched then
        local shrinkPercent = o.shrinkPercent or 90
        local sP = shrinkPercent / 100
        local dX = (x2 - x1) * (1 - sP) / 2
        local dY = (y2 - y1) * (1 - sP) / 2
        x1 = x1 + dX
        y1 = y1 + dY
        x2 = x2 - dX
        y2 = y2 - dY
    end

    -- Padding
    local p = o.pad or nil
    local pPad = o.pPad or false
    if pPad then
        checkMutuallyExclusiveArgs("pad", p, "pPad", pPad)
        local pPadPercent = o.pPadPercent or 5
        p = width * (pPadPercent / 100)
    end
    local pad = p or 0
    x1 = x1 + pad
    y1 = y1 + pad
    x2 = x2 - pad
    y2 = y2 - pad

    -- Pack coordinates
    local pA = { x1, y1 }
    local pB = { x2, y2 }

    -- Draw
    local function drawButton()
        local br = btnTouched and 1 or 0
        local st = grid[id] * 0.5
        local f = math.max(0, math.min(br + st, 1))
        local paint = color_paint(
            { c[1] * f, c[2] * f, c[3] * f, c[4] }
        )
        if not border then
            fill_rect(pA, pB, radius, paint)
        else
            -- Border
            fill_rect(pA, pB, radius, color_paint(borderColor))

            -- Adjust the radius as border gets thicker
            local innerWidth = x2 - x1 - borderWidth
            local innerHeight = y2 - y1 - borderWidth
            local scaleFactor = math.min(innerWidth / (x2 - x1),
                innerHeight / (y2 - y1))
            local adjustedRadius = radius * scaleFactor

            -- Inner rectangle
            local hBW = borderWidth / 2
            local pAB = { x1 + hBW, y1 + hBW }
            local pBB = { x2 - hBW, y2 - hBW }
            fill_rect(pAB, pBB, adjustedRadius, paint)
        end
    end

    drawButton()
end

function tile_button_fn(func, r, c)
    return function(x, y, w, o)
        local h = o.height or w
        for i = 0, c - 1 do
            for j = 0, r - 1 do
                o.id = i + 1 + j * c
                func(x + i * w, y + j * h, w, o)
            end
        end
    end
end
