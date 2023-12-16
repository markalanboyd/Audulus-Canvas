-- Inputs
-- tX tY t x1y1 x2y1 x3y1 x4y1 x1y2 x2y2 x3y2 x4y2 x1y3 x2y3 x3y3 x4y3 x1y4 x2y4 x3y4 x4y4

local tX = tX * canvas_width
local tY = tY * canvas_height

local grid = {
    x1y1, x2y1, x3y1, x4y1,
    x1y2, x2y2, x3y2, x4y2,
    x1y3, x2y3, x3y3, x4y3,
    x1y4, x2y4, x3y4, x4y4
}

local function btn(x, y, size, options)
	local o = options or {}
	local id = o.id or 0
	local c = o.color or { 1, 1, 1, 1 }

    local pad = o.pad or 0
	local pPad = o.pPad or false
    if pPad then
        if pad ~= 0 then
            error(string.format("Remove pad argument or set pPad = false"))
        end
        local pPadPercent = o.pPadPercent or 5
        pad = size * ( pPadPercent / 100 )
    end

	local radius = o.radius or 0
    local pRadius = o.pRadius or false
    if pRadius then
        if radius ~= 0 then
            error(string.format("Remove radius argument or set pRadius = false"))
        end
        local pRadiusPercent = o.pRadiusPercent or 10
        radius = size / pRadiusPercent
    else
        if radius > size then
            error(string.format("Radius cannot exceed size." ..
                                "Max: %d, " ..
                                "Provided: %d",
                                size, radius))
        end
    end



	local x1 = x + pad
	local y1 = y + pad
    local x2 = x + size - pad
    local y2 = y + size - pad
    local pA = { x1, y1 }
    local pB = { x2, y2 }

    local function tIsInside()
        return tX >= x1 and tX <= x2 and tY >= y1 and tY <= y2 and t > 0
    end

    local function drawButton()
	    local br = tIsInside() and 1 or 0
		local st = grid[id] * 0.5
	    local f = math.max(0, math.min(br + st, 1))
	    local paint = color_paint(
            { c[1] * f , c[2] * f, c[3] * f, c[4] }
        )
    	fill_rect(pA, pB, radius, paint)
    end

    drawButton()
end


local function tileFn(func, r, c)
    return function(x, y, s, o)
        local options = {
            color = o.color,
            pad = o.pad,
            pPad = o.pPad,
            pPadPercent = o.pPadPercent,
            radius = o.radius,
            pRadius = o.pRadius,
            pRadiusPercent = o.pRadiusPercent,
        }
        for i = 0, c - 1 do
            for j = 0, r - 1 do
                options.id = i + 1 + j * c
                func(x + i * s, y + j * s, s, options)
            end
        end
    end
end


local tileBtn = tileFn(btn, 4, 4)
tileBtn(0, 0, 50, {
    pPad=true,
    color=theme.azureHighlight,
    pRadius=true,
    }
)
