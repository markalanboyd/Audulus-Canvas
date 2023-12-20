local function createPrintLogger()
	local queue = {}

	local function hasNonIntegerKeys(t)
		for k, _ in pairs(t) do
			if type(k) ~= "number" or k ~= math.floor(k) or k < 1 then
				return true
			end
		end
		return false
	end

	local function tableToString(t)
		local parts = {}
		if hasNonIntegerKeys(t) then
			for k, v in pairs(t) do
				parts[#parts + 1] = "[" .. tostring(k) .. "] = " .. tostring(v)
			end
		else
			for _, v in ipairs(t) do
				parts[#parts + 1] = tostring(v)
			end
		end
		return "{ " .. table.concat(parts, ", ") .. " }"
	end

	local function addToQueue(...)
		local args = { ... }
		local statements = {}

		for i, arg in ipairs(args) do
			statements[i] = (type(arg) == "table")
				and tableToString(arg) or tostring(arg)
		end

		table.insert(queue, table.concat(statements, ", "))
	end

	local function printQueue()
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

local print, printAll = createPrintLogger()

-- INSERT SCRIPT HERE --

printAll()
