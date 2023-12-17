-- Insert this function definition at the beginning of your script

local function createPrintLogger()
	local queue = {}

	local function addToPrintQueue(s)
		table.insert(queue, s)
	end

	local function printQueue()
		translate { 0 , -30 }
		text("Print Queue Output", theme.text)
		translate { 0, -20}
		for i, s in ipairs(queue) do
			text(i .. ": " .. s, theme.text)
			translate { 0 , -14 }
		end
	end

	return addToPrintQueue, printQueue
end

local print, printAll = createPrintLogger()

-- Your code goes here
-- Use `print()` as needed

-- Call `printAll()` in the last line in your script
printAll()
