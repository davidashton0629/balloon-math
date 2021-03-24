local lg = love.graphics
local floor, min, max, random = math.floor, math.min, math.max, love.math.random
local pauseMenu = Game.GUI:new()

pauseMenu:add("box", "pausedbg"):setData({x = 200, y = 230, z = 100000, w = 375, h = 250, useBorder = true, borderColor = {.7,.2,.2,.8}, color = {.2,.7,.7,.8}, clickable = false, round = true, radius = 10})
pauseMenu:add("text", "paused"):setData({x = 210, y = 240, z = 100000, w = 355, text = "Paused", shadow = true, color = {1,0,0,1}, font = Game.fonts.huge})
pauseMenu:add("box", "pauseback"):setData({x = 210, y = 300, z = 100001, w = 355, h = 60, useBorder = true, borderColor = {.4,.4,.4,.7}, color = {.5,.2,.7,.7}})
pauseMenu:add("text", "pausebacktext"):setData({x = 215, y = 310, z = 100002, w = 345, color = {0,.9,.9,.5}, text = "Main Menu", font = Game.fonts.large, clickable = false, shadow = true})
pauseMenu:add("box", "pausequit"):setData({x = 210, y = 400, z = 100001, w = 355, h = 60, useBorder = true, borderColor = {.4,.4,.4,.7}, color = {.5,.2,.7,.7}})
pauseMenu:add("text", "pausequittext"):setData({x = 215, y = 410, z = 100002, w = 345, color = {0,.9,.9,.5}, text = "Quit Game", font = Game.fonts.large, clickable = false, shadow = true})

pauseMenu:child("pauseback"):registerEvent("onClick", function(self)
	pauseMenu:disable()
	Game.inGame:disable()
	Game.mainMenu:enable()
	Game:animateBG()
end):registerEvent("onHoverEnter", function(self)
	self:animateToOpacity(1):animateBorderToOpacity(1)
	pauseMenu:child("pausebacktext"):animateToColor({1,1,1,1})
end):registerEvent("onHoverExit", function(self)
	self:animateToOpacity(.7):animateBorderToOpacity(.7)
	pauseMenu:child("pausebacktext"):animateToColor({0,.9,.9,.5})
end)

pauseMenu:child("pausequit"):registerEvent("onClick", function(self)
	love.event.quit()
end):registerEvent("onHoverEnter", function(self)
	self:animateToOpacity(1):animateBorderToOpacity(1)
	pauseMenu:child("pausequittext"):animateToColor({1,1,1,1})
end):registerEvent("onHoverExit", function(self)
	self:animateToOpacity(.7):animateBorderToOpacity(.7)
	pauseMenu:child("pausequittext"):animateToColor({0,.9,.9,.5})
end)

pauseMenu:disable()

return getmetatable(setmetatable(pauseMenu, pauseMenu))