local dragonArtCard = {
    name = "dragon",
    key = "dragon_art_card",

    set = "ArtCard",

    display_size = { w = 75, h = 83 },

    config = { max_highlighted = 1, mod_conv = 'm_dragon_tip', skipTransformAnimation = false },
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {
            set = "Other",
            key = "m_dragon_tip",
            specific_vars = {
                G.P_CENTERS["m_imaginary_dragonCard"].config.xMult,
            }
        }
        info_queue[#info_queue+1] = {
            set = "Other",
            key = "m_burntCard_tip",
            specific_vars = {
                G.P_CENTERS["m_imaginary_burntCard"].config.chanceNumerator,
                G.P_CENTERS["m_imaginary_burntCard"].config.chanceDenominator,
                G.P_CENTERS["m_imaginary_burntCard"].config.xMult,
            }
        }

		return {vars = {card.ability.max_highlighted}}  
	end,

    -- loc_txt = {
    --     name = "DRAGON",
    --     text = {
    --         "Select {C:attention}#1#{} card to",
    --         "become a {C:hearts}Dragon{}"
    --     }
    -- },

    pos = { x = 0, y = 0 },
    atlas = "ArtCards",
    cost = 3,
    unlocked = true,
    discovered = true,

    can_use = function(self, card)  
        return #G.hand.highlighted == 1 and
        G.hand.highlighted[1].ability.name ~= "m_imaginary_dragonCard"
    end,

    use = function(self, card, area, copier)
        card:start_dissolve(nil, nil)

        --card.config.skipTransformAnimation = true
        if not card.config.skipTransformAnimation then
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            TransformCardInto("m_imaginary_dragonCard", card, G.hand.highlighted, 25, 4, { play = function(card) 
				local fireParticles = {}

				play_sound("imaginary_dragonScreech")
				play_sound("imaginary_dragonFlame")
			
				for i = 1, 4 do
					fireParticles[i] = Particles(1, 1, 0, 0, {
						timer = 0.015,
						scale = 0.3 * i,
						initialize = true,
						lifespan = 1,
						speed = 4 * i,
						padding = -1,
						attach = card,
						colours = {G.C.WHITE, lighten(G.C.ORANGE, 0.4), lighten(G.C.RED, 0.2), lighten(G.C.YELLOW, 0.2)},
						fill = true
					})
				end 
				for i = 1, #fireParticles do
					fireParticles[i].fade_alpha = 0
					fireParticles[i]:fade(0.5, 1)
				end
			
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
					for i = 1, #fireParticles do
						fireParticles[i]:remove()
					end
			
					return true
				end, }))
            end })

            return true
        end }))
    else 
        for i = 1, card.ability.max_highlighted do
            local highlighted = G.hand.highlighted[i]
            highlighted:set_ability(G.P_CENTERS["m_imaginary_dragonCard"])
        end
    end
        delay(0.6)
    end
}

local humanArtCard = {
    name = "dragon",
    key = "human_art_card",

    set = "ArtCard",

    display_size = { w = 75, h = 83 },

    config = { max_highlighted = 2, mod_conv = 'm_werewolf_tip', skipTransformAnimation = false },
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {
            set = "Other",
            key = "m_humanCard_tip",
            specific_vars = {
                G.P_CENTERS["m_imaginary_humanCard"].config.chips,
                G.P_CENTERS["m_imaginary_humanCard"].config.humanMult,
            }
        }
        info_queue[#info_queue+1] = {
            set = "Other",
            key = "m_werewolfCard_tip",
            specific_vars = {
                G.P_CENTERS["m_imaginary_werewolfCard"].config.totalMult
            }
        }

		return {vars = { card.ability.max_highlighted }}  
	end,

    pos = { x = 1, y = 0 },
    atlas = "ArtCards",
    cost = 3,
    unlocked = true,
    discovered = true,

    can_use = function(self, card)  
        if #G.hand.highlighted <= card.ability.max_highlighted and #G.hand.highlighted > 0 then
            for k, v in ipairs(G.hand.highlighted) do
                if v.ability.name == "m_imaginary_humanCard" or v.ability.name == "m_imaginary_werewolfCard" then
                    return false
                end
            end
        else return false end

        return true
    end,

    use = function(self, card, area, copier)
        card:start_dissolve(nil, nil)

        --card.config.skipTransformAnimation = true
        if not card.config.skipTransformAnimation then
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            TransformCardInto("m_imaginary_humanCard", card, G.hand.highlighted, 10, 2, { play = function(card) 
                
            end })

            return true
        end }))
        end 
    end
}

return {
	name = "ArtCardConsumables",
	
	list = { dragonArtCard, humanArtCard }
}