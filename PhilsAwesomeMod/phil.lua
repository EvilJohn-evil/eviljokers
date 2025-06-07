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

    SMODS.Joker {
        key = 'mirror_joker',
        atlas = "Jokers",
        pos = { x = 4, y = 0 },
        discovered = true,
        rarity = 2,
        cost = 6,
        blueprint_compat = true,

        config = { extra = {
            repetitions = 1
        }
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
            return {vars = {card.ability.extra.repetitions}} 
        end,

        loc_txt = {
            name = "Mirror Joker",
            text = {
                "Retrigger all {C:attention}Glass Cards{}"
            }
        },
        
        calculate = function(self,card,context)
            if context.repetition then
                if SMODS.has_enhancement(context.other_card, 'm_glass') then
                    if context.cardarea == G.play then
                        return {
                            repetitions = card.ability.extra.repetitions
                        }
                    end

                    if context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) then
                        return {
                            repetitions = card.ability.extra.repetitions
                        }
                    end
                end
            end
        end

    }

    SMODS.Joker {
    key = "wanted_poster",
    atlas = "Jokers",
    blueprint_compat = true,
    discovered = true,
    rarity = 1,
    cost = 4,
    pos = { x = 5, y = 0 },
    
    config = { extra = { dollars = 3 } 
    },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, localize((G.GAME.current_round.vremade_wanted_card or {}).rank or 'Ace', 'ranks') } }
    end,

    loc_txt = {
        name = "Wanted Poster",
        text = {
            "Earn {C:attention}$#1#{} for each scored {C:attention}#2#{},",
            "rank changes at the end of each round"


        }

    },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == G.GAME.current_round.vremade_wanted_card.id then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                return {
                    dollars = card.ability.extra.dollars,
                    func = function() -- This is for timing purposes, it runs after the dollar manipulation
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }            
            
            end
        end
    end
    }
    
    local function reset_vremade_wanted_rank()
        G.GAME.current_round.vremade_wanted_card = { rank = 'Ace' }
        local valid_wanted_cards = {}
        for _, playing_card in ipairs(G.playing_cards) do
            if not SMODS.has_no_rank(playing_card) then
                valid_wanted_cards[#valid_wanted_cards + 1] = playing_card
            end
        end
        local wanted_card = pseudorandom_element(valid_wanted_cards, pseudoseed('vremade_wanted' .. G.GAME.round_resets.ante))
        if wanted_card then
            G.GAME.current_round.vremade_wanted_card.rank = wanted_card.base.value
            G.GAME.current_round.vremade_wanted_card.id = wanted_card.base.id
        end
    end

    function SMODS.current_mod.reset_game_globals(run_start)
    reset_vremade_wanted_rank()
    end

    SMODS.Joker {
    
    key = "the_only_thing_they_fear",
    atlas = "Jokers",
    blueprint_compat = true,
    discovered = true,
    rarity = 3,
    cost = 8,
    pos = { x = 6, y = 0 },
    
    config = { extra = {destroy = 3} 
    },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.destroy} }
    end,

    loc_txt = {
        name = "The Only Thing They Fear",
        text = {
            "Destroy {C:attention}#1#{} cards held in hand",
            "if scored hand exceeds blind requirement "


        }

    },
    calculate = function(self,card,context)
        if context.after and hand_chips * mult >= G.GAME.blind.chips then
            local destroyed_cards = {}
            local temp_hand = {}

            for _, playing_card in ipairs(G.hand.cards) do temp_hand[#temp_hand + 1] = playing_card end
            table.sort(temp_hand,
                function(a, b)
                    return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card
                end
            )

            pseudoshuffle(temp_hand, pseudoseed('immolate'))

            for i = 1, card.ability.extra.destroy do destroyed_cards[#destroyed_cards + 1] = temp_hand[i] end

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    SMODS.destroy_cards(destroyed_cards)
                    return {true
                    }
                end

            }))
            return {
                message = "Rip and Tear!",
                colour = G.C.MULT
            
            }
        end
    end
    }
    
    
    SMODS.Joker {
    
    key = "the_bard",
    atlas = "Jokers",
    blueprint_compat = true,
    discovered = false,
    rarity = 3,
    cost = 8,
    pos = { x = 8, y = 0 },
    
    config = { extra = {planet_odds = 4, tarot_odds = 8, spectral_odds = 16 } 
    },
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
        return { vars = { G.GAME and G.GAME.probabilities.normal or 1, 
            card.ability.extra.planet_odds, 
            card.ability.extra.tarot_odds, 
            card.ability.extra.spectral_odds
            } 
        }
    end,

    loc_txt = {
        name = "The Bard",
        text = {
            "When a {C:attention}Wild Card{} is scored:",
            "{C:green}#1# in #2#{} chance to create a {C:attention}Planet Card{}",
            "{C:green}#1# in #3#{} chance to create a {C:attention}Tarot Card{}",            
            "{C:green}#1# in #4#{} chance to create a {C:attention}Spectral Card{}",

        }

    },
    calculate = function(self,card,context)    
        
       
        if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_wild") then
            local success_count = 0
            
            if pseudorandom('vremade_bard') < G.GAME.probabilities.normal / card.ability.extra.planet_odds and 
            #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                success_count = success_count + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Planet'
                        }
                        G.GAME.consumeable_buffer = 0
                        return {true}
                    end)
                }))
            end

            if pseudorandom('vremade_bard') < G.GAME.probabilities.normal / card.ability.extra.tarot_odds and 
            #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit  then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                success_count = success_count + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Tarot'
                        }
                        G.GAME.consumeable_buffer = 0
                        return {true}
                    end)
                }))

            end

            if pseudorandom('vremade_bard') < G.GAME.probabilities.normal / card.ability.extra.spectral_odds and 
            #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                success_count = success_count + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Spectral'
                        }
                        G.GAME.consumeable_buffer = 0
                        return {true}
                    end)
                }))
                
            end
            
            if success_count == 1 then
                return {
                    message = "Here you go!",
                    message_card = card
                }
            elseif success_count > 1 then
                return { 
                    message = "Have some of these!",
                    message_card = card
                }
            end

        end
    end
    }

    SMODS.Joker {
    
    key = "the_fighter",
    atlas = "Jokers",
    blueprint_compat = true,
    discovered = false,
    rarity = 3,
    cost = 8,
    pos = { x = 9, y = 0 },
    
    config = { extra = {odds = 4 } 
    },
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_tower
        return { vars = { 
            G.GAME and G.GAME.probabilities.normal or 1,
            card.ability.extra.odds 

            } 
        }
    end,

    loc_txt = {
        name = "The Fighter",
        text = {
            "{C:green}#1# in #2#{} chance to create a {C:dark_edition}Negative{} {C:attention}The Tower{}",
            "when a {C:attention}Stone Card{} is scored"


        }

    },

    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_stone") and pseudorandom('vremade_fighter') < G.GAME.probabilities.normal / card.ability.extra.odds then
            return {
                extra = {
                    message = "Action Surge!",
                    message_card = other_card,
                    func = function() -- This is for timing purposes, everything here runs after the message
                        G.E_MANAGER:add_event(Event({
                            func = (function()
                                SMODS.add_card {
                                    set = 'Tarot',
                                    key = "c_tower",
                                    edition = "e_negative"

                                }
                                return true
                            end)
                        }))
                    end
                },
            }

        end
    
    
    end
    }

    SMODS.Joker {
    
    key = "the_druid",
    atlas = "Jokers",
    blueprint_compat = true,
    discovered = false,
    rarity = 3,
    cost = 8,
    pos = { x = 10, y = 0 },
    
    config = { extra = {odds = 3 } 
    },
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_death
        return { vars = { 
            G.GAME and G.GAME.probabilities.normal or 1,
            card.ability.extra.odds 

            } 
        }
    end,

    loc_txt = {
        name = "The Druid",
        text = {
            "{C:green}#1# in #2#{} chance to create a random {C:attention}Joker{} card",
            "when a {C:attention}Death{} is used",
            "{C:inactive}(Must have room){}"
        }

    },

    calculate = function(self,card,context)
        if context.consumeable then
            if context.consumeable.ability.name == "Death" and pseudorandom('vremade_druid') < G.GAME.probabilities.normal / card.ability.extra.odds then
                if #G.jokers.cards < G.jokers.config.card_limit then                
                    return {
                        extra = {
                            message = "Arise!",
                            func = function() -- This is for timing purposes, everything here runs after the message
                                G.E_MANAGER:add_event(Event({
                                    func = (function()
                                        SMODS.add_card {
                                            set = 'Joker'
                                        }
                                        return true
                                    end)
                                }))
                            end
                        },
                    }
                else
                    return {
                        message = "No Room!",
                        colour = G.C.RED
                    }
                end
            end
        end
    end
    }

    SMODS.Joker {
    
    key = "visible_joker",
    atlas = "Jokers",
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,
    rarity = 2,
    cost = 6,
    pos = { x = 7, y = 0 },

    config = { extra = {total_rounds = 2, visible_rounds = 0} },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.total_rounds, card.ability.extra.visible_rounds } }


    end,

    loc_txt = {
        name = "Visible Joker",
        text = {
            "Sell this card after {C:attention}#1#{} rounds",
            "to create a {C:red}Rare{} {C:attention}Joker{}.",
            "{C:inactive}(Currently {}{C:attention}#2#{}{C:inactive}/2){}"
        }
    },

    calculate = function(self,card,context)
    
        if context.selling_self and (card.ability.extra.visible_rounds >= card.ability.extra.total_rounds) and not context.blueprint then
            if #G.jokers.cards <= G.jokers.config.card_limit then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_card {
                            set = 'Joker',
                            rarity = 'Rare',
                        }
                        G.GAME.joker_buffer = 0
                        return true
                    end
                }))
                return {
                    message = 'Rare Joker!',
                    colour = G.C.RED,
                }
            else 
                return { 
                    message = "No Room!",
                    colour = G.C.RED
                }
            end
        end
        
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.visible_rounds = card.ability.extra.visible_rounds + 1
            if card.ability.extra.visible_rounds == card.ability.extra.total_rounds then
                local eval = function(card) return not card.REMOVED end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.visible_rounds < card.ability.extra.total_rounds then
                return { 
                    message = card.ability.extra.visible_rounds.. "/" ..card.ability.extra.total_rounds,
                    colour = G.C.FILTER
                }
            else
                return { 
                    message = "Active!",
                    colour = G.C.FILTER
                } 
            end

        end


    end

    }

    --MODCODE END--