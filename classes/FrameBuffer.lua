local utils = require('../utils')

local ESC = string.char(27)
local CSI = ESC .. '['
local COLOR_FG = CSI .. '38;2;%i;%i;%im'
local COLOR_BG = CSI .. '48;2;%i;%i;%im'
local RESET_FG = CSI .. '39m'
local RESET_BG = CSI .. '49m'
local RESET = CSI .. '0m'

local FrameBuffer = utils.class()

function FrameBuffer:__init()
	self.fg = nil
	self.bg = nil
end

function FrameBuffer:add(char, fg, bg)
	if fg ~= self.fg then
		table.insert(self, fg and string.format(COLOR_FG, fg:toRGB()) or RESET_FG)
		self.fg = fg
	end
	if bg ~= self.bg then
		table.insert(self, bg and string.format(COLOR_BG, bg:toRGB()) or RESET_BG)
		self.bg = bg
	end
	return table.insert(self, assert(char))
end

function FrameBuffer:close()
	return table.insert(self, RESET)
end

return FrameBuffer