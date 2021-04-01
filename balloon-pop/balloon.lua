local lg = love.graphics
local floor, min, max, random, noise = math.floor, math.min, math.max, love.math.random, love.math.noise
local Balloon = {}
local Game
local function initBalloon(G)
	Game = G
	return Balloon
end
function Balloon:new(g)
	if not Game then Game = g end
	local b = {}
	b.__index = Balloon
	b.balloon = 0
	repeat
		b.balloon = floor(random(1, #Game.balloons))
	until Game.balloons[b.balloon]
	b.w = 80
	b.h = 90
	b.x = floor(random(50, 690))
	b.oX = b.x
	b.xMin = b.x - (30 + floor(random(1, 10)))
	b.xMax = b.x + (30 + floor(random(1, 10)))
	b.xMove = 1
	b.y = 600
	b.killedAt = 0
	b.z = (Game.balloonCount + random(0.01, 0.99)) * 2
	b.correct = false
	b.id = Game.balloonCount
	b.name = "balloon" .. Game.balloonCount
	b.animating = true
	b.visible = false
	b.shake = false
	b.animateXTime = 0
	b.animateYTime = 0
	b.animateXSpeed = random(0.5,4)
	b.animateYSpeed = (b.animateXSpeed + (random(0.5 * Game.speedMultiplier,8 * Game.speedMultiplier) / 1.25))
	local n1, n2
	n1 = random(1, 5 * Game.difficulty)
	n2 = random(1, (10 * Game.difficulty) - n1)
	local roll = random(0,100)
	if Game.difficulty == 1 then
		b.number = n1 + n2
	elseif Game.difficulty == 2 then
		if roll > 50 then
			b.number = n1 + n2
		else
			b.number = max(n1,n2) - min(n1,n2)
		end
	elseif Game.difficulty == 3 then
		if roll > 50 then
			repeat
				n2 = random(1, (10 * Game.difficulty) - n1)
			until n1 % n2 == 0
			b.number = floor((max(n1,n2) / min(n1,n2)) * 10) / 10
		else
			b.number = n1 * n2
		end
	else
		if roll > 70 then
			if roll > 90 then
				b.number = n1 * n2
			else
				repeat
					n2 = random(1, (10 * Game.difficulty) - n1)
				until n1 % n2 == 0
				b.number = floor((max(n1,n2) / min(n1,n2)) * 10) / 10
			end
		elseif roll > 40 then
			b.number = max(n1,n2) - min(n1,n2)
		else
			b.number = n1 + n2
		end
	end
	if Game.noRightAnswerTime > (3 / Game.difficulty) then
		b.number = Game.problemResult
		Game.noRightAnswerTime = 0
	end
	b.animateFrom = 600
	b.hovered = false
	b.markForDelete = false
	return setmetatable(b,b)
end

function Balloon:draw()
	if self.animating then
		local x, y = self.x, self.y
		
		if not Game.paused and self.shake then
			if random(0,100) > 50 then
				x = (self.x - 5) + ((noise(self.x)) * random(3,5))
				y = self.y + ((noise(self.y)) * random(3,5))
			else
				x = (self.x - 5) - ((noise(self.x)) * random(3,5))
				y = self.y - ((noise(self.y)) * random(3,5))
			end
		end
		lg.setColor(1,1,1,1)
		if not self.shake then
			lg.draw(Game.shadowBalloon, x-9, y-19)
			lg.draw(Game.balloons[self.balloon], x-10, y-20)
		else
			lg.draw(Game.balloonsPopped[self.balloon], x-10, y-20)
		end
		lg.setFont(Game.fonts.balloon)
		if not self.shake then
			lg.setColor(0,0,0,.95)
			lg.printf(self.number, self.x, self.y + 23, self.w - 5, "center")
			lg.setColor(1,1,1,1)
			lg.printf(self.number, self.x, self.y + 22, self.w - 5, "center")
		else
			if not self.correct then
				lg.setColor(0,0,0,.95)
				lg.printf("X", x + 5, y + 5, self.w - 5, "center")
				lg.setColor(1,0,0,1)
				lg.printf("X", x + 5, y + 4, self.w - 5, "center")
			end
		end
	end
end

function Balloon:update(dt)
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
				if self.xMove == 1 or self.xMove == 3 then
					if self.x ~= self.xMin then
						if self.xMove == 1 then
							self.x = max(10, self:lerp(self.oX, self.xMin, tX))
						else
							self.x = max(5, self:lerp(self.oX, self.xMin, tX))
						end
					else
						self.xMove = 2
						self.oX = self.x
						self.animateXTime = 0
					end
				else
					if self.x ~= self.xMax then
						self.x = min(700, self:lerp(self.oX, self.xMax, tX))
					else
						self.xMove = 3
						self.oX = self.x
						self.animateXTime = 0
					end
				end
				local tY = min(self.animateYTime * ((self.animateYSpeed / 60) * Game.timeScale), 1.0)
				if self.y > -197 then
					self.y = self:lerp(self.animateFrom, -197, tY)
					if not self.visible then self.visible = true end
				else
					self.animating = false
					if self.visible then self.visible = false end
					Game.needToSort = true
				end
			else
				if self.y < 600 then
					self.y = self.y + (180 * dt) * min(2.5, ((800 / self.killedAt) / 2))
					if not self.visible then self.visible = true end
					Game.needToSort = true
				else
					self.animating = false
					if self.visible then self.visible = false end
				end
			end
		end
	end
end

function Balloon:mousepressed()
	if self.number == Game.problemResult then
		Game.score = Game.score + (100 * Game.difficulty)
		Game:setProblem()
		Game.noRightAnswerTime = 0
		self.correct = true
		love.audio.newSource(Game.right):play()
	else
		Game.score = max(0, Game.score - (50 * (Game.difficulty * Game.difficulty)))
		self.w = 80
		self.h = 80
		love.audio.newSource(Game.wrong):play()
	end
	Game.inGame:child("score"):setText("SCORE " .. Game.score)
	self.image = self.popped
	self.shake = true
	self.animateFrom = self.y
	self.animateYTime = 0
	self.animateYSpeed = max(5, min(10, (600 / self.y) * 2))
	self.killedAt = self.y
	if Game.balloonPop:isPlaying() then Game.balloonPop:stop() end
	Game.balloonPop:play()
end

function Balloon:lerp(t1,t2,t)
	return (1 - t) * t1 + t * t2
end

--setmetatable(Balloon,Balloon)
return initBalloon, setmetatable(Balloon,Balloon)