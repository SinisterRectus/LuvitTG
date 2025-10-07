local utils = require('../utils')

local Vector2 = utils.class()

function Vector2:__init(x, y)
	self[1] = x or 0
	self[2] = y or 0
end

function Vector2:__eq(other)
	return self[1] == other[1] and self[2] == other[2]
end

function Vector2:__add(other)
	return Vector2(self[1] + other[1], self[2] + other[2])
end

function Vector2:__sub(other)
	return Vector2(self[1] - other[1], self[2] - other[2])
end

function Vector2:__mul(other)
	if type(other) == 'number' then
		return Vector2(self[1] * other, self[2] * other)
	elseif type(self) == 'number' then
		return Vector2(other[1] * self, other[2] * self)
	else
		error('operation not defined')
	end
end

function Vector2:__div(other)
	if type(other) == 'number' and other ~= 0 then
		return Vector2(self[1] / other, self[2] / other)
	else
		error('operation not defined')
	end
end

function Vector2:__unm()
	return Vector2(-self[1], -self[2])
end

function Vector2:lerp(other, t)
	local x = utils.lerp(self[1], other[1], t)
	local y = utils.lerp(self[2], other[2], t)
	return Vector2(x, y)
end

function Vector2:distance(other)
	return math.sqrt(self:distanceSq(other))
end

function Vector2:distanceSq(other)
	local dx = other[1] - self[1]
	local dy = other[2] - self[2]
	return dx * dx + dy * dy
end

function Vector2:dot(other)
	return self[1] * other[1] + self[2] * other[2]
end

function Vector2:cross(other)
	return self[1] * other[2] - self[2] * other[1]
end

function Vector2:angle(other)
	local d = self:length() * other:length()
	if d == 0 then
		return 0
	else
		return math.acos(utils.clamp(self:dot(other) / d, -1, 1))
	end
end

function Vector2:length()
	return math.sqrt(self:lengthSq())
end

function Vector2:lengthSq()
	return self[1] * self[1] + self[2] * self[2]
end

function Vector2:normalize()
	local len = self:length()
	if len == 0 then
		self[1], self[2] = 0, 0
	else
		self[1], self[2] = self[1] / len, self[2] / len
	end
	return self
end

function Vector2:normalized()
	local len = self:length()
	if len == 0 then
		return Vector2(0, 0)
	else
		return Vector2(self[1] / len, self[2] / len)
	end
end

function Vector2:scale(x, y)
	y = y or x
	self[1] = self[1] * x
	self[2] = self[2] * y
	return self
end

function Vector2:scaled(x, y)
	y = y or x
	return Vector2(self[1] * x, self[2] * y)
end

function Vector2:translate(x, y)
	self[1] = self[1] + x
	self[2] = self[2] + y
	return self
end

function Vector2:translated(x, y)
	return Vector2(self[1] + x, self[2] + y)
end

function Vector2:rotate(t)
	local ct, st = math.cos(t), math.sin(t)
	local x, y = self[1], self[2]
	self[1] = x * ct - y * st
	self[2] = x * st + y * ct
	return self
end

function Vector2:rotated(t)
	local ct, st = math.cos(t), math.sin(t)
	local x, y = self[1], self[2]
	return Vector2(x * ct - y * st, x * st + y * ct)
end

function Vector2:transform(m)
	local x, y = self[1], self[2]
	self[1] = x * m[1] + y * m[3] + m[5]
	self[2] = x * m[2] + y * m[4] + m[6]
	return self
end

function Vector2:transformed(m)
	local x = self[1] * m[1] + self[2] * m[3] + m[5]
	local y = self[1] * m[2] + self[2] * m[4] + m[6]
	return Vector2(x, y)
end

return Vector2