-- TODO implement operator overloading

Gradient = {}
G = Gradient
Gradient.__index = Gradient

Gradient.id = 1

function Gradient.new(vec2a, vec2b, color1, color2)
    local self = setmetatable({}, Gradient)
    self.element_id = Element.id
    Element.id = Element.id + 1
    self.class_id = Gradient.id
    Gradient.id = Gradient.id + 1

    self.vec2a = vec2a or Vec2.new()
    self.vec2b = vec2b or Vec2.new()
    self.color1 = color1 or Color.new()
    self.color2 = color2 or Color.new()
    return self
end

function Gradient.__add(self, other)
    return self:clone():add(other)
end

function Gradient:add(gradient)
    local color1 = self.color1:add(gradient.color1)
    local color2 = self.color2:add(gradient.color2)
    return Gradient.new(self.vec2a, self.vec2b, color1, color2)
end

function Gradient:clone()
    return Factory.clone_one(Gradient, self)
end

function Gradient:to_paint()
    return linear_gradient(
        self.vec2a:to_xy_pair(),
        self.vec2b:to_xy_pair(),
        self.color1:table(),
        self.color2:table()
    )
end
