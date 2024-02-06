-- TODO: triangulation

LineGroup = {}
LG = LineGroup

LineGroup.id = 1

LineGroup.styles = Line.styles

LineGroup.methods = {
    grid = {
        lines = nil,
        v_lines = 10,
        h_lines = 10,
    }
}

LineGroup.__index = Utils.resolve_property

function LineGroup.new(vec2s, options)
    local self = setmetatable({}, LineGroup)
    self.vec2s = vec2s or { Vec2.new(0, 0) }
    self.options = options or {}

    Utils.assign_ids(self)
    Utils.assign_options(self, self.options)
    Color.assign_color(self, self.options)

    self.name = self.name or ("LineGroup " .. self.element_id .. ":" .. self.class_id)
    self.z_index = self.options.z_index or 0
    self.method = self.options.method or "graph"
    self.style = self.options.style or "normal"

    self.__len_vec2s = #self.vec2s

    return self
end

function LineGroup:draw()
    if self.method == "graph" then
        self:graph()
    elseif self.method == "star" then
        self:star()
    elseif self.method == "polyline" then
        self:polyline()
    elseif self.method == "grid" then
        self:grid()
    end
end

function LineGroup:draw_line(line)
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

function LineGroup:graph()
    for i = 1, self.__len_vec2s do
        for j = i + 1, self.__len_vec2s do
            local line = Line.new(self.vec2s[i], self.vec2s[j], self.options)
            self:draw_line(line)
        end
    end
end

function LineGroup:grid()
    local vec2a = self.vec2s[1]
    local vec2b = self.vec2s[2]
    local xd = vec2b.x - vec2a.x
    local yd = vec2b.y - vec2a.y
    local v_iters = self.lines ~= nil and self.lines or self.v_lines
    local h_iters = self.lines ~= nil and self.lines or self.h_lines
    local x_space = xd / v_iters
    local y_space = yd / h_iters
    for i = 0, v_iters do
        local v1 = Vec2.new(vec2a.x + x_space * i, vec2a.y)
        local v2 = Vec2.new(vec2a.x + x_space * i, vec2b.y)
        local v_line = Line.new(v1, v2, self.options)
        self:draw_line(v_line)
    end
    for i = 0, h_iters do
        local h1 = Vec2.new(vec2a.x, vec2a.y + y_space * i)
        local h2 = Vec2.new(vec2b.x, vec2a.y + y_space * i)
        local h_line = Line.new(h1, h2, self.options)
        self:draw_line(h_line)
    end
end

function LineGroup:polyline()
    for i = 2, self.__len_vec2s do
        local line = Line.new(self.vec2s[i - 1], self.vec2s[i], self.options)
        self:draw_line(line)
    end
end

function LineGroup:star()
    for i = 2, self.__len_vec2s do
        local line = Line.new(self.vec2s[1], self.vec2s[i], self.o)
        self:draw_line(line)
    end
end

function LineGroup:print(places)
    places = places or 2

    local element_id = tostring(self.element_id)
    local class_id = tostring(self.class_id)
    local z_index = tostring(self.z_index)
    local style = self.style
    local method = self.method

    print("-- LineGroup " .. element_id .. ":" .. class_id .. " --")
    print("  element_id: " .. element_id)
    print("  class_id: " .. class_id)
    print("  z_index: " .. z_index)
    print("  len_vec2s: " .. tostring(self.__len_vec2s))
    for i, vec2 in ipairs(self.vec2s) do
        local x = tostring(Math.truncate(vec2.x, places))
        local y = tostring(Math.truncate(vec2.y, places))
        print("  vec2_" .. i .. ": { x = " .. x .. ", y = " .. y .. " }")
    end
    print("  method: " .. method)
    if method == "grid" then
        if self.lines ~= nil then
            print("  lines: " .. tostring(self.lines))
        else
            print("  v_lines: " .. tostring(self.v_lines))
            print("  h_lines: " .. tostring(self.h_lines))
        end
    end
    print("  style: " .. style)
    if style == "normal" then
        print("  width: " .. tostring(Math.truncate(self.width, places)))
    elseif style == "dashed" then
        print("  width: " .. tostring(Math.truncate(self.width, places)))
        print("  dash_length: " .. tostring(Math.truncate(self.dash_length, places)))
        print("  space_length: " .. tostring(Math.truncate(self.space_length, places)))
    elseif style == "dotted" then
        print("  dot_radius: " .. tostring(Math.truncate(self.dot_radius, places)))
        print("  space_length: " .. tostring(Math.truncate(self.space_length, places)))
    elseif style == "char" then
        print("  char: " .. self.char)
        print("  char_vertex: " .. self.char_vertex)
        print("  char_vertex nudge: " .. Utils.table_to_string(self.char_vertex_nudge, true, places))
        print("  char_size: " .. tostring(Math.truncate(self.char_size, places)))
        print("  space_length: " .. tostring(Math.truncate(self.space_length, places)))
    end
    if self.gradient == nil then
        print("  color: " .. tostring(Utils.table_to_string(self.color, true, places)))
    else
        print("  gradient: " .. tostring(Utils.table_to_string(self.gradient.color1:table(), true, places))
            .. " → " .. tostring(Utils.table_to_string(self.gradient.color2:table(), true, places)))
    end
    print("")
end
