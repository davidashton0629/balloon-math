local lg = love.graphics
local floor, min, max, random = math.floor, math.min, math.max, love.math.random
local Game

local function initInGame(G)
	Game = G
	local inGame = Game.GUI:new():setZ(1)
	inGame:add("box", "question"):setData({x = 0, y = 30, z = 5, w = 800, h = 70, useBorder = true, borderColor = {.4,.2,.5,.7}, color = {.6,.4,.8,.6}, clickable = false})
	inGame:add("box", "questionHighlight"):setData({x = 229, y = 29, z = 6, w = 322, h = 72, color = {0,0,0,.35}, clickable = false})
	inGame:add("text", "problem"):setData({x = 240, y = 45, z = 7, w = 300, text = tostring( floor(random(1 * Game.difficulty, 5 * Game.difficulty)) ) .. " + " .. tostring( floor(random(1 * Game.difficulty, 5 * Game.difficulty)) ), shadow = true, font = Game.fonts.large, clickable = false})
	Game.problemResult = 0
	for n in inGame:child("problem"):getText():gmatch("%d+") do
		Game.problemResult = Game.problemResult + tonumber(n)
	end
	inGame:add("text", "timeLeft"):setData({ x = 27, y = 45, z = 6, color = {1,1,1,1}, text = "TIME 5:00", shadow = true, font = Game.fonts.large, clickable = false})
	inGame:add("text", "score"):setData({x = 590, y = 45, z = 6, w = 400, align = "left", color = {1,1,1}, text = "SCORE 0", shadow = true, font = Game.fonts.large, clickable = false})

	inGame:disable()

	--return getmetatable(setmetatable(inGame, inGame))
	return inGame
end

return initInGame