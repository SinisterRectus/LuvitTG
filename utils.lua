local classMeta = {__call = function(self, ...)
	local obj = setmetatable({}, self)
	obj:__init(...)
	return obj
end}

local function class()
	local cls = setmetatable({}, classMeta)
	cls.__index = cls
	return cls
end

local bufferMeta = {__call = table.insert}
local function buffer()
	return setmetatable({}, bufferMeta)
end

local function round(n)
	return math.floor(n + 0.5)
end

local function clamp(n, a, b)
	return math.min(math.max(a, n), b)
end

local function lerp(a, b, t)
	return a + (b - a) * t
end

return {
	class = class,
	buffer = buffer,
	round = round,
	clamp = clamp,
	lerp = lerp,
}