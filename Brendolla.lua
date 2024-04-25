local internalNpcName = "Brendolla"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1783,
	lookHead = 58,
	lookBody = 17,
	lookLegs = 17,
	lookFeet = 114,
	lookAddons = 2,
}

npcConfig.flags = {
	floorchange = false,
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

local itemsTable = {
	["life"] = {
		{ itemName = "vampire teeth", clientId = 9685, buy = 500 },
		{ itemName = "bloody pincers", clientId = 9633, buy = 2500 },
		{ itemName = "piece of dead brain", clientId = 9663, buy = 12500 },		
	},
	["mana"] = {
		{ itemName = "rope belt", clientId = 11492, buy = 500 },
		{ itemName = "silencer claw", clientId = 20200, buy = 2500 },
		{ itemName = "grimeleech wing", clientId = 22730, buy = 12500 },
	},
	["critical"] = {
		{ itemName = "protective charm", clientId = 11444, buy = 500 },
		{ itemName = "sabretooth", clientId = 10311, buy = 2500 },
		{ itemName = "vexclaw talon", clientId = 22728, buy = 12500 },
	},
	["fire"] = {
		{ itemName = "green dragon leather", clientId = 5877, buy = 500 },
		{ itemName = "blazing bone", clientId = 16131, buy = 2500 },
		{ itemName = "draken sulphur", clientId = 11658, buy = 12500 },		
	},
	["ice"] = {
		{ itemName = "winter wolf fur", clientId = 10295, buy = 500 },
		{ itemName = "thick fur", clientId = 10307, buy = 2500 },
		{ itemName = "deepling warts", clientId = 14012, buy = 12500 },		
	},
	["earth"] = {
		{ itemName = "piece of swampling wood", clientId = 17823, buy = 500 },
		{ itemName = "snake skin", clientId = 9694, buy = 2500 },
		{ itemName = "brimstone fangs", clientId = 11702, buy = 12500 },	
	},
	["energy"] = {
		{ itemName = "wyvern talisman", clientId = 9644, buy = 500 },
		{ itemName = "crawler head", clientId = 14079, buy = 2500 },
		{ itemName = "wyrm scale", clientId = 9665, buy = 12500 },	
	},
	["holy"] = {
		{ itemName = "cultish robe", clientId = 9639, buy = 500 },
		{ itemName = "cultish mask", clientId = 9638, buy = 2500 },
		{ itemName = "hellspawn tail", clientId = 10304, buy = 12500 },	
	},
	["death"] = {
		{ itemName = "flask of embalming", clientId = 11466, buy = 500 },
		{ itemName = "gloom wolf fur", clientId = 22007, buy = 2500 },
		{ itemName = "mystical hourglass", clientId = 9660, buy = 12500 },	
	},	
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local formattedCategoryNames = {}
	for categoryName, _ in pairs(itemsTable) do
		table.insert(formattedCategoryNames, "{" .. categoryName .. "}")
	end

	local categoryTable = itemsTable[message:lower()]

	if categoryTable then
		npcHandler:say("Aqui, dê uma olhada...", npc, player)
		npc:openShopWindowTable(player, categoryTable)
	end
	return true
end

local function onTradeRequest(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	npcHandler:say("Eu vendo imbuements de {life}, {mana} e {critical}. Também as proteções de {fire}, {ice}, {earth}, {energy}, {holy} e {death}.", npc, creature)
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Todo mundo aqui é doido! Fale {trade} e tente ser alguém normal.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Vejo você em breve!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Hey! Vai me deixar falando sozinha?!")

npcHandler:setCallback(CALLBACK_ON_TRADE_REQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end

npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end

npcType.onCheckItem = function(npc, player, clientId, subType) end
npcType:register(npcConfig)
