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
