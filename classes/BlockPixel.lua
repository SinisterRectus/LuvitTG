local utils = require('../utils')

local UPPER_HALF_BLOCK = '▀'
local LOWER_HALF_BLOCK = '▄'

local BlockPixel = utils.class()

BlockPixel.width = 1
BlockPixel.height = 2

function BlockPixel:__init()
end

function BlockPixel:set(row, _, color)
	self[row] = color
end

function BlockPixel:getState()
	if self[1] and self[2] then
		return UPPER_HALF_BLOCK, self[1], self[2]
	elseif self[1] then
		return UPPER_HALF_BLOCK, self[1]
	elseif self[2] then
		return LOWER_HALF_BLOCK, self[2]
	end
end

return BlockPixel