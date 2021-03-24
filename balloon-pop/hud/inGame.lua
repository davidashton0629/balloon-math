local lg = love.graphics
local floor, min, max, random = math.floor, math.min, math.max, love.math.random
local inGame = Game.GUI:new()

inGame:add("box", "question"):setData({x = 240, y = 30, z = 100000, w = 230, h = 70, useBorder = true, borderColor = {.4,.2,.5,.7}, color = {.6,.4,.8,.6}, clickable = false})
inGame:add("text", "problem"):setData({x = 240, y = 45, z = 100000, w = 230, text = tostring( floor(random(1 * Game.difficulty, 5 * Game.difficulty)) ) .. " + " .. tostring( floor(random(1 * Game.difficulty, 5 * Game.difficulty)) ), shadow = true, font = Game.fonts.large, clickable = false})
Game.problemResult = 0
for n in inGame:child("problem"):getText():gmatch("%d+") do
	Game.problemResult = Game.problemResult + tonumber(n)
end
inGame:add("text", "timeLeft"):setData({ x = 20, y = 48, z = 100000, color = {.4,.4,.4,1}, text = "TIME - 5:00", shadow = true, font = Game.fonts.large, clickable = false})
inGame:add("text", "score"):setData({x = 490, y = 40, z = 100000, w = 400, align = "left", color = {.4,.4,.4,1}, text = "Score: 0", shadow = true, font = Game.fonts.huge, clickable = false})

inGame:disable()

return getmetatable(setmetatable(inGame, inGame))