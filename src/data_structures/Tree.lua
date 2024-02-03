Tree = {}

Tree.__index = Tree

function Tree.new(value)
    local self = setmetatable({}, Tree)
    self.val = value

    self.parent = nil
    self.children = {}
    return self
end

function Tree:__call(...)
    local nodes = { ... }

    for _, node in ipairs(nodes) do
        self:add_child(node)
    end
end

function Tree:__tostring()
    local function tostring_r(node, depth, childNumber)
        local indent = (depth > 0) and string.rep("    ", depth - 1) .. "    |- " or ""
        local prefix = (depth > 0) and ("Child" .. childNumber .. ": ") or "Root: "
        local str = indent .. prefix .. "val = " .. tostring(node.val)

        for i, child in ipairs(node.children) do
            str = str .. "\n" .. tostring_r(child, depth + 1, i)
        end

        return str
    end

    return tostring_r(self, 0, 0)
end

function Tree:add_child(node)
    node.parent = self
    table.insert(self.children, node)
    return self
end

-- TODO Should this return self or the child or both?
function Tree:remove_child(node)
    local index
    for i, v in ipairs(self.children) do
        if v == node then
            index = i
            break
        end
    end
    if index == nil then return end
    table.remove(self.children, index)
    return self
end

function Tree:dfs_pre(t)
    if not t then t = {} end

    table.insert(t, self)

    for _, node in ipairs(self.children) do
        node:dfs_pre(t)
    end

    return t
end

function Tree:dfs_post(t)
    if not t then t = {} end

    for _, node in ipairs(self.children) do
        node:dfs_post(t)
    end

    table.insert(t, self)

    return t
end

function Tree:bfs()
    local function dequeue(t)
        return table.remove(t, 1)
    end
    local visited = {}
    local to_visit = {}
    table.insert(to_visit, self)
    while #to_visit ~= 0 do
        local node = dequeue(to_visit)
        table.insert(visited, node)
        if node.children then
            for _, child in ipairs(node.children) do
                table.insert(to_visit, child)
            end
        end
    end
    return visited
end

function Tree:add_structure(tree_structure)
    for _, v in ipairs(tree_structure) do
        local node = Tree.new(v.val)
        self:add_child(node)
        if v.children then
            node:add_structure(v.children)
        end
    end

    return self
end
