local lg = love.graphics
local floor, min, max, random = math.floor, math.min, math.max, love.math.random
local settingsMenu = Game.GUI:new():setZ(1)
local textToImage = {red=1,blue=2,green=3,yellow=4,pink=5,purple=6}

settingsMenu:add("box", "settingsBG"):setData({x = 220, y = 0, z = 0, w = 580, h = 600, clickable = false, color = {.2,.2,.2,.85}, useBorder = true, borderColor = {.3,.3,.3,1}})
settingsMenu:add("checkbox", "colors"):setData({w = 10, h = 15, x = 260, y = 90, z = 1, font = Game.fonts.small, padding = {10,10,10,10}, fixPadding = true, color = {.3,.2,.8,.4}, label = "Enabled Colors", labelColor = {.88,.88,.88,1}, labelFont = Game.fonts.large, labelPos = {260, 30, 1}, labelShadow = true, options = {"Red", "Blue", "Green", "Yellow", "Pink", "Purple"}, optionColor = {0,.8,.1,1}, default = "all", useBorder = true, borderColor = {.9,.9,.9,.4}, overlayColor = {.1,.8,.1,.7}, force = true, selectedBorder = {0,0,0,.6}})
settingsMenu:add("checkbox", "length"):setData({w = 10, h = 15, x = 260, y = 230, z = 1, font = Game.fonts.small, padding = {10,10,10,10}, fixPadding = true, color = {.3,.2,.8,.4}, label = "Round Length", labelColor = {.88,.88,.88,1}, labelFont = Game.fonts.large, labelPos = {260, 170, 1}, labelShadow = true, options = {"1min", "2min", "3min", "4min", "5min"}, optionColor = {0,.8,.1,1}, singleSelection = true, default = "5min", useBorder = true, borderColor = {.9,.9,.9,.4}, overlayColor = {.1,.8,.1,.7}, force = true, selectedBorder = {0,0,0,.6}})
settingsMenu:add("checkbox", "speed"):setData({w = 10, h = 15, x = 260, y = 370, z = 1, font = Game.fonts.small, padding = {10,10,10,10}, fixPadding = true, color = {.3,.2,.8,.4}, label = "Balloon Speed", labelColor = {.88,.88,.88,1}, labelFont = Game.fonts.large, labelPos = {260, 310, 1}, labelShadow = true, options = {"Slow", "Normal", "Double", "Triple"}, optionColor = {0,.8,.1,1}, singleSelection = true, default = "Normal", useBorder = true, borderColor = {.9,.9,.9,.4}, overlayColor = {.1,.8,.1,.7}, force = true, selectedBorder = {0,0,0,.6}})
settingsMenu:add("checkbox", "difficulty"):setData({w = 10, h = 15, x = 260, y = 510, z = 1, font = Game.fonts.small, padding = {10,10,10,10}, fixPadding = true, color = {.3,.2,.8,.4}, label = "Difficulty", labelColor = {.88,.88,.88,1}, labelFont = Game.fonts.large, labelPos = {260, 450, 1}, labelShadow = true, options = {"Easy", "Medium", "Hard", "Extreme"}, optionColor = {0,.8,.1,1}, singleSelection = true, default = "Easy", useBorder = true, borderColor = {.9,.9,.9,.4}, overlayColor = {.1,.8,.1,.7}, force = true, selectedBorder = {0,0,0,.6}})
settingsMenu:add("box", "back"):setData({x = 40, y = 32, z = 1, w = 150, h = 50, color = {.5,.2,.7,.7}, useBorder = true, borderColor = {.4,.4,.4,.7}})
settingsMenu:add("text", "backtext"):setData({x = 50, y = 44, z = 2, w = 130, color = {0,.9,.9,.5}, text = "Back", clickable = false, font = Game.fonts.medium})

settingsMenu:child("difficulty"):registerEvent("onOptionClick", function(self, option)
	if option.text == "Easy" then
		Game.difficulty = 1
	elseif option.text == "Medium" then
		Game.difficulty = 2
	elseif option.text == "Hard" then
		Game.difficulty = 3
	else
		Game.difficulty = 4
	end
end)

settingsMenu:child("speed"):registerEvent("onOptionClick", function(self, option)
	if option.text == "Slow" then
		Game.speedMultiplier = 0.5
	elseif option.text == "Normal" then
		Game.speedMultiplier = 1
	elseif option.text == "Double" then
		Game.speedMultiplier = 2
	else
		Game.speedMultiplier = 3
	end
end)

settingsMenu:child("length"):registerEvent("onOptionClick", function(self, option)
	if option.text == "1min" then
		Game.length = 60
	elseif option.text == "2min" then
		Game.length = 120
	elseif option.text == "3min" then
		Game.length = 180
	elseif option.text == "4min" then
		Game.length = 240
	else
		Game.length = 300
	end
end)

settingsMenu:child("colors"):registerEvent("onOptionClick", function(self, option)
	local text = option.text:lower()
	if option.selected then
		if not Game.balloons[textToImage[text]] then
			Game.balloons[textToImage[text]] = lg.newImage("/res/" .. text .. ".png")
			Game.balloonsPopped[textToImage[text]] = lg.newImage("/res/" .. text .. "pop.png")
		end
	else
		if Game.balloons[textToImage[text]] then
			Game.balloons[textToImage[text]] = nil
			Game.balloonsPopped[textToImage[text]] = nil
		end
	end
end)

settingsMenu:child("back"):registerEvent("onClick", function(self)
	Game.mainMenu:enable()
	Game.credits:enable()
	settingsMenu:disable(false)
end):registerEvent("onHoverEnter", function(self)
	self:animateToOpacity(1):animateBorderToOpacity(1)
	settingsMenu:child("backtext"):animateToColor({1,1,1,1})
end):registerEvent("onHoverExit", function(self)
	self:animateToOpacity(.7):animateBorderToOpacity(.7)
	settingsMenu:child("backtext"):animateToColor({0,.9,.9,.5})
end)

settingsMenu:disable()

return getmetatable(setmetatable(settingsMenu, settingsMenu))