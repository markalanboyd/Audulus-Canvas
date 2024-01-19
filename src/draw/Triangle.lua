Triangle = {}
T = Triangle
Triangle.__index = Triangle

function Triangle.new(vec2_a, vec2_b, vec2_c, color)
    local self = setmetatable({}, Triangle)
    self.vec2_a = vec2_a or { x = 0, y = 0 }
    self.vec2_b = vec2_b or { x = 0, y = 0 }
    self.vec2_c = vec2_c or { x = 0, y = 0 }
    self.color = color or theme.text
    return self
end

function Triangle:draw()
    local paint = color_paint(self.color)
    move_to { self.vec2_a.x, self.vec2_a.y }
    line_to { self.vec2_b.x, self.vec2_b.y }
    line_to { self.vec2_c.x, self.vec2_c.y }
    line_to { self.vec2_a.x, self.vec2_a.y }
    fill(paint)
end

function Triangle:get_vec2s()
    return { vec2_a = self.vec2_a, vec2_b = self.vec2_b, vec2_c = self.vec2_c }
end

function Triangle:get_vec2_a()
    return self.vec2_a
end

function Triangle:get_vec2_b()
    return self.vec2_b
end

function Triangle:get_vec2_c()
    return self.vec2_c
end

function Triangle:Set_vec2s(...)
end

function Triangle:Set_vec2_a(x, y)
    self.vec2_a:Set(x, y)
    return self
end

function Triangle:Set_vec2_b(x, y)
    self.vec2_b:Set(x, y)
    return self
end

function Triangle:Set_vec2_c(x, y)
    self.vec2_c:Set(x, y)
    return self
end

function Triangle:centroid()
    local cx = (self.vec2_a.x + self.vec2_b.x + self.vec2_c.x) / 3
    local cy = (self.vec2_a.y + self.vec2_b.y + self.vec2_c.y) / 3
    return Vec2.new(cx, cy)
end

function Triangle:area()
    local a = self.vec2_a
    local b = self.vec2_b
    local c = self.vec2_c

    local area = 0.5 * math.abs(
        a.x * (b.y - c.y) +
        b.x * (c.y - a.y) +
        c.x * (a.y - b.y)
    )
    return area
end

function Triangle:perimeter()
    local a_b = self.vec2_a:distance(self.vec2_b)
    local b_c = self.vec2_b:distance(self.vec2_c)
    local c_a = self.vec2_c:distance(self.vec2_a)

    local perimeter = a_b + b_c + c_a
    return perimeter
end

function Triangle:type()
    local tolerance = 0.00001
    local a_b = self.vec2_a:distance(self.vec2_b)
    local b_c = self.vec2_b:distance(self.vec2_c)
    local c_a = self.vec2_c:distance(self.vec2_a)

    local ab_bc = math.abs(a_b - b_c) < tolerance
    local ab_ca = math.abs(a_b - c_a) < tolerance
    local bc_ca = math.abs(b_c - c_a) < tolerance

    if ab_bc and ab_ca then
        return "equilateral"
    elseif ab_bc or ab_ca or bc_ca then
        return "isosceles"
    else
        return "scalene"
    end
end

function Triangle:angle_type()
    local vec_a_b = self.vec2_b:sub(self.vec2_a)
    local vec_a_c = self.vec2_c:sub(self.vec2_a)
    local vec_b_a = self.vec2_a:sub(self.vec2_b)
    local vec_b_c = self.vec2_c:sub(self.vec2_b)
    local vec_c_a = self.vec2_a:sub(self.vec2_c)
    local vec_c_b = self.vec2_b:sub(self.vec2_c)

    local dot_a = vec_a_b:dot(vec_a_c)
    local dot_b = vec_b_a:dot(vec_b_c)
    local dot_c = vec_c_a:dot(vec_c_b)

    local isRight = dot_a == 0 or dot_b == 0 or dot_c == 0
    local isObtuse = dot_a < 0 or dot_b < 0 or dot_c < 0

    if isRight then
        return "right"
    elseif isObtuse then
        return "obtuse"
    else
        return "acute"
    end
end

