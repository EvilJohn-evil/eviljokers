SMODS.current_mod.optional_features = function()
    return {
        quantum_enhancements = true
    }
end


SMODS.Atlas {
        key = 'Jokers',
        path = 'Jokers.png',
        px = 71,
        py = 95
}


SMODS.Rarity {
    key = 'special',
    loc_txt = {
        name = "Special"
    },
    badge_colour = G.C.MONEY,
    default_weight = 0
}


    SMODS.Joker {
        object_type = 'Joker',
        key = 'jokers_crazy_slots',
        atlas = "Jokers",
        pos = { x = 0, y = 0 },
        discovered = true,
        rarity = 2,
        cost = 6,
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
        end,
        loc_txt = {
            name = "Joker's Crazy Slots",
            text = {
                'If scored hand contains 3 or more {C:attention}7{}s',
                'turn all cards in scored hand {C:attention}Lucky{}'
                }
        },
        calculate = function(self, card, context)
            if context.before and context.main_eval and not context.blueprint then
                local sevencount = 0
                for _, scored_card in ipairs(context.scoring_hand) do
                    if scored_card:get_id() == 7 then
                        sevencount = sevencount + 1
                    end
                end
                if sevencount > 2 then
                    for _, scored_card in ipairs(context.scoring_hand) do
                        scored_card:set_ability('m_lucky', nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                scored_card:juice_up()
                                return true
                            end
                        }))
                    end
                    return{
                        message = "JACKPOT!",
                        colour = G.C.MONEY
                    }
                end
            end
        end
    }

    SMODS.Joker {
        key = 'jimbo_may_joke',
        atlas = "Jokers",
        pos = { x = 1, y = 0 },
        discovered = true,
        rarity = 3,
        cost = 8,

        config = { extra = {
            Xmult = 1,
            Xmult_gain = 0.2,
            poker_hand = 'High Card'
        }
        },

        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.Xmult, card.ability.extra.Xmult_gain, localize(card.ability.extra.poker_hand, 'poker_hands') } }
        end,

        loc_txt = {
            name = "Jimbo May Joke",
            text = {
                'Gains {X:mult,C:white}X0.2{} Mult if played hand is a {C:attention}#3#{}',
                'hand changes every round (Currently at {X:mult,C:white}X#1#{} Mult).',
                '{X:black,C:white}Transforms{} at {X:mult,C:white}X3{} Mult'
            }
        },

        calculate = function(self, card, context)
            if context.before and context.main_eval and context.scoring_name == card.ability.extra.poker_hand and not context.blueprint then
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
                return {
                    message = "Upgrade!",
                    colour = G.C.MULT
                }
            end
            
            if context.joker_main then
                return {
                    card = card,
                    Xmult_mod = card.ability.extra.Xmult,
                    message = "X" .. card.ability.extra.Xmult,
                    colour = G.C.MULT
                }
            end
            if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
                if card.ability.extra.Xmult >= 3 then
                    return {
                        message = "Let's Rock!"
                    },
                    SMODS.add_card {
                        set = 'Joker',
                        rarity = 'phil_special',
                        key_append = 'phil_joker_trigger'
                    },
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 1,
                        blockable = false,
                        func = function()
                            card:remove()
                            return true
                        end
                    }))
                    
                end
                
                local _poker_hands = {}
                for k, v in pairs(G.GAME.hands) do
                    if v.visible and k ~= card.ability.extra.poker_hand then
                        _poker_hands[#_poker_hands + 1] = k
                    end
                end
                card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, pseudoseed('vremade_to_do'))
                return {
                    message = localize('k_reset')
                }
            end
        end,
        set_ability = function(self, card, initial, delay_sprites)
            local _poker_hands = {}
            for k, v in pairs(G.GAME.hands) do
                if v.visible and k ~= card.ability.extra.poker_hand then
                    _poker_hands[#_poker_hands + 1] = k
                end
            end
            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands,
                pseudoseed((card.area and card.area.config.type == 'title') and 'vremade_false_to_do' or 'vremade_to_do'))
        end
    }

    SMODS.Joker {
        key = 'joker_trigger',
        atlas = 'Jokers',
        pos = { x = 2, y = 0},
        discovered = true,
        rarity = 'phil_special',
        cost = 8,

        config = { extra = {
            Xmult = 4,
            poker_hand = 'High Card',
            trigger_rounds = -1,
            total_rounds = 2
        }
        },

        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.Xmult, localize(card.ability.extra.poker_hand, 'poker_hands'), card.ability.extra.trigger_rounds, card.ability.extra.total_rounds } }
        end,

        loc_txt = {
            name = "JOKER TRIGGER",
            text = {
                '{X:mult,C:white}X#1#{} Mult.',
                'If played hand is a {C:attention}#2#{}',
                '{C:attention}destroy{} all cards in hand.',
                'Reverts to {C:attention}Jimbo May Joke{} in {C:attention}#4#{} rounds.',
                '(Currently {C:attention}#3#{}/#4#)'

            }


        },

        calculate = function(self,card,context)
            
            if context.joker_main then
                
                return {
                    card = card,
                    Xmult_mod = card.ability.extra.Xmult,
                    message = "X" .. card.ability.extra.Xmult,
                    colour = G.C.MULT
                }


            end


            if context.scoring_name == card.ability.extra.poker_hand and not context.blueprint then
                    
                for _, scored_card in ipairs(context.scoring_hand) do
                    card = scored_card
                    if context.destroy_card and context.destroy_card == card and not context.blueprint then
                        return {
                            remove = true
                        }
                    end
                end
            end
            
            if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
                card.ability.extra.trigger_rounds = card.ability.extra.trigger_rounds + 1
                if card.ability.extra.trigger_rounds == card.ability.extra.total_rounds then
                    
			        
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                         delay = 1,
                        blockable = false,
                        func = function()
                            card:remove()
                            return true
                        end
                    }))


			        local card = create_card("phil_Joker", G.jokers, false, 1, false, false, "j_phil_jimbo_may_joke")
			        card:add_to_deck()
			        G.jokers:emplace(card)
			        return {
                        nil, 
                        true,
                        message = "Now you've really crossed the line..."
                    }
                end
            end
            
            if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
                local _poker_hands = {}
                for k, v in pairs(G.GAME.hands) do
                    if v.visible and k ~= card.ability.extra.poker_hand then
                        _poker_hands[#_poker_hands + 1] = k
                    end
                end
                card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, pseudoseed('vremade_to_do'))
                return {
                    message = localize('k_reset')
                }                
            end
        end,
        set_ability = function(self, card, initial, delay_sprites)
            local _poker_hands = {}
            for k, v in pairs(G.GAME.hands) do
                if v.visible and k ~= card.ability.extra.poker_hand then
                    _poker_hands[#_poker_hands + 1] = k
                end
            end
            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands,
                pseudoseed((card.area and card.area.config.type == 'title') and 'vremade_false_to_do' or 'vremade_to_do'))
        end 





    }


    SMODS.Joker {
        key = 'kiln',
        atlas = 'Jokers',
        pos = { x = 3, y = 0},
        discovered = true,
        rarity = 3,
        cost = 8,
        
        config = { extra = {
            Xmult = 2,
            odds = 4

        }
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
            info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
            return { vars = {card.ability.extra.Xmult, (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds }}
        end,

        loc_txt = {
            name = "Kiln",
            text = {
                "All played {C:attention}Stone Cards{}",
                "function as {C:attention}Glass Cards{}"

            }
        },

        calculate = function(self, card, context)
            if context.check_enhancement then
                if context.other_card.config.center.key == "m_stone" then
                    return {m_glass = true}
                end
            end
        end
    }
    --MODCODE END--