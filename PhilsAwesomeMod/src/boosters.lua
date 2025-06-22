SMODS.Atlas {
  key = 'boosters',
  px = 71,
  py = 95,
  path = 'Boosters.png'
}

SMODS.Booster {
    key = "gallery_booster",

    kind = "gallery_mini",



    atlas = "boosters",

    pos = { x = 0, y = 0 },

    config = {extra = 2, choose = 1 },


    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.choose, card.ability.extra } }
    end,


    loc_txt = {
        name = "Gallery Pack",
        text = { 
            "Choose {C:attention}#1#{} of up to {C:attention}#2#{} {X:black,C:white}Gallery{} cards", 
            "to be used immediately"
        },
        group_name = "Gallery Pack"

    },


    pools = {
        ["phil_gallery"] = true
    },
    weight = 0.3,

    create_card = function(self, card, i)
        return {set = "gallery", area = G.pack_cards, soulable = false, skip_materialize = true}
    end,

    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.WHITE)
        ease_background_colour{new_colour = G.C.WHITE, special_colour = G.C.BLACK, contrast = 5}
    end,




    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0,0, {
            timer = 0.015,
            scale = 0.05,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = {G.C.WHITE, G.C.BLACK},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end

}

SMODS.Booster {
    key = "gallery_booster2",

    kind = "gallery_mini",


    atlas = "boosters",

    pos = { x = 1, y = 0 },

    config = {extra = 2, choose = 1 },


    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.choose, card.ability.extra } }
    end,


    loc_txt = {
        name = "Gallery Pack",
        text = { 
            "Choose {C:attention}#1#{} of up to {C:attention}#2#{} {X:black,C:white}Gallery{} cards", 
            "to be used immediately"
        },
        group_name = "Gallery Pack"
    },

    pools = {
        ["phil_gallery"] = true
    },
    weight = 0.3,

    create_card = function(self, card, i)
        return {set = "gallery", area = G.pack_cards, soulable = false, skip_materialize = true}
    end,

    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.WHITE)
        ease_background_colour{new_colour = G.C.WHITE, special_colour = G.C.BLACK, contrast = 5}
    end,




    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0,0, {
            timer = 0.015,
            scale = 0.05,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = {G.C.WHITE, G.C.BLACK},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end

}

SMODS.Booster {
    key = "gallery_booster_jumbo",

    atlas = "boosters",

    pos = { x = 2, y = 0 },

    config = {extra = 4, choose = 1 },


    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.choose, card.ability.extra } }
    end,


    loc_txt = {
        name = "Jumbo Gallery Pack",
        text = { 
            "Choose {C:attention}#1#{} of up to {C:attention}#2#{} {X:black,C:white}Gallery{} cards", 
            "to be used immediately"
        },
        group_name = "Gallery Pack"
    },

    pools = {
        ["phil_gallery"] = true
    },
    weight = 0.3,
    cost = 6,

    create_card = function(self, card, i)
        return {set = "gallery", area = G.pack_cards, soulable = false, skip_materialize = true}
    end,

    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.WHITE)
        ease_background_colour{new_colour = G.C.WHITE, special_colour = G.C.BLACK, contrast = 5}
    end,




    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0,0, {
            timer = 0.015,
            scale = 0.05,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = {G.C.WHITE, G.C.BLACK},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end

}

SMODS.Booster {
    key = "gallery_booster_mega",

    atlas = "boosters",

    pos = { x = 3, y = 0 },

    config = {extra = 4, choose = 2 },


    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.choose, card.ability.extra } }
    end,


    loc_txt = {
        name = "Mega Gallery Pack",
        text = { 
            "Choose {C:attention}#1#{} of up to {C:attention}#2#{} {X:black,C:white}Gallery{} cards", 
            "to be used immediately"
        },
        group_name = "Gallery Pack"
    },

    pools = {
        ["phil_gallery"] = true
    },
    weight = 0.07,
    cost = 8,

    create_card = function(self, card, i)
        return {set = "gallery", area = G.pack_cards, soulable = false, skip_materialize = true}
    end,

    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.WHITE)
        ease_background_colour{new_colour = G.C.WHITE, special_colour = G.C.BLACK, contrast = 5}
    end,




    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0,0, {
            timer = 0.015,
            scale = 0.05,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = {G.C.WHITE, G.C.BLACK},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end

}