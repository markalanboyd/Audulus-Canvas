-- Inputs
-- tX tY t x1y1 x2y1 x3y1 x4y1 x1y2 x2y2 x3y2 x4y2 x1y3 x2y3 x3y3 x4y3 x1y4 x2y4 x3y4 x4y4

tX = tX * canvas_width
tY = tY * canvas_height

grid = {
    x1y1, x2y1, x3y1, x4y1,
    x1y2, x2y2, x3y2, x4y2,
    x1y3, x2y3, x3y3, x4y3,
    x1y4, x2y4, x3y4, x4y4
}

function btn(x, y, size, options)
	local options = options or {}
	local id = options.id or 0
	local pad = options.pad or 0
	local c = options.color or {1, 1, 1, 1}

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
	    local paint = color_paint({c[1] * f , c[2] * f, c[3] * f, c[4]})
    	fill_rect(pA, pB, 0, paint)
    end
   
    drawButton()
end


function tileFn(func, r, c)
    return function(x, y, s, o)
        for i = 0, c - 1 do
            for j = 0, r - 1 do
            	idx = j * c + i + 1
            	local options = {id = idx, pad = o.pad, color = o.color}
                func(x + i * s, y + j * s, s, options)
            end
        end
    end
end


tileBtn = tileFn(btn, 4, 4)
tileBtn(0, 0, 50, {pad=3, color=theme.azureHighlight})



