local lg = love.graphics
local floor, min, max, random = math.floor, math.min, math.max, love.math.random
local mainMenu = Game.GUI:new():setZ(1)

mainMenu:add("box", "start"):setData({x = 275, y = 85, z = 1, w = 260, h = 80, color = {.5,.2,.7,.7}, useBorder = true, borderColor = {.4,.4,.4,.7}})
mainMenu:add("text", "startgame"):setData({x = 295, y = 105, z = 2, w = 215, color = {0,.9,.9,.5}, text = "Start Game", clickable = false, font = Game.fonts.large})
mainMenu:add("box", "settings"):setData({x = 275, y = 205, z = 1, w = 260, h = 80, color = {.5,.2,.7,.7}, useBorder = true, borderColor = {.4,.4,.4,.7}})
mainMenu:add("text", "settingsText"):setData({x = 295, y = 225, z = 2, w = 215, color = {0,.9,.9,.5}, text = "Settings", clickable = false, font = Game.fonts.large})
mainMenu:add("box", "help"):setData({x = 275, y = 325, z = 1, w = 260, h = 80, color = {.5,.2,.7,.7}, useBorder = true, borderColor = {.4,.4,.4,.7}})
mainMenu:add("text", "gamehelp"):setData({x = 295, y = 345, z = 2, w = 215, color = {0,.9,.9,.5}, text = "Help Menu", clickable = false, font = Game.fonts.large})
mainMenu:add("box", "quit"):setData({x = 275, y = 445, z = 1, w = 260, h = 80, color = {.5,.2,.7,.7}, useBorder = true, borderColor = {.4,.4,.4,.7}})
mainMenu:add("text", "quitgame"):setData({x = 295, y = 465, z = 2, w = 215, color = {0,.9,.9,.5}, text = "Quit Game", clickable = false, font = Game.fonts.large})

mainMenu:child("start"):registerEvent("onClick", function(self)
	mainMenu:disable()
	for _,v in ipairs(Game.background:children("box")) do
		if v.name:match("Balloon") then
			Game.background:child(v.name):disable()
		end
	end
	Game.credits:disable(false)
	Game.paused = false
	Game.score = 0
	Game.timePassed = 2
	Game.timeLeft = Game.length
	Game.runTime = 0
	Game.balloonCount = 1
	Game.inGame:enable()
	Game:setProblem()
	for k,v in ipairs(Game.balloonObjects) do
		Game.balloonObjects[k] = nil
	end
	Game.balloonObjects = {}
end)

mainMenu:child("settings"):registerEvent("onClick", function(self)
	Game.settingsMenu:enable()
	mainMenu:disable()
	Game.credits:disable(false)
end)

mainMenu:child("help"):registerEvent("onClick", function(self)
	Game.helpMenu:enable()
	mainMenu:disable()
	Game.credits:disable(false)
end)

mainMenu:child("quit"):registerEvent("onClick", function(self)
	love.event.quit()
end)

mainMenu:registerGlobalEvent("onHoverEnter", "box", function(self)
	if self.name == "start" or self.name == "help" or self.name == "quit" or self.name == "settings" then
		self:animateToOpacity(1):animateBorderToOpacity(1)
		if self.name == "start" then
			mainMenu:child("startgame"):animateToColor({1,1,1,1})
		elseif self.name == "help" then
			mainMenu:child("gamehelp"):animateToColor({1,1,1,1})
		elseif self.name == "quit" then
			mainMenu:child("quitgame"):animateToColor({1,1,1,1})
		else
			mainMenu:child("settingsText"):animateToColor({1,1,1,1})
		end
	end
end)

mainMenu:registerGlobalEvent("onHoverExit", "box", function(self)
	if self.name == "start" or self.name == "help" or self.name == "quit" or self.name == "settings" then
		self:animateToOpacity(.7):animateBorderToOpacity(.7)
		if self.name == "start" then
			mainMenu:child("startgame"):animateToColor({0,.9,.9,.5})
		elseif self.name == "help" then
			mainMenu:child("gamehelp"):animateToColor({0,.9,.9,.5})
		elseif self.name == "quit" then
			mainMenu:child("quitgame"):animateToColor({0,.9,.9,.5})
		else
			mainMenu:child("settingsText"):animateToColor({0,.9,.9,.5})
		end
	end
end)

return getmetatable(setmetatable(mainMenu, mainMenu))