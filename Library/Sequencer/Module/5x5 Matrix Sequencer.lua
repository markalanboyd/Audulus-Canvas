
----|| DECLARE CONSTANTS ||----

-- Colors --

BLUE_LIGHT = color_paint(theme.azureHighlight)
BLUE_DARK = color_paint(theme.azureHighlightDark)
BLUE_BACKGROUND = color_paint(theme.azureHighlightBackground)

GREEN_LIGHT = color_paint(theme.greenHighlight)
GREEN_DARK = color_paint(theme.greenHighlightDark)
GREEN_BACKGROUND = color_paint(theme.greenHighlightBackground)

RED_LIGHT = color_paint(theme.redHighlight)
RED_DARK = color_paint(theme.redHighlightDark)
RED_BACKGROUND = color_paint(theme.redHighlightBackground)

GRAY_LIGHT = color_paint(theme.text)
GROOVES = color_paint(theme.grooves)
MODULES = color_paint(theme.modules)

TEXT_LIGHT = theme.text
TEXT_DARK = theme.grooves

-- Size & Spacing --

NUM_ROWS = 4

X_MATRIX_ORIGIN = 30
Y_MATRIX_ORIGIN = 320

KNOB_SPACING = 30

TEXT_NORMAL = 1
TEXT_SMALL = 0.5

SIZE_XL = 10
SIZE_L = 8
SIZE_M = 6
SIZE_S = 4
SIZE_XS = 2

-- Math Constants --

PI = 3.14159265359


----|| DECLARE VARIABLES ||----

-- Output lights --

-- X sequence outputs
x1Light = color_paint {x1, 0, 0, 1}
x2Light = color_paint {x2, 0, 0, 1}
x3Light = color_paint {x3, 0, 0, 1}
x4Light = color_paint {x4, 0, 0, 1}
x5Light = color_paint {x5, 0, 0, 1}

-- XY sequence output
xyLight = color_paint {xy, 0, 0, 1}

-- Y sequence outputs
y1Light = color_paint {y1, 0, 0, 1}
y2Light = color_paint {y2, 0, 0, 1}
y3Light = color_paint {y3, 0, 0, 1}
y4Light = color_paint {y4, 0, 0, 1}
y5Light = color_paint {y5, 0, 0, 1}


-- Input lights --

-- Button lights
modeGateLight = color_paint({theme.azureHighlight[1], theme.azureHighlight[2], theme.azureHighlight[3],
    theme.azureHighlight[4] * modeTriggerToggleGate})

-- Knob mod input lights
knob1ModLight = color_paint {knob1Mod, 0, 0, 1}
knob2ModLight = color_paint {knob2Mod, 0, 0, 1}
knob3ModLight = color_paint {knob3Mod, 0, 0, 1}
knob4ModLight = color_paint {knob4Mod, 0, 0, 1}
knob5ModLight = color_paint {knob5Mod, 0, 0, 1}
knob6ModLight = color_paint {knob6Mod, 0, 0, 1}

-- Gate lights
xGateLight = color_paint({theme.azureHighlight[1], theme.azureHighlight[2], theme.azureHighlight[3],
    theme.azureHighlight[4] * xIn1})
xSyncLight = color_paint({theme.azureHighlight[1], theme.azureHighlight[2], theme.azureHighlight[3],
    theme.azureHighlight[4] * xIn2})
yGateLight = color_paint({theme.azureHighlight[1], theme.azureHighlight[2], theme.azureHighlight[3],
    theme.azureHighlight[4] * yIn1})
ySyncLight = color_paint({theme.azureHighlight[1], theme.azureHighlight[2], theme.azureHighlight[3],
    theme.azureHighlight[4] * yIn2})
trigger1InLight = color_paint({theme.azureHighlight[1], theme.azureHighlight[2], theme.azureHighlight[3],
    theme.azureHighlight[4] * trigger1ToggleGate})
trigger2InLight = color_paint({theme.azureHighlight[1], theme.azureHighlight[2], theme.azureHighlight[3],
    theme.azureHighlight[4] * trigger2ToggleGate})

