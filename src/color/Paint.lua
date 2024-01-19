Paint = {}

function Paint.create(color, gradient)
    if gradient ~= nil then
        return gradient:to_paint()
    else
        return color:to_paint()
    end
end
