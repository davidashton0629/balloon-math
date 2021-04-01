local lg = love.graphics
local floor, min, max, random, rad = math.floor, math.min, math.max, love.math.random, math.rad
local Game
local function initBackground(G)
	Game = G
	local background = Game.GUI:new():setZ(0)
	background:add("box", "background"):addImage(Game.bg, "background", true):setData({x = 0, y = 0, z = 0, w = 800, h = 600, clickable = false})
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

	--return setmetatable(background, background)
	return background
end
return initBackground