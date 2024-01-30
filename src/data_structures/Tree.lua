Tree = {}

Tree.__index = Tree

function Tree.new(value)
    local self = setmetatable({}, Tree)
    self.val = value

    self.parent = nil
    self.children = {}
    return self
end

-- TODO Print the tree out left to right
function Tree:__tostring()
    local function recursive_to_string(node, depth)
        depth = depth or 0
        local indent = string.rep("  ", depth)
        local str = "TreeNode: val = " .. tostring(node.val)

        if node.parent then
            str = str .. "\n" .. indent .. "  ⮑  parent = " .. recursive_to_string(node.parent, depth + 1)
        else
            str = str .. "\n" .. indent .. "  ⮑  parent = nil"
        end

        return str
    end

    return recursive_to_string(self)
end

function Tree:add_child(node)
    node.parent = self
    table.insert(self.children, node)
    return self
end

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

function Tree:dfs(t)
    if self == nil then return end
    if not t then t = {} end

    table.insert(t, self)

    for _, node in ipairs(self.children) do
        node:dfs(t)
    end

    return t
end
