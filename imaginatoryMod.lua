imaginatoryMod = {}

-- path & config
modDir = ''..SMODS.current_mod.path
--modConfig = ''..SMODS.current_mod.config

--Load visual assets
local sprite, loadError = SMODS.load_file("imaginatoryVisual.lua")
if loadError then
  sendDebugMessage (""..loadError)
else
  sprite()
end

--load jokers
local jokerFiles = NFS.getDirectoryItems(modDir.."jokers")

for _, file in ipairs(jokerFiles) do
	sendDebugMessage (""..file)
	local joker, loadError = SMODS.load_file("jokers/"..file)
	if loadError then
		sendDebugMessage (""..loadError)
	else
		local currentJoker = joker()
		if currentJoker.init then currentJoker:init() end
		
		if currentJoker.list and #currentJoker.list > 0 then
			for i, item in ipairs(currentJoker.list) do
			
				item.discovered = true
				
				if not item.key then
					item.key = item.name
				end
				if not item.config then
					item.config = {}
				end
				
				SMODS.Joker(item)
				sendTraceMessage(item.name)
			end
		end
	end
end	

--load boosters
local boosterFiles = NFS.getDirectoryItems(modDir.."boosters")

for _, file in ipairs(boosterFiles) do
  	local booster, loadError = SMODS.load_file("boosters/"..file)
  	if loadError then
  	  	sendDebugMessage (loadError)
  	else
  	  	local currentBooster = booster()
  	  	if currentBooster.init then currentBooster:init() end
		
  	  	for i, item in ipairs(currentBooster.list) do
  	  	  	SMODS.Booster(item)
		  	sendTraceMessage(item.name)
  	  	end
  	end
end

local enhancementFiles = NFS.getDirectoryItems(modDir.."enhancements")

for _, file in ipairs(enhancementFiles) do
	local enhancement, loadError = SMODS.load_file("enhancements/"..file)
	if loadError then
		sendDebugMessage(loadError)
	else
		local currentEnhancement = enhancement()
		
		for i, item in ipairs(currentEnhancement.list) do
			SMODS.Enhancement(item)
			sendTraceMessage(item.name)
		end
	end
end

local consumableTypeFiles = NFS.getDirectoryItems(modDir.."consumableTypes")

for _, file in ipairs(consumableTypeFiles) do
	local consumableType, loadError = SMODS.load_file("consumableTypes/"..file)
	if loadError then
		sendDebugMessage(loadError)
	else
		local currentConsumableType = consumableType()
		
		for i, item in ipairs(currentConsumableType.list) do
			SMODS.ConsumableType(item)
			sendTraceMessage(item.name)
		end
	end
end

local consumableFiles = NFS.getDirectoryItems(modDir.."consumables")

for _, file in ipairs(consumableFiles) do
	local consumable, loadError = SMODS.load_file("consumables/"..file)
	if loadError then
		sendDebugMessage(loadError)
	else
		local currentConsumable = consumable()
		
		for i, item in ipairs(currentConsumable.list) do
			SMODS.Consumable(item)
			sendTraceMessage(item.name)	
		end
	end
end

local soundFiles = NFS.getDirectoryItems(modDir.."soundLua")

for _, file in ipairs(soundFiles) do
	local soundFile, loadError = SMODS.load_file("soundLua/"..file)
	if loadError then
		sendDebugMessage(loadError)
	else
		local currentSound = soundFile()

		for i, item in ipairs(currentSound.list) do
			SMODS.Sound(item)
			sendTraceMessage(item.name)
		end
	end
end



