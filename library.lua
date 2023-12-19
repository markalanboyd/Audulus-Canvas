local colors = {indianred={205,92,92,1},lightcoral={240,128,128,1},salmon={250,128,114,1},darksalmon={233,150,122,1},lightsalmon={255,160,122,1},crimson={220,20,60,1},red={255,0,0,1},firebrick={178,34,34,1},darkred={139,0,0,1},pink={255,192,203,1},lightpink={255,182,193,1},hotpink={255,105,180,1},deeppink={255,20,147,1},mediumvioletred={199,21,133,1},palevioletred={219,112,147,1},coral={255,127,80,1},tomato={255,99,71,1},orangered={255,69,0,1},darkorange={255,140,0,1},orange={255,165,0,1},gold={255,215,0,1},yellow={255,255,0,1},lightyellow={255,255,224,1},lemonchiffon={255,250,205,1},lightgoldenrodyellow={250,250,210,1},papayawhip={255,239,213,1},moccasin={255,228,181,1},peachpuff={255,218,185,1},palegoldenrod={238,232,170,1},khaki={240,230,140,1},darkkhaki={189,183,107,1},lavender={230,230,250,1},thistle={216,191,216,1},plum={221,160,221,1},violet={238,130,238,1},orchid={218,112,214,1},fuchsia={255,0,255,1},magenta={255,0,255,1},mediumorchid={186,85,211,1},mediumpurple={147,112,219,1},rebeccapurple={102,51,153,1},blueviolet={138,43,226,1},darkviolet={148,0,211,1},darkorchid={153,50,204,1},darkmagenta={139,0,139,1},purple={128,0,128,1},indigo={75,0,130,1},slateblue={106,90,205,1},darkslateblue={72,61,139,1},mediumslateblue={123,104,238,1},greenyellow={173,255,47,1},chartreuse={127,255,0,1},lawngreen={124,252,0,1},lime={0,255,0,1},limegreen={50,205,50,1},palegreen={152,251,152,1},lightgreen={144,238,144,1},mediumspringgreen={0,250,154,1},springgreen={0,255,127,1},mediumseagreen={60,179,113,1},seagreen={46,139,87,1},forestgreen={34,139,34,1},green={0,128,0,1},darkgreen={0,100,0,1},yellowgreen={154,205,50,1},olivedrab={107,142,35,1},olive={128,128,0,1},darkolivegreen={85,107,47,1},mediumaquamarine={102,205,170,1},darkseagreen={143,188,139,1},lightseagreen={32,178,170,1},darkcyan={0,139,139,1},teal={0,128,128,1},aqua={0,255,255,1},cyan={0,255,255,1},lightcyan={224,255,255,1},paleturquoise={175,238,238,1},aquamarine={127,255,212,1},turquoise={64,224,208,1},mediumturquoise={72,209,204,1},darkturquoise={0,206,209,1},cadetblue={95,158,160,1},steelblue={70,130,180,1},lightsteelblue={176,196,222,1},powderblue={176,224,230,1},lightblue={173,216,230,1},skyblue={135,206,235,1},lightskyblue={135,206,250,1},deepskyblue={0,191,255,1},dodgerblue={30,144,255,1},cornflowerblue={100,149,237,1},royalblue={65,105,225,1},blue={0,0,255,1},mediumblue={0,0,205,1},darkblue={0,0,139,1},navy={0,0,128,1},midnightblue={25,25,112,1},cornsilk={255,248,220,1},blanchedalmond={255,235,205,1},bisque={255,228,196,1},navajowhite={255,222,173,1},wheat={245,222,179,1},burlywood={222,184,135,1},tan={210,180,140,1},rosybrown={188,143,143,1},sandybrown={244,164,96,1},goldenrod={218,165,32,1},darkgoldenrod={184,134,11,1},peru={205,133,63,1},chocolate={210,105,30,1},saddlebrown={139,69,19,1},sienna={160,82,45,1},brown={165,42,42,1},maroon={128,0,0,1},white={255,255,255,1},snow={255,250,250,1},honeydew={240,255,240,1},mintcream={245,255,250,1},azure={240,255,255,1},aliceblue={240,248,255,1},ghostwhite={248,248,255,1},whitesmoke={245,245,245,1},seashell={255,245,238,1},beige={245,245,220,1},oldlace={253,245,230,1},floralwhite={255,250,240,1},ivory={255,255,240,1},antiquewhite={250,235,215,1},linen={250,240,230,1},lavenderblush={255,240,245,1},mistyrose={255,228,225,1},gainsboro={220,220,220,1},lightgray={211,211,211,1},silver={192,192,192,1},darkgray={169,169,169,1},gray={128,128,128,1},dimgray={105,105,105,1},lightslategray={119,136,153,1},slategray={112,128,144,1},darkslategray={47,79,79,1},black={0,0,0,1}}

