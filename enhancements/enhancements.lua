local burntCard = {
    key = "burntCard",
    --slug = "burntCard",

    config = { chanceNumerator = 1, chanceDenominator = 2, xMult = 0.5},
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chanceNumerator, card.ability.chanceDenominator, card.ability.xMult } }
	end,

    discovered = true,
    atlas = "Enhancements",
    atlas_hc = "Enhancements",
    pos = { x = 0, y = 0 },
    effect = "Burnt Card",
    label = "Burnt Card",
    playing_card = true,
    always_scores = true,

    in_pool = function(self)
        return false
    end,

    update = function(self, card, dt)
        
    end,

    calculate = function(self, card, context, effect)
        if context.cardarea == G.play and not context.repetition and context.main_scoring
        and pseudorandom('burnt_xMult') < G.GAME.probabilities.normal / card.ability.chanceDenominator
         then
            return { x_mult = card.ability.xMult }
        end
    end
}

local dragonCard = {
    key = "dragonCard",

    config = { xMult = 0.5, totalXMult = 1, burntThisHand = 0, setEnhancements = true, hideEnhancements = true, playTransformationAnimation = false },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {
            set = "Other",
            key = "m_burntCard_tip",
            specific_vars = {
                G.P_CENTERS["m_imaginary_burntCard"].config.chanceNumerator,
                G.P_CENTERS["m_imaginary_burntCard"].config.chanceDenominator,
                G.P_CENTERS["m_imaginary_burntCard"].config.xMult,
            }
        }

		return { vars = { card.ability.xMult, card.ability.totalXMult } }
	end,

    discovered = true,
    atlas = "Enhancements",
    atlas_hc = "Enhancements",
    pos = { x = 1, y = 0 },
    effect = "Dragon Card",
    label = "Dragon Card",
    --playing_card = true,
    always_scores = true,

    no_suit = true,
    no_rank = true,
    replace_base_card = true,

    in_pool = function(self)
        return false
    end,

    update = function(self, card, dt) 
        if G.STATE == G.STATES.DRAW_TO_HAND and not card.ability.setEnhancements then   
            card.ability.setEnhancements = true
            card.ability.hideEnhancements = true
            card.ability.burntThisHand = 0
        end

        if G.STATE == G.STATES.HAND_PLAYED and #G.hand.highlighted == 0 then 
            local cardInHand = false

            for k, v in ipairs(G.play.cards) do
                if v.ability.name == "m_imaginary_dragonCard" and v ~= card then break end
                if v == card then
                    cardInHand = true
                    break
                end
            end

            if cardInHand then
                if card.ability.setEnhancements then
                    for k, v in ipairs(G.play.cards) do
                        if v.ability.name ~= "m_imaginary_dragonCard" and v.ability.name ~= "m_imaginary_burntCard" then
                            v.config.previousName = v.config.center_key

                            v:set_ability(G.P_CENTERS["m_imaginary_burntCard"]) 

                            card.ability.burntThisHand = card.ability.burntThisHand + 1
                        end
                    end

                    card.ability.totalXMult = card.ability.totalXMult + (card.ability.burntThisHand * card.ability.xMult)
                    card.ability.setEnhancements = false
                end
                if card.ability.hideEnhancements then
                    for k, v in ipairs(G.play.cards) do
                        if v.ability.name == "m_imaginary_burntCard" then
                            v:set_sprites(G.P_CENTERS[v.config.previousName], nil)

                            if (G.P_CENTERS[v.config.previousName].config.replace_base_card or v.config.previousName == "m_stone")
                             and v.children.front then v.children.front.VT.w = 0 end
                            -- add patch that stops front from rendering
                            v.dont_render_front = true
                        end
                    end
                end
            end
        end
    end,

    calculate = function(self, card, context, effect)   
        if context.before and context.cardarea == G.play then 
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                card:juice_up(1.5, 1.5)

                local fireParticles = {}

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
                    fireParticles[i]:fade(0.3, 1)
                end

                return true
            end, }))

            for k, v in pairs(context.full_hand) do
                if v.ability.name ~= "m_imaginary_dragonCard" then

                    local percent = 1.15 - (k - 0.999) / (#G.play.cards - 0.998) * 0.3
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        delay = 0.05,
                        func = function()    
                            v:flip()
                            play_sound("card1", percent)
                            v:juice_up(0.3, 0.3)
                            return true
                        end,
                    }))
                    local percent = 0.85 + (k - 0.999) / (#G.play.cards - 0.998) * 0.3
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        delay = 0.05,
                        func = function()
                            v:flip()

                            card.ability.hideEnhancements = false
                            v:set_sprites(G.P_CENTERS["m_imaginary_burntCard"])

                            play_sound("tarot2", percent)
                            v:juice_up(0.3, 0.3)
                            return true
                        end,
                    }))
                end
            end

            delay (0.5)

            return { message = "Burnt "..card.ability.burntThisHand..'!' }
        end

        if context.cardarea == G.play and context.main_scoring then
            return { x_mult = card.ability.totalXMult }
        end
    end,
}