function TransformCardInto(center_key, card, cardTable, transformTicks, ticksPerSecond, awaken) 
	if not transformTicks then transformTicks = 25 end
	if not ticksPerSecond then ticksPerSecond = 4 end

	play_sound('timpani')

	local areas = {}
	local cardsToTransform = {}
	for i = 1, #cardTable do
		cardsToTransform[i] = cardTable[i]
	end

	for k, v in ipairs(cardsToTransform) do
		v:flip()

		areas[#areas+1] = v.area
		if v.area then v.area:remove_card(v) end

		local cardTableStart = G.ROOM.T.x + G.ROOM.T.w/2 - v.T.w/2 - 0.5
		local padding = v.T.w / 2
		local cardStartOffset = ((padding / 2) * (#cardsToTransform - 1)) * 2
		v.T.x = (cardTableStart - cardStartOffset) + ((padding * 2) * (k-1))

		if (G.STATE >= G.STATES.TAROT_PACK) then
	 		v.T.y = G.ROOM.T.y + G.ROOM.T.h/2 - v.T.h/2 + 3.15
	 	else
	 		v.T.y = G.ROOM.T.y + G.ROOM.T.h/2 - v.T.h/2 - 1
	 	end
	end

	delay(1)

	local previousState = G.STATE
	G.STATE = G.STATES.PLAY_TAROT
	G.STATE_COMPLETE = false

	local firstPlay = true
	for i = 1, transformTicks do
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 1 / ticksPerSecond, func = function()
			local percent = ((i/5)/transformTicks)
			play_sound("card1", percent)

			for k, v in ipairs(cardsToTransform) do
 				v:juice_up(i / transformTicks, i / transformTicks)	

 				if i == transformTicks then
 					v:flip()
 					v:set_ability(G.P_CENTERS[center_key])

 					awaken.play(v, firstPlay, k)

					if firstPlay then firstPlay = false end
 				end
			end
		return true
		end, }))
	end

	G.E_MANAGER:add_event(Event({trigger = 'after', delay = 3, func = function()
		for k, v in ipairs(cardsToTransform) do
			areas[k]:emplace(v, nil, true)
		end

		return true
	end, }))

	-- for j = 1, #cardsToTransform do
	-- 	local highlighted = cardsToTransform[j]

	-- 	if highlighted then
	-- 		highlighted:flip()
			
	-- 		local area = highlighted.area
	-- 		if highlighted.area then highlighted.area:remove_card(highlighted) end

	-- 		if (G.STATE >= G.STATES.TAROT_PACK) then
	-- 			highlighted.T.x = G.ROOM.T.x + G.ROOM.T.w/2 - highlighted.T.w/2 - 0.75
	-- 			highlighted.T.y = G.ROOM.T.y + G.ROOM.T.h/2 - highlighted.T.h/2 + 3.15
	-- 		else
	-- 			highlighted.T.x = G.ROOM.T.x + G.ROOM.T.w/2 - highlighted.T.w/2 - 0.75
	-- 			highlighted.T.y = G.ROOM.T.y + G.ROOM.T.h/2 - highlighted.T.h/2 - 0.5
	-- 		end

	-- 		for i = 1, transformTicks do
	-- 			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 1 / ticksPerSecond, func = function()
	-- 				local percent = (i/5)/transformTicks
	-- 				play_sound("card1", percent)
	-- 				highlighted:juice_up(i / transformTicks, i / transformTicks)
					
	-- 				if i == transformTicks then
	-- 					highlighted:flip()
	-- 					highlighted:set_ability(G.P_CENTERS[center_key])
						
	-- 					awaken.play(highlighted)
	-- 				end

	-- 				return true
	-- 			end,
	-- 			}))
	-- 		end
	-- 		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 3, func = function()
	-- 			area:emplace(highlighted, nil, true)
	-- 			return true
	-- 		end, }))
	-- 	else
	-- 		break
	-- 	end
	-- end
	G.E_MANAGER:add_event(Event({ trigger = "after", delay = 0.4, func = function()
		G.hand:unhighlight_all()

		sendTraceMessage("reset state")
		G.STATE = previousState
		G.STATE_COMPLETE = false
		return true
	end }))
	delay (0.8)

	return true
end