-- Mod lights
xModLight = color_paint({theme.redHighlight[1], theme.redHighlight[2], theme.redHighlight[3],
    theme.redHighlight[4] * xIn1})
xModLight2 = color_paint({theme.redHighlight[1], theme.redHighlight[2], theme.redHighlight[3],
    theme.redHighlight[4] * xIn2})
yModLight = color_paint({theme.redHighlight[1], theme.redHighlight[2], theme.redHighlight[3],
    theme.redHighlight[4] * yIn1})
yModLight2 = color_paint({theme.redHighlight[1], theme.redHighlight[2], theme.redHighlight[3],
    theme.redHighlight[4] * yIn2})


----|| DEFINE FUNCTIONS ||----
function drawXBeginEndControls()
    -- Circles for X and Y begin and end controls
    fill_circle({55, 135}, SIZE_M, GREEN_DARK)
    fill_circle({85, 135}, SIZE_S, RED_DARK)
end

function drawYBeginEndControls()
    fill_circle({115, 135}, SIZE_M, GREEN_DARK)
    fill_circle({145, 135}, SIZE_S, RED_DARK)
end

function drawXDirectionArrow()
    -- Arrows for x direction control
    if xBegin < xEnd then
        if xDirectionGate == 1 then
            drawText("→", 1.8, TEXT_LIGHT, 71, 62.4)
        else
            drawText("←", 1.8, TEXT_LIGHT, 71, 62.4)
        end
    elseif xBegin == xEnd then
        drawText("x", 1.8, TEXT_LIGHT, 73.4, 64.4)
    else
        if xDirectionGate == 1 then
            drawText("←", 1.8, TEXT_LIGHT, 71, 62.4)
        else
            drawText("→", 1.8, TEXT_LIGHT, 71, 62.4)
        end
    end
end

function drawYDirectionArrow()
    -- Arrows for y direction control
    if yBegin < yEnd then
        if yDirectionGate == 1 then
            drawText("↑", 1.8, TEXT_LIGHT, 114.5, 62.4)
        else
            drawText("↓", 1.8, TEXT_LIGHT, 114.5, 62.4)
        end
    elseif yBegin == yEnd then
        drawText("x", 1.8, TEXT_LIGHT, 114, 64.4)
    else
        if yDirectionGate == 1 then
            drawText("↓", 1.8, TEXT_LIGHT, 114.5, 62.4)
        else
            drawText("↑", 1.8, TEXT_LIGHT, 114.5, 62.4)
        end
    end
end

function drawDots(x, y, direction)
    -- Variables
    width = 0.5
    dotColor = GRAY_LIGHT

    -- Draw direction
    -- 0 = horizontal
    -- 1 = vertical
    if direction == 0 then
        for i = 1, 3 do
            fill_circle({x, y + i * 2}, width, dotColor)
        end
    else
        for i = 1, 5 do
            fill_circle({x + i * 2, y}, width, dotColor)
        end
    end
end

function drawInput(x, y, light, textContent, textSize, type, textX, textY)
    -- Type
    -- 0 = gate
    -- 1 = mod
    if type == 0 then
        stroke_circle({x, y}, 10, 1.5, BLUE_DARK)
    elseif type == 1 then
        fill_circle({x, y}, 4.2, RED_LIGHT)
    end

    -- Light ring
    stroke_circle({x, y}, 10, 1.5, light)
    
    -- Label
    drawText(textContent, textSize, TEXT_DARK, textX, textY)
end

function drawKnobMod(control, mod, x, y)
    -- Variables
    mod_radius = 11.5
    mod_width = 2
    mod_color = RED_DARK

    -- Save transform state
    save()

    -- Rotate so that beginning points match
    rotate(0.5 * PI)

    -- Calculate initial variables to animate modulation
    aperture = mod * PI
    rotation = control * PI * 2 + aperture

    -- Calculate how much the animation overshoots (wraps around the bottom)
    over = math.max(-PI * 2 + rotation + aperture, 0)

    -- Recalculate variables taking overshoot into account
    aperture2 = mod * PI - over * 0.5
    rotation2 = control * PI * 2 + aperture2

    -- Draw meter
    stroke_arc({y, -x}, mod_radius, mod_width, rotation2, aperture2, mod_color)

    -- Restore transform state
    restore()
