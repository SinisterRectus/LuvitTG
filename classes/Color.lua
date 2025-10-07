local utils = require('../utils')

local function checkByte(n)
	return utils.clamp(math.floor(n), 0, 0xFF)
end

local function checkFloat(n)
	return utils.clamp(n, 0, 1)
end

local function checkAngle(n)
	return (n % 360 + 360) % 360
end

local Color = utils.class()

function Color:__init(r, g, b)
	self[1] = checkByte(r)
	self[2] = checkByte(g)
	self[3] = checkByte(b)
end

function Color:__eq(other)
	return self[1] == other[1] and self[2] == other[2] and self[3] == other[3]
end

function Color:__add(other)
	local r = self[1] + other[1]
	local g = self[2] + other[2]
	local b = self[3] + other[3]
	return Color(r, g, b)
end

function Color:__sub(other)
	local r = self[1] - other[1]
	local g = self[2] - other[2]
	local b = self[3] - other[3]
	return Color(r, g, b)
end

function Color:__mul(other)
	if type(other) == 'number' then
		local r = self[1] * other
		local g = self[2] * other
		local b = self[3] * other
		return Color(r, g, b)
	elseif type(self) == 'number' then
		local r = other[1] * self
		local g = other[2] * self
		local b = other[3] * self
		return Color(r, g, b)
	else
		error('operation not defined')
	end
end

function Color:__div(other)
	if type(other) == 'number' and other ~= 0 then
		local r = self[1] / other
		local g = self[2] / other
		local b = self[3] / other
		return Color(r, g, b)
	else
		error('operation not defined')
	end
end

function Color:lerp(other, t)
	local r = utils.lerp(self[1], other[1], t)
	local g = utils.lerp(self[2], other[2], t)
	local b = utils.lerp(self[3], other[3], t)
	return Color(r, g, b)
end

function Color.fromHex(str)
	local r, g, b = str:match('^#?(%x%x)(%x%x)(%x%x)$')
	assert(r and g and b, 'invalid hex string')
	return Color(tonumber(r, 16), tonumber(g, 16), tonumber(b, 16))
end

function Color.fromRGB(r, g, b)
	return Color(r, g, b)
end

local function fromHue(h, c, m)
	local x = c * (1 - math.abs(h / 60 % 2 - 1))
	local r, g, b
	if h < 60 then
		r, g, b = c, x, 0
	elseif h < 120 then
		r, g, b = x, c, 0
	elseif h < 180 then
		r, g, b = 0, c, x
	elseif h < 240 then
		r, g, b = 0, x, c
	elseif h < 300 then
		r, g, b = x, 0, c
	elseif h < 360 then
		r, g, b = c, 0, x
	end
	return (r + m) * 0xFF, (g + m) * 0xFF, (b + m) * 0xFF
end

function Color.fromHSV(h, s, v)
	h = checkAngle(h)
	s = checkFloat(s)
	v = checkFloat(v)
	local c = v * s
	local m = v - c
	local r, g, b = fromHue(h, c, m)
	return Color(r, g, b)
end

function Color.fromHSL(h, s, l)
	h = checkAngle(h)
	s = checkFloat(s)
	l = checkFloat(l)
	local c = (1 - math.abs(2 * l - 1)) * s
	local m = l - c * 0.5
	local r, g, b = fromHue(h, c, m)
	return Color(r, g, b)
end

function Color:toHex()
	return string.format('#%02X%02X%02X', self[1], self[2], self[3])
end

function Color:toRGB()
	return self[1], self[2], self[3]
end

local function toHue(r, g, b)
	r = r / 0xFF
	g = g / 0xFF
	b = b / 0xFF
	local v = math.max(r, g, b)
	local c = v - math.min(r, g, b)
	local h
	if c == 0 then
		h = 0
	elseif v == r then
		h = (g - b) / c + 0
	elseif v == g then
		h = (b - r) / c + 2
	elseif v == b then
		h = (r - g) / c + 4
	end
	return checkAngle(h * 60), c, v
end

function Color:toHSV()
	local h, c, v = toHue(self:toRGB())
	local s = v == 0 and 0 or c / v
	return h, s, v
end

function Color:toHSL()
	local h, c, v = toHue(self[1], self[2], self[3])
	local l = v - c * 0.5
	local s = (l == 0 or l == 1) and 0 or c / (1 - math.abs(2 * l - 1))
	return h, s, l
end

return Color