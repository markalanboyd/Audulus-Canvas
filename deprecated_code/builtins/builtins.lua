--[[

    This file contains all of the built-in functions and variables that 
    are available to the user in the Canvas node.

    The functions in other files use and expand on these built-in
    functions.

-- ]]

paint = color_paint{r, g, b, a}
paint = linear_gradient({start_x, start_y}, {end_x, end_y}, {r, g, b, a}, {r, g, b, a}) 

fill_circle({x, y}, radius, paint)
stroke_circle({x, y}, radius, width, paint)
stroke_arc({x, y}, radius, width, rotation, aperture, paint)
stroke_segment({ax, ay}, {bx, by}, width, paint)
fill_rect({min_x, min_y}, {max_x, max_y}, corner_radius, paint)
stroke_rect({min_x, min_y}, {max_x, max_y}, corner_radius, width, paint)
stroke_bezier({ax, ay}, {bx, by}, {cx, cy}, width, paint)

text("hello world!", {r,g,b,a})
min, max = text_bounds("hello world!")
text_box("lorem ipsum...", break_row_width, {r,g,b,a})
min, max = text_box_bounds("lorem ipsum...", break_row_width)

move_to{x, y}
line_to{x, y}
quad_to({bx, by}, {cx, cy})
fill(paint)

translate{tx, ty}
scale{sx, sy}
rotate(theta)
save()
restore()

canvas_width
canvas_height

theme.azureHighlight
theme.azureHighlightDark
theme.azureHighlightBackground
theme.greenHighlight
theme.greenHighlightDark
theme.greenHighlightBackground
theme.redHighlight
theme.redHighlightDark
theme.redHighlightBackground
theme.grooves
theme.modules
theme.text