end

function drawModMixIndicator(x, y, knob, orientation)
    -- Draw pin
    drawPinIndicator(x, y, knob)
    
    -- Orientation
    -- 0 = x on right
    -- 1 = y on right
    if orientation == 0 then
        drawText("X", 0.4, TEXT_LIGHT, x + 6, y - 1.5)
        drawText("Y", 0.4, TEXT_LIGHT, x - 1.5, y + 6)
    else
        drawText("Y", 0.4, TEXT_LIGHT, x + 6, y - 1.5)
        drawText("X", 0.4, TEXT_LIGHT, x - 1.2, y + 6)
    end
    drawText("-", TEXT_SMALL, TEXT_LIGHT, x - 9.2, y - 1.5)
end

function drawOutput(x, y, light, textContent, textSize, textX, textY)
    -- Light
    fill_circle({x, y}, SIZE_S, light)
    
    -- Label
    drawText(textContent, textSize, TEXT_LIGHT, textX, textY)
end

function drawPinIndicator(x, y, knob)
    -- Variables
    length = 5
    width = 1.5

    -- Save transform state
    save()

    -- Set origin of the indicator
    translate {x, y}

    -- Rotate 180° over sweep of knob
    rotate(-knob * PI)

    -- Reposition so that origin is at one end of pin
    translate {-length, -width / 2}

    -- Draw rectangle
    fill_rect({0, 0}, {length, width}, 0.5, RED_LIGHT)

    -- Restore transform state
    restore()
end

function drawPolyLightSlice(x, y, rotation, aperture, light)
    -- Slice
    stroke_arc({x, y}, 1, 6, rotation, aperture, light)
end

function drawPolyLightX(x, y, number)
    -- Divide pi by the number of slices
    fractPI = PI / number

    -- Draw appropriate number of slices
    if number >= 2 then
        drawPolyLightSlice(x, y, 0, fractPI, x1Light)
        drawPolyLightSlice(x, y, fractPI * 2 , fractPI, x2Light)
    end
    if number >= 3 then
        drawPolyLightSlice(x, y, fractPI * 4 , fractPI, x3Light)
    end
    if number >= 4 then
        drawPolyLightSlice(x, y, fractPI * 6 , fractPI, x4Light)
    end
    if number >= 5 then
        drawPolyLightSlice(x, y, fractPI * 8 , fractPI, x5Light)
    end
end

function drawPolyLightY(x, y, number)
    -- Divide pi by the number of slices
    fractPI = PI / number

    -- Draw appropriate number of slices
    if number >= 2 then
        drawPolyLightSlice(x, y, 0, fractPI, y1Light)
        drawPolyLightSlice(x, y, fractPI * 2, fractPI, y2Light)
    end
    if number >= 3 then
        drawPolyLightSlice(x, y, fractPI * 4, fractPI, y3Light)
    end
    if number >= 4 then
        drawPolyLightSlice(x, y, fractPI * 6, fractPI, y4Light)
    end
    if number >= 5 then
        drawPolyLightSlice(x, y, fractPI * 8, fractPI, y5Light)
    end
end

function drawMatrixGateMode(xCount, yCount, xBegin, xEnd)
    -- Variables
    xCoordinate = X_MATRIX_ORIGIN + (KNOB_SPACING * xCount)
    beginPosX = X_MATRIX_ORIGIN + (KNOB_SPACING * xBegin)
    endPosX = X_MATRIX_ORIGIN + (KNOB_SPACING * xEnd)
    beginPosY = 200 + (KNOB_SPACING * yBegin)
    endPosY = 200 + (KNOB_SPACING * yEnd)
    
    for i = 0, NUM_ROWS do
        -- XY step indicator
        if yCount == i then
        fill_circle({xCoordinate, 200 + i * KNOB_SPACING}, SIZE_XL, BLUE_LIGHT)
        end

        -- X Begin Steps
        fill_circle({beginPosX, Y_MATRIX_ORIGIN - KNOB_SPACING * i}, SIZE_M, GREEN_DARK)

        -- Y Begin Steps
        fill_circle({X_MATRIX_ORIGIN + i * KNOB_SPACING, beginPosY}, SIZE_M, GREEN_DARK)

        -- X End Steps
        fill_circle({endPosX, Y_MATRIX_ORIGIN - KNOB_SPACING * i}, SIZE_S, RED_DARK)

        -- Y End Steps
        fill_circle({X_MATRIX_ORIGIN + i * KNOB_SPACING, endPosY}, SIZE_S, RED_DARK)

        -- Draw X step indicators
        fill_circle({xCoordinate, Y_MATRIX_ORIGIN - KNOB_SPACING * i}, SIZE_XS, BLUE_LIGHT)

        -- Draw Y step indicators
        fill_circle({X_MATRIX_ORIGIN + i * KNOB_SPACING, 200 + KNOB_SPACING * yCount}, SIZE_XS, BLUE_LIGHT)
    end
