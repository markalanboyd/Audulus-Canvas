LineGroup = {}
LG = LineGroup

LineGroup.__index = LineGroup

LineGroup.id = 1

function LineGroup.new(vec2s, options)
    for _, vec2 in ipairs(vec2s) do
        if not Vec2.is_vec2(vec2) then
            error("All elements in vec2s must be Vec2 instances.")
        end
    end

    local self = setmetatable({}, LineGroup)
    self.element_id = Element.id
    Element.id = Element.id + 1
    self.class_id = LineGroup.id
    LineGroup.id = LineGroup.id + 1

    self.vec2s = vec2s or { Vec2.new(0, 0) }
    self.o = options or {}

    self.len_vec2s = #vec2s
    self.color = self.o.color or theme.text
    self.width = self.o.width or 1
    self.style = self.o.style or "normal"
    self.dash_length = self.o.dash_length or 5
    self.dot_radius = self.o.dot_radius or 1
    self.char = self.o.char or "+"
    self.char_vertex = self.o.char_vertex or self.char
    self.char_vertex_nudge = self.o.char_vertex_nudge or { 0, 0 }
    self.char_size = self.o.char_size or 12
    self.space_length = self.o.space_length or self.dash_length
    self.method = self.o.method or "between"
    return self
end

function LineGroup:draw_between()
    for i = 1, self.len_vec2s do
        for j = i + 1, self.len_vec2s do
            local line = Line.new(self.vec2s[i], self.vec2s[j], self.o)
            if self.style == "normal" then
                line:draw_normal()
            elseif self.style == "dashed" then
                line:draw_dashed()
            elseif self.style == "dotted" then
                line:draw_dotted()
            elseif self.style == "char" then
                line:draw_char()
            end
        end
    end
end

function LineGroup:draw_from_to()
    for i = 1, self.len_vec2s do
        local line = Line.new(self.vec2s[1], self.vec2s[i], self.o)
        if self.style == "normal" then
            line:draw_normal()
        elseif self.style == "dashed" then
            line:draw_dashed()
        elseif self.style == "dotted" then
            line:draw_dotted()
        elseif self.style == "char" then
            line:draw_char()
        end
    end
end

function LineGroup:draw()
    if self.method == "between" then
        self:draw_between()
    elseif self.method == "from-to" then
        self:draw_from_to()
    end
end

function LineGroup:print(places)
    places = places or 2

    local element_id = tostring(self.element_id)
    local class_id = tostring(self.class_id)
    local len_vec2s = tostring(self.len_vec2s)
    local color = tostring(Utils.table_to_string(self.color, true, places))
    local width = tostring(Math.truncate(self.width, places))
    local style = self.style
    local dash_length = tostring(Math.truncate(self.dash_length, places))
    local dot_radius = tostring(Math.truncate(self.dot_radius, places))
    local char = self.char
    local char_vertex = self.char_vertex
    local char_vertex_nudge = Utils.table_to_string(self.char_vertex_nudge, true, places)
    local char_size = tostring(Math.truncate(self.char_size, places))
    local space_length = tostring(Math.truncate(self.space_length, places))

    print("-- LineGroup " .. element_id .. ":" .. class_id .. " --")
    print("  element_id: " .. element_id)
    print("  class_id: " .. class_id)
    print("  len_vec2s: " .. len_vec2s)
    for i, vec2 in ipairs(self.vec2s) do
        local x = tostring(Math.truncate(vec2.x, places))
        local y = tostring(Math.truncate(vec2.y, places))
        print("vec2_" .. i .. ": " .. x .. ", y = " .. y .. " }")
    end
    print("  color: " .. color)
    print("  width: " .. width)
    print("  style: " .. style)
    print("  dash_length: " .. dash_length)
    print("  dot_radius: " .. dot_radius)
    print("  char: " .. char)
    print("  char_vertex: " .. char_vertex)
    print("  char_vertex nudge:" .. char_vertex_nudge)
    print("  char_size: " .. char_size)
    print("  space_length: " .. space_length)
    print("")
end
