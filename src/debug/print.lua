local function createPrintLogger()
    local queue = {}

    local function addToQueue(...)
    	local args = {...}
    	local statement = ""

    	for i, arg in ipairs(args) do
    		if i == 1 then
	    		statement = statement .. arg
	    	else
	    		statement = statement .. ", " .. arg
	    	end
    	end

    	table.insert(queue, statement)
    end

    local function printQueue()
        translate { 0 , -30 }
        text("Print Queue Output", theme.text)
        translate { 0, -4}
        text("_________________", theme.text)
        translate { 0, -20}

        for i, s in ipairs(queue) do
            text(i .. ": " .. s, theme.text)
            translate { 0 , -14 }
        end
    end

    return addToQueue, printQueue
end

local print, printAll = createPrintLogger()

-- INSERT SCRIPT HERE --

printAll()
