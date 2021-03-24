local lg = love.graphics
local floor, min, max, random = math.floor, math.min, math.max, love.math.random
local helpMenu = Game.GUI:new()

helpMenu:add("box", "background"):addImage(Game.bg, "background", true):setData({x = 0, y = 0, z = 0, w = 800, h = 600, clickable = false})
helpMenu:add("text", "helpText"):setData({x = 40, y = 85, w = 490, shadow = true, color = {1,1,1,1}, font = Game.fonts.medium, text = "To play the game, click the balloons that show up that match the math problem at the top of the screen! You can increase your game difficulty, as well as balloon speed, to make the game harder, or easier, and a higher difficulty will give you more points! Each round will last for 5 minutes, or however long you decide to set it for! You can pause by pressing Escape while playing. Good luck!"})
helpMenu:add("box", "backstart"):setData({x = 600, y = 135, z = 1, w = 160, h = 80, color = {.5,.2,.7,.7}, useBorder = true, borderColor = {.4,.4,.4,.7}})
helpMenu:add("text", "backStartText"):setData({x = 573, y = 155, z = 2, w = 215, color = {0,.9,.9,.5}, text = "Back", clickable = false, font = Game.fonts.large})

helpMenu:child("backstart"):registerEvent("onClick", function(self)
	Game.mainMenu:enable()
	helpMenu:disable()
	Game:animateBG()
end):registerEvent("onHoverEnter", function(self)
	self:animateToOpacity(1):animateBorderToOpacity(1)
	helpMenu:child("backStartText"):animateToColor({1,1,1,1})
end):registerEvent("onHoverExit", function(self)
	self:animateToOpacity(.7):animateBorderToOpacity(.7)
	helpMenu:child("backStartText"):animateToColor({0,.9,.9,.5})
end)

helpMenu:disable()
	
return getmetatable(setmetatable(helpMenu, helpMenu))