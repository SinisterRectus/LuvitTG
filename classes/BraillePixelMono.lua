local utils = require('../utils')

local UNICODE = 0x2800

local map = {
	{0x01, 0x08},
	{0x02, 0x10},
	{0x04, 0x20},
	{0x40, 0x80},
}

local BraillePixelMono = utils.class()

BraillePixelMono.width = 2
BraillePixelMono.height = 4

function BraillePixelMono:__init()
	self[1] = 0
end

function BraillePixelMono:set(row, col)
	self[1] = bit.bor(self[1], map[row][col])
end

function BraillePixelMono:getState()
	return utf8.char(UNICODE + self[1])
end

return BraillePixelMono