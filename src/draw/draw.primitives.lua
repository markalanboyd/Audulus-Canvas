function fill_triangle(coord_a, coord_b, coord_c, paint)
    move_to(coord_a)
    line_to(coord_b)
    line_to(coord_c)
    line_to(coord_a)
    fill(paint)
end