local humanCard = {
    key = "humanCard",

    config = { chips = 30, humanMult = 7, werewolfMult = 0, transforming = false },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {
            set = "Other",
            key = "m_werewolfCard_tip",
            specific_vars = {
                G.P_CENTERS["m_imaginary_werewolfCard"].config.multScale
            }
        }

        return { vars = { card.ability.chips, card.ability.humanMult } }
    end,

    discovered = true,
    atlas = "Enhancements",
    atlas_hc = "Enhancements",
    pos = { x = 2, y = 0 },
    effect = "Human Card",
    label = "Human Card",
    always_scores = true,

    no_suit = true,
    no_rank = true,
    replace_base_card = true,

    in_pool = function(self)
        return false
    end,

    update = function(self, card, dt)   
        if G.STATE == G.STATES.SELECTING_HAND and G.GAME.blind and G.GAME.blind.boss and not card.ability.transforming then
            local humans = {}
            local werewolfMult = {}

            for k, v in ipairs(G.hand.cards) do
                if v.ability.name == "m_imaginary_humanCard" then
                    v.ability.transforming = true

                    humans[#humans+1] = v
                    werewolfMult[#werewolfMult+1] = v.ability.werewolfMult
                end
            end

            if #humans > 0 then

                TransformCardInto("m_imaginary_werewolfCard", card, humans, 25, 6, { play = function(card, playSound, index)
                    if playSound then
                        play_sound("imaginary_werewolfTransformation", 1, 0.5)
                    end

                    card.ability.werewolfMult = werewolfMult[index]

                    local eval = function() return card.area end
                    juice_card_until(card, eval, true)
                end })
            end
        end
    end,

    calculate = function(self, card, context, effect)
        if context.cardarea == G.play and context.main_scoring then
            return { chips = card.ability.chips, mult = card.ability.humanMult }
        end
    end
}

local werewolfCard = {
    key = "werewolfCard",

    config = { multScale = 12, werewolfMult = 0, consumed = 0, hasConsumed = false, transforming = false},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {
            set = "Other",
            key = "m_humanCard_tip",
            specific_vars = {
                G.P_CENTERS["m_imaginary_humanCard"].config.chips,
                G.P_CENTERS["m_imaginary_humanCard"].config.humanMult,
            }
        }

        return { vars = { card.ability.multScale, card.ability.werewolfMult } }
    end,

    discovered = true,
    atlas = "Enhancements",
    atlas_hc = "Enhancements",
    pos = { x = 3, y = 0 },
    effect = "Werewolf Card",
    label = "Werewolf Card",
    always_scores = true,

    no_suit = true,
    no_rank = true,
    replace_base_card = true,

    in_pool = function(self)
        return false
    end,

    update = function(self, card, dt) 
        --consume hearts
        if G.STATE == G.STATES.HAND_PLAYED and #G.hand.highlighted == 0 then 
            local cardInHand = false

            for k, v in ipairs(G.play.cards) do
                if v.ability.name == "m_imaginary_dragonCard" and v ~= card then break end
                if v == card then
                    cardInHand = true
                    break
                end
            end

            if cardInHand then
                if not card.ability.hasConsumed then
                    card.config.cardsToDestroy = {}
                    for k, v in ipairs(G.play.cards) do
                        if v:is_suit("Hearts", true) then   
                            card.config.cardsToDestroy[#card.config.cardsToDestroy+1] = v
                            card.ability.consumed = card.ability.consumed + 1

                            v:start_dissolve({G.C.RED, G.C.BLACK}, false)
                        end
                    end

                    card.ability.hasConsumed = true
                end
            end
        end

        --transform to human, reset hasConsumed
        if G.STATE == G.STATES.DRAW_TO_HAND then
            if card.ability.hasConsumed then
                card.ability.hasConsumed = false
            end

            if G.GAME.blind and not G.GAME.blind.boss and not card.ability.transforming and (#G.hand.cards >= G.hand.config.card_limit or #G.playing_cards <= 0) then
                local werewolves = {}
                local werewolfMult = {}

                for k, v in ipairs(G.hand.cards) do
                    if v.ability.name == "m_imaginary_werewolfCard" then
                        v.ability.transforming = true
    
                        werewolves[#werewolves+1] = v
                        werewolfMult[#werewolfMult+1] = v.ability.werewolfMult
                    end
                end
    
                if #werewolves > 0 then
                    TransformCardInto("m_imaginary_humanCard", card, werewolves, 10, 2, { play = function(card, playSound, index) 
                        if playSound then
                            --play_sound("imaginary_werewolfTransformation")
                        end
    
                        card.ability.werewolfMult = werewolfMult[index]

                        local eval = function() return card.area end
                        juice_card_until(card, eval, true)
                    end })
                end
            end
        end
    end,

    calculate = function(self, card, context, effect)
        if context.before and context.cardarea == G.play then 
            card.ability.werewolfMult = card.ability.werewolfMult + (card.ability.consumed * card.ability.multScale)

            return { colour = G.C.RED, message = "Ate "..card.ability.consumed..'!' }
        end

        if context.cardarea == G.play and context.main_scoring then
            card.ability.consumed = 0
            card.ability.cardsToDestroy = {}

            return { mult = card.ability.werewolfMult }
        end
    end
}

return {
    name = "EnhancementsFile",
    list = { burntCard, dragonCard, humanCard, werewolfCard }
}