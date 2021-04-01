local lg = love.graphics
local floor, min, max, random = math.floor, math.min, math.max, love.math.random
local Game

local function initHelp(G)
	Game = G
	local helpMenu = Game.GUI:new():setZ(1)
	helpMenu:add("box", "settingsBG"):setData({x = 0, y = 0, z = 0, w = 570, h = 600, clickable = false, color = {.2,.2,.2,.85}, useBorder = true, borderColor = {.3,.3,.3,1}})
	helpMenu:add("text", "helpText"):setData({x = 40, y = 28, w = 490, shadow = true, color = {1,1,1,1}, font = Game.fonts.info, align = "left", text = "To play the game, click the balloons that show up that match the math problem at the top of the screen! You can increase your game difficulty, as well as balloon speed, to make the game harder, or easier, and a higher difficulty will give you more points! The balloons will start off slow, and pick up speed as the round progresses. Each round will last for 5 minutes, or however long you decide to set it for! You can pause by pressing Escape while playing. Good luck!"})
	helpMenu:add("text", "helpTextEasy"):setData({x = 40, y = 287, w = 490, shadow = true, color = {.8,1,.8,1}, font = Game.fonts.info, align = "left", text = "On the [EASY] difficulty mode, you will be given addition problems, up to 5 + 5."})
	helpMenu:add("text", "helpTextMedium"):setData({x = 40, y = 355, w = 490, shadow = true, color = {1,.8,.8,1}, font = Game.fonts.info, align = "left", text = "On the [MEDIUM] difficulty mode, you will be given either addition or subtraction problems, up to 10 + 10, or 10 - 10."})
	helpMenu:add("text", "helpTextHard"):setData({x = 40, y = 420, w = 490, shadow = true, color = {.8,.8,1,1}, font = Game.fonts.info, align = "left", text = "On the [HARD] difficulty mode, you will be given multiplication, or division problems, up to 15 * 15, or 15 / 15."})
	helpMenu:add("text", "helpTextExtreme"):setData({x = 40, y = 485, w = 490, shadow = true, color = {1,1,.8,1}, font = Game.fonts.info, align = "left", text = "On the [EXTREME] difficulty mode, you will be given addition, subtraction, multiplication, or division problems, up to 20 + 20, 20 - 20, 20 * 20, or 20 / 20."})
	helpMenu:add("box", "backstart"):setData({x = 600, y = 30, z = 1, w = 170, h = 80, color = {.5,.2,.7,.7}, useBorder = true, borderColor = {.4,.4,.4,.7}})
	helpMenu:add("text", "backStartText"):setData({x = 573, y = 50, z = 2, w = 215, color = {0,.9,.9,.5}, text = "Back", clickable = false, font = Game.fonts.large})

	helpMenu:child("backstart"):registerEvent("onClick", function(self)
		Game.mainMenu:enable()
		Game.credits:enable()
		helpMenu:disable()
	end):registerEvent("onHoverEnter", function(self)
		self:animateToOpacity(1):animateBorderToOpacity(1)
		helpMenu:child("backStartText"):animateToColor({1,1,1,1})
	end):registerEvent("onHoverExit", function(self)
		self:animateToOpacity(.7):animateBorderToOpacity(.7)
		helpMenu:child("backStartText"):animateToColor({0,.9,.9,.5})
	end)

	helpMenu:disable()
		
	--return getmetatable(setmetatable(helpMenu, helpMenu))
	return helpMenu
end
return initHelp