Text = {}
Text.__index = Text

Text.id = 1

function Text.new(string, options)
    local self = setmetatable({}, Text)
    self.element_id = Element.id
    Element.id = Element.id + 1
    self.class_id = Text.id
    Text.id = Text.id + 1


    self.string = string or ""
    self.o = options or {}

    self.vec2 = self.o.vec2 or Vec2.new()
    self.size = self.o.size or 12
    self.color = self.o.color or Color.new(theme.text)
    return self
end

function Text:draw()
    local scale_factor = self.size / 12
    save()
    translate(self.vec2:to_xy_pair())
    scale { scale_factor, scale_factor }
    text(self.string, self.color:table())
    restore()
end
