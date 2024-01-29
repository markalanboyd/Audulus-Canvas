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

function Color.__sub(self, other)
    return self:clone():sub(other)
end

function Color.__mul(self, other)
    return self:clone():mult(other)
end

function Color.__div(self, other)
    return self:clone():div(other)
end

function Color.__unm(self)
    return self:clone():invert()
end

function Gradient:add(gradient)
    local color1 = self.color1:add(gradient.color1)
    local color2 = self.color2:add(gradient.color2)
    return Gradient.new(self.vec2a, self.vec2b, color1, color2)
end

function Gradient:Add(gradient)
    self.color1:Add(gradient.color1)
    self.color2:Add(gradient.color2)
    return self
end

function Gradient:sub(gradient)
    local color1 = self.color1:sub(gradient.color1)
    local color2 = self.color2:sub(gradient.color2)
    return Gradient.new(self.vec2a, self.vec2b, color1, color2)
end

function Gradient:Sub(gradient)
    self.color1:Sub(gradient.color1)
    self.color2:Sub(gradient.color2)
    return self
end

function Gradient:mult(gradient)
    local color1 = self.color1:mult(gradient.color1)
    local color2 = self.color2:mult(gradient.color2)
    return Gradient.new(self.vec2a, self.vec2b, color1, color2)
end

function Gradient:Mult(gradient)
    self.color1:Mult(gradient.color1)
    self.color2:Mult(gradient.color2)
    return self
end

function Gradient:div(gradient)
    local color1 = self.color1:div(gradient.color1)
    local color2 = self.color2:div(gradient.color2)
    return Gradient.new(self.vec2a, self.vec2b, color1, color2)
end

function Gradient:Div(gradient)
    self.color1:Div(gradient.color1)
    self.color2:Div(gradient.color2)
    return self
end

function Gradient:invert()
    local color1 = self.color1:invert()
    local color2 = self.color2:invert()
    return Gradient.new(self.vec2a, self.vec2b, color1, color2)
end

function Gradient:Invert()
    self.color1:Invert()
    self.color2:Invert()
    return self
end

function Gradient:clone()
    return Factory.clone(self)
end

function Gradient:to_paint()
    return linear_gradient(
        self.vec2a:to_xy_table(),
        self.vec2b:to_xy_table(),
        self.color1:table(),
        self.color2:table()
    )
end
