local Class = require "Class"
local ItemTracker = Class()
local Item = require "Item"

--[[The ItemTracker class is for managing the items the player has collected
--]]

-- initialize ItemTracker object
function ItemTracker:__init__(game)
	self.game = game
	self.itemNames = {
		"BaseballBatAndBall",
		"Boomerang",
		"EzelAndPaintbrush",
		"Gameboy",
		"Pillow",
		"SoccerBall",
		"StuffedBear",
		"StuffedCat",
		"StuffedDog",
		"StuffedRabbit",
		"ToyDinosaur",
		"ToyRobot",
		"ToyTrain",
		"Xylophone"
	}
	self.collectedItems = {}
	self.uncollectedItems = {}
	self.allItems = {}
	
	for k,v in pairs(self.itemNames) do
		local thisItem = Item(game, 0, 0, v)
		table.insert(self.allItems, thisItem)
		table.insert(self.uncollectedItems, thisItem)
	end
end

function ItemTracker:getAllItems()
	return self.allItems
end

function ItemTracker:getCollectedItems()
	return self.collectedItems
end

function ItemTracker:getUncollectedItems() 
	return self.uncollectedItems
end

function ItemTracker:collect(item)
	--removes the item from uncollected, adds to collected table
	for i,v in ipairs(self.uncollectedItems) do
		if v==item then
			t[i] = nil
			table.insert(self.collectedItems, item)
			return
		end
	end

	--if code reaches here, item was invalid. error?
end

return ItemTracker