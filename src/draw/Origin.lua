-- TODO Add a method to force origin to stay on top

Origin = {}
Origin.__index = Origin

function Origin.new(direction, options)
    local self = setmetatable({}, Origin)
    local o = options or {}

    self.direction = direction or "sw"
    self.show = o.show or false
    self.type = string.lower(o.type) or "stroke"
    self.width = o.width or 4
    self.color = o.color or theme.text
    self.offset = self.calculate_offset(direction)

    translate(self.offset)

    if self.show then
        local paint = color_paint(self.color)
        if self.type == "stroke" or self.type == "outline" then
            stroke_circle({ 0, 0 }, self.width, 1, paint)
        elseif self.type == "fill" or self.type == "dot" then
            fill_circle({ 0, 0 }, self.width, paint)
        elseif self.type == "+" or self.type == "cross" then
            stroke_segment({ 0, -self.width }, { 0, self.width }, 1, paint)
            stroke_segment({ -self.width, 0 }, { self.width, 0 }, 1, paint)
        end
    end

    return self
end

function Origin.calculate_offset(direction)
    local w = canvas_width
    local h = canvas_height
    local hw = w / 2
    local hh = h / 2
    local origin_offsets = {
        sw = { 0, 0 },
        w  = { 0, hh },
        nw = { 0, h },
        n  = { hw, h },
        ne = { w, h },
        e  = { w, hh },
        se = { w, 0 },
        s  = { hw, 0 },
        c  = { hw, hw }
    }
    local offset = origin_offsets[string.lower(direction)]
    if type(offset) == nil then
        error("Invalid direction. Must be 'n', 'ne', 'e', 'se', 's', 'sw', 'w', or 'nw'")
    end
    return offset
end

function Origin:reset()
    translate { -self.offset[1], -self.offset[2] }
end
