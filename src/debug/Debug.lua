-- TODO Add automatic line breaking
-- TODO Add a way to parse parameters for a Class.docs("short")
-- TODO Add automatic tostring

Debug = {}

function Debug.Logger()
    local queue = {}

    local function add_to_queue(...)
        local statements = {}

        for i = 1, select("#", ...) do
            local arg = select(i, ...)
            if arg == nil then
                statements[i] = "nil"
            elseif arg.__tostring then
                statements[i] = tostring(arg)
            else
                statements[i] = (type(arg) == "table")
                    and Utils.table_to_string(arg) or tostring(arg)
            end
        end

        table.insert(queue, table.concat(statements, ", "))
    end

    local function truncate_and_add_to_queue(places, ...)
        if not Math.is_positive_int(places) then
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
                    or tostring(Math.truncate(arg, places))
            end
        end

        table.insert(queue, table.concat(statements, ", "))
    end

    local function print_queue()
        translate { 0, -30 }
        text(_VERSION, theme.azureHighlight)
        translate { 0, -20 }
        text("Memory Usage: " .. Utils.get_peak_memory(10) .. "KB", theme.text)
        translate { 0, -20 }
        text("Print Queue Output", theme.text)
        translate { 0, -4 }
        text("_________________", theme.text)
        translate { 0, -20 }

        for _, s in ipairs(queue) do
            if s:sub(1, 3) == "-- " or s:sub(1, 1) == "." then
                text("> " .. s, theme.greenHighlight)
            elseif s:sub(1, 3) == ":: " then
                text("> " .. s, theme.azureHighlight)
            elseif string.match(s, "^:%S") then
                text("> " .. s, ColorTables.theme.yellow)
            elseif s:sub(1, 9) == "    param" then
                local scale_factor = 0.75
                local dim_green = {
                    theme.greenHighlight[1] * scale_factor,
                    theme.greenHighlight[2] * scale_factor,
                    theme.greenHighlight[3] * scale_factor,
                    theme.greenHighlight[4]
                }
                text("> " .. s, dim_green)
            elseif s:sub(1, 11) == "    Returns" then
                local scale_factor = 0.8
                local dim_red = {
                    theme.redHighlight[1] * scale_factor,
                    theme.redHighlight[2] * scale_factor,
                    theme.redHighlight[3] * scale_factor,
                    theme.redHighlight[4]
                }
                text("> " .. s, dim_red)
            elseif Utils.has_substring(s, "\n") then
                for line in string.gmatch(s, "([^\n]+)") do
                    text("> " .. line, theme.text)
                    translate { 0, -14 }
                end
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
