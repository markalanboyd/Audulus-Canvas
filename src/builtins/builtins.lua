--- Draw, move, scale, and color basic shapes.
-- These functions draw, move, scale, and color shapes on the Canvas node.
-- There are also several built-in theme values that represent color tables
-- matching the style of Audulus. The Audulus-Canvas library is extends the
-- usefulness of these built-ins by adding additional abstraction layers and
-- utility functions that simplify complex drawing operations.
-- @module builtins

-- Note: If you would like to see the source code for these functions, you can
-- view it at https://github.com/audulus/vger.

--- Returns a paint userdata from a color table.
-- Creates a userdata called paint that represents an rgba color. Paints are
-- used to color all of the SVG shapes. It is good practice to keep colors
-- values as color values right up until you need them to be paints, usually
-- just one line before you actually draw the shape that takes a paint. This is
-- because you cannot index into and manipulate the rgba values of a paint.
-- @tparam table color_table An {r, g, b, a} color table where each variable is
-- a normalized 0 to 1 value.
-- @treturn userdata A paint userdata.
-- @usage
-- white = {1, 1, 1, 1}
-- paint = color_paint(white)
-- fill_circle({0, 0}, 10, paint) -- white circle
--
-- -- In this example, sine is a Canvas node input and is a 0 to 1 sine wave
-- pulsing_red = {sine, 0, 0, 1}
-- pulsing_red_paint = color_paint(pulsing_red)
-- fill_rect({0, 0}, {40, 10}, 0, pulsing_red_paint) --
--
-- print(white[1]) -- 1
-- print(paint[1]) -- Error: attempt to index global 'white' (a userdata value)
function color_paint(color_table)
end

--- Returns a linear gradient paint from two color tables and a set of coordinates.
function linear_gradient(start_coord, end_coord, color_start, color_end)
end

--- Draws a solid circle.
function fill_circle(coordinate, radius, paint)
end

--- Draws an outlined circle.
function stroke_circle(coordinate, radius, width, paint)
end

--- Draws an arc.
function stroke_arc(coordinate, radius, width, rotation, aperture, paint)
end

--- Draws a line.
function stroke_segment(a, b, width, paint)
end

--- Draws a solid rectangle.
function fill_rect(min, max, corner_radius, paint)
end

--- Draws an outlined rectangle.
function stroke_rect(min, max, corner_radius, width, paint)
end

--- Draws a quadratic bezier curve.
function stroke_bezier(a, b, c, width, paint)
end

--- Draws a string.
function text(s, color_table)
end

--- Returns the minimum and maximum of a string.
function text_bounds(s)
end

--- Draws a string in a text box.
function text_box(s, break_row_width, color_table)
end

--- Pick up the pen and move to coordinate {x, y}
function move_to(coordinate)
end

--- Draw a line from current pen position to coordinate {x, y}
function line_to(coordinate)
end

--- Draw a quadratic bezier curve from current pen position to coord_c
function quad_to(coord_b, coord_c)
end

--- Fill the space enclosed by the pen with a paint color.
function fill(paint)
end

--- Translate the coordinate system by an offset set by the coordinate {tx, ty}
function translate(coordinate)
end

--- Grow (>1) or shrink (<1) the x and y axes independently with the coordinate
function scale(coordinate)
end

--- Rotates the canvas around the origin by radians.
-- Positive to left, negative to right.
function rotate(theta)
end

--- Saves the coordinate system state.
function save()
end

--- Restores the coordinate system state to the point where it was saved.
function restore()
end

-- canvas_width
-- canvas_height

-- theme.azureHighlight
-- theme.azureHighlightDark
-- theme.azureHighlightBackground

-- theme.greenHighlight
-- theme.greenHighlightDark
-- theme.azureHighlightBackground

-- theme.redHighlight
-- theme.redHighlightDark
-- theme.redHighlightBackground

-- theme.grooves
-- theme.modules
-- theme.text
