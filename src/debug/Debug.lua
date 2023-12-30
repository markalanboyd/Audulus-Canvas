Debug = {}

function Debug.Logger()
    local queue = {}

    local function add_to_queue(...)
        local statements = {}

        for i = 1, select("#", ...) do
            local arg = select(i, ...)
            if arg == nil then
                statements[i] = "nil"
            else
                statements[i] = (type(arg) == "table")
                    and Utils.table_to_string(arg) or tostring(arg)
            end
        end

        table.insert(queue, table.concat(statements, ", "))
    end

    local function truncate_and_add_to_queue(places, ...)
        if not MathUtils.is_positive_int(places) then
            error("Error: First argument 'places' must be a positive integer")
        end
        local statements = {}

        for i = 1, select("#", ...) do
            local arg = select(i, ...)
            if arg == nil then
                statements[i] = "nil"
            else
                statements[i] = (type(arg) == "table")
                    and Utils.table_to_string(arg, true, places)
                    or tostring(MathUtils.truncate(arg, places))
            end
        end

        table.insert(queue, table.concat(statements, ", "))
    end

    local function print_queue()
        translate { 0, -30 }
        text("Memory usage: " .. Utils.get_peak_memory(10) .. "KB", theme.text)
        translate { 0, -20 }
        text("Print Queue Output", theme.text)
        translate { 0, -4 }
        text("_________________", theme.text)
        translate { 0, -20 }

        for _, s in ipairs(queue) do
            if s:sub(1, 3) == "-- " then
                text("> " .. s, theme.greenHighlight)
            elseif s:sub(1, 3) == ":: " then
                text("> " .. s, theme.azureHighlight)
            elseif string.match(s, "^:%S") then
                text("> " .. s, ColorUtils.theme_yellow)
            else
                text("> " .. s, theme.text)
            end
            translate { 0, -14 }
        end
    end

    return add_to_queue, truncate_and_add_to_queue, print_queue
end

print, tprint, print_all = Debug.Logger()

function Debug.print_docstring(docstring)
    local newline = "\n"
    local buffer = ""
    for i = 1, #docstring do
        if docstring:sub(i, i) == newline then
            print(buffer)
            buffer = ""
        else
            buffer = buffer .. docstring:sub(i, i)
        end
    end
end
