local lg = love.graphics
local floor, min, max, random = math.floor, math.min, math.max, love.math.random
local gameOver = Game.GUI:new()

gameOver:add("box", "background"):addImage(Game.bg, "background", true):setData({x = 0, y = 0, z = 0, w = 800, h = 600, clickable = false})
gameOver:add("text", "endscore"):setData({x = 100, y = 100, z = 5, w = 600, text = "Final Score: 0", color = {1,1,1,1}, shadow = true, font = Game.fonts.huge})
gameOver:add("text", "playagain"):setData({x = 100, y = 180, z = 5, w = 600, text = "Press 'Escape' To Go Back To The Main Menu", color = {1,1,1,1}, shadow = true, font = Game.fonts.huge})

gameOver:disable()

return getmetatable(setmetatable(gameOver, gameOver))