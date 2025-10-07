local utils = require('../utils')

local Transform2 = utils.class()

function Transform2:__init(a, b, c, d, x, y)
	self[1], self[2] = a or 1, b or 0
	self[3], self[4] = c or 0, d or 1
	self[5], self[6] = x or 0, y or 0
end

function Transform2:isIdentity()
	return  self[1] == 1 and self[2] == 0
		and self[3] == 0 and self[4] == 1
		and self[5] == 0 and self[6] == 0
end

function Transform2:reset()
	self[1], self[2] = 1, 0
	self[3], self[4] = 0, 1
	self[5], self[6] = 0, 0
	return self
end

function Transform2:scale(x, y)
	y = y or x
	self[1] = self[1] * x
	self[2] = self[2] * y
	self[3] = self[3] * x
	self[4] = self[4] * y
	return self
end

function Transform2:translate(x, y)
	self[5] = self[5] + x * self[1] + y * self[3]
	self[6] = self[6] + x * self[2] + y * self[4]
	return self
end

function Transform2:rotate(t)
	local ct, st = math.cos(t), math.sin(t)
	local a, b, c, d = self[1], self[2], self[3], self[4]
	self[1] = a * ct + c * st
	self[2] = b * ct + d * st
	self[3] = c * ct - a * st
	self[4] = d * ct - b * st
	return self
end

return Transform2