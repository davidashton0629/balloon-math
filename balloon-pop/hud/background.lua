local lg = love.graphics
local floor, min, max, random, rad = math.floor, math.min, math.max, love.math.random, math.rad
local background = Game.GUI:new():setZ(0)

background:add("box", "background"):addImage(Game.bg, "background", true):setData({x = 0, y = 0, z = 0, w = 800, h = 600, clickable = false})
--[[
background:add("box", "bgBalloon"):addImage(Game.balloons[1], "balloon", true):setData({x = random(20,700), y = 600, z = 1, w = 80, h = 90, rot = rad(random(-30,30)), clickable = false}):animateToPosition(random(-100, 900), -197, max(random(0.4,1.3), random(0.4,1.3)))
background:add("box", "bgBalloon2"):addImage(Game.balloons[2], "balloon", true):setData({x = random(20,700), y = 600, z = 2, w = 80, h = 90, rot = rad(random(-30,30)), clickable = false}):animateToPosition(random(-100, 900), -197, max(random(0.4,1.3), random(0.4,1.3)))
background:add("box", "bgBalloon3"):addImage(Game.balloons[3], "balloon", true):setData({x = random(20,700), y = 600, z = 3, w = 80, h = 90, rot = rad(random(-30,30)), clickable = false}):animateToPosition(random(-100, 900), -197, max(random(0.4,1.3), random(0.4,1.3)))
background:add("box", "bgBalloon4"):addImage(Game.balloons[4], "balloon", true):setData({x = random(20,700), y = 600, z = 4, w = 80, h = 90, rot = rad(random(-30,30)), clickable = false}):animateToPosition(random(-100, 900), -197, max(random(0.4,1.3), random(0.4,1.3)))
background:add("box", "bgBalloon5"):addImage(Game.balloons[5], "balloon", true):setData({x = random(20,700), y = 600, z = 5, w = 80, h = 90, rot = rad(random(-30,30)), clickable = false}):animateToPosition(random(-100, 900), -197, max(random(0.4,1.3), random(0.4,1.3)))
background:add("box", "bgBalloon6"):addImage(Game.balloons[6], "balloon", true):setData({x = random(20,700), y = 600, z = 6, w = 80, h = 90, rot = rad(random(-30,30)), clickable = false}):animateToPosition(random(-100, 900), -197, max(random(0.4,1.3), random(0.4,1.3)))
background:add("box", "bgBalloon7"):addImage(Game.balloons[1], "balloon", true):setData({x = random(20,700), y = 600, z = 1, w = 80, h = 90, rot = rad(random(-30,30)), clickable = false}):animateToPosition(random(-100, 900), -197, max(random(0.4,1.3), random(0.4,1.3)))
background:add("box", "bgBalloon8"):addImage(Game.balloons[2], "balloon", true):setData({x = random(20,700), y = 600, z = 2, w = 80, h = 90, rot = rad(random(-30,30)), clickable = false}):animateToPosition(random(-100, 900), -197, max(random(0.4,1.3), random(0.4,1.3)))
background:add("box", "bgBalloon9"):addImage(Game.balloons[3], "balloon", true):setData({x = random(20,700), y = 600, z = 3, w = 80, h = 90, rot = rad(random(-30,30)), clickable = false}):animateToPosition(random(-100, 900), -197, max(random(0.4,1.3), random(0.4,1.3)))
background:add("box", "bgBalloon10"):addImage(Game.balloons[4], "balloon", true):setData({x = random(20,700), y = 600, z = 4, w = 80, h = 90, rot = rad(random(-30,30)), clickable = false}):animateToPosition(random(-100, 900), -197, max(random(0.4,1.3), random(0.4,1.3)))
background:add("box", "bgBalloon11"):addImage(Game.balloons[5], "balloon", true):setData({x = random(20,700), y = 600, z = 5, w = 80, h = 90, rot = rad(random(-30,30)), clickable = false}):animateToPosition(random(-100, 900), -197, max(random(0.4,1.3), random(0.4,1.3)))
background:add("box", "bgBalloon12"):addImage(Game.balloons[6], "balloon", true):setData({x = random(20,700), y = 600, z = 6, w = 80, h = 90, rot = rad(random(-30,30)), clickable = false}):animateToPosition(random(-100, 900), -197, max(random(0.4,1.3), random(0.4,1.3)))
--]]
background:registerGlobalEvent("onAnimationStart", "box", function(self)
	if self.name:match("Balloon") then
		if self.rot > 0 then
			if self.positionToAnimateTo.x < self.pos.x then
				self:animateToPosition(900, -197, max(random(0.4,1.3), random(0.4,1.3)), true)
			end
		else
			if self.positionToAnimateTo.x > self.pos.x then
				self:animateToPosition(-100, -197, max(random(0.4,1.3), random(0.4,1.3)), true)
			end
		end
	end
end)
background:registerGlobalEvent("onAnimationComplete", "box", function(self)
	if self.name:match("Balloon") then
		self:setData({x = random(20,700), y = 600, w = 80, h = 90, rot = rad(random(-30,30))}):animateToPosition(random(-100, 900), -197, max(random(0.4,1.3), random(0.4,1.3)))
	end
end)

background:child("background"):registerEvent("onAnimationComplete", function(self)
	Game:animateBG()
end)

return getmetatable(setmetatable(background, background))