end

function drawMatrixModMode(xCount, yCount, xBegin, xEnd)
    -- Variables
    xCoordinate = X_MATRIX_ORIGIN + (KNOB_SPACING * xCount)
    beginPosX = X_MATRIX_ORIGIN + (KNOB_SPACING * xBegin)
    endPosX = X_MATRIX_ORIGIN + (KNOB_SPACING * xEnd)
    beginPosY = 200 + (KNOB_SPACING * yBegin)
    endPosY = 200 + (KNOB_SPACING * yEnd)
    
    for i = 0, NUM_ROWS do
        -- XY step indicator
        if yCount == i then
        fill_circle({xCoordinate, 200 + i * KNOB_SPACING}, SIZE_XL, BLUE_LIGHT)
        end

        -- Draw X step indicators
        fill_circle({xCoordinate, Y_MATRIX_ORIGIN - KNOB_SPACING * i}, SIZE_XS, BLUE_LIGHT)

        -- Draw Y step indicators
        fill_circle({X_MATRIX_ORIGIN + i * KNOB_SPACING, 200 + KNOB_SPACING * yCount}, SIZE_XS, BLUE_LIGHT)
    end
end

function drawMatrixModSplitMode(xCount, yCount, xBegin, xEnd)
    -- Variables
    xCoordinate = X_MATRIX_ORIGIN + (KNOB_SPACING * xCount)
    beginPosX = X_MATRIX_ORIGIN + (KNOB_SPACING * xBegin)
    endPosX = X_MATRIX_ORIGIN + (KNOB_SPACING * xEnd)
    beginPosY = 200 + (KNOB_SPACING * yBegin)
    endPosY = 200 + (KNOB_SPACING * yEnd)
    
    for i = 0, NUM_ROWS do
        -- XY step indicator
        if yCount == i then
        fill_circle({xCoordinate, 200 + i * KNOB_SPACING}, SIZE_XL, BLUE_LIGHT)
        end

        -- Y Begin Steps
        fill_circle({X_MATRIX_ORIGIN + i * KNOB_SPACING, beginPosY}, SIZE_M, GREEN_DARK)

        -- Y End Steps
        fill_circle({X_MATRIX_ORIGIN + i * KNOB_SPACING, endPosY}, SIZE_S, RED_DARK)

        -- Draw X step indicators
        fill_circle({xCoordinate, Y_MATRIX_ORIGIN - KNOB_SPACING * i}, SIZE_XS, BLUE_LIGHT)

        -- Draw Y step indicators
        fill_circle({X_MATRIX_ORIGIN + i * KNOB_SPACING, 200 + KNOB_SPACING * yCount}, SIZE_XS, BLUE_LIGHT)
    end
end

function drawText(textContent, size, color, x, y)
    -- Save transform state
    save()

    -- Position the text
    translate {x, y}

    -- Resize the text
    scale {size, size}

    -- Draw text
    text(textContent, color)

    -- Restore transform state
    restore()
end

function drawTriggerLight(x, y, light)
    -- Draw dark ring
    stroke_circle({x, y}, 13, 2, GROOVES)

    -- Draw light ring
    stroke_circle({x, y}, 13.4, 0.8, light)
end

function drawTriggerLabel(trigger, textContent, textSize, x, y)
    -- When trigger is actively being pressed, invert the color; then draw text
    if trigger == 1 then
        drawText(textContent, textSize, TEXT_DARK, x, y)
    else
        drawText(textContent, textSize, TEXT_LIGHT, x, y)
    end
