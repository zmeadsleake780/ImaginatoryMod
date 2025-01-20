local artCards = {
    key = "ArtCard",
    primary_colour = HEX("EDFFFE"),
    secondary_colour = HEX("AAB3B2"),
    loc_txt =  	{
        name = 'Art Card', -- used on card type badges
        collection = 'Art Cards', -- label for the button to access the collection
    },
    collection_row = {1, 2},
    shop_rate = 0.0,
    default = "c_dragon_art_card"
}

return {
    name = "Consumable Types",
    list = { artCards }
}