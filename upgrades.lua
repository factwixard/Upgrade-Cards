--Heya! Glad you decided to try and look through this. If you're here to try and bug fix (or to base some of your code off of mine), feel free to take a look around! I'll make sure to note what stuff does when applicable (barring any extremely obvious things that one could glean by looking at the SMODS wiki).
--Not much to note until after atlases
SMODS.Atlas({
	key = 'modicon',
	path = 'upgrd.png',
	px = 32,
	py = 32,
})
SMODS.Atlas({
	key = 'upgrdtag',
	path = 'upgrd.png',
	px = 32,
	py = 32,
})
SMODS.Atlas({
	key = 'upgradecards',
	path = 'upgrdcards.png',
	px = 71,
	py = 95,
})
SMODS.UndiscoveredSprite({ --This creates the undiscovered sprite for the consumabletype. I *think* the key is supposed to be the same as the type. Considering I can't find it handled anywhere else, that's probably the case.
	key = 'upgrd_upgrade',
	atlas = 'upgradecards',
	path = 'upgrdcards.png',
	pos = { x = 2, y = 2 },
	px = 71,
	py = 95,
})
SMODS.Atlas({
	key = 'upgradepacks',
	path = 'upgrdpacks.png',
	px = 71,
	py = 95,
})
G.C.UPGRD = { --Custom colors attached to the mod, can be more depending on how many custom colors you want
	UPGRADE = HEX("9b3b4a"),
}
local loc_colour_ref = loc_colour --Thank Joyousspring for this stuff
function loc_colour(_c, _default)
	if not G.ARGS.LOC_COLOURS then
		loc_colour_ref()
	end
	G.ARGS.LOC_COLOURS.upgrd_upgrade = G.C.UPGRD.UPGRADE
	return loc_colour_ref(_c, _default)
