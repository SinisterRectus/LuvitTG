local utils = require('../utils')
local clear = require('table.clear')

local Vector2 = require('./Vector2')
local Transform2 = require('./Transform2')
local FrameBuffer = require('./FrameBuffer')

local stdout = process.stdout.handle

local NEWLINE = '\n'
local SPACE = ' '

local function locate(a, b)
	local int = math.floor(a / b)
	local rem = math.floor(a) - int * math.floor(b)
	return int + 1, rem + 1
end

local meta = {__index = function(self, k)
	self[k] = {}; return self[k]
end}

local Canvas = utils.class()

function Canvas:__init(pixelClass)
	self.pixels = setmetatable({}, meta)
	self.pixelClass = assert(pixelClass)
	self.transform = Transform2()
end

function Canvas:clear()
	return clear(self.pixels)
end

function Canvas:set(x, y, ...)
	local cCol, pCol = locate(x, self.pixelClass.width)
	local cRow, pRow = locate(y, self.pixelClass.height)
	self.pixels[cRow][cCol] = self.pixels[cRow][cCol] or self.pixelClass()
	return self.pixels[cRow][cCol]:set(pRow, pCol, ...)
end

function Canvas:drawPoint(point, ...)
	if not self.transform:isIdentity() then
		point = point:transformed(self.transform)
	end
	self:set(point[1], point[2], ...)
end

function Canvas:drawLine(a, b, ...)
	if not self.transform:isIdentity() then
		a = a:transformed(self.transform)
		b = b:transformed(self.transform)
	end
	local x1, y1 = a[1], a[2]
	local x2, y2 = b[1], b[2]
	local dx = x2 - x1
	local dy = y2 - y1
	local n = math.max(math.abs(dx), math.abs(dy))
	if n == 0 then
		self:set(x1, y1, ...)
	else
		dx = dx / n
		dy = dy / n
		for i = 0, n do
			self:set(x1 + dx * i, y1 + dy * i, ...)
		end
	end
end

function Canvas:drawEllipse(center, size, ...)
	local rx, ry = size[1], size[2]
	local n = 4 * (rx + ry)
	local dt = 2 * math.pi / n
	local prev = center:translated(rx, 0)
	for i = 1, n do
		local x = rx * math.cos(dt * i)
		local y = ry * math.sin(dt * i)
		local curr = center:translated(x, y)
		self:drawLine(prev, curr, ...)
		prev = curr
	end
end

function Canvas:drawRect(pos, size, ...)
	local a = pos
	local b = pos:translated(size[1], 0)
	local c = pos:translated(size[1], size[2])
	local d = pos:translated(0, size[2])
	self:drawLine(a, b, ...)
	self:drawLine(b, c, ...)
	self:drawLine(c, d, ...)
	self:drawLine(d, a, ...)
end

function Canvas:drawPoints(points, ...)
	for _, point in ipairs(points) do
		self:drawPoint(point, ...)
	end
end

function Canvas:drawPolyline(points, ...)
	for i = 1, #points - 1 do
		self:drawLine(points[i], points[i + 1], ...)
	end
end

function Canvas:drawPolygon(points, ...)
	self:drawLine(points[1], points[#points], ...)
	self:drawPolyline(points, ...)
end

function Canvas:getSize()
	local cols, rows = stdout:get_winsize()
	return Vector2(cols * self.pixelClass.width, rows * self.pixelClass.height)
end

function Canvas:getFrame()
	local buf = FrameBuffer()
	local cols, rows = stdout:get_winsize()
	for row = 1, rows do
		for col = 1, cols do
			if self.pixels[row][col] then
				buf:add(self.pixels[row][col]:getState())
			else
				buf:add(SPACE)
			end
		end
		buf:add(NEWLINE)
	end
	buf:close()
	return buf
end

return Canvas