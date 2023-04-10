pi=3.1415926535

paint = color_paint{0.5,0.5,1,1}
paint0 = color_paint{1,0.8,1,.1}
axispaint = color_paint{0.3, 0.3, 0.3,1}
camerapaint = color_paint{0.3, 0.7, 0.7,1}

WIDTH = canvas_width
HEIGHT = canvas_height

rx = pi*2*rotatex
ry = pi*2*rotatey
rz = pi*2*rotatez

--camera[1] = camera[1] + translatex * 100
--camera[2] = camera[2] + translatey * 100

camera = {110, 110, 0}

function rot (x0, y0, z0)
-- Rotation Matrix, see: https://en.wikipedia.org/wiki/Rotation_matrix#In_three_dimensions
	x1 = (math.cos(ry)*math.cos(rz))*x0 + (-	math.cos(ry)*math.sin(rz))*y0 + math.sin(ry)*z0
	y1 = (math.cos(rx)*math.sin(rz) + math.cos(rz)*math.sin(rx)*math.sin(ry))*x0 + (math.cos(rx)*math.cos(rz) -math.sin(rx)*math.sin(ry)*math.sin(rz))*y0 -math.cos(ry)*math.sin(rx)*z0
	z1 = (math.sin(rx)*math.sin(rz) - math.cos(rz)*math.cos(rx)*math.sin(ry))*x0 + (math.cos(rz)*math.sin(rx) +math.sin(rz)*math.sin(ry)*math.cos(rx))*y0 + (math.cos(rx)*math.cos(ry))*z0
	return x1, y1, z1
end

function proj(x0, y0, z0)
-- project 3d coords (x0, y0, z0) to 2d (x1, y1)
-- need further optimization for camera position
	local F = (z0-camera[3])
	x1 = ((x0-camera[1])*(F/z0)) + camera[1]
	y1 = ((y0-camera[2])*(F/z0)) + camera[2]
	return x1, y1
end



-- start drawing axes
xaxis = {300, 0, 0}
yaxis = {0, 300, 0}
zaxis = {0, 0, 300}
-- X axis
xx, xy, xz = rot(xaxis[1], xaxis[2], xaxis[3])
xxx, xyy = proj(xx, xy, xz)
stroke_bezier({0,0}, {xxx, xyy}, {xxx, xyy}, 1, axispaint)
translate{xxx, xyy}
text("X-axis", {1,1,1,1})
translate{-xxx, -xyy}
-- Y axis
yx, yy, yz = rot(yaxis[1], yaxis[2], yaxis[3])
yxx, yyy = proj(yx, yy, yz)
stroke_bezier({0,0}, {yxx, yyy}, {yxx, yyy}, 1, axispaint)
translate{yxx, yyy}
text("Y-axis", {1,1,1,1})
translate{-yxx, -yyy}
-- Z axis
zx, zy, zz = rot(zaxis[1], zaxis[2], zaxis[3])
zxx, zyy = proj(zx, zy, zz)
stroke_bezier({0,0}, {zxx, zyy}, {zxx, zyy}, 1, axispaint)
translate{zxx, zyy}
text("Z-axis", {1,1,1,1})
translate{-zxx, -zyy}

-- draw camera
camera_x, camera_y, camera_z = rot(camera[1], camera[2], camera[3])
camera_xx, camera_yy = proj(camera_x, camera_y, camera_z)
fill_circle({camera_xx, camera_yy}, 10, camerapaint)
translate{camera_xx, camera_yy}
text("CAMERA", {1,1,1,1})
translate{-camera_xx, -camera_yy}


-- lengths of the sides of the cube
CUBE_X = 150
CUBE_Y = 150
CUBE_Z = 150

-- define corners of the cube and rotate first
rx0, ry0, rz0 = rot(.1, .1, .1)
rx1, ry1, rz1 = rot(CUBE_X, 0.1, CUBE_Z)
rx2, ry2, rz2 = rot(CUBE_X, CUBE_Y, CUBE_Z)
rx3, ry3, rz3 = rot(CUBE_X, CUBE_Y, 0.1)
rx4, ry4, rz4 = rot(0.1, CUBE_Y, CUBE_Z)
rx5, ry5, rz5 = rot(0.1, 0.1, CUBE_Z)
rx6, ry6, rz6 = rot(0.1, CUBE_Y, 0.1)
rx7, ry7, rz7 = rot(CUBE_X, 0.1, 0.1)

-- then project to 2d canvas
cx0, cy0 = proj(rx0, ry0, rz0)
cx1, cy1 = proj(rx1, ry1, rz1)
cx2, cy2 = proj(rx2, ry2, rz2)
cx3, cy3 = proj(rx3, ry3, rz3)
cx4, cy4 = proj(rx4, ry4, rz4)
cx5, cy5 = proj(rx5, ry5, rz5)
cx6, cy6 = proj(rx6, ry6, rz6)
cx7, cy7 = proj(rx7, ry7, rz7)

fill_circle({cx0,cy0}, 5, paint)
fill_circle({cx1,cy1}, 5, paint)
fill_circle({cx2,cy2}, 5, paint)
fill_circle({cx3,cy3}, 5, paint)
fill_circle({cx4,cy4}, 5, paint)
fill_circle({cx5,cy5}, 5, paint)
fill_circle({cx6,cy6}, 5, paint)
fill_circle({cx7,cy7}, 5, paint)

