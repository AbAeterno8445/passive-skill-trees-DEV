return {
    ---- TAINTED CHARACTER TREE NODE MODIFIERS ----
    ["node_coalescingsoul_name"] = "Coalescing Soul",
    ["node_coalescingsoul"] = {
        "When entering a floor, 3% chance to drop a soul stone corresponding to your character.",
        "This effect can only trigger once per run.",
        "Doesn't trigger on first floor."
    },
    ["node_warpedcoalescence_name"] = "Warped Coalescence",
    ["node_warpedcoalescence"] = {
        "Coalescing Soul can now trigger an additional {{coalescingSoulProcs}} times per run, and gains +{{coalescingSoulChance}}% base trigger chance.",
        "40% chance for Coalescing Soul to drop a random soul stone instead of",
        "the one matching your character."
    },
    ["node_coalescingsoulchance_name"] = "Coalescing Soul Chance",
    ["node_coalescingsoulchance"] = {
        "+{{coalSoulRoomClearChance}}% Coalescing Soul trigger chance when clearing a room without taking damage.",
        "{{coalSoulHitChance}}% Coalescing Soul trigger chance when hit by a monster."
    },
    ["node_soulstoneallstat_name"] = "Soul Stone All Stats",
    ["node_soulstoneallstat"] = {
        "+{{soulStoneAllstats}}% all stats when using a soul stone matching your character, once per run.",
        "{{soulStoneUnusedAllstats}}% all stats while you haven't used a soul stone matching your character."
    },

    -- T. ISAAC'S TREE --
    ["node_vacuophobia_name"] = "Vacuophobia",
    ["node_vacuophobia"] = {
        "Begin the game with Birthright.",
        "-1% all stats per missing item in your inventory.",
        "-4% all stats while you're not holding a trinket.",
        "-4% all stats while you're not holding an active item.",
        "-4% all stats while your pocket slots are empty."
    },
    ["node_consumingvoid_name"] = "Consuming Void",
    ["node_consumingvoid"] = {
        "When entering a floor, if your inventory is full, spawn Void.",
        "Void now gets consumed on use.",
        "+20% all stats when consuming an item with void.",
        "Halve the current stats bonus from this effect when clearing a room."
    },
    ["node_fracturedremains_name"] = "Fractured Remains",
    ["node_fracturedremains"] = {
        "Start the game with a Dice Shard.",
        "Clearing a regular room without taking damage has a 3% chance of spawning a Dice Shard.",
        "Clearing a regular room without taking damage has a 7% chance of spawning a Rune Shard.",
        "Clearing a boss room without taking damage has a 75% chance of spawning a Dice Shard.",
        "Clearing a boss room without taking damage spawns two Rune Shards.",
    },
    ["node_sinistralrunemaster_name"] = "Sinistral Runemaster",
    ["node_sinistralrunemaster"] = {
        "+{{blackRuneAbsorb}}% chance for items consumed with Black Runes to be obtained as innate items.",
        "Improve rune effects:",
        "- Hagalaz: additionally trigger Dad's Key's effect.",
        "- Jera: duplicated pickups have an 8% chance of becoming a special version.",
        "- Ehwaz: +3% all stats for the next floor if you step into a trapdoor in the current room.",
        "- Dagaz: +3% all stats for the current floor per cleansed curse.",
        "These effects only have a 75% chance to trigger if you have Dextral Runemaster allocated.",
    },
    ["node_dextralrunemaster_name"] = "Dextral Runemaster",
    ["node_dextralrunemaster"] = {
        "+{{blackRuneAbsorb}}% chance for items consumed with Black Runes to be obtained as innate items.",
        "Improve rune effects:",
        "- Ansuz: on use, +15% chance to trigger a map reveal on the next floor.",
        "- Perthro: a random item pedestal gains an additional item choice from the treasure room pool.",
        "- Berkano: gain Hive Mind innately for the current floor. If you already have it, spawn twice as",
        "many spiders and flies.",
        "- Algiz: +7% damage and tears for 20 seconds.",
        "- Blank rune: additionally trigger a Rune Shard's effect.",
        "These effects only have a 75% chance to trigger if you have Sinistral Runemaster allocated."
    },

    ["node_obtitem_dmg_name"] = "Obtained Item Damage",
    ["node_obtitem_dmg"] = "+{{obtainedItemDamage}}% damage per obtained item.",
    ["node_obtitem_tears_name"] = "Obtained Item Tears",
    ["node_obtitem_tears"] = "+{{obtainedItemTears}}% tears per obtained item.",
    ["node_obtitem_range_name"] = "Obtained Item Range",
    ["node_obtitem_range"] = "+{{obtainedItemRange}}% range per obtained item.",
    ["node_flawlessbossluck_name"] = "Flawless Boss Clear Luck",
    ["node_flawlessbossluck"] = "+{{flawlessBossLuck}} luck when clearing a boss room without taking damage.",
    ["node_voidconsumeluck_name"] = "Void Consumption Luck",
    ["node_voidconsumeluck"] = "+{{voidConsumeLuck}} luck when consuming an item with Void.",
    ["node_runeshardspawn_name"] = "Rune Shard Spawn",
    ["node_runeshardspawn"] = "{{diceShardRuneShard}}% chance to spawn a Rune Shard when using a Dice Shard.",
    ["node_runicspeed_name"] = "Runic Speed",
    ["node_runicspeed"] = {
        "+{{runicSpeed}}% speed when using a Rune or Rune Shard, up to 22%.",
        "Resets every floor."
    },
    ["node_runeshardstacking_name"] = "Rune Shard Stacking",
    ["node_runeshardstacking"] = {
        "You can now stack rune shards. Reaching {{runeshardStacksReq}} stacks drops a random rune.",
        "Stacks can be accumulated while holding any rune or rune shard."
    },
    ["node_runeshardassemblystacks_name"] = "Rune Shard Assembly Stacks",
    ["node_runeshardassemblystacks"] = "{{runeshardStacksReq}} required rune shard stacks to assemble a rune.",
    ["node_blackruneassembly_name"] = "Black Rune Assembly",
    ["node_blackruneassembly"] = "{{blackRuneAssembly}}% chance for the random rune assembled from rune shards to be a Black Rune."
}