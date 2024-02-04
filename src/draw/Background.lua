Background = {}
B = Background

Background.id = 1
Background.created = false

Background.__index = Utils.resolve_property

function Background.new(options)
    if Background.created == true then
        error("Only one instance of Background is permitted.")
    end
    local self = setmetatable({}, Background)
    self.origin = origin
    self.options = options or {}

    self.z_index = -math.huge
    self.vec2a = self.origin.bottom_left
    self.vec2b = self.origin.top_right
    self.rounded = self.options.rounded or true
    Color.assign_color(self, self.options)
    Utils.assign_options(self, self.options)
    Utils.assign_ids(self)
    Background.created = true
    return self
end

function Background:draw()
    local paint = Paint.create(self.color, self.gradient)
    local x1, y1, x2, y2, corner_radius

    if self.rounded == true then
        x1 = self.vec2a.x - 10
        y1 = self.vec2a.y - 9.5
        x2 = self.vec2b.x + 9
        y2 = self.vec2b.y + 10
        corner_radius = 6
    else
        x1 = self.vec2a.x - 11
        y1 = self.vec2a.y - 11
        x2 = self.vec2b.x + 11
        y2 = self.vec2b.y + 11
        corner_radius = 0
    end
    fill_rect({ x1, y1 }, { x2, y2 }, corner_radius, paint)
end