end
SMODS.ConsumableType { --.misc.dictionary.b_upgrd_upgrade_cards defines the name put on the button in collection, other than that make a label entry for the comsumabletype
	key = 'upgrd_upgrade', --putting your modprefix here helps if there may pootentially be some other mod with the same name for a consumable type
	primary_colour = HEX("c75062"),
	secondary_colour = HEX("9b3b4a"), --idk what exactly this is for unless its for the "shadow" on the label
	shop_rate = 1.5, --less than vanillaremades tarot cards
	collection_rows = { 5, 6 } --got this from vanillaremade, could change it but it looks fine as is
}
SMODS.Consumable {
	key = 'chippi',
	set = 'upgrd_upgrade',
	atlas = 'upgradecards',
	pos = { x = 0, y = 0 },
	config = { max_highlighted = 3, extra = { bonus = 20 } }, --max_highighted here and beyond dictates how many cards you can highlight up to and makes it so you don't need a can_use'
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.max_highlighted, card.ability.extra.bonus } }
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({ --shake the card when used
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.highlighted do --flip the cards
			local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound('card1', percent)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end
			}))
		end
		delay(0.2)
		for i = 1, #G.hand.highlighted do --upgrade the cards
			G.hand.highlighted[i].ability.perma_bonus = G.hand.highlighted[i].ability.perma_bonus or 0
			G.hand.highlighted[i].ability.perma_bonus = G.hand.highlighted[i].ability.perma_bonus + card.ability.extra.bonus
		end
		for i = 1, #G.hand.highlighted do --unflip the cards
			local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound('tarot2', percent, 0.6)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end
			}))
		end
		G.E_MANAGER:add_event(Event({ --unhighlight to end the sequence
			trigger = 'after',
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all()
				return true
			end
		}))
		delay(0.5)
	end
}
SMODS.Consumable {
	key = 'multy',
	set = 'upgrd_upgrade',
	atlas = 'upgradecards',
	pos = { x = 1, y = 0 },
	config = { max_highlighted = 3, extra = { mult = 4 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.max_highlighted, card.ability.extra.mult } }
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.highlighted do
			local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound('card1', percent)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end
			}))
		end
		delay(0.2)
		for i = 1, #G.hand.highlighted do
			G.hand.highlighted[i].ability.perma_mult = G.hand.highlighted[i].ability.perma_mult or 0
			G.hand.highlighted[i].ability.perma_mult = G.hand.highlighted[i].ability.perma_mult + card.ability.extra.mult
		end
		for i = 1, #G.hand.highlighted do
			local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound('tarot2', percent, 0.6)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end
			}))
		end
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all()
				return true
			end
		}))
		delay(0.5)
	end
}
SMODS.Consumable {
	key = 'chipliply',
	set = 'upgrd_upgrade',
	atlas = 'upgradecards',
	pos = { x = 2, y = 0 },
	config = { max_highlighted = 3, extra = { xchips = 0.5 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.max_highlighted, card.ability.extra.xchips } }
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.highlighted do
			local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound('card1', percent)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end
			}))
		end
		delay(0.2)
		for i = 1, #G.hand.highlighted do
			G.hand.highlighted[i].ability.perma_x_chips = G.hand.highlighted[i].ability.perma_x_chips or 0 --yes the bonus here starts at 0 on all playing cards, same with xmult
			G.hand.highlighted[i].ability.perma_x_chips = G.hand.highlighted[i].ability.perma_x_chips + card.ability.extra.xchips
		end
		for i = 1, #G.hand.highlighted do
			local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound('tarot2', percent, 0.6)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end
			}))
		end
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all()
				return true
			end
		}))
		delay(0.5)
	end
}
SMODS.Consumable {
	key = 'multiplicate',
	set = 'upgrd_upgrade',
	atlas = 'upgradecards',
	pos = { x = 3, y = 0 },
	config = { max_highlighted = 3, extra = { xmult = 0.5 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.max_highlighted, card.ability.extra.xmult } }
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.highlighted do
			local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound('card1', percent)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end
			}))
		end
		delay(0.2)
		for i = 1, #G.hand.highlighted do
			G.hand.highlighted[i].ability.perma_x_mult = G.hand.highlighted[i].ability.perma_x_mult or 0
			G.hand.highlighted[i].ability.perma_x_mult = G.hand.highlighted[i].ability.perma_x_mult + card.ability.extra.xmult
		end
		for i = 1, #G.hand.highlighted do
			local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound('tarot2', percent, 0.6)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end
			}))
		end
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all()
				return true
			end
		}))
		delay(0.5)
	end
}
SMODS.Consumable {
	key = 'dollarify',
	set = 'upgrd_upgrade',
	atlas = 'upgradecards',
	pos = { x = 4, y = 0 },
	config = { max_highlighted = 3, extra = { dollars = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.max_highlighted, card.ability.extra.dollars } }
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.highlighted do
			local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound('card1', percent)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end
			}))
		end
		delay(0.2)
		for i = 1, #G.hand.highlighted do
			G.hand.highlighted[i].ability.perma_p_dollars = G.hand.highlighted[i].ability.perma_p_dollars or 0
			G.hand.highlighted[i].ability.perma_p_dollars = G.hand.highlighted[i].ability.perma_p_dollars + card.ability.extra.dollars
		end
		for i = 1, #G.hand.highlighted do
			local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound('tarot2', percent, 0.6)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end
			}))
		end
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all()
				return true
			end
		}))
		delay(0.5)
	end
}
SMODS.Consumable {
	key = 'handimate',
	set = 'upgrd_upgrade',
	atlas = 'upgradecards',
	pos = { x = 5, y = 0 },
	config = { max_highlighted = 2, extra = { chips = 15, mult = 2, xchips = 0.25, xmult = 0.25, dollars = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.max_highlighted, card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.xchips, card.ability.extra.xmult, card.ability.extra.dollars } }
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.highlighted do
			local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound('card1', percent)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end
			}))
		end
		delay(0.2)
		for i = 1, #G.hand.highlighted do
			G.hand.highlighted[i].ability.perma_h_chips = G.hand.highlighted[i].ability.perma_h_chips or 0
			G.hand.highlighted[i].ability.perma_h_chips = G.hand.highlighted[i].ability.perma_h_chips + card.ability.extra.chips
			G.hand.highlighted[i].ability.perma_h_mult = G.hand.highlighted[i].ability.perma_h_mult or 0
			G.hand.highlighted[i].ability.perma_h_mult = G.hand.highlighted[i].ability.perma_h_mult + card.ability.extra.mult
			G.hand.highlighted[i].ability.perma_h_x_chips = G.hand.highlighted[i].ability.perma_h_x_chips or 0
			G.hand.highlighted[i].ability.perma_h_x_chips = G.hand.highlighted[i].ability.perma_h_x_chips + card.ability.extra.xchips
			G.hand.highlighted[i].ability.perma_h_x_mult = G.hand.highlighted[i].ability.perma_h_x_mult or 0
			G.hand.highlighted[i].ability.perma_h_x_mult = G.hand.highlighted[i].ability.perma_h_x_mult + card.ability.extra.xmult
			G.hand.highlighted[i].ability.perma_h_dollars = G.hand.highlighted[i].ability.perma_h_dollars or 0
			G.hand.highlighted[i].ability.perma_h_dollars = G.hand.highlighted[i].ability.perma_h_dollars + card.ability.extra.dollars
		end
		for i = 1, #G.hand.highlighted do
			local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound('tarot2', percent, 0.6)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end
			}))
		end
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all()
				return true
			end
		}))
		delay(0.5)
	end
}
SMODS.Consumable {
	key = 'finalize',
	set = 'Spectral', --only Spectral card in this mod
	atlas = 'upgradecards',
	pos = { x = 6, y = 0 },
	soul_pos = { x = 7, y = 0 },
	hidden = true,
	soul_set = 'upgrd_upgrade', --will occasionally replace upgrade cards in pack
	soul_rate = 0.003, --rate at which it will replace upgrade cards
	config = { max_highlighted = 2, extra = { chips = 40, mult = 8, xchips = 1, xmult = 1, dollars = 4 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.max_highlighted, card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.xchips, card.ability.extra.xmult, card.ability.extra.dollars } }
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.highlighted do
			local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound('card1', percent)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end
			}))
		end
		delay(0.2)
		for i = 1, #G.hand.highlighted do
			G.hand.highlighted[i].ability.perma_bonus = G.hand.highlighted[i].ability.perma_bonus or 0
			G.hand.highlighted[i].ability.perma_bonus = G.hand.highlighted[i].ability.perma_bonus + card.ability.extra.chips
			G.hand.highlighted[i].ability.perma_mult = G.hand.highlighted[i].ability.perma_mult or 0
			G.hand.highlighted[i].ability.perma_mult = G.hand.highlighted[i].ability.perma_mult + card.ability.extra.mult
			G.hand.highlighted[i].ability.perma_x_chips = G.hand.highlighted[i].ability.perma_x_chips or 0
			G.hand.highlighted[i].ability.perma_x_chips = G.hand.highlighted[i].ability.perma_x_chips + card.ability.extra.xchips
			G.hand.highlighted[i].ability.perma_x_mult = G.hand.highlighted[i].ability.perma_x_mult or 0
			G.hand.highlighted[i].ability.perma_x_mult = G.hand.highlighted[i].ability.perma_x_mult + card.ability.extra.xmult
			G.hand.highlighted[i].ability.perma_p_dollars = G.hand.highlighted[i].ability.perma_p_dollars or 0
			G.hand.highlighted[i].ability.perma_p_dollars = G.hand.highlighted[i].ability.perma_p_dollars + card.ability.extra.dollars
		end
		for i = 1, #G.hand.highlighted do
			local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound('tarot2', percent, 0.6)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end
			}))
		end
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all()
				return true
			end
		}))
		delay(0.5)
	end
}
SMODS.Consumable {
	key = 'planetrical',
	set = 'upgrd_upgrade',
	atlas = 'upgradecards',
	pos = { x = 0, y = 1 },
	config = { extra = { effect = 2 } },
	use = function(self, card, area, copier)
		for k, v in pairs(G.GAME.hands) do --upgrades all hands
			v.l_mult = v.l_mult * card.ability.extra.effect
			v.l_chips = v.l_chips * card.ability.extra.effect
		end
		play_sound(tarot1)
	end,
	can_use = function(self, card) --needs to be set manually but since this doesnt affect playing cards it can be used at any time
		return true
	end
}
SMODS.Consumable {
	key = 'levelevel',
	set = 'upgrd_upgrade',
	atlas = 'upgradecards',
	pos = { x = 1, y = 1 },
	config = { extra = { effect = 4 } },
	use = function(self, card, area, copier)
		local _handname, _played, _order = 'High Card', -1, 100 --checks for most played hand (does not work when all are 0)
			for k, v in pairs(G.GAME.hands) do
				if v.played > _played or (v.played == _played and _order > v.order) then
					_played = v.played
					_handname = k
				end
			end
		G.GAME.hands[_handname].l_mult = G.GAME.hands[_handname].l_mult * card.ability.extra.effect --upgrades most played hand
		G.GAME.hands[_handname].l_chips = G.GAME.hands[_handname].l_chips * card.ability.extra.effect
		play_sound(tarot1)
	end,
	can_use = function(self, card)
		return true
	end
}
SMODS.Consumable {
	key = 'swordity',
	set = 'upgrd_upgrade',
	atlas = 'upgradecards',
	pos = { x = 2, y = 1 },
	config = { extra = { bonus = 25 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.bonus } }
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.cards do --flip cards in hand
			local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if G.hand.cards[i]:is_suit('Spades') then --check for suit
						G.hand.cards[i]:flip()
						play_sound('card1', percent)
						G.hand.cards[i]:juice_up(0.3, 0.3)
					end
					return true
				end
			}))
		end
		delay(0.2)
		for i = 1, #G.playing_cards do --this one runs through the whole deck
			if G.playing_cards[i]:is_suit('Spades') then --check for spades in full deck, then upgrade spades
				G.playing_cards[i].ability.perma_bonus = G.playing_cards[i].ability.perma_bonus or 0
				G.playing_cards[i].ability.perma_bonus = G.playing_cards[i].ability.perma_bonus + card.ability.extra.bonus
			end
		end
		for i = 1, #G.hand.cards do --unflip cards in hand
			local percent = 0.85 + (i - 0.999) / (#G.playing_cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if G.hand.cards[i]:is_suit('Spades') then --check for suit
						G.hand.cards[i]:flip()
						play_sound('tarot2', percent, 0.6)
						G.hand.cards[i]:juice_up(0.3, 0.3)
					end
					return true
				end
			}))
		end
		delay(0.5)
	end,
	can_use = function(self, card) --only able to be used if cards are present
		return G.hand and  #G.hand.cards > 0
	end
}
SMODS.Consumable {
	key = 'coinraliry',
	set = 'upgrd_upgrade',
	atlas = 'upgradecards',
	pos = { x = 3, y = 1 },
	config = { extra = { bonus = 25 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.bonus } }
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.cards do
			local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if G.hand.cards[i]:is_suit('Diamonds') then
						G.hand.cards[i]:flip()
						play_sound('card1', percent)
						G.hand.cards[i]:juice_up(0.3, 0.3)
					end
					return true
				end
			}))
		end
		delay(0.2)
		for i = 1, #G.playing_cards do
			if G.playing_cards[i]:is_suit('Diamonds') then
				G.playing_cards[i].ability.perma_bonus = G.playing_cards[i].ability.perma_bonus or 0
				G.playing_cards[i].ability.perma_bonus = G.playing_cards[i].ability.perma_bonus + card.ability.extra.bonus
			end
		end
		for i = 1, #G.hand.cards do
			local percent = 0.85 + (i - 0.999) / (#G.playing_cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if G.hand.cards[i]:is_suit('Diamonds') then
						G.hand.cards[i]:flip()
						play_sound('tarot2', percent, 0.6)
						G.hand.cards[i]:juice_up(0.3, 0.3)
					end
					return true
				end
			}))
		end
		delay(0.5)
	end,
	can_use = function(self, card)
		return G.hand and #G.hand.cards > 0
	end
}
SMODS.Consumable {
	key = 'wandolotry',
	set = 'upgrd_upgrade',
	atlas = 'upgradecards',
	pos = { x = 4, y = 1 },
	config = { extra = { bonus = 25 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.bonus } }
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.cards do
			local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if G.hand.cards[i]:is_suit('Clubs') then
						G.hand.cards[i]:flip()
						play_sound('card1', percent)
						G.hand.cards[i]:juice_up(0.3, 0.3)
					end
					return true
				end
			}))
		end
		delay(0.2)
		for i = 1, #G.playing_cards do
			if G.playing_cards[i]:is_suit('Clubs') then
				G.playing_cards[i].ability.perma_bonus = G.playing_cards[i].ability.perma_bonus or 0
				G.playing_cards[i].ability.perma_bonus = G.playing_cards[i].ability.perma_bonus + card.ability.extra.bonus
			end
		end
		for i = 1, #G.hand.cards do
			local percent = 0.85 + (i - 0.999) / (#G.playing_cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if G.hand.cards[i]:is_suit('Clubs') then
						G.hand.cards[i]:flip()
						play_sound('tarot2', percent, 0.6)
						G.hand.cards[i]:juice_up(0.3, 0.3)
					end
					return true
				end
			}))
		end
		delay(0.5)
	end,
	can_use = function(self, card)
		return G.hand and #G.hand.cards > 0
	end
}
SMODS.Consumable {
	key = 'cupriscity',
	set = 'upgrd_upgrade',
	atlas = 'upgradecards',
	pos = { x = 5, y = 1 },
	config = { extra = { bonus = 25 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.bonus } }
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.cards do
			local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if G.hand.cards[i]:is_suit('Hearts') then
						G.hand.cards[i]:flip()
						play_sound('card1', percent)
						G.hand.cards[i]:juice_up(0.3, 0.3)
					end
					return true
				end
			}))
		end
		delay(0.2)
		for i = 1, #G.playing_cards do
			if G.playing_cards[i]:is_suit('Hearts') then
				G.playing_cards[i].ability.perma_bonus = G.playing_cards[i].ability.perma_bonus or 0
				G.playing_cards[i].ability.perma_bonus = G.playing_cards[i].ability.perma_bonus + card.ability.extra.bonus
			end
		end
		for i = 1, #G.hand.cards do
			local percent = 0.85 + (i - 0.999) / (#G.playing_cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if G.hand.cards[i]:is_suit('Hearts') then
						G.hand.cards[i]:flip()
						play_sound('tarot2', percent, 0.6)
						G.hand.cards[i]:juice_up(0.3, 0.3)
					end
					return true
				end
			}))
		end
		delay(0.5)
	end,
	can_use = function(self, card)
		return G.hand and #G.hand.cards > 0
	end
}
SMODS.Consumable {
	key = 'arrowfall',
	set = 'upgrd_upgrade',
	atlas = 'upgradecards',
	pos = { x = 6, y = 1 },
	config = { extra = { bonus = 50 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.bonus } }
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.cards do
			local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if G.hand.cards[i]:is_suit('Spades') then
						G.hand.cards[i]:flip()
						play_sound('card1', percent)
						G.hand.cards[i]:juice_up(0.3, 0.3)
					end
					return true
				end
			}))
		end
		delay(0.2)
		for i = 1, #G.hand.cards do
			if G.hand.cards[i]:is_suit('Spades') then
				G.hand.cards[i].ability.perma_bonus = G.hand.cards[i].ability.perma_bonus or 0
				G.hand.cards[i].ability.perma_bonus = G.hand.cards[i].ability.perma_bonus + card.ability.extra.bonus
			end
		end
		for i = 1, #G.hand.cards do
			local percent = 0.85 + (i - 0.999) / (#G.playing_cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if G.hand.cards[i]:is_suit('Spades') then
						G.hand.cards[i]:flip()
						play_sound('tarot2', percent, 0.6)
						G.hand.cards[i]:juice_up(0.3, 0.3)
					end
					return true
				end
			}))
		end
		delay(0.5)
	end,
	can_use = function(self, card)
		return G.hand and  #G.hand.cards > 0
	end
}
SMODS.Consumable {
	key = 'cutgem',
	set = 'upgrd_upgrade',
	atlas = 'upgradecards',
	pos = { x = 7, y = 1 },
	config = { extra = { dollars = 5 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.dollars } }
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.cards do
			local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if G.hand.cards[i]:is_suit('Diamonds') then
						G.hand.cards[i]:flip()
						play_sound('card1', percent)
						G.hand.cards[i]:juice_up(0.3, 0.3)
					end
					return true
				end
			}))
		end
		delay(0.2)
		for i = 1, #G.hand.cards do
			if G.hand.cards[i]:is_suit('Diamonds') then
				G.hand.cards[i].ability.perma_p_dollars = G.hand.cards[i].ability.perma_p_dollars or 0
				G.hand.cards[i].ability.perma_p_dollars = G.hand.cards[i].ability.perma_p_dollars + card.ability.extra.dollars
			end
		end
		for i = 1, #G.hand.cards do
			local percent = 0.85 + (i - 0.999) / (#G.playing_cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if G.hand.cards[i]:is_suit('Diamonds') then
						G.hand.cards[i]:flip()
						play_sound('tarot2', percent, 0.6)
						G.hand.cards[i]:juice_up(0.3, 0.3)
					end
					return true
				end
			}))
		end
		delay(0.5)
	end,
	can_use = function(self, card)
		return G.hand and  #G.hand.cards > 0
	end
}
SMODS.Consumable {
	key = 'onyxorb',
	set = 'upgrd_upgrade',
	atlas = 'upgradecards',
	pos = { x = 0, y = 2 },
	config = { extra = { mult = 10 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.cards do
			local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if G.hand.cards[i]:is_suit('Clubs') then
						G.hand.cards[i]:flip()
						play_sound('card1', percent)
						G.hand.cards[i]:juice_up(0.3, 0.3)
					end
					return true
				end
			}))
		end
		delay(0.2)
		for i = 1, #G.hand.cards do
			if G.hand.cards[i]:is_suit('Clubs') then
				G.hand.cards[i].ability.perma_mult = G.hand.cards[i].ability.perma_mult or 0
				G.hand.cards[i].ability.perma_mult = G.hand.cards[i].ability.perma_mult + card.ability.extra.mult
			end
		end
		for i = 1, #G.hand.cards do
			local percent = 0.85 + (i - 0.999) / (#G.playing_cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if G.hand.cards[i]:is_suit('Clubs') then
						G.hand.cards[i]:flip()
						play_sound('tarot2', percent, 0.6)
						G.hand.cards[i]:juice_up(0.3, 0.3)
					end
					return true
				end
			}))
		end
		delay(0.5)
	end,
	can_use = function(self, card)
		return G.hand and  #G.hand.cards > 0
	end
}
SMODS.Consumable {
	key = 'bloodrush',
	set = 'upgrd_upgrade',
	atlas = 'upgradecards',
	pos = { x = 1, y = 2 },
	config = { extra = { xmult = 1.5 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.cards do
			local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if G.hand.cards[i]:is_suit('Hearts') then
						G.hand.cards[i]:flip()
						play_sound('card1', percent)
						G.hand.cards[i]:juice_up(0.3, 0.3)
					end
					return true
				end
			}))
		end
		delay(0.2)
		for i = 1, #G.hand.cards do
			if G.hand.cards[i]:is_suit('Hearts') then
				G.hand.cards[i].ability.perma_x_mult = G.hand.cards[i].ability.perma_x_mult or 0
				G.hand.cards[i].ability.perma_x_mult = G.hand.cards[i].ability.perma_x_mult + card.ability.extra.xmult
			end
		end
		for i = 1, #G.hand.cards do
			local percent = 0.85 + (i - 0.999) / (#G.playing_cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if G.hand.cards[i]:is_suit('Hearts') then
						G.hand.cards[i]:flip()
						play_sound('tarot2', percent, 0.6)
						G.hand.cards[i]:juice_up(0.3, 0.3)
					end
					return true
				end
			}))
		end
		delay(0.5)
	end,
	can_use = function(self, card)
		return G.hand and  #G.hand.cards > 0
	end
}
SMODS.Booster { --booster packs are pretty much all coded the same way
	key = 'upgrdpack1',
	atlas = 'upgradepacks',
	pos = { x = 0, y = 0 },
	config = { extra = 3, choose = 1 }, --extra here is the number of cards, choose is the number of them you can, well, choose.
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.choose, card.ability.extra } }
	end,
	cost = 4,
	weight = 0.475,
	group_key = 'upgrd_upgrade_pack', --groups the bosters together
	kind = 'Upgrade', --unsure of what this does but included it anyway
	draw_hand = true,
	create_card = function(self, card) --creates upgrade cards
		return create_card('upgrd_upgrade', G.pack_cards, nil, nil, true, true, nil, 'upgrd_upgrade')
	end
}
SMODS.Booster {
	key = 'upgrdpack2',
	atlas = 'upgradepacks',
	pos = { x = 1, y = 0 },
	config = { extra = 3, choose = 1 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.choose, card.ability.extra } }
	end,
	cost = 4,
	weight = 0.475,
	group_key = 'upgrd_upgrade_pack',
	kind = 'Upgrade',
	draw_hand = true,
	create_card = function(self, card)
		return create_card('upgrd_upgrade', G.pack_cards, nil, nil, true, true, nil, 'upgrd_upgrade')
	end
}
SMODS.Booster {
	key = 'upgrdpack3',
	atlas = 'upgradepacks',
	pos = { x = 2, y = 0 },
	config = { extra = 3, choose = 1 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.choose, card.ability.extra } }
	end,
	cost = 4,
	weight = 0.475,
	group_key = 'upgrd_upgrade_pack',
	kind = 'Upgrade',
	draw_hand = true,
	create_card = function(self, card)
		return create_card('upgrd_upgrade', G.pack_cards, nil, nil, true, true, nil, 'upgrd_upgrade')
	end
}
SMODS.Booster {
	key = 'upgrdpack4',
	atlas = 'upgradepacks',
	pos = { x = 3, y = 0 },
	config = { extra = 3, choose = 1 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.choose, card.ability.extra } }
	end,
	cost = 4,
	weight = 0.475,
	group_key = 'upgrd_upgrade_pack',
	kind = 'Upgrade',
	draw_hand = true,
	create_card = function(self, card)
		return create_card('upgrd_upgrade', G.pack_cards, nil, nil, true, true, nil, 'upgrd_upgrade')
	end
}
SMODS.Booster {
	key = 'upgrdpack1_j',
	atlas = 'upgradepacks',
	pos = { x = 0, y = 1 },
	config = { extra = 5, choose = 1 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.choose, card.ability.extra } }
	end,
	cost = 6,
	weight = 0.225,
	group_key = 'upgrd_upgrade_pack',
	kind = 'Upgrade',
	draw_hand = true,
	create_card = function(self, card)
		return create_card('upgrd_upgrade', G.pack_cards, nil, nil, true, true, nil, 'upgrd_upgrade')
	end
}
SMODS.Booster {
	key = 'upgrdpack2_j',
	atlas = 'upgradepacks',
	pos = { x = 1, y = 1 },
	config = { extra = 5, choose = 1 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.choose, card.ability.extra } }
	end,
	cost = 6,
	weight = 0.225,
	group_key = 'upgrd_upgrade_pack',
	kind = 'Upgrade',
	draw_hand = true,
	create_card = function(self, card)
		return create_card('upgrd_upgrade', G.pack_cards, nil, nil, true, true, nil, 'upgrd_upgrade')
	end
}
SMODS.Booster {
	key = 'upgrdpack1_m',
	atlas = 'upgradepacks',
	pos = { x = 2, y = 1 },
	config = { extra = 5, choose = 2 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.choose, card.ability.extra } }
	end,
	cost = 8,
	weight = 0.075,
	group_key = 'upgrd_upgrade_pack',
	kind = 'Upgrade',
	draw_hand = true,
	create_card = function(self, card)
		return create_card('upgrd_upgrade', G.pack_cards, nil, nil, true, true, nil, 'upgrd_upgrade')
	end
}
SMODS.Booster {
	key = 'upgrdpack2_m',
	atlas = 'upgradepacks',
	pos = { x = 3, y = 1 },
	config = { extra = 5, choose = 2 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.choose, card.ability.extra } }
	end,
	cost = 8,
	weight = 0.075,
	group_key = 'upgrd_upgrade_pack',
	kind = 'Upgrade',
	draw_hand = true,
	create_card = function(self, card)
		return create_card('upgrd_upgrade', G.pack_cards, nil, nil, true, true, nil, 'upgrd_upgrade')
	end
}
SMODS.Tag { --thank artbox for this code
	key = 'deckbuild',
	atlas = 'upgrdtag',
	pos = { x = 0, y = 0 },
	loc_vars = function(self, info_queue)
		info_queue[#info_queue + 1] = G.P_CENTERS.p_upgrd_upgrdpack1_m
	end,
	apply = function(self, tag, context)
		if context.type == "new_blind_choice" then
			local lock = tag.ID
			G.CONTROLLER.locks[lock] = true
			tag:yep('+', HEX("9b3b4a"),function() --the color here is the background color for when the tag is actually used
				local key = 'p_upgrd_upgrdpack1_m' --only creates a single specific Mega Pack but thats honestly fine as is
				local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
				G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
				card.cost = 0
				card.from_tag = true
				G.FUNCS.use_card({config = {ref_table = card}})
				card:start_materialize()
				G.CONTROLLER.locks[lock] = nil
				return true
			end)
			tag.triggered = true
			return true
		end
  end
}
