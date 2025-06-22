SMODS.ConsumableType {
	key = 'gallery',
	collection_rows = {6, 6}, 
	primary_colour = G.C.BLACK,
	secondary_colour = G.C.BLACK,
	loc_txt = {
		collection = 'Gallery Cards',
		name = 'Gallery'
	},
	shop_rate = 0,
    
}

SMODS.Atlas {
    key = 'Gallery',
    path = 'Gallery.png',
    px = 71,
    py = 95
}

SMODS.Consumable {

    key = 'infinite_corridor',
    set = 'gallery',
    atlas = "Gallery",
    pos = { x = 0, y = 0 },
    discovered = true,
    
    draw = function(self, card, layer)
        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' and (card.config.center.discovered or card.bypass_discovery_center) then
            card.children.center:draw_shader('negative_shine', nil, card.ARGS.send_to_shader)
        end
    end, 

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_mime
        info_queue[#info_queue + 1] = G.P_CENTERS.j_baron
        info_queue[#info_queue + 1] = G.P_CENTERS.j_sock_and_buskin
        info_queue[#info_queue + 1] = G.P_CENTERS.j_idol
    end,


    loc_txt = {
        name = "The Infinite Corridor",
        text = {
            "Creates a random {C:attention}Endless Mode{} Joker.",
            "{X:mult,C:black}Doubles{} the initial cost of all rerolls"
        }

    },

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                SMODS.add_card({ set = 'infinite_corridor' })
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        delay(0.6)
        
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost * 2
                G.GAME.current_round.reroll_cost = math.max(0,
                    G.GAME.current_round.reroll_cost * 2)
                return true
            end
        }))

    end,

    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end
}

SMODS.Consumable {

    key = 'candid',
    set = 'gallery',
    atlas = "Gallery",
    pos = { x = 1, y = 0 },
    discovered = true,
    
    draw = function(self, card, layer)
        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' and (card.config.center.discovered or card.bypass_discovery_center) then
            card.children.center:draw_shader('negative_shine', nil, card.ARGS.send_to_shader)
        end
    end, 
    
    config = { extra = { 
        dollars = 6, 
    } },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_photograph
        info_queue[#info_queue + 1] = G.P_CENTERS.j_hanging_chad
        return { vars = { card.ability.extra.dollars, card.ability.extra.safe_rarity}}
    end,


    loc_txt = {
        name = "Candid",
        text = {
            "Creates a random {C:attention}Photochad{} Joker.",
            "Lose {C:attention}$#1#{} for every non-{C:common}Common{} Joker currently owned"
        }

    },

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                SMODS.add_card({ set = 'candid' })
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            func = function()
                local noncommon = 0
                for i = 1, #G.jokers.cards do

                    if G.jokers.cards[i].config.center.rarity ~= 1 then
                        noncommon = noncommon + 1
                    end

                end
                ease_dollars(-(card.ability.extra.dollars * noncommon))
                return true
            end
        }))

    end,

    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end
}



SMODS.Consumable {

    key = 'cameo',
    set = 'gallery',
    atlas = "Gallery",
    pos = { x = 2, y = 0 },
    discovered = true,
    
    draw = function(self, card, layer)
        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' and (card.config.center.discovered or card.bypass_discovery_center) then
            card.children.center:draw_shader('negative_shine', nil, card.ARGS.send_to_shader)
        end
    end, 
    
    config = { extra = { 
        halved_rounds = 0
    } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.halved_rounds,}}
    end,

    loc_txt = {
        name = "Cameo",
        text = {
            "Creates a random {C:attention}Three Heroes{} Joker.",
            "{C:green}Probabilities{} are {C:red}25% less likely to occur{}"
        }

    },

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                for k, v in pairs(G.GAME.probabilities) do
                    G.GAME.probabilities[k] = v * 0.75
                end

                play_sound('timpani')
                SMODS.add_card({ set = 'cameo' })
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
    end,
    
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end,

}


SMODS.Consumable {

    key = 'corporate',
    set = 'gallery',
    atlas = "Gallery",
    pos = { x = 3, y = 0 },
    discovered = true,
    
    draw = function(self, card, layer)
        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' and (card.config.center.discovered or card.bypass_discovery_center) then
            card.children.center:draw_shader('negative_shine', nil, card.ARGS.send_to_shader)
        end
    end, 
    
    config = { extra = { 
        odds = 3
    } },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_business
        info_queue[#info_queue + 1] = G.P_CENTERS.j_mail
        info_queue[#info_queue + 1] = G.P_CENTERS.j_reserved_parking
        info_queue[#info_queue + 1] = G.P_CENTERS.j_phil_wanted_poster
        info_queue[#info_queue + 1] = G.P_CENTERS.j_greedy_joker
        return { vars = { G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds}}
    end,

    loc_txt = {
        name = "Corporate",
        text = {
            "Creates a random {C:common}Common{} {C:attention}Money{} Joker.",
            "{C:green}#1# in #2#{} chance to create an {C:red}Eternal{} {C:attention}Greedy Joker{}"
        }

    },

    use = function(self, card, area, copier)
        
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                SMODS.add_card({ set = 'corporate' })
                card:juice_up(0.3, 0.5)
                return true
            end

        }))

        if pseudorandom('corporate') < G.GAME.probabilities.normal / card.ability.extra.odds then
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    SMODS.add_card({ 
                        key = 'j_greedy_joker',
                        stickers = {"eternal"}
                    })
                    card:juice_up(0.3, 0.5)
                    return true
                end
            
            }))
        end
    end,
    
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit - 1
    end,

}