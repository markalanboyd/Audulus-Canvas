-- tX tY t

tX = tX * canvas_width
tY = tY * canvas_height

function btn(x, y, s)
    local x2 = x + s
    local y2 = y + s
    local pA = { x, y }
    local pB = { x2, y2 }
    
    local function tIsInside()
        return tX >= x and tX <= x2 and tY >= y and tY <= y2 and t > 0
    end
    
    local function drawButton()
        local b = tIsInside() and 1 or 0.5
        paint = color_paint{ 1*b, 1*b, 1*b, 1 }
        fill_rect(pA, pB, 0, paint)
    end
        
    drawButton()
end


function tileFn(func, r, c)
    return function(x, y, s)
        for i = 0, c - 1 do
            for j = 0, r - 1 do
                func(x + i * s, y + j * s, s)
            end
        end
    end
end


tileBtn = tileFn(btn, 10, 10)
tileBtn(0, 0, 10)



