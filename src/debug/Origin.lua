-- TODO Add a method in concert with Layer class to force origin to stay on top

Origin = {}

Origin.id = 1
Origin.created = false

Origin.__index = Utils.resolve_property

function Origin.new(options)
    if Origin.created == true then
        error("Only one instance of Origin is permitted.")
    end
    local self = setmetatable({}, Origin)
    self.options = options or {}

    self.z_index = self.options.z_index or math.huge
    self.direction = self.options.direction or "c"
    self.type = self.options.type or "stroke"
    self.width = self.options.width or 4
    Color.assign_color(self, self.options)
    Utils.assign_ids(self)
    Origin.created = true

    self._offset = Origin._calculate_offset(self.direction)
    self:_calc_and_assign_corners(self.direction)

    translate(self._offset)

    return self
end

function Origin:_assign_corners(t)
    self.top_left = Vec2.new(t[1][1], t[1][2])
    self.top_right = Vec2.new(t[2][1], t[2][2])
    self.bottom_right = Vec2.new(t[3][1], t[3][2])
    self.bottom_left = Vec2.new(t[4][1], t[4][2])
end

function Origin:_calc_and_assign_corners(direction)
    local w = canvas_width
    local h = canvas_height
    local hw = w * 0.5
    local hh = h * 0.5

    local coords = {
        nw = { { 0, 0 }, { w, 0 }, { w, -h }, { 0, -h } },
        n  = { { -hw, 0 }, { hw, 0 }, { hw, -h }, { -hw, -h } },
        ne = { { -w, 0 }, { 0, 0 }, { 0, -h }, { -w, -h } },
        e  = { { -w, hh }, { 0, hh }, { 0, -hh }, { -w, -hh } },
        se = { { -w, h }, { 0, h }, { 0, 0 }, { -w, 0 } },
        s  = { { -hw, h }, { hw, h }, { hw, 0 }, { -hw, 0 } },
        sw = { { 0, h }, { w, h }, { w, 0 }, { 0, 0 } },
        w  = { { 0, hh }, { w, hh }, { w, -hh }, { 0, -hh } },
        c  = { { -hw, hh }, { hw, hh }, { hw, -hh }, { -hw, -hh } }
    }

    self:_assign_corners(coords[direction])
end

function Origin._calculate_offset(direction)
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
        c  = { hw, hh }
    }
    local offset = origin_offsets[direction]
    if type(offset) == nil then
        error("Invalid direction. Must be 'n', 'ne', 'e', 'se', 's', 'sw', 'w', or 'nw'")
    end
    return offset
end

function Origin:draw()
    local paint = Paint.create(self.color, self.gradient)
    if self.type == "stroke" then
        stroke_circle({ 0, 0 }, self.width, 1, paint)
    elseif self.type == "dot" then
        fill_circle({ 0, 0 }, self.width, paint)
    elseif self.type == "crosshair" then
        stroke_segment({ 0, -self.width }, { 0, self.width }, 1, paint)
        stroke_segment({ -self.width, 0 }, { self.width, 0 }, 1, paint)
    end
end

function Origin:reset()
    translate { -self._offset[1], -self._offset[2] }
end
