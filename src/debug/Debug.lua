Debug = {}

function Debug.Logger()
    local queue = {}

    local function add_to_queue(...)
        local args = { ... }
        local statements = {}

        for i, arg in ipairs(args) do
            statements[i] = (type(arg) == "table")
                and Utils.table_to_string(arg) or tostring(arg)
        end

        table.insert(queue, table.concat(statements, ", "))
    end

    local function get_peak_memory(interval)
        if _PeakMemory == nil then
            _PeakMemory = math.floor(collectgarbage("count"))
        end

        if Time == nil then Time = 0 end
        local current_memory_usage = math.floor(collectgarbage("count"))
        local truncated_time = math.floor(Time * 100) / 100

        if _PeakMemory < current_memory_usage then
            _PeakMemory = current_memory_usage
        end

        if truncated_time % interval == 0 then _PeakMemory = 0 end

        return _PeakMemory
    end

    local function print_queue()
        translate { 0, -30 }
        text("Peak memory usage (KB): " .. get_peak_memory(10), theme.text)
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

    return add_to_queue, print_queue
end

print, print_all = Debug.Logger()
