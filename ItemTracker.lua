local Class = require "Class"
local ItemTracker = Class()

--[[The ItemTracker class is for managing the items the player has collected
--]]

-- initialize Item object
function Item:__init__(game, x, y)
	self.game = game
	self.collectedItems = {}
	self.uncollectedItems = {} --add items to collect!
end

function ItemTracker:getCollectedItems() {
	return self.collectedItems
}

function ItemTracker:getUncollectedItems() {
	return self.uncollectedItems
}

function ItemTracker:collect(item) {
	--removes the item from uncollected, adds to collected table
	for i,v in ipairs(self.uncollectedItems) {
		if v==item
			t[i] = nil
			table.insert(self.collectedItems, item)
			return
	}

	--if code reaches here, item was invalid. error?
}