function Triangle:scale(scalar)
    local centroid = self:centroid()

    return Triangle.new(
        self.vec2_a:scale_about(scalar, centroid),
        self.vec2_b:scale_about(scalar, centroid),
        self.vec2_c:scale_about(scalar, centroid)
    )
end

function Triangle:Scale(scalar)
    local centroid = self:centroid()

    self.vec2_a:Scale_about(scalar, centroid)
    self.vec2_b:Scale_about(scalar, centroid)
    self.vec2_c:Scale_about(scalar, centroid)
    return self
end

function Triangle:rotate(angle)
    local centroid = self:centroid()

    local rotate_vertex = function(vertex)
        local translated_vertex = vertex:sub(centroid)
        local rotated_vertex = translated_vertex:rotate(angle)
        return rotated_vertex:add(centroid)
    end

    return Triangle.new(
        rotate_vertex(self.vec2_a),
        rotate_vertex(self.vec2_b),
        rotate_vertex(self.vec2_c)
    )
end

function Triangle:Rotate(angle)
    local centroid = self:centroid()

    local rotate_vertex = function(vertex)
        local translated_vertex = vertex:sub(centroid)
        local rotated_vertex = translated_vertex:rotate(angle)
        return rotated_vertex:add(centroid)
    end

    self.vec2_a = rotate_vertex(self.vec2_a)
    self.vec2_b = rotate_vertex(self.vec2_b)
    self.vec2_c = rotate_vertex(self.vec2_c)
    return self
end

function Triangle:translate(vec2)
    return Triangle.new(
        self.vec2_a:add(vec2),
        self.vec2_b:add(vec2),
        self.vec2_c:add(vec2)
    )
end

function Triangle:Translate(vec2)
    self.vec2_a:add(vec2)
    self.vec2_b:add(vec2)
    self.vec2_c:add(vec2)
    return self
end

function Triangle:bounding_box()
    local min_x = math.min(self.vec2_a.x, self.vec2_b.x, self.vec2_c.x)
    local max_x = math.max(self.vec2_a.x, self.vec2_b.x, self.vec2_c.x)
    local min_y = math.min(self.vec2_a.y, self.vec2_b.y, self.vec2_c.y)
    local max_y = math.max(self.vec2_a.y, self.vec2_b.y, self.vec2_c.y)
    return Vec2.new(min_x, min_y), Vec2.new(max_x, max_y)
end

function Triangle:incircle()
    local a = self.vec2_b:distance(self.vec2_c)
    local b = self.vec2_c:distance(self.vec2_a)
    local c = self.vec2_a:distance(self.vec2_b)
    local s = (a + b + c) / 2
    local area = math.sqrt(s * (s - a) * (s - b) * (s - c))
    local incenterX = (a * self.vec2_a.x + b * self.vec2_b.x + c * self.vec2_c.x) / (a + b + c)
    local incenterY = (a * self.vec2_a.y + b * self.vec2_b.y + c * self.vec2_c.y) / (a + b + c)
    local radius = area / s
    return Vec2.new(incenterX, incenterY), radius
end

function Triangle:circumcircle()
    local a = self.vec2_b:distance(self.vec2_c)
    local b = self.vec2_c:distance(self.vec2_a)
    local c = self.vec2_a:distance(self.vec2_b)
    local s = (a + b + c) / 2
    local area = math.sqrt(s * (s - a) * (s - b) * (s - c))
    local radius = (a * b * c) / (4 * area)
    local ax, ay = self.vec2_a.x, self.vec2_a.y
    local bx, by = self.vec2_b.x, self.vec2_b.y
    local cx, cy = self.vec2_c.x, self.vec2_c.y
    local D = 2 * (
        ax * (by - cy) +
        bx * (cy - ay) +
        cx * (ay - by)
    )
    local Ux = (
        (ax ^ 2 + ay ^ 2) * (by - cy) +
        (bx ^ 2 + by ^ 2) * (cy - ay) +
        (cx ^ 2 + cy ^ 2) * (ay - by)) / D
    local Uy = (
        (ax ^ 2 + ay ^ 2) * (cx - bx) +
        (bx ^ 2 + by ^ 2) * (ax - cx) +
        (cx ^ 2 + cy ^ 2) * (bx - ax)) / D
    return Vec2.new(Ux, Uy), radius
end
