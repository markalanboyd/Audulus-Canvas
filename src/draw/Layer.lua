-- TODO - Implement transforms
-- TODO - Implement bounding_box
-- TODO - Ability to reassign objects from one layer to another

Layer = {}
La = Layer

Layer.id = 1

Layer.__index = Layer


function Layer.new(options)
    local self = setmetatable({}, Layer)
    self.options = options or {}

    Utils.assign_ids(self)
    Utils.assign_options(self, self.options)

    self.name = self.name or ("Layer " .. self.element_id .. ":" .. self.class_id)
    self.z_index = options.z_index or 0
    self.contents = options.contents or {}
    self.opacity = options.opacity or 1
    self.hue = options.hue or 0
    self.saturation = options.saturation or 1
    self.lightness = options.lightness or 0.5

    self.superlayer = nil
    self.sublayers = {}

    return self
end

function Layer:__call(...)
    local args = { ... }

    if #args == 1 then
        local arg = args[1]
        if type(arg) == "table" and arg.contents then
            self:add_sublayer(arg)
        else
            self:add_tree(arg)
        end
        return self
    end

    for _, layer in ipairs(args) do
        self:add_sublayer(layer)
    end
    return self
end

-- TODO Inline mode vs expanded
-- TODO fewer decimals
-- TODO print hue
function Layer:__tostring()
    local function tostring_r(layer, depth)
        local indent = (depth > 0) and string.rep("  ", depth - 1) .. "  |- " or ""
        local prefix = (depth > 0) and (layer.name .. ": ") or layer.name .. ": "
        local contents
        if layer.contents.name then
            contents = tostring(layer.contents)
        else
            contents = Utils.get_names(layer.contents)
        end
        local str = indent ..
            prefix ..
            "z_index = " .. tostring(layer.z_index) ..
            ", opacity = " .. tostring(layer.opacity) ..
            ", contents = " .. tostring(contents)

        for _, sublayer in ipairs(layer.sublayers) do
            str = str .. "\n" .. tostring_r(sublayer, depth + 1)
        end

        return str
    end

    return tostring_r(self, 0)
end

function Layer:add_sublayer(layer)
    layer.superlayer = self
    table.insert(self.sublayers, layer)
    return self
end

function Layer:remove_sublayer(layer)
    local index
    for i, v in ipairs(self.sublayers) do
        if v == layer then
            index = i
            break
        end
    end
    if index == nil then return end
    table.remove(self.sublayers, index)
    return self
end

function Layer:sort_sublayers()
    if self.sublayers then
        table.sort(self.sublayers, function(a, b)
            return a.z_index < b.z_index
        end)
    end
end

function Layer:sort_contents()
    if self.contents then
        table.sort(self.contents, function(a, b)
            return a.z_index < b.z_index
        end)
    end
end

function Layer:add_tree(tree)
    for _, l in ipairs(tree) do
        local name = l.name or l.n
        local z_index = l.z_index or l.z
        local contents = l.contents or l.c
        local opacity = l.opacity or l.o
        local hue = l.hue or l.h
        local saturation = l.saturation or l.s
        local lightness = l.lightness or l.l
        local options = {
            name = name,
            z_index = z_index,
            contents = contents,
            opacity = opacity,
            hue = hue,
            saturation = saturation,
            lightness = lightness,
        }
        local layer = Layer.new(options)

        local sublayers = l.sublayers or l.sl
        self:add_sublayer(layer)
        if sublayers then
            layer:add_tree(sublayers)
        end
    end

    return self
end

function Layer:_dfs_sort_and_collect(t)
    if not t then t = {} end
    self:sort_contents()
    self:sort_sublayers()
    for _, layer in ipairs(self.sublayers) do
        layer:_dfs_sort_and_collect(t)
    end
    table.insert(t, self)
    return t
end

function Layer:draw(options)
    options = options or {}
    local sl_opacity = options.sl_opacity or 1
    local opacity = sl_opacity * self.opacity
    local sl_saturation = options.sl_saturation or 1
    local saturation = sl_saturation * self.saturation

    local to_draw = self:_dfs_sort_and_collect()
    for _, layer in ipairs(to_draw) do
        if #layer.contents > 0 then
            if layer.contents.draw then
                layer.contents.color:Opacity(opacity)
                layer.contents.color:Offset_Hue(self.hue)
                layer.contents.color:Saturation(saturation)
                layer.contents:draw()
            else
                for _, obj in ipairs(layer.contents) do
                    obj.color:Opacity(opacity)
                    obj.color:Offset_Hue(self.hue)
                    obj.color:Saturation(saturation)
                    obj:draw()
                end
            end
        end
        if #layer.sublayers > 0 then
            for _, sublayer in ipairs(layer.sublayers) do
                options = {
                    sl_opacity = opacity,
                    sl_hue = self.hue,
                    sl_saturation = saturation
                }
                sublayer:draw(options)
            end
        end
    end
end
