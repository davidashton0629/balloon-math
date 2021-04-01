local lg = love.graphics
local floor, min, max, random = math.floor, math.min, math.max, love.math.random
local textToImage = {red=1,blue=2,green=3,yellow=4,pink=5,purple=6}
local Game 

local function initSettings(G)
	Game = G
	local settingsMenu = Game.GUI:new():setZ(1)
	settingsMenu:add("box", "settingsBG"):setData({x = 173, y = 0, z = 0, w = 627, h = 600, clickable = false, color = {.2,.2,.2,.85}, useBorder = true, borderColor = {.3,.3,.3,1}})
	settingsMenu:add("checkbox", "colors"):setData({w = 10, h = 15, x = 260, y = 90, z = 1, font = Game.fonts.small, padding = {10,10,10,10}, fixPadding = true, color = {.3,.2,.8,.4}, label = "Enabled Colors", labelColor = {.88,.88,.88,1}, labelFont = Game.fonts.large, labelPos = {260, 30, 1}, labelShadow = true, options = {"Red", "Blue", "Green", "Yellow", "Pink", "Purple"}, optionColor = {0,.8,.1,1}, default = "all", useBorder = true, borderColor = {.9,.9,.9,.4}, overlayColor = {.1,.8,.1,.7}, force = true, selectedBorder = {0,0,0,.6}})
	settingsMenu:add("checkbox", "length"):setData(settingsMenu:child("colors"):getDefault()):setData({x = 260, y = 230, label = "Round Length", labelPos = {260, 170, 1}, singleSelection = true, options = {"1min", "2min", "3min", "4min", "5min"}, default = "2min"})
	settingsMenu:add("checkbox", "speed"):setData(settingsMenu:child("colors"):getDefault()):setData({x = 260, y = 370, label = "Balloon Speed", labelPos = {260, 310, 1}, singleSelection = true, options = {"Slow", "Normal", "Double", "Triple"}, default = "Normal"})
	settingsMenu:add("checkbox", "difficulty"):setData(settingsMenu:child("colors"):getDefault()):setData({x = 260, y = 510, label = "Difficulty", labelPos = {260, 450, 1}, singleSelection = true, options = {"Easy", "Medium", "Hard", "Extreme"},  default = "Easy"})
	settingsMenu:add("box", "back"):setData({x = 10, y = 12, z = 1, w = 150, h = 50, color = {.5,.2,.7,.7}, useBorder = true, borderColor = {.4,.4,.4,.7}})
	settingsMenu:add("text", "backtext"):setData({x = 20, y = 24, z = 2, w = 130, color = {0,.9,.9,.5}, text = "Back", clickable = false, font = Game.fonts.medium})

	settingsMenu:registerGlobalEvent("onOptionHover", "checkbox", function(self, option)
		if self.name == "colors" then
			settingsMenu:child("tooltipBG"):enable():setData({w = 230, x = (option.x - ((230 - option.w) / 2)) + 2, y = option.y - 68, borderColor = {.8,1,1,.85}})
			settingsMenu:child("tooltipText"):enable():setData({x = (option.x - ((220 - option.w) / 2)), y = option.y - 52, w = 223, text = "choose what color balloons show up", color = {.8,1,1,1}})
		elseif self.name == "length" then
			settingsMenu:child("tooltipBG"):enable():setData({w = 230, x = (option.x - ((230 - option.w) / 2)) + 2, y = option.y - 68, borderColor = {1,.8,1,.85}})
			settingsMenu:child("tooltipText"):enable():setData({x = (option.x - ((220 - option.w) / 2)), y = option.y - 52, w = 223, text = "choose how long your rounds are", color = {1,.8,1,1}})
		elseif self.name == "speed" then
			settingsMenu:child("tooltipBG"):enable():setData({w = 230, x = (option.x - ((230 - option.w) / 2)) + 2, y = option.y - 68, borderColor = {1,1,.8,.85}})
			settingsMenu:child("tooltipText"):enable():setData({x = (option.x - ((220 - option.w) / 2)), y = option.y - 52, w = 223, text = "choose how fast the balloons move", color = {1,1,.8,1}})
		else
			settingsMenu:child("tooltipBG"):enable():setData({w = 230, x = (option.x - ((230 - option.w) / 2)) + 2, y = option.y - 68, borderColor = {1,.8,.8,.85}})
			settingsMenu:child("tooltipText"):enable():setData({x = (option.x - ((220 - option.w) / 2)), y = option.y - 52, w = 223, color = {1,.8,.8,1}})
			if option.text == "Easy" then
				settingsMenu:child("tooltipText"):setText("Addition Only [5->5]")
			elseif option.text == "Medium" then
				settingsMenu:child("tooltipText"):setText("Addition and Subtraction [10->10]")
			elseif option.text == "Hard" then
				settingsMenu:child("tooltipText"):setText("Multiplication and Division [15->15]")
			else
				settingsMenu:child("tooltipBG"):setData({w = 230, x = (option.x - ((230 - option.w) / 2)) + 2, y = option.y - 68, borderColor = {1,.8,.8,.85}})
				settingsMenu:child("tooltipText"):setData({w = 220, x = (option.x - ((220 - option.w) / 2)), y = option.y - 60, color = {1,.8,.8,.8}})

				settingsMenu:child("tooltipText"):setText("Addition, Subtraction, Multiplication and Division [20->20]")
			end
		end
	end)

	settingsMenu:registerGlobalEvent("onHoverExit", "checkbox", function(self, option)
		settingsMenu:child("tooltipBG"):disable()
		settingsMenu:child("tooltipText"):disable()
	end)

	settingsMenu:add("box", "tooltipBG"):setData({x = 260, y = 80, z = 3, w = 230, h = 50, color = {.2,.2,.2,.9}, useBorder = true, borderColor = {.8,1,1,.85}}):disable()
	settingsMenu:child("tooltipBG").draw = function(self)
		local color = settingsMenu:child("tooltipText").color
		lg.setColor(color[1], color[2], color[3], .85)
		lg.polygon(
			"line", 
			self.pos.x + (self.w / 2) - 10, self.pos.y + self.h  + 2, 
			self.pos.x + (self.w / 2) + 10, self.pos.y + self.h + 2, 
			self.pos.x + (self.w / 2), self.pos.y + self.h + 15
		)
		lg.setColor(.2,.2,.2,.9)
		lg.polygon(
			"fill", 
			self.pos.x + (self.w / 2) - 9, self.pos.y + self.h  + 2, 
			self.pos.x + (self.w / 2) + 9, self.pos.y + self.h + 2, 
			self.pos.x + (self.w / 2), self.pos.y + self.h + 14
		)
		lg.setColor(.2,.2,.2,.9)
		lg.setBlendMode("replace","premultiplied")
		lg.setLineWidth(1)
		lg.line(self.pos.x + (self.w / 2) - 8.95, self.pos.y + self.h, self.pos.x + (self.w / 2) + 8.95, self.pos.y + self.h)
		lg.line(self.pos.x + (self.w / 2) - 8.95, self.pos.y + self.h + 1, self.pos.x + (self.w / 2) + 8.95, self.pos.y + self.h + 1)
		lg.line(self.pos.x + (self.w / 2) - 8, self.pos.y + self.h + 2, self.pos.x + (self.w / 2) + 8, self.pos.y + self.h + 2)
		lg.setLineWidth(1)
		lg.setBlendMode("alpha")
		lg.setColor(1,1,1,1)
	end
	settingsMenu:add("text", "tooltipText"):setData({x = 270, y = 90, z = 4, w = 220, h = 30, font = Game.fonts.tooltip, text = "toggle what color balloons show up", color = {.8,1,1,1}, shadow = true}):disable()


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
	--return getmetatable(setmetatable(settingsMenu, settingsMenu))
	return settingsMenu
end

return initSettings