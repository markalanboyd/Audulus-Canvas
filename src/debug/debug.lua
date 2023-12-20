--- Useful debugging functions.
-- @module debug

--- Returns a set of functions that together enable stdout-like printing.
-- The built-in Lua print() function can't print anywhere in Audulus. This
-- function enables you to add in a stdout-like experience in Audulus. The
-- function creates two functions (normally named print and printAll) that
-- assist in printing variables beneath the Canvas node. print() will add a
-- variable or value to the print queue. Use print() just as you would in any
-- any other program. Then, call printAll() at the very end of your script to
-- display the print queue. Each print item is numbered in the order it was
-- called starting at 1. Additionally, displays the current memory usage.
-- @treturn function add_to_queue Adds variable to print queue.
-- @treturn function print_queue Prints the queue beneath the Canvas node.
-- @usage
-- print, printAll = create_print_logger()
--
-- x = 1 + 1
-- print(x)
--
-- color = {0.5, 0.75, 0.1, 1}
-- print(color)
--
-- coordinate = {x = 1, y = 12}
-- print(coordinate)
--
-- printAll()
-- -- (Note: This appears below the Canvas node) --
-- -- Memory usage (KB): 72
-- -- Print Queue Output
-- -- _________________
-- -- 1. 2
-- -- 2. {0.5, 0.75, 0.1, 1}
-- -- 3. {x = 1, y = 12}
function create_print_logger()
    local queue = {}

    local function has_non_integer_keys(t)
        for k, _ in pairs(t) do
            if type(k) ~= "number" or k ~= math.floor(k) or k < 1 then
                return true
            end
        end
        return false
    end

    local function table_to_string(t)
        local parts = {}
        if has_non_integer_keys(t) then
            for k, v in pairs(t) do
                parts[#parts + 1] = tostring(k) .. " = " .. tostring(v)
            end
        else
            for _, v in ipairs(t) do
                parts[#parts + 1] = tostring(v)
            end
        end
        return "{ " .. table.concat(parts, ", ") .. " }"
    end

    local function add_to_queue(...)
        local args = { ... }
        local statements = {}

        for i, arg in ipairs(args) do
            statements[i] = (type(arg) == "table")
                and table_to_string(arg) or tostring(arg)
        end

        table.insert(queue, table.concat(statements, ", "))
    end

    local function print_queue()
        local memory = math.floor(collectgarbage("count"))

        translate { 0, -30 }
        text("Memory usage (KB): " .. memory, theme.text)
        translate { 0, -20 }
        text("Print Queue Output", theme.text)
        translate { 0, -4 }
        text("_________________", theme.text)
        translate { 0, -20 }

        for i, s in ipairs(queue) do
            text(i .. ": " .. s, theme.text)
            translate { 0, -14 }
        end
    end

    return addToQueue, printQueue
end
