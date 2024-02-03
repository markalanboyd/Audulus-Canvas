-- TODO - Set a background that is always the lowest layer
-- TODO - Set a foreground that is always the highest layer
-- TODO - Attach origin to background/foreground based on preference
-- TODO - Global layer system vs local layer system - objects can have their own layers
-- TODO - Guard against directly putting things into layers that can't be drawn

Layer = {}
La = Layer
Layer.__index = Layer
Layer.layers = {}

setmetatable(Layer, { __index = Tree })

function Layer.new(z_index, val)
    local self = Tree.new(val)
    setmetatable(self, {
        __index = Layer,
        __call = Tree.__call,
        __tostring = Layer.__tostring,
    })

    self.z_index = z_index or 0

    return self
end

function Layer:__tostring()
    local function tostring_r(node, depth, childNumber)
        local indent = (depth > 0) and string.rep("  ", depth - 1) .. "  |- " or ""
        local prefix = (depth > 0) and ("Child" .. childNumber .. ": ") or "Root: "
        local str = indent .. prefix .. "z_index = " .. tostring(node.z_index) .. ", contents = " .. tostring(node.val)

        for i, child in ipairs(node.children) do
            str = str .. "\n" .. tostring_r(child, depth + 1, i)
        end

        return str
    end

    return tostring_r(self, 0, 0)
end

function Layer:sort_children()
    table.sort(self.children, function(a, b)
        return a.z_index < b.z_index
    end)
end

-- TODO Make this work with call method?
-- TODO Shorten z_index and contents?
function Layer:add_structure(tree_structure)
    for _, v in ipairs(tree_structure) do
        local z_index = v.z_index or v.z or 0
        local contents = v.contents or v.c
        local sublayers = v.sublayers or v.sl
        local node = Layer.new(z_index, contents)
        self:add_child(node)
        if sublayers then
            node:add_structure(sublayers)
        end
    end

    return self
end

function Layer:_dfs_sort_and_collect(t)
    if not t then t = {} end
    if self.children then
        self:sort_children()
    end
    for _, node in ipairs(self.children) do
        node:_dfs_sort_and_collect(t)
    end
    table.insert(t, self)
    return t
end

-- TODO Sort objects by z_index within the tree_structure
function Layer:draw()
    local to_draw = self:_dfs_sort_and_collect()
    for _, node in ipairs(to_draw) do
        if node.val ~= nil then
            if node.val.draw ~= nil then
                node.val:draw()
            else
                for _, obj in ipairs(node.val) do
                    obj:draw()
                end
            end
        end
    end
end
