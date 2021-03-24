local Neon = require("neon")
local lg = love.graphics
local floor, min, max, random = math.floor, math.min, math.max, love.math.random

Game = {}
Game.GUI = require("neon")
Game.font = love.filesystem.newFileData("/res/thicktext.otf")
Game.fonts = {
	small = lg.newFont(Game.font, 18),
	medium = lg.newFont(Game.font, 24),
	large = lg.newFont(Game.font, 36),
	help = lg.newFont(Game.font, 40),
	huge = lg.newFont(Game.font, 48),
}
Game.timePassed = 5
Game.runTime = 0
Game.length = 300
Game.paused = false
Game.problemResult = nil
Game.score = 0
Game.balloonPop = love.audio.newSource("/res/pop.mp3", "static")
Game.balloonPop:setVolume(0.1)
Game.backgrounds = {
	lg.newImage("/res/background.png"),
	lg.newImage("/res/background2.png"),
	lg.newImage("/res/background3.png"),
	lg.newImage("/res/background4.png")
}
Game.bg = Game.backgrounds[random(1, #Game.backgrounds)]
Game.inGameBG = lg.newImage("/res/ingame.png")
Game.backgroundMusic = love.audio.newSource("/res/background.mp3", "stream")
Game.backgroundMusic:setVolume(0.1)
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
Game.mainMenu = require("hud.mainMenu")
Game.helpMenu = require("hud.helpMenu")
Game.settingsMenu = require("hud.settingsMenu")
Game.pauseMenu = require("hud.pauseMenu")
Game.inGame = require("hud.inGame")
Game.gameOver = require("hud.gameOver")
local Balloon = require("balloon")
--

function love.load()
	Game:animateBG()
end

function Game:setProblem()
	local n1, n2
	n1 = random(1, 5 * self.difficulty)
	n2 = random(1, (10 * self.difficulty) - n1)
	self.inGame:child("problem"):setText(n1 .. " + " .. n2)
	self.problemResult = n1 + n2
end

function Game:animateBG()
	local i = random(1, #self.backgrounds)
	repeat 
		i = random(1, #self.backgrounds)
	until self.mainMenu:child("background"):getImage() ~= self.backgrounds[i]
	self.mainMenu:child("background"):animateToImage(self.backgrounds[i], 5)
end

function love.update(dt)
	if not Game.backgroundMusic:isPlaying() then
		Game.backgroundMusic:play()
	end
	Neon:update(dt)
	for _,v in ipairs(Game.balloonObjects) do
		v:update(dt)
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
		if Game.timePassed > (0.75 / Game.speedMultiplier) then
			Game.balloonObjects[#Game.balloonObjects + 1] = Balloon:new(Game)
			Game.timePassed = 0
		end
		Game.runTime = Game.runTime - dt
		if Game.runTime <= 0 then
			Game.inGame:disable()
			Game.gameOver:enable()
			Game.gameOver:child("endscore"):setText("Final Score: " .. Game.score)
		else
			if floor(Game.runTime) >= 10 then
				local t1, t2 = floor(Game.runTime / 60), floor(Game.runTime % 60)
				if t2 >= 10 then
					Game.inGame:child("timeLeft"):setText("TIME - " .. t1 .. ":" .. t2)
				else
					Game.inGame:child("timeLeft"):setText("TIME - " .. t1 .. ":0" .. t2)
				end
			else
				Game.inGame:child("timeLeft"):setText("TIME - 0:0" .. floor(Game.runTime))
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
		end
	end
end

function love.draw()
	if Game.gameOver.enabled then
		Game.gameOver:draw()
	end
	if Game.helpMenu.enabled then
		Game.helpMenu:draw()
	end
	if Game.mainMenu.enabled then
		Game.mainMenu:draw()
	end
	if Game.settingsMenu.enabled then
		Game.settingsMenu:draw()
	end
	if Game.inGame.enabled then
		lg.setColor(1,1,1,1)
		lg.draw(Game.inGameBG, 0, 0)
		table.sort(Game.balloonObjects, function(a,b) 
			if not a or not b then return false end 
			return a.z == b.z and (a.id == b.id and (a) or a.id > b.id) or a.z < b.z 
		end)
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
		return a.z == b.z and (a.id < b.id) or a.z > b.z 
	end)
	for _,v in ipairs(Game.balloonObjects) do
		if v.hovered and not v.shake then
			v:mousepressed(x, y, button, istouch, presses)
			break
		end
	end
	table.sort(Game.balloonObjects, function(a,b) 
		if not a or not b then return false end 
		return a.z == b.z and (a.id > b.id) or a.z < b.z 
	end)
end