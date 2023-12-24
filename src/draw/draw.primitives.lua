function fill_triangle(vec2_a, vec2_b, vec2_c, paint)
    move_to(vec2_a)
    line_to(vec2_b)
    line_to(vec2_c)
    line_to(vec2_a)
    fill(paint)
end
