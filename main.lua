local Neon = require("neon")
local lg = love.graphics
local floor, min, max, random, rad = math.floor, math.min, math.max, love.math.random, math.rad

local Game = {}
Game.GUI = require("neon")
Game.GUI:addColor({1,0.8,0,1}, "golden")
Game.font = love.filesystem.newFileData("/res/thicktext.otf")
Game.balloonFont = love.filesystem.newFileData("/res/balloon.ttf")
Game.fonts = {
	tooltip = lg.newFont(Game.font, 16),
	small = lg.newFont(Game.font, 18),
	info = lg.newFont(Game.font, 20),
	medium = lg.newFont(Game.font, 24),
	large = lg.newFont(Game.font, 36),
	help = lg.newFont(Game.font, 40),
	huge = lg.newFont(Game.font, 48),
	balloon = lg.newFont(Game.balloonFont, 40)
}
Game.fonts.tooltip:setLineHeight(0.75)
Game.backgroundBalloons = 1
Game.timePassed = 5
Game.runTime = 0
Game.timeLeft = 0
Game.length = 120
Game.balloonCount = 1
Game.timeScale = 0
Game.bgTimePassed = 0
Game.paused = false
Game.problemResult = nil
Game.score = 0
Game.needToSort = false
Game.right = love.sound.newSoundData("/res/right.mp3")
Game.wrong = love.sound.newSoundData("/res/wrong.mp3")
Game.balloonPop = love.audio.newSource("/res/pop.mp3", "static")
Game.backgrounds = {
	lg.newImage("/res/background.png"),
	lg.newImage("/res/background2.png"),
	lg.newImage("/res/background3.png"),
	lg.newImage("/res/background4.png")
}
Game.bg = Game.backgrounds[random(1, #Game.backgrounds)]
Game.inGameBG = lg.newImage("/res/ingame.png")
Game.backgroundMusic = love.audio.newSource("/res/background.mp3", "stream")
Game.difficulty = 1
Game.speedMultiplier = 1
Game.noRightAnswerTime = 0
Game.balloons = {
	lg.newImage("/res/red.png"),
	lg.newImage("/res/blue.png"),
	lg.newImage("/res/green.png"),
	lg.newImage("/res/yellow.png"),
	lg.newImage("/res/pink.png"),
	lg.newImage("/res/purple.png"),
}
Game.shadowBalloon = lg.newImage("/res/shadow.png")
Game.balloonsPopped = {
	lg.newImage("/res/redpop.png"),
	lg.newImage("/res/bluepop.png"),
	lg.newImage("/res/greenpop.png"),
	lg.newImage("/res/yellowpop.png"),
	lg.newImage("/res/pinkpop.png"),
	lg.newImage("/res/purplepop.png"),
}
Game.balloonObjects = {}
--
Game.credits = Game.GUI:new()
Game.credits:add("text", "credits"):setData({x = 70, y = 570, z = 4, color = {1,1,1,1}, shadow = true, text = "Background music made by https://www.bensound.com | Balloon images made by{c=golden}Koen Schippers{/}", font = Game.fonts.small, clickable = false}):animateToPosition(75, 560, 4)
Game.credits:child("credits"):registerEvent("onAnimationComplete", function(self) 
	if self:getY() == 560 then 
		self:animateToPosition(75, 570, 4) 
	else 
		self:animateToPosition(75, 560, 4) 
	end 
end)

local Balloon = require("balloon")(Game)
Game.background = require("hud.background")(Game)
Game.mainMenu = require("hud.mainMenu")(Game)
Game.helpMenu = require("hud.helpMenu")(Game)
Game.settingsMenu = require("hud.settingsMenu")(Game)
Game.pauseMenu = require("hud.pauseMenu")(Game)
Game.inGame = require("hud.inGame")(Game)
Game.gameOver = require("hud.gameOver")(Game)
--

function love.load()
	Game:animateBG()
	love.audio.setVolume(0.1)
end

function Game:setProblem()
	local n1, n2
	n1 = random(1, 5 * self.difficulty)
	n2 = random(1, (10 * self.difficulty) - n1)
	local roll = random(0,100)
	if Game.difficulty == 1 then
		self.problemResult = n1 + n2
		self.inGame:child("problem"):setText(n1 .. " + " .. n2)
	elseif Game.difficulty == 2 then
		if roll > 50 then
			self.problemResult = n1 + n2
			self.inGame:child("problem"):setText(n1 .. " + " .. n2)
		else
			self.problemResult = max(n1,n2) - min(n1,n2)
			self.inGame:child("problem"):setText(max(n1,n2) .. " - " ..min(n1,n2))
		end
	elseif Game.difficulty == 3 then
		if roll > 50 then
			repeat
				n2 = random(1, (10 * Game.difficulty) - n1)
			until n1 % n2 == 0
			self.problemResult = floor((max(n1,n2) / min(n1,n2)) * 10) / 10
			self.inGame:child("problem"):setText(max(n1,n2) .. " / " ..min(n1,n2))
		else
			self.problemResult = n1 * n2
			self.inGame:child("problem"):setText(n1 .. " * " .. n2)
		end
	else
		if roll > 70 then
			if roll > 90 then
				self.problemResult = n1 * n2
				self.inGame:child("problem"):setText(n1 .. " * " .. n2)
			else
				repeat
					n2 = random(1, (10 * Game.difficulty) - n1)
				until n1 % n2 == 0
				self.problemResult = floor((max(n1,n2) / min(n1,n2)) * 10) / 10
				self.inGame:child("problem"):setText(max(n1,n2) .. " / " ..min(n1,n2))
			end
		elseif roll > 40 then
			self.problemResult = max(n1,n2) - min(n1,n2)
			self.inGame:child("problem"):setText(max(n1,n2) .. " - " ..min(n1,n2))
		else
			self.problemResult = n1 + n2
			self.inGame:child("problem"):setText(n1 .. " + " .. n2)
		end
	end
end

function Game:animateBG()
	local i = random(1, #self.backgrounds)
	repeat 
		i = random(1, #self.backgrounds)
	until self.background:child("background"):getImage() ~= self.backgrounds[i]
	self.background:child("background"):animateToImage(self.backgrounds[i], 5)
end

function Game:sortDraw()
	table.sort(self.balloonObjects, function(a,b) 
		if not a or not b then return false end
		if a.z == b.z then
			if a.id == b.id then
				if a.x == b.x then
					if a.y == b.y then
						return false
					else
						return a.y > b.y
					end
				else
					return a.x < b.x
				end
			else
				return a.id > b.id
			end
		else
			return a.z < b.z
		end
	end)
end

function love.update(dt)
	if not Game.backgroundMusic:isPlaying() then
		Game.backgroundMusic:play()
	end
	Neon:update(dt)
	for _,v in ipairs(Game.balloonObjects) do
		v:update(dt)
	end
	if Game.background.enabled and Game.backgroundBalloons < 13 then
		Game.bgTimePassed = Game.bgTimePassed + dt
		if Game.bgTimePassed > 0.65 then
			local img = (Game.backgroundBalloons < 7) and Game.balloons[Game.backgroundBalloons] or Game.balloons[(Game.backgroundBalloons % 6) + 1]
			Game.background:add("box", "bgBalloon" .. Game.backgroundBalloons):addImage(img, "balloon", true):setData({x = random(20,700), y = 600, z = 1, w = 80, h = 90, rot = rad(random(-30,30)), clickable = false}):animateToPosition(random(-100, 900), -197, max(random(0.4,1.3), random(0.4,1.3)))
			Game.bgTimePassed = 0
			Game.backgroundBalloons = Game.backgroundBalloons + 1
		end
	end
	if not Game.paused and Game.inGame.enabled then
		Game.timePassed = Game.timePassed + ((1 * dt) * Game.speedMultiplier)
		local rightAnswer = false
		for _,v in ipairs(Game.balloonObjects) do
			if v.visible and v.number == Game.problemResult then
				rightAnswer = true
			end
		end
		if not rightAnswer then
			Game.noRightAnswerTime = Game.noRightAnswerTime + dt
		else
			Game.noRightAnswerTime = 0
		end
		if Game.timePassed > ((0.75 / Game.timeScale) / Game.speedMultiplier) then
			Game.balloonCount = 0
			repeat
				Game.balloonCount = Game.balloonCount + 1
			until (not Game.balloonObjects[Game.balloonCount]) or (Game.balloonObjects[Game.balloonCount] and not Game.balloonObjects[Game.balloonCount].animating)
			Game.balloonObjects[Game.balloonCount] = Balloon:new()
			Game.timePassed = 0
			Game.needToSort = true
		end
		Game.runTime = Game.runTime + dt
		Game.timeScale = (Game.runTime + 40) / Game.length
		Game.timeLeft = Game.timeLeft - dt
		if Game.runTime > Game.length then
			Game.inGame:disable()
			Game.balloonObjects = {}
			Game.gameOver:enable()
			Game.gameOver:child("endscore"):setText("Final Score: " .. Game.score)
		else
			if floor(Game.timeLeft) >= 10 then
				local t1, t2 = floor(Game.timeLeft / 60), floor(Game.timeLeft % 60)
				if t2 >= 10 then
					Game.inGame:child("timeLeft"):setText("TIME " .. t1 .. ":" .. t2)
				else
					Game.inGame:child("timeLeft"):setText("TIME " .. t1 .. ":0" .. t2)
				end
			else
				Game.inGame:child("timeLeft"):setText("TIME 0:0" .. floor(Game.timeLeft))
			end
		end
	end
end

function love.keypressed(key,scan,isrepeat)
	Neon:keypressed(key,scan,isrepeat)
	if key == "escape" then
		if Game.inGame.enabled then
			Game.paused = not Game.paused
			if Game.paused then
				Game.pauseMenu:enable()
			else
				Game.pauseMenu:disable(false)
				Game.timePassed = 0
			end
		end
		if Game.gameOver.enabled then
			Game.gameOver:disable()
			Game.mainMenu:enable()
			Game:animateBG()
			for _,v in ipairs(Game.background:children("box")) do
				if v.name:match("Balloon") then
					Game.background:child(v.name):enable()
				end
			end
			Game.credits:enable()
		end
	end
end

function love.draw()
	Game.background:draw()
	if Game.gameOver.enabled then
		Game.gameOver:draw()
	end
	if Game.helpMenu.enabled then
		Game.helpMenu:draw()
	end
	if Game.mainMenu.enabled then
		Game.mainMenu:draw()
		Game.credits:draw()
	end
	if Game.settingsMenu.enabled then
		Game.settingsMenu:draw()
	end
	if Game.inGame.enabled then
		lg.setColor(1,1,1,1)
		lg.draw(Game.inGameBG, 0, 0)
		if Game.needToSort then
			Game:sortDraw()
			Game.needToSort = false
		end
		for _,v in ipairs(Game.balloonObjects) do
			v:draw()
		end
		Game.inGame:draw()
	end
	if Game.pauseMenu.enabled then
		Game.pauseMenu:draw()
	end
end

function love.mousepressed(x, y, button, istouch, presses)
	Neon:mousepressed(x, y, button, istouch, presses)
	table.sort(Game.balloonObjects, function(a,b) 
		if not a or not b then return false end
		if a.z == b.z then
			if a.id == b.id then
				if a.x == b.x then
					if a.y == b.y then
						return false
					else
						return a.y < b.y
					end
				else
					return a.x > b.x
				end
			else
				return a.id < b.id
			end
		else
			return a.z > b.z
		end
	end)
	if Game.inGame.enabled and not Game.paused then
		for _,v in ipairs(Game.balloonObjects) do
			if v.hovered and not v.shake then
				v:mousepressed(x, y, button, istouch, presses)
				break
			end
		end
	end
	Game:sortDraw()
end