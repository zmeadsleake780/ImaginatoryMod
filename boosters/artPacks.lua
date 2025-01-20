local createArtCard = function(self, card)
	return create_card("ArtCard", G.pack_cards, nil, nil, true, true, nil, nil)
end

local pack1 = {
	key = "artPackNormal1",

	loc_txt = {
		name = "Art Pack",
		group_name = "Art Pack",
		text = {
			"Choose 1 of 3 Art cards to modify your deck"
		}
	},

	atlas = "ArtBoosters",
	kind = "Art",
	pos = { x = 0, y = 0 },
	config = { extra = 1, choose = 1},
	cost = 4,
	order = 1,
	weight = 1,
	draw_hand = true,
	unlocked = true,
	discovered = true,
	create_card = function(self, card)
    	return createArtCard(self, card)
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
	group_key = "k_art_pack",
}

return {
	name = "Art Packs",
	list = { pack1 }
}