end


----|| DRAW ||----

--// Knobs //--
---- drawKnobMod(control, mod, x, y)
---- drawDots(x, y, direction)

-- Knob input mod meter
drawKnobMod(knob1, knob1Mod, 55, 135)
drawKnobMod(knob2, knob2Mod, 85, 135)
drawKnobMod(knob3, knob3Mod, 115, 135)
drawKnobMod(knob4, knob4Mod, 145, 135)
drawKnobMod(knob5, knob5Mod, 80, 70)
drawKnobMod(knob6, knob6Mod, 120, 70)

-- Indicator dots
drawDots(55, 113, 0)
drawDots(85, 113, 0)
drawDots(115, 113, 0)
drawDots(145, 113, 0)
drawDots(53, 70, 1)
drawDots(135, 70, 1)


--// Inputs //--
---- drawInput(x, y, light, textContent, textSize, type, textX, textY)

-- Modulation input lights for knobs
drawInput(55, 100, knob1ModLight, "M", TEXT_SMALL, 1, 52.6, 98)
drawInput(85, 100, knob2ModLight, "M", TEXT_SMALL, 1, 82.6, 98)
drawInput(115, 100, knob3ModLight, "M", TEXT_SMALL, 1, 112.6, 98)
drawInput(145, 100, knob4ModLight, "M", TEXT_SMALL, 1, 142.6, 98)
drawInput(40, 70, knob5ModLight, "M", TEXT_SMALL, 1, 37.6, 68)
drawInput(160, 70, knob6ModLight, "M", TEXT_SMALL, 1, 157.6, 68)

-- Gate input light for triggers
drawInput(20, 105, trigger1InLight, "G", TEXT_SMALL, 0, 18.2, 103)
drawInput(180, 105, trigger2InLight, "G", TEXT_SMALL, 0, 178.2, 103)


--// Outputs //--
---- drawOutput(x, y, light, textContent, textSize, textX, textY)
---- drawPolyLightX(x, y, number)
---- drawPolyLightY(x, y, number)

-- X sequence mod outputs
drawOutput(180, 320, x1Light, "X", TEXT_SMALL, 178, 318)
drawOutput(180, 290, x2Light, "2", TEXT_SMALL, 178.2, 288)
drawOutput(180, 260, x3Light, "3", TEXT_SMALL, 178.2, 258)
drawOutput(180, 230, x4Light, "4", TEXT_SMALL, 178.2, 228)
drawOutput(180, 200, x5Light, "5", TEXT_SMALL, 178.2, 198)

-- XY sequence mod output
drawOutput(180, 170, xyLight, "XY", 0.4, 176.9, 168.3)

-- Y sequence mod outputs
drawOutput(30, 170, y1Light, "Y", TEXT_SMALL, 27.9, 168)
drawOutput(60, 170, y2Light, "2", TEXT_SMALL, 58.2, 168)
drawOutput(90, 170, y3Light, "3", TEXT_SMALL, 88.2, 168)
drawOutput(120, 170, y4Light, "4", TEXT_SMALL, 118.2, 168)
drawOutput(150, 170, y5Light, "5", TEXT_SMALL, 148.2, 168)

-- X sequence poly outputs
drawPolyLightX(100, 40, 2)
drawPolyLightX(130, 40, 3)
drawPolyLightX(160, 40, 4)
drawPolyLightX(190, 40, 5)

-- Y sequence poly outputs
drawPolyLightY(100, 10, 2)
drawPolyLightY(130, 10, 3)
drawPolyLightY(160, 10, 4)
drawPolyLightY(190, 10, 5)


--// Triggers //--
---- drawTriggerLight(x, y, light)

-- Trigger lights
drawTriggerLight(20, 135, trigger1InLight)
drawTriggerLight(180, 135, trigger2InLight)
drawTriggerLight(70, 25, modeGateLight)


--// Labels //--
---- drawText(textContent, size, color, x, y)

-- Poly output labels
drawText("2", TEXT_SMALL, TEXT_LIGHT, 98, 23)
drawText("3", TEXT_SMALL, TEXT_LIGHT, 128, 23)
drawText("4", TEXT_SMALL, TEXT_LIGHT, 158, 23)
drawText("5", TEXT_SMALL, TEXT_LIGHT, 188, 23)


--// Mode Switch //--
if modeTriggerToggleGate == 1 then
    -- GATE MODE --
    ---- drawMatrixGateMode()
    ---- drawTriggerLabel(textContent, textSize, x, y)
    ---- drawInput(x, y, light, textContent, textSize, type, textX, textY)
    ---- drawText(textContent, size, color, x, y)
    --// Knobs //--
    
    -- Matrix indicators
    drawMatrixGateMode(xCount, yCount, xBegin, xEnd)

    -- Begin and end control indicators
    drawXBeginEndControls()
    drawYBeginEndControls()

    -- Direction arrows
    drawXDirectionArrow()
    drawYDirectionArrow()

    --// Triggers //--
    drawTriggerLabel(modeTrigger, "Gate", TEXT_SMALL, 64, 23)
    drawTriggerLabel(trigger1, "Random", 0.4, 11.2, 133.8)
    drawTriggerLabel(trigger2, "Random", 0.4, 171.2, 133.8)

    --// Inputs //--
    drawInput(10, 40, xGateLight, "X", TEXT_SMALL, 0, 8.1, 38)
    drawInput(40, 40, xSyncLight, "S", TEXT_SMALL, 0, 38.2, 38)
    drawInput(10, 10, yGateLight, "Y", TEXT_SMALL, 0, 8, 8)
    drawInput(40, 10, ySyncLight, "S", TEXT_SMALL, 0, 38.2, 8)

    --// Labels //--
    drawText("X", TEXT_NORMAL, TEXT_LIGHT, 66, 147)
    drawText("Y", TEXT_NORMAL, TEXT_LIGHT, 126, 147)
else
    -- MOD MODE --
    ---- drawMatrixModMode()
    ---- drawInput(x, y, light, textContent, textSize, type, textX, textY)
    ---- drawTriggerLabel(textContent, textSize, x, y)
    ---- drawModMixIndicator(x, y, knob, orientation)
    ---- drawText(textContent, size, color, x, y)

    
    
    --// Inputs //--
    drawInput(10, 40, xModLight, "X", TEXT_SMALL, 1, 8.1, 38)
    drawInput(40, 40, xModLight2, "M", TEXT_SMALL, 1, 37.6, 38)
    drawInput(10, 10, yModLight, "Y", TEXT_SMALL, 1, 8, 8)
    drawInput(40, 10, yModLight2, "M", TEXT_SMALL, 1, 37.6, 8)

    --// Triggers //--
    drawTriggerLabel(modeTrigger, "Mod", TEXT_SMALL, 64.1, 23)

    --// Knobs //--
    drawModMixIndicator(80, 70, knob5, 0)
    
    
    --// Labels //--
    drawText("Length", TEXT_SMALL, TEXT_LIGHT, 46, 133)
    drawText("Height", TEXT_SMALL, TEXT_LIGHT, 76.4, 133)
    
    if trigger2ToggleGate == 1 then
        -- SPLIT YMOD MODE
        --// Knobs //--
        drawMatrixModMode(xCount, yCount, xBegin, xEnd)
        drawModMixIndicator(120, 70, knob6, 1)
        
        --// Labels //--
        drawText("G", TEXT_NORMAL, TEXT_LIGHT, 96.5, 147)
        drawText("Skip", TEXT_SMALL, TEXT_LIGHT, 109, 133)
        drawText("Out", TEXT_SMALL, TEXT_LIGHT, 140, 133)
    else
        -- SPLIT YGATE MODE
        --// Knobs //--
        -- Matrix indicators
        drawMatrixModSplitMode(xCount, yCount, xBegin, xEnd)
        drawYBeginEndControls()
        drawYDirectionArrow()

        --// Labels //--
        drawText("G", TEXT_NORMAL, TEXT_LIGHT, 66.5, 147)
        drawText("Y", TEXT_NORMAL, TEXT_LIGHT, 126, 147)
    end

    
end



