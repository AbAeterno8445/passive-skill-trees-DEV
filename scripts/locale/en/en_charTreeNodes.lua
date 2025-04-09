return {
    ---- CHARACTER TREE NODE MODIFIERS ----
    ["node_crimsoncore_name"] = "Core Crimson Node",
    ["node_crimsoncore"] = {
        "Allocate to choose any medium node from this character tree.",
        "Gain the effects of the chosen node while allocated."
    },
    ["node_crimsonuniv_name"] = "Universal Crimson Node",
    ["node_crimsonuniv"] = {
        "Allocate to choose any medium node from the global skill tree.",
        "Gain the effects of the chosen node while allocated."
    },
    ["node_crimsondivergent_name"] = "Divergent Crimson Node",
    ["node_crimsondivergent"] = {
        "Allocate to choose any medium node from another character's tree.",
        "Gain the effects of the chosen node while allocated."
    },

    -- ISAAC'S TREE --
    ["node_magicdie_name"] = "Magic Die",
    ["node_magicdie"] = {
        "Using the D6 grants a permanent stat buff. The buff's stats depend on the room you used the D6 in:",
        "- Angel room: +7% speed and tears",
        "- Devil room: +6% damage and range",
        "- Treasure room and shop: +7% shot speed and luck",
        "- Boss room: if you have a boost, augment it by +3%, otherwise +3% all stats",
        "- Anywhere else: +2% all stats",
        "You can only have one of these stat buffs at a time. Using the D6 in a different room switches the",
        "stats gained."
    },
    ["node_intermittentconceptions_name"] = "Intermittent Conceptions",
    ["node_intermittentconceptions"] = {
        "Begin the game with Birthright.",
        "When first entering a room containing item pedestals, remove birthright.",
        "After picking up 2 passive items, receive birthright again.",
        "Effect repeats."
    },
    ["node_isaacblessing_name"] = "Isaac's Blessing",
    ["node_isaacblessing"] = {
        "Start a run with +{{isaacBlessing}}% all stats.",
        "Restarting the run removes this effect.",
        "Defeating Mom's Heart re-enables this for the next run."
    },
    ["node_boonoftheordinary_name"] = "Boon of the Ordinary",
    ["node_boonoftheordinary"] = {
        "While you have at least 25 coins, your minimum speed is 1.33.",
        "While you have at least 12 bombs, your hits gain a 10% chance to deal double damage.",
        "While you have at least 12 keys, gain Eye Drops.",
        "Eye Drops can no longer show up naturally."
    },

    ["node_allstats_name"] = "All Stats",
    ["node_allstats"] = "+{{allstats}} all stats.",
    ["node_allstatchance_name"] = "All Stats Chance On Room",
    ["node_allstatchance"] = "When entering a room with monsters, {{allstatsRoom}}% chance to gain +4% all stats for the current room.",
    ["node_allstatbirthright_name"] = "All Stats - Birthright",
    ["node_allstatbirthright"] = "+{{allstatsBirthright}} all stats while holding birthright.",
    ["node_dicepickups_name"] = "Dice Pickups",
    ["node_dicepickups"] = "{{d6Pickup}}% chance when using any dice items to spawn a random pickup (coin, bomb, key or heart).",
    ["node_dicecharge_name"] = "Dice Charge",
    ["node_dicecharge"] = "{{d6HalfCharge}}% chance when using any dice items to keep half of its charge.",
    ["node_chestreclose_name"] = "Chest Re-closing",
    ["node_chestreclose"] = "{{chestReclose}}% chance for opened chests to close again 1 second after opened, up to twice per room.",
    ["node_pickupdupe_name"] = "Pickup Duplication",
    ["node_pickupdupe"] = "{{pickupDupe}}% chance to duplicate dropped coins/keys/bombs.",
    ["node_pickupboons_name"] = "Pickup Boons",
    ["node_pickupboons"] = {
        "For the current floor:",
        "  +{{pickupBoons}}% damage per bomb picked up, up to 10%.",
        "  +{{pickupBoons}}% tears per key picked up, up to 10%.",
        "  +{{pickupBoons}}% speed per coin picked up, up to 10%."
    },
}