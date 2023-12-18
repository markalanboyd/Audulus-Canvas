local function createPrintLogger()
	local queue = {}

	local function addToQueue(...)
		local function hasNonIntegerKeys(t)
			for k, _ in pairs(t) do
				if type(k) ~= "number" or k ~= math.floor(k) or k < 1 then
					return true
				end
			end
			return false
		end

		local function tableToString(t)
			local s = "{ "
			if hasNonIntegerKeys(t) then
				for k, v in pairs(t) do
					s = s .. "[" .. k .. "] = " .. v .. ", "
				end
			else
				for _, v in pairs(t) do
					s = s .. v .. ", "
				end
			end
			s = s:sub(1, -3) .. " }"
			return s
		end

		local args = { ... }
		local statement = ""

		for i, arg in ipairs(args) do
			if type(arg) == "table" then
				arg = tableToString(arg)
			end
			statement = statement .. tostring(arg) .. ", "
		end

		statement = statement:sub(1, -3)
		table.insert(queue, statement)
	end

	local function printQueue()
		translate { 0, -30 }
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
-- Call print() where needed --

printAll()