function isValidHexCode(hex)
    hex = hex:gsub("#", "")
    local invalidChars = string.match(hex, "[^0-9a-fA-F]+")
    local hasValidChars = invalidChars == nil
    local isValidLen = #hex == 3 or #hex == 4 or #hex == 6 or #hex == 8
    return hasValidChars and isValidLen
end


--- Converts a hex code string to a color table.
-- Takes a string representation of a CSS hex value and converts it into
-- an {r, g, b, a} color table. The function ignores the leading #
-- symbol if present and will parse an 3 (rgb), 4 (rgba), 6 (rrggbb), or
-- 8 (rrggbbaa) character-long hex value into a normalized (0 to 1) rgba
-- color table. Sets a to 1 if not present in the hex code.

-- @tparam string s A hex code formatted as #rgb, #rgba, #rrggbb, or
-- #rrggbbaa with or without the leading # symbol
-- @treturn table color A color table in the format {r, g, b, a}
-- @error ValueError if hex code is malformed
-- @see isValidHexCode Depends on this validator
-- @see hexToColor If you want to convert a hexidecimal number to
-- a color table.
function hexCodeStrToColor(s)
    if not isValidHexCode(s) then
        error("ValueError: Not a valid hex code.")
    end

    s = tostring(s):gsub("#", "")
    local color = { r = "", g = "", b = "", a = "" }
    if #s == 3 or #s == 4 then
        color["r"] = s:sub(1, 1):rep(2)
        color["g"] = s:sub(2, 2):rep(2)
        color["b"] = s:sub(3, 3):rep(2)
        color["a"] = (#s == 4) and s:sub(4, 4):rep(2) or "FF"
    elseif #s == 6 or #s == 8 then
        color["r"] = s:sub(1, 2)
        color["g"] = s:sub(3, 4)
        color["b"] = s:sub(5, 6)
        color["a"] = (#s == 8) and s:sub(7, 8) or "FF"
    end

    for k, v in pairs(color) do
        color[k] = tonumber(v, 16) / 255
    end

    return color
end


function normalizedValToHexStr(nVal)
    return "#" .. string.format("%08X", math.floor(nVal * 0xFFFFFFFF))
end


function parseSVG(s)
    function parseStringVal(s, key, valType)
        local function escapeDashes(s)
            return (s:gsub("%-", "%%-"))
        end

        local function tobool(s)
            if s == "true" then
                return true
            elseif s == "false" then
                return false
            else
                error("TypeError: Cannot convert " .. s .. " to boolean.")
            end
        end

        local pattern = escapeDashes(key) .. '="([^"]+)"'
        local value = string.match(s, pattern)

        if valType == "number" then
            return tonumber(value)
        elseif valType == "string" then
            return value
        elseif valType == "bool" then
            return tobool(value)
        else
            error("TypeError: Invalid type. Options are 'number', 'string', or 'bool'.")
        end
    end

    local function parseRect(sub)
        local x1 = parseVal(sub, "x", "number")
        local y1 = parseVal(sub, "y", "number")
        local width = parseVal(sub, "width", "number")
        local height = parseVal(sub, "height", "number")
        local x2 = x1 + width
        local y2 = y1 + height
        local coordA = { x1, y1 }
        local coordB = { x2, y2 }
        local fill = parseVal(sub, "fill", "string")
        if fill ~= nil then fill = color_paint(colors[fill]) end
        local stroke = parseVal(sub, "stroke", "string")
        if stroke ~= nil then stroke = color_paint(colors[stroke]) end
        local strokeWidth = parseVal(sub, "stroke-width", "number")

        if fill ~= "none" then
            fill_rect(coordA, coordB, 0, fill)
        end

        if stroke ~= "none" then
            stroke_rect(coordA, coordB, -strokeWidth / 2, strokeWidth, stroke)
        end
    end

    for rect in s:gmatch("<rect%s+([^>]+)/>") do
        parseRect(rect)
    end
end


function parseStringVal(s, key, valType)
    local function escapeDashes(s)
        return (s:gsub("%-", "%%-"))
    end

    local function tobool(s)
        if s == "true" then
            return true
        elseif s == "false" then
            return false
        else
            error("TypeError: Cannot convert " .. s .. " to boolean.")
        end
    end

    local pattern = escapeDashes(key) .. '="([^"]+)"'
    local value = string.match(s, pattern)

    if valType == "number" then
        return tonumber(value)
    elseif valType == "string" then
        return value
    elseif valType == "bool" then
        return tobool(value)
    else
        error("TypeError: Invalid type. Options are 'number', 'string', or 'bool'.")
    end
end


paint = color_paint { r, g, b, a }
paint = linear_gradient( {start_x, start_y}, {end_x, end_y}, {r, g, b, a}, {r, g, b, a})

fill_circle( {x, y}, radius, paint)
stroke_circle( {x, y}, radius, width, paint)

stroke_arc( {x, y}, radius, width, rotation, aperture, paint)
stroke_segment( {ax, ay}, {bx, by}, width, paint)

fill_rect( {min_x, min_y}, {max_x, max_y}, corner_radius, paint)
stroke_rect( {min_x, min_y}, {max_x, max_y}, corner_radius, width, paint)

stroke_bezier( {ax, ay}, {bx, by}, {cx, cy}, width, paint)

text("hello world!", {r,g,b,a})
min, max = text_bounds("hello world!")
text_box("lorem ipsum...", break_row_width, {r,g,b,a})

move_to {x, y}
line_to {x, y}
quad_to({bx, by}, {cx, cy})
fill(paint)

translate {tx, ty}
scale {sx, sy}
scale {sx, sy}
save()
restore()

canvas_width
canvas_height

theme.azureHighlight
theme.azureHighlightDark
theme.azureHighlightBackground

theme.greenHighlight
theme.greenHighlightDark
theme.azureHighlightBackground

theme.redHighlight
theme.redHighlightDark
theme.redHighlightBackground

theme.grooves
theme.modules
theme.text


function btn(x, y, width, options)
    -- Error Handling
    local function checkMutuallyExclusiveArgs(arg1Name, arg1, arg2Name, arg2)
        local e = "MutuallyExclusiveArgError: '%s' and '%s' cannot be used" ..
            "together. Remove one or the other."
        if arg1 and arg2 then
            error(string.format(e, arg1Name, arg2Name))
        end
    end

    -- Optional Keyword Arguments
    local o = options or {}
    local height = o.height or width
    local id = o.id or 0
    local c = o.color or { 1, 1, 1, 1 }

    -- Corner Radius
    local r = o.radius or nil
    local pRadius = o.pRadius or false
    if pRadius then
        checkMutuallyExclusiveArgs("radius", r, "pRadius", pRadius)
        local pRadiusPercent = math.min(o.pRadiusPercent or 10, 50)
        r = width * (pRadiusPercent / 100)
    else
        if r ~= nil and r > width then
            error(string.format("ValueError: Radius cannot exceed size." ..
                "Max: %d, " ..
                "Provided: %d",
                width, r))
        end
    end
    local radius = r or 0

    -- Border
    local border = o.border or false
    local borderWidth = o.borderWidth or 1
    local borderColor = o.borderColor or
        { c[1] * 0.75, c[2] * 0.75, c[3] * 0.75, c[4] }

    -- Initialize coordinates
    local x1 = x
    local y1 = y
    local x2 = x + width
    local y2 = y + height

    -- Touch detector
    local btnTouched = tX >= x1 and tX <= x2 and tY >= y1 and tY <= y2 and t > 0

    -- Shrink on press
    local shrinkOnPress = o.shrinkOnPress or false
    if shrinkOnPress and btnTouched then
        local shrinkPercent = o.shrinkPercent or 90
        local sP = shrinkPercent / 100
        local dX = (x2 - x1) * (1 - sP) / 2
        local dY = (y2 - y1) * (1 - sP) / 2
        x1 = x1 + dX
        y1 = y1 + dY
        x2 = x2 - dX
        y2 = y2 - dY
    end

    -- Padding
    local p = o.pad or nil
    local pPad = o.pPad or false
    if pPad then
        checkMutuallyExclusiveArgs("pad", p, "pPad", pPad)
        local pPadPercent = o.pPadPercent or 5
        p = width * (pPadPercent / 100)
    end
    local pad = p or 0
    x1 = x1 + pad
    y1 = y1 + pad
    x2 = x2 - pad
    y2 = y2 - pad

    -- Pack coordinates
    local pA = { x1, y1 }
    local pB = { x2, y2 }

    -- Draw
    local function drawButton()
        local br = btnTouched and 1 or 0
        local st = grid[id] * 0.5
        local f = math.max(0, math.min(br + st, 1))
        local paint = color_paint(
            { c[1] * f, c[2] * f, c[3] * f, c[4] }
        )
        if not border then
            fill_rect(pA, pB, radius, paint)
        else
            -- Border
            fill_rect(pA, pB, radius, color_paint(borderColor))

            -- Adjust the radius as border gets thicker
            local innerWidth = x2 - x1 - borderWidth
            local innerHeight = y2 - y1 - borderWidth
            local scaleFactor = math.min(innerWidth / (x2 - x1),
                innerHeight / (y2 - y1))
            local adjustedRadius = radius * scaleFactor

            -- Inner rectangle
            local hBW = borderWidth / 2
            local pAB = { x1 + hBW, y1 + hBW }
            local pBB = { x2 - hBW, y2 - hBW }
            fill_rect(pAB, pBB, adjustedRadius, paint)
        end
    end

    drawButton()
end

function tileFn(func, r, c)
    return function(x, y, w, o)
        local h = o.height or w
        for i = 0, c - 1 do
            for j = 0, r - 1 do
                o.id = i + 1 + j * c
                func(x + i * w, y + j * h, w, o)
            end
        end
    end
end


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
			if type(arg) == "table" then arg = tableToString(arg) end
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


