local utils = require('../utils')

local BlockPixelMono = utils.class()

BlockPixelMono.width = 1
BlockPixelMono.height = 2

local map = {
	[0x1] = '▀',
	[0x2] = '▄',
	[0x3] = '█',
}

function BlockPixelMono:__init()
	self[1] = 0
end

function BlockPixelMono:set(row)
	self[1] = bit.bor(self[1], row)
end

function BlockPixelMono:getState()
	return map[self[1]]
end

return BlockPixelMono