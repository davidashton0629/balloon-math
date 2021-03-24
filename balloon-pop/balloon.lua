local lg = love.graphics
local floor, min, max, random, noise = math.floor, math.min, math.max, love.math.random, love.math.noise
local Balloon = {}
local balloonCount = 0
local Game

function Balloon:new(g)
	if not Game then Game = g end
	local answerOnScreen = false
	for _,v in ipairs(Game.balloonObjects) do
		if not v.animating then
			balloonCount = v.id
			isBalloon = true
			if not v.visible then
				v.markForDelete = true
			end
		end
	end
	if not isBalloon then
		balloonCount = balloonCount + 1
	end
	local b = {}
	local newBalloon
	repeat
		newBalloon = floor(random(1, #Game.balloons))
	until Game.balloons[newBalloon]
	b.w = 85
	b.h = 115
	b.x = floor(random(50, 690))
	b.oX = b.x
	b.xMin = b.x - (30 + floor(random(1, 10)))
	b.xMax = b.x + (30 + floor(random(1, 10)))
	b.xMove = 1
	b.y = 600
	b.killedAt = 0
	b.z = balloonCount
	b.balloon = Game.balloons[newBalloon]
	b.popped = Game.balloonsPopped[newBalloon]
	b.image = b.balloon
	b.id = balloonCount + (random(0.01,1) * random())
	b.name = "balloon" .. balloonCount
	b.animating = true
	b.visible = false
	b.shake = false
	b.animateXTime = 0
	b.animateYTime = 0
	b.animateXSpeed = random(0.5,4)
	b.animateYSpeed = b.animateXSpeed + (random(0.5,8) / 1.25)
	local n1, n2
	n1 = random(1, 5 * Game.difficulty)
	n2 = random(1, (10 * Game.difficulty) - n1)
	b.number = n1 + n2
	if Game.noRightAnswerTime > 3 then
		b.number = Game.problemResult
	end
	b.animateFrom = 600
	b.hovered = false
	b.markForDelete = false
	
	function b:draw()
		if self.animating then
			local x, y = self.x, self.y
			
			if not Game.paused and self.shake then
				if random(0,100) > 50 then
					x = self.x + ((noise(self.x)) * random(3,5))
					y = self.y + ((noise(self.y)) * random(3,5))
				else
					x = self.x - ((noise(self.x)) * random(3,5))
					y = self.y - ((noise(self.y)) * random(3,5))
				end
			end
			lg.setColor(1,1,1,1)
			lg.draw(self.image, x + 2, y)
			if not self.shake then
				lg.setFont(Game.fonts.large)
				lg.setColor(0,0,0,1)
				lg.printf(self.number, self.x + 10, self.y + 42, self.w - 15, "center")
			end
		end
	end
	
	function b:update(dt)
		if Game and not Game.paused then
			local x,y = love.mouse.getPosition()
			
			if (x >= self.x and x <= self.x + self.w) and (y >= self.y and y <= self.y + self.h) then
				if not self.hovered then self.hovered = true end
			else
				if self.hovered then self.hovered = false end
			end
			
			if self.animating then
				self.animateXTime = self.animateXTime + dt
				self.animateYTime = self.animateYTime + dt
				if not self.shake then
					local tX = min(self.animateXTime * (self.animateXSpeed / 8), 1.0)
					if self.xMove == 1 then
						if self.x ~= self.xMin then
							self.x = max(10, self:lerp(self.oX, self.xMin, tX))
						else
							self.xMove = 2
							self.oX = self.x
							self.animateXTime = 0
						end
					else
						if self.x ~= self.xMax then
							self.x = min(700, self:lerp(self.oX, self.xMax, tX))
						else
							self.xMove = 1
							self.oX = self.x
							self.animateXTime = 0
						end
					end
					local tY = min(self.animateYTime * (self.animateYSpeed / 25), 1.0)
					if self.y > -197 then
						self.y = self:lerp(self.animateFrom, -197, tY)
						if not self.visible then self.visible = true end
					else
						self.animating = false
						if self.visible then self.visible = false end
					end
				else
					if self.y < 600 then
						self.y = self.y + (180 * dt) * min(2.5, ((800 / self.killedAt) / 2))
						if not self.visible then self.visible = true end
					else
						self.animating = false
						if self.visible then self.visible = false end
					end
				end
			end
		end
	end
	
	function b:mousepressed()
		if self.number == Game.problemResult then
			Game.score = Game.score + (100 * Game.difficulty)
			Game:setProblem()
		else
			Game.score = max(0, Game.score - (50 * (Game.difficulty * Game.difficulty)))
		end
		Game.inGame:child("score"):setText("Score: " .. Game.score)
		self.image = self.popped
		self.shake = true
		self.animateFrom = self.y
		self.animateYTime = 0
		self.animateYSpeed = max(5, min(10, (600 / self.y) * 2))
		self.killedAt = self.y
		if Game.balloonPop:isPlaying() then Game.balloonPop:stop() end
		Game.balloonPop:play()
	end

	function b:lerp(t1,t2,t)
		return (1 - t) * t1 + t * t2
	end
	
	for _,v in ipairs(Game.balloonObjects) do
		if v.markForDelete then
			v = nil
		end
	end
	
	setmetatable(b, b)
	return b
end

return Balloon