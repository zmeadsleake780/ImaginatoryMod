

return {
	descriptions = {
		Enhanced = {
			m_imaginary_dragonCard = {
				name = "Dragon Card",
        		text = {
					"{C:diamonds}Burns{} all other played ",
					"cards but gains {X:mult,C:white} X#1#{} Mult",
					"for every card {C:diamonds}burnt{} this run",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{} {C:inactive}Mult){}"
        		}
			},
			m_imaginary_burntCard = {
				name = "Burnt Card",
				text = {
					"{C:green}#1# in #2#{} chance",
        			"to give {X:mult,C:white} X#3# {} Mult"
				}
			},
			m_imaginary_humanCard = {
				name = "Human? Card",
				text = {
					"Gives {C:chips}+#1#{} Chips and",
					"{C:mult}+#2#{} Mult when scored.",
					"{C:attention}Transforms{} into a {C:clubs}Werewolf{}",
					"when drawn during a {C:attention}Boss Blind{}",
					"{C:inactive}(Currently {}{C:mult}+#3# {}{C:inactive}Mult as Werewolf){}"
				}
			},
			m_imaginary_werewolfCard = {
				name = "Werewolf Card",
				text = {
					"{C:mult}Consumes{} all played {C:hearts}heart{} cards,",
					"gaining {C:mult}+#1#{} Mult for each card destroyed.",
					"Transforms into a {C:diamonds}Human{}",
					"when drawn during a {C:attention}Non-Boss Blind{}",
					"{C:inactive}(Currently {}{C:mult}+#2# {}{C:inactive}Mult){}"
				}
			}
		},
		ArtCard = {
			c_imaginary_dragon_art_card = {
				name = "DRAGON",
        		text = {
        		    "Select {C:attention}#1#{} card to",
        		    "become a {C:hearts}Dragon{}"
        		}
			},
			c_imaginary_human_art_card = {
				name = "Moon Rock",
				text = {
					"Select {C:attention}#1#{} cards to",
        		    "become a {C:attention}Human{C:inactive}...?{}"
				}
			}
		},
		Joker = {
			j_imaginary_paradise = {
				name = "Paradise",
				text = {
					"Apply {C:hearts}P{C:mult}o{C:diamonds}l{C:attention}y{C:money}c{C:green}h{C:planet}r{C:chips}o{C:spades}m{C:tarot}e{} to a random card",
					"held in hand if played hand contains",
					"at least one of every {C:attention}suit{}."
				}
			},
			j_imaginary_partyLuck = {
				name = "Party Luck",
				text = {
					"{C:attention}Lucky{} cards always {C:green}trigger{}",
					"if you have at least {C:attention}#1#{}",
					"{C:attention}Lucky{} cards in your full deck",
					"{C:inactive}(Currently {C:attention}#2#{C:inactive})",
				}
			},
		},
		Other = {
			m_dragon_tip = {
				name = "Dragon",
        		text = {
					"{C:diamonds}Burns{} all other played ",
					"cards but gains {X:mult,C:white} X#1#{} Mult",
					"for every card {C:diamonds}burnt{} this run"
        		}
			},
			m_burntCard_tip = {
				name = "Burnt",
				text = {
					"{C:green}#1# in #2#{} chance",
        			"to give {X:mult,C:white} X#3# {} Mult"
				}
			},
			m_humanCard_tip = {
				name = "Human?",
				text = {
					"Gives {C:chips}+#1#{} Chips and",
					"{C:mult}+#2#{} Mult when scored.",
					"{C:attention}Transforms{} into a {C:clubs}Werewolf{}",
					"when drawn during a {C:attention}Boss Blind{}"
				}
			},
			m_werewolfCard_tip = {
				name = "Werewolf",
				text = {
					"{C:mult}Consumes{} all played {C:hearts}heart{} cards,",
					"gaining {C:mult}+#1#{} Mult for each card destroyed.",
					"Transforms into a {C:diamonds}Human{}",
					"when drawn during a {C:attention}Non-Boss Blind{}"
				}
			}
		}
	},
	misc = {
		dictionary = {
			k_art_pack = "Art Pack",
			
			k_polychromed = "Polychromed!"
		}
	}
}