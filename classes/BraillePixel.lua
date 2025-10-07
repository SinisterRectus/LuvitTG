local utils = require('../utils')
local Color = require('./Color')

local UNICODE = 0x2800
local GAMMA = 2.2
local INV_GAMMA = 1 / GAMMA

local map = {
	{0x01, 0x08},
	{0x02, 0x10},
	{0x04, 0x20},
	{0x40, 0x80},
}

local BraillePixel = utils.class()

BraillePixel.width = 2
BraillePixel.height = 4

function BraillePixel:__init()
end

function BraillePixel:set(row, col, color)
	self[map[row][col]] = color
end

function BraillePixel:getState()
	local offset, r, g, b, n = 0, 0, 0, 0, 0
	for k, v in pairs(self) do
		offset = bit.bor(offset, k)
		r = r + v[1] ^ GAMMA
		g = g + v[2] ^ GAMMA
		b = b + v[3] ^ GAMMA
		n = n + 1
	end
	if n ~= 0 then
		r = (r / n) ^ INV_GAMMA
		g = (g / n) ^ INV_GAMMA
		b = (b / n) ^ INV_GAMMA
	end
	return utf8.char(UNICODE + offset), Color(r, g, b)
end

return BraillePixel