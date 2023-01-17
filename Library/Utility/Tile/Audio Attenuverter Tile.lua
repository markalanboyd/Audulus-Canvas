----|| AUDIO ATTENUVERTER TILE ||--
-- v1.1


----|| INPUTS ||--__
-- in1 out1 knob1


----|| DECLARE CONSTANTS ||----

-- Themes --

TEXT_LIGHT = theme.text
TEXT_DARK = theme.grooves

RED = { 1, 0, 0, 1 }
GREEN = { 0, 1, 0, 1 }
BLUE = { 0, 0, 1, 1 }

-- Paints --

RED_LIGHT = color_paint(theme.redHighlight)
RED_DARK = color_paint(theme.redHighlightDark)
RED_BACKGROUND = color_paint(theme.redHighlightBackground)

GREEN_LIGHT = color_paint(theme.greenHighlight)
GREEN_DARK = color_paint(theme.greenHighlightDark)
GREEN_BACKGROUND = color_paint(theme.greenHighlightBackground)

BLUE_LIGHT = color_paint(theme.azureHighlight)
BLUE_DARK = color_paint(theme.azureHighlightDark)
BLUE_BACKGROUND = color_paint(theme.azureHighlightBackground)

GRAY_LIGHT = color_paint(theme.text)
GRAY_DARK = color_paint {0.3, 0.3, 0.3, 1}

GROOVES = color_paint(theme.grooves)
MODULES = color_paint(theme.modules)

-- Sizes --

SIZE_XL = 10
SIZE_L = 8
SIZE_M = 6
SIZE_S = 4
SIZE_XS = 2

TEXT_SMALL = 0.5
TEXT_MEDIUM = 0.75
TEXT_NORMAL = 1
TEXT_LARGE = 2


----|| DEFINE FUNCTIONS ||----

--// Boilerplate functions //--

function adjustAlpha(input, colorTheme)
    --// Returns a paint color whose alpha value is modulated by the input
    return color_paint { colorTheme[1], colorTheme[2], colorTheme[3], colorTheme[4] * input }
end

function adjustBrightness(input, colorTheme)
    --// Returns a paint color whose brightness is modulated by the input
    return color_paint { colorTheme[1] * input, colorTheme[2] * input, colorTheme[3] * input, colorTheme[4] }
end

function createLight(type, input)
    --// Creates a paint color modulated by an input
    -- Type
    -- 0 = gate
    -- 1 = mod
    -- 2 = audio / any
    if type == 0 then
        return adjustAlpha(input, theme.azureHighlight)
    elseif type == 1 then
        return adjustBrightness(input, RED)
    elseif type == 2 then
        if input > 0 then
            return adjustBrightness(input, RED)
        else
            return adjustBrightness(-input, BLUE)
        end
    end
end

function drawInput(x, y, type, light, textX, textY, textContent, textSize)
    --// Draws an input light
    -- Type
    -- 0 = gate
    -- 1 = mod
    -- 2 = audio/any
    if type == 0 then
        textColor = TEXT_DARK
        stroke_circle({x, y}, 10, 1.5, BLUE_DARK)
        fill_circle({x, y}, 4.2, BLUE_LIGHT)
    elseif type == 1 then
        textColor = TEXT_DARK
        stroke_circle({x, y}, 10, 1.5, RED_DARK)
        fill_circle({x, y}, 4.2, RED_LIGHT)
    elseif type == 2 then
        textColor = TEXT_LIGHT
        stroke_circle({x, y}, 10, 1.5, GROOVES)
        fill_circle({x, y}, 4.2, MODULES)
    end

    -- Light ring
    stroke_circle({x, y}, 10, 1.5, light)

    -- Label
    drawText(textX, textY, textContent, textSize, textColor)
end

function drawOutput(x, y, type, light, textX, textY, textContent, textSize)
    --// Draws an output light
    -- Type
    -- 0 = gate
    -- 1 or 2 = mod/audio/any
    if type == 0 then
        textColor = TEXT_DARK
        fill_circle({x, y}, SIZE_S, BLUE_DARK)
        fill_circle({x, y}, SIZE_S, light)
    elseif type == 1 or type == 2 then
        textColor = TEXT_LIGHT
        fill_circle({x, y}, SIZE_S, light)
    end
    
    -- Label
    drawText(textX, textY, textContent, textSize, textColor)
end

function drawText(x, y, textContent, size, color)
    --// Draws text
    -- Save transform state
    save()

    -- Position
    translate {x, y}

    -- Resize
    scale {size, size}

    -- Draw
    text(textContent, color)
    
    -- Restore transform state
    restore()
end

--// Module-specific functions //--

function drawAudioSineWaveBackground(x, y, size)
	-- // Draws a muted two-color sine wave
    -- Define variable
	width = 1

    -- Save transform state
	save()

    -- Position
	translate {x, y}

    -- Draw the two segments of the sine wave
	stroke_bezier( {0, 0}, {0.25 * size , 1 * size}, {0.5 * size, 0}, width, RED_DARK)
	stroke_bezier( {0.5 * size, 0}, {0.75 * size , -1 * size}, {1 * size, 0}, width, BLUE_DARK)

    -- Restore transform state
	restore()
end

function drawAtvertAudioSineWaveIcon(x, y, size, control)
	-- // Draws a two-color sine wave whose amplitude and orientation are responsive to a control input
	-- Define variables
    width = 1
	bipolarControl = (control - 0.5) * 2
    
    -- Save transform state
	save()

    -- Position
	translate {x, y}

    -- Draw sine wave and swap colors so that red is always on top and blue is always on bottom
	if control > 0.5 then
		stroke_bezier( {0, 0}, {0.25 * size , 1 * size * bipolarControl}, {0.5 * size, 0}, width, RED_LIGHT)
		stroke_bezier( {0.5 * size, 0}, {0.75 * size , -1 * size * bipolarControl}, {1 * size, 0}, width, BLUE_LIGHT)
	else
		stroke_bezier( {0, 0}, {0.25 * size , 1 * size * bipolarControl}, {0.5 * size, 0}, width, BLUE_LIGHT)
		stroke_bezier( {0.5 * size, 0}, {0.75 * size , -1 * size * bipolarControl}, {1 * size, 0}, width, RED_LIGHT)
	end
	
    -- Restore transform state
	restore()
end


----|| DEFINE VARIABLES ||----

-- Lights --
---- createLight(type, input)

in1Light = createLight(2, in1)
out1Light = createLight(2, out1)


----|| DRAW ||----

--// Input //--
---- drawInput(x, y, type, light, textX, textY, textContent, textSize)
drawInput( 10, 10, 2, in1Light, 7.9, 8, "A", TEXT_SMALL )

--// Output //--
---- drawOutput(x, y, type, light, textX, textY, textContent, textSize)
drawOutput( 50, 10, 2, out1Light, 47.9, 8, "A", TEXT_SMALL)

--// Graphics //--
---- drawAudioSineWave(x, y, size, control)
---- drawAtvertAudioSineWaveIcon(x, y, size, control)
drawAudioSineWaveBackground(20, 60, 20)
drawAtvertAudioSineWaveIcon(20, 60, 20, knob1)

