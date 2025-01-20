local paradise = { 
	key = "paradise",

	loc_txt = {
		name = "Paradise",
		text = {
			"Apply {C:hearts}P{C:mult}o{C:diamonds}l{C:attention}y{C:money}c{C:green}h{C:planet}r{C:chips}o{C:spades}m{C:tarot}e{} to a random card held in hand",
			"if played hand contains at least one of every {C:attention}suit{}."
		}
	},
	config = { },
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	
	pos = { x = 0, y = 0 },
	rarity = 1, 
	cost = 5, 
	atlas = "ImaginedJokers",
	blueprint_compat = true,
	
	calculate = function(self, card, context) 
		-- if context.individual and context.cardarea == G.play then 
		-- 	return {
		-- 		x_mult = 2,
		-- 		card = self
		-- 	}
		-- end
		if context.after and #context.scoring_hand >= 4 then
			local suits = {
				['Hearts'] = 0,
				['Diamonds'] = 0,
				['Spades'] = 0,
				['Clubs'] = 0
			}
			for i = 1, #context.scoring_hand do
				if context.scoring_hand[i].ability.name ~= 'Wild Card' then
					if context.scoring_hand[i]:is_suit('Hearts', true) and suits["Hearts"] == 0 then suits["Hearts"] = suits["Hearts"] + 1
					elseif context.scoring_hand[i]:is_suit('Diamonds', true) and suits["Diamonds"] == 0  then suits["Diamonds"] = suits["Diamonds"] + 1
					elseif context.scoring_hand[i]:is_suit('Spades', true) and suits["Spades"] == 0  then suits["Spades"] = suits["Spades"] + 1
					elseif context.scoring_hand[i]:is_suit('Clubs', true) and suits["Clubs"] == 0  then suits["Clubs"] = suits["Clubs"] + 1 end
				end
			end
			for i = 1, #context.scoring_hand do
				if context.scoring_hand[i].ability.name == 'Wild Card' then
					if context.scoring_hand[i]:is_suit('Hearts') and suits["Hearts"] == 0 then suits["Hearts"] = suits["Hearts"] + 1
					elseif context.scoring_hand[i]:is_suit('Diamonds') and suits["Diamonds"] == 0  then suits["Diamonds"] = suits["Diamonds"] + 1
					elseif context.scoring_hand[i]:is_suit('Spades') and suits["Spades"] == 0  then suits["Spades"] = suits["Spades"] + 1
					elseif context.scoring_hand[i]:is_suit('Clubs') and suits["Clubs"] == 0  then suits["Clubs"] = suits["Clubs"] + 1 end
				end
			end
			if suits["Hearts"] > 0 and suits["Diamonds"] > 0 and suits["Spades"] > 0 and suits["Clubs"] > 0 then
				local nDelay = 0.4
				if context.blueprint then nDelay = 0.5 end

				local eligibleCardsInHand = {}

				for k, v in ipairs(G.hand.cards) do
					if v.edition == nil then eligibleCardsInHand[#eligibleCardsInHand+1] = v end
				end

				G.E_MANAGER:add_event(Event({trigger = 'after', delay = nDelay, func = function()
					for k, v in ipairs(G.hand.cards) do
						if v.edition == nil then eligibleCardsInHand[#eligibleCardsInHand+1] = v end
					end
				
					--sendTraceMessage(#eligibleCardsInHand..", "..card.ability.name)
					if #eligibleCardsInHand > 0 then 
				
						local randomCard = {}
						randomCard = pseudorandom_element(eligibleCardsInHand, pseudoseed('paradise'))

						if randomCard then randomCard:set_edition('e_polychrome', true) end

						card:juice_up(0.3, 0.3)
						card.message = localize('k_polychromed')
					end

					return true
					
				end }))
			
			if #eligibleCardsInHand > 0 then
				return {
					message = localize('k_polychromed')
				}	
			end
			end
		end
	end
}

local partyLuck = {
	key = "partyLuck",

	loc_txt = {
		name = "Party Luck",
		text = {
			"{C:attention}Lucky{} cards always {C:green}trigger{}",
			"if you have at least {C:attention}#1#{}",
			"{C:attention}Lucky{} cards in your full deck",
			"{C:inactive}(Currently {C:attention}#2#{C:inactive})",
		}
	},

	config = { activeCount = 21 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.activeCount, card.ability.luckyTally or '0' } }
	end,

	pos = { x = 3, y = 0 },
	rarity = 2, 
	cost = 6, 
	atlas = "ImaginedJokers",
	blueprint_compat = false,

	calculate = function(self, card, context) 
		if context.before then
			card.ability.luckyTally = 0
            for k, v in pairs(G.playing_cards) do
                if v.config.center == G.P_CENTERS.m_lucky then card.ability.luckyTally = card.ability.luckyTally + 1 end
            end
		end

		if context.individual and context.cardarea == G.play then 
			if context.other_card.config.center == G.P_CENTERS.m_lucky and card.ability.luckyTally >= card.ability.activeCount
			and not context.other_card.debuff and not context.blueprint then 
				if not context.other_card.lucky_trigger then
					return {
						mult = G.P_CENTERS.m_lucky.config.mult,
						dollars = G.P_CENTERS.m_lucky.config.p_dollars,
						card = context.other_card,
					}
				elseif context.other_card.ability.mult < 20 then
					return {
						mult = G.P_CENTERS.m_lucky.config.mult,
						card = context.other_card,
					}
				elseif context.other_card.ability.dollars == nil then
					return {
						dollars = G.P_CENTERS.m_lucky.config.p_dollars,
						card = context.other_card,
					}
				end
			end
		end
	end
}

return {
	name = "Jokers Row 1",
	
	list = { paradise, partyLuck }
}