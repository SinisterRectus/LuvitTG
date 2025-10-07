local Canvas = require('./classes/Canvas')
local Color = require('./classes/Color')
local Vector2 = require('./classes/Vector2')
local BlockPixel = require('./classes/BlockPixel')
local BraillePixel = require('./classes/BraillePixel')
local BlockPixelMono = require('./classes/BlockPixelMono')
local BraillePixelMono = require('./classes/BraillePixelMono')

local stdin = process.stdin.handle
local stdout = process.stdout.handle

local ESC = string.char(27)
local CSI = ESC .. '['
local HIDE_CURSOR = CSI .. '?25l'
local SHOW_CURSOR = CSI .. '?25h'
local HOME = CSI .. 'H'
local CLEAR = CSI .. '3J'

local colors = {
	red = Color(255, 0, 0),
	yellow = Color(255, 255, 0),
	lime = Color(0, 255, 0),
	cyan = Color(0, 255, 255),
	blue = Color(0, 0, 255),
	magenta = Color(255, 0, 255),
	white = Color(255, 255, 255),
	black = Color(0, 0, 0),
}

local canvas = Canvas(BraillePixel) -- change pixel type here

local function render() -- example scene

	local size = canvas:getSize()
	local r = size:length() / 20
	local center = size / 2
	local angle = math.rad(45)

	local cSize = Vector2(r, r)
	local cPos = cSize:scaled(3)
	local eSize = cSize:scaled(2, 1)
	local ePos = cPos:translated(0, cSize[2] * 3)

	local rSize = Vector2(r * 4, r * 2)
	local rPos = center - rSize / 2

	-- draw point at center
	canvas:drawPoint(center, colors.white)

	-- draw rectangles at center
	canvas:drawRect(rPos, rSize, colors.blue)
	canvas.transform:translate(center[1], center[2]):rotate(angle):translate(-center[1], -center[2])
	canvas:drawRect(rPos, rSize, colors.lime)
	canvas.transform:reset()

	-- draw circles relative to top left corner
	canvas:drawEllipse(cPos, cSize, colors.red)
	canvas:drawEllipse(cPos, cSize:scaled(0.5), colors.yellow)

	-- draw ellipses relative to circles
	canvas:drawEllipse(ePos, eSize, colors.magenta)
	canvas.transform:translate(ePos[1], ePos[2]):rotate(-angle):translate(-ePos[1], -ePos[2])
	canvas:drawEllipse(ePos, eSize, colors.cyan)
	canvas.transform:reset()

	stdout:write(canvas:getFrame())

end

local function loop()
	process:on('sigwinch', function()
		stdout:write(HOME .. CLEAR)
		canvas:clear()
		canvas.transform:reset()
		render()
	end)
	stdin:set_mode('raw')
	stdout:write(HIDE_CURSOR)
	stdin:read_start(function(err, data)
		assert(not err, err)
		if data == ESC then -- press ESC to exit
			stdin:set_mode('normal')
			stdout:write(SHOW_CURSOR)
			process:exit()
		end
	end)
end

render()
loop()