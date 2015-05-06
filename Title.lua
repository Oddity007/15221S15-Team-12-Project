local Class = require "Class"
local Title = Class()

--[[The Title class
--]]

-- initialize the Game
function Title:__init__()
	self.status = true
	self.charChosen = false

	self.camera = {position = {x = 0, y = 0}, scale = 1}

	self.bg = love.graphics.newImage("Assets/FairyForestBG.png")
	self.boy = love.graphics.newImage("Assets/CharacterSprites/BoyFront.png")
	self.girl = love.graphics.newImage("Assets/CharacterSprites/GirlFront.png")

end

function Title:onRender()
	width, height = love.graphics.getDimensions()
	bgScalew = width / 1440
	bgScaleh = height / 900
	titley = 80
	titlex = 10
	choosex = (width / 2) - 145
	choosey = (height / 2) + 45
	rectanglex = (width / 2) - 120
	rectangley = (height / 2) + 70
	rectanglew = 240
	rectangleh = 124
	offsetx = 10
	offsety = 40
	textSpacey = 18

	self.charactery = (height / 2) + 100
	self.girlx = (width / 2) - 94
	self.boyx = (width / 2) + 30

	love.graphics.draw(self.bg,0,0,0, bgScalew, bgScaleh)
	love.graphics.rectangle("fill", rectanglex, rectangley, rectanglew, rectangleh)
	love.graphics.draw(self.boy, self.boyx, self.charactery)
	love.graphics.draw(self.girl, self.girlx, self.charactery)
	love.graphics.setFont(love.graphics.newFont(40))
	love.graphics.print("ExtendableGame", titlex, titley)
	love.graphics.setFont(love.graphics.newFont(18))
	love.graphics.print("You are a child.", titlex + offsetx, titley + offsety)
	offsety = offsety + textSpacey
	love.graphics.print("Your toys are stolen by the fairies that live in the forest behind your house!", titlex + offsetx, titley + offsety)
	offsety = offsety + textSpacey
	love.graphics.print("Get as many back as you can before it gets dark!", titlex + offsetx, titley + offsety)
	offsety = offsety + textSpacey
	love.graphics.print("Here are some useful tips:", titlex + offsetx, titley + offsety)
	offsety = offsety + textSpacey
	offsetx = offsetx + 15
	love.graphics.print("- Use cannons to launch yourself to move faster", titlex + offsetx, titley + offsety)
	offsety = offsety + textSpacey
	love.graphics.print("- Collect flowers for extra points", titlex + offsetx, titley + offsety)
	offsety = offsety + textSpacey
	love.graphics.print("- Change the amount of time you have left with clocks", titlex + offsetx, titley + offsety)
	offsety = offsety + textSpacey
	offsetx = offsetx - 15
	love.graphics.print("Some fairies will want to help you, others will not...", titlex + offsetx, titley + offsety)
	offsety = offsety + textSpacey
	love.graphics.print("Watch their colors to see whether they will help or hinder you.", titlex + offsetx, titley + offsety)
	offsety = offsety + textSpacey
	love.graphics.print("Choose your character to begin.", choosex, choosey)

end


-- update everything in the game (called each update loop)
function Title:onUpdate(seconds)

end

-- process mouse clicks
function Title:onMousePress(mouseX, mouseY, button)
	if mouseY > self.charactery and mouseY < self.charactery + 64 then
		if mouseX > self.girlx and mouseX < self.girlx + 64 then
			self.character = 1
			self.status = false
		elseif mouseX > self.boyx and mouseX < self.boyx + 64 then
			self.character = 2
			self.status = false
		end
	end

end

-- Nothing Happens
function Title:onKeyPress(key)

end

return Title
