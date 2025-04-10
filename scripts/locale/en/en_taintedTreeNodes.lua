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
    ["node_blackruneassembly"] = "{{blackRuneAssembly}}% chance for the random rune assembled from rune shards to be a Black Rune.",


    -- T. MAGDALENE'S TREE --
    ["node_taintedhealth_name"] = "Tainted Health",
    ["node_taintedhealth"] = {
        "+0.1 damage per 1/2 remaining red heart above 2 hearts.",
        "+3% tears per 1/2 remaining soul heart.",
        "-15% speed while you have 3 or less remaining red hearts."
    },
    ["node_testoftemperance_name"] = "Test Of Temperance",
    ["node_testoftemperance"] = {
        "5% chance to drop a 1/2 red heart pickup when hitting a boss, which vanishes after 2 seconds.",
        "This effect has a 0.5 second cooldown once triggered.",
        "If you have more than 2 remaining red hearts, receive an additional 1/2 heart",
        "damage when hit in boss rooms."
    },
    ["node_bloodful_name"] = "Bloodful",
    ["node_bloodful"] = {
        "Start with Blood Oath.",
        "+1% all stats per red heart collected in the current room, up to +10%.",
        "-5% all stats while you haven't collected any red hearts in the current room."
    },
    ["node_lingeringmalice_name"] = "Lingering Malice",
    ["node_lingeringmalice"] = {
        "Start with a smelted Lost Cork.",
        "Creep left by you can damage flying enemies.",
        "+{{creepDamage}}% damage dealt by creep."
    },

    ["node_remaininghpspeed_name"] = "Remaining Hearts Speed",
    ["node_remaininghpspeed"] = "+{{remainingHeartsSpeed}} speed per 1/2 remaining red heart past 2.",
    ["node_remaininghpdmg_name"] = "Remaining Hearts Damage",
    ["node_remaininghpdmg"] = "+{{remainingHeartsDmg}} damage per 1/2 remaining red heart past 2.",
    ["node_remaininghptears_name"] = "Remaining Hearts Tears",
    ["node_remaininghptears"] = "+{{remainingHeartsTears}} tears per 1/2 remaining red heart past 2.",
    ["node_tempheart_time_name"] = "Temporary Heart Time",
    ["node_tempheart_time"] = "+{{temporaryHeartTime}} seconds to temporary red heart pickups before they vanish.",
    ["node_tempheartdmg_name"] = "Temporary Heart Damage",
    ["node_tempheartdmg"] = {
        "+{{temporaryHeartDmg}}% damage for 2 seconds after picking up a temporary red heart.",
        "Modifiers that increase temporary heart duration also affect this buff's time.",
    },
    ["node_tempheart_tears_name"] = "Temporary Heart Tears",
    ["node_tempheart_tears"] = {
        "+{{temporaryHeartTears}}% tears for 2 seconds after picking up a temporary red heart.",
        "Modifiers that increase temporary heart duration also affect this buff's time."
    },
    ["node_creepdmg_name"] = "Creep Damage",
    ["node_creepdmg"] = "+{{creepDamage}}% damage dealt by creep.",
    ["node_halfheartconv_name"] = "Half Heart Pickup Conversion",
    ["node_halfheartconv"] = "{{halfHeartPickupToFull}}% chance to convert dropped 1/2 red heart pickups into full red hearts.",
    ["node_tempheartluck_name"] = "Temporary Heart Luck",
    ["node_tempheartluck"] = {
        "{{temporaryHeartLuck}}% chance to gain 0.01 luck when picking up a temporary red heart while its lifetime has 1.8",
        "seconds or more remaining.",
        "Total bonus gets halved when entering a new floor."
    },
    ["node_blooddono_temphearts_name"] = "Blood Donation Temporary Hearts",
    ["node_blooddono_temphearts"] = {
        "{{bloodDonoTempHearts}}% chance to drop a 1/2 red heart when using a Blood Donation Machine, which vanishes",
        "after 2 seconds."
    },


    -- T. CAIN'S TREE --
    ["node_ransacking_name"] = "Ransacking",
    ["node_ransacking"] = {
        "Bag of Crafting's melee attack gains an additional {{craftBagMeleeDmgInherit}}% of your damage.",
        "Killing an enemy with Bag of Crafting's melee attack has a 10% chance to spawn a",
        "coin/key/bomb/half heart, up to 5 per room.",
        "+0.02 luck when killing an enemy with Bag of Crafting's melee attack."
    },
    ["node_magicbag_name"] = "Magic Bag",
    ["node_magicbag"] = {
        "When crafting an item, additionally drop one of the pickups used to craft it.",
        "+0.5% all stats per pickup in the crafting bag."
    },
    ["node_opportunist_name"] = "Opportunist",
    ["node_opportunist"] = {
        "When grabbing a pickup with the Bag of Crafting, trigger an effect based on the pickup:",
        "  - Red hearts: 30% chance to heal 1/2 red heart.",
        "  - Soul/black hearts: 15% chance to add 1/2 of the grabbed heart.",
        "  - Coins/keys/bombs: 15% chance to grant the grabbed pickup as if collected normally.",
        "  - Batteries: 15% chance to add 2 charges to your active items.",
        "  - Runes: triggers Rune Shard's effect.",
        "  - Cards: permanent +0.5% luck."
    },
    ["node_grandingredient_coins_name"] = "Grand Ingredient: Coins",
    ["node_grandingredient_coins"] = {
        "If the first pickup in the bag is a coin, gain an effect based on its type:",
        "  - Penny: +3% luck and range.",
        "  - Lucky Penny: +7% luck.",
        "  - Nickel: gain 5 coins when crafting an item.",
        "  - Dime: gain 10 coins when crafting an item.",
        "  - Golden: +7% all stats.",
        "Having more than 2 Grand Ingredient nodes allocated nullifies these effects."
    },
    ["node_grandingredient_keys_name"] = "Grand Ingredient: Keys",
    ["node_grandingredient_keys"] = {
        "If the first pickup in the bag is a key, gain an effect based on its type:",
        "  - Normal: +3% tears.",
        "  - Golden: grants you 4 keys and triggers Dad's Key's effect when crafting an item.",
        "  - Charged: grants an additional charge to your active items when clearing a room.",
        "Having more than 2 Grand Ingredient nodes allocated nullifies these effects."
    },
    ["node_grandingredient_bombs_name"] = "Grand Ingredient: Bombs",
    ["node_grandingredient_bombs"] = {
        "If the first pickup in the bag is a bomb, gain an effect based on its type:",
        "  - Normal: +5% damage.",
        "  - Golden: permanent +10% damage when crafting an item.",
        "  - Giga: +30% damage.",
        "Having more than 2 Grand Ingredient nodes allocated nullifies these effects."
    },
    ["node_grandingredient_hearts_name"] = "Grand Ingredient: Hearts",
    ["node_grandingredient_hearts"] = {
        "If the first pickup in the bag is a heart, gain an effect based on its type:",
        "  - Red: heal 1 red heart when crafting an item.",
        "  - Soul: gain a soul heart when crafting an item.",
        "  - Black: gain a black heart when crafting an item.",
        "  - Eternal: fully heals you when crafting an item.",
        "  - Golden: gain 7 coins when crafting an item.",
        "  - Bone: gain an empty bone heart when crafting an item.",
        "  - Rotten: spawn 2-4 blue spiders and 2-4 blue flies when crafting an item.",
        "Having more than 2 Grand Ingredient nodes allocated nullifies these effects."
    },

    ["node_craftbagmeleedmg_name"] = "Bag Of Crafting Melee Damage",
    ["node_craftbagmeleedmg"] = "Bag of Crafting's melee attack gains an additional {{craftBagMeleeDmgInherit}}% of your damage.",
    ["node_craftpickuprecovery_name"] = "Crafting Pickup Recovery",
    ["node_craftpickuprecovery"] = "{{craftPickupRecovery}}% chance to spawn one of the consumed pickups when crafting an item.",
    ["node_droppedspecialpickups_name"] = "Dropped Special Pickups",
    ["node_droppedspecialpickups"] = {
        "{{droppedSpecialPickups}}% chance for dropped pickups to be a special variant, such as golden/charged keys, golden",
        "bombs, etc."
    },
    ["node_itemcraftluck_name"] = "Item Crafting Luck",
    ["node_itemcraftluck"] = "+{{itemCraftingLuck}} luck when crafting an item.",
    ["node_bagbombpickupbuff_name"] = "Bag Bomb Pickup Buff",
    ["node_bagbombpickupbuff"] = "+{{bagBombDamage}}% damage per bomb pickup in the crafting bag.",
    ["node_bagkeypickupbuff_name"] = "Bag Key Pickup Buff",
    ["node_bagkeypickupbuff"] = "+{{bagKeyTears}}% tears per key pickup in the crafting bag.",
    ["node_bagcoinpickupbuff_name"] = "Bag Coin Pickup Buff",
    ["node_bagcoinpickupbuff"] = "+{{bagCoinRangeLuck}}% range and luck per coin pickup in the crafting bag.",
    ["node_bagheartpickupbuff_name"] = "Bag Heart Pickup Buff",
    ["node_bagheartpickupbuff"] = "+{{bagHeartSpeed}}% speed per heart pickup in the crafting bag.",
    ["node_addpedestalpickup_name"] = "Additional Pedestal Pickup",
    ["node_addpedestalpickup"] = {
        "{{additionalPedestalPickup}}% chance to spawn an additional coin/key/bomb/half heart pickup when collecting an",
        "item pedestal.",
        "Above 100% total chance, roll multiple times."
    },
    ["node_randclearpickup_name"] = "Pickup On Clear",
    ["node_randclearpickup"] = "{{randPickupOnClear}}% chance to spawn an additional coin/key/bomb/half heart when completing a room.",


    -- T. JUDAS' TREE --
    ["node_agile_expertise_name"] = "Agile Expertise",
    ["node_agile_expertise"] = {
        "Trigger How To Jump's effect when using Dark Arts.",
        "-2 seconds to Dark Arts' cooldown.",
        "Reduce Dark Arts' cooldown by 1 second if it hits a boss."
    },
    ["node_stealthtactics_name"] = "Stealth Tactics",
    ["node_stealthtactics"] = {
        "Start with 9 Volt.",
        "Speed cannot exceed 1.2 while Dark Arts is active.",
        "{{nonDarkArtsDmg}}% damage with sources that aren't Dark Arts."
    },
    ["node_lightlessbounty_name"] = "Bounty For The Lightless",
    ["node_lightlessbounty"] = {
        "Killing an enemy with Dark Arts has a 15% chance of granting half a black heart if you have",
        "less than 4 black hearts.",
        "Killing an enemy with Dark Arts grants +0.03 luck, up to +1 per floor."
    },
    ["node_annihilation_name"] = "Annihilation",
    ["node_annihilation"] = {
        "The first time you hit a boss enemy with Dark Arts, deal an additional 40 damage or",
        "10% of its HP as damage, whichever is highest.",
        "Effect can only happen twice per room if multiple bosses are present.",
        "25% chance to take an additional 1/2 heart damage from bosses if you have 3 or more black hearts."
    },
    ["node_anarchy_name"] = "Anarchy",
    ["node_anarchy"] = {
        "Enemies hit by Dark Arts have a 25% chance to spawn a troll bomb, up to thrice per room.",
        "Enemies take 75% reduced damage from troll bombs.",
        "Enemies killed by bombs reduce Dark Arts' cooldown by 0.5 seconds."
    },
    ["node_darkexpertise_name"] = "Dark Expertise",
    ["node_darkexpertise"] = {
        "Reduce Dark Arts' cooldown by 0.5 seconds per non-boss enemy hit with it.",
        "Reduce Dark Arts' cooldown by 1 second per boss enemy hit with it.",
        "+{{darkArtsCD}} seconds to Dark Arts' cooldown."
    },

    ["node_jumppulse_name"] = "How To Jump Pulse",
    ["node_jumppulse"] = {
        "{{howToJumpPulse}}% chance to trigger a dark pulse when landing with How to Jump, dealing 150% of your",
        "damage to nearby enemies."
    },
    ["node_darkartscd_name"] = "Dark Arts Cooldown",
    ["node_darkartscd"] = "{{darkArtsCD}} seconds to Dark Arts' cooldown.",
    ["node_darkartscdreset_name"] = "Dark Arts Cooldown Reset",
    ["node_darkartscdreset"] = "{{darkArtsCDReset}}% chance to reset Dark Arts' cooldown when a monster hits you.",
    ["node_darkartsdmg_name"] = "Dark Arts Damage",
    ["node_darkartsdmg"] = {
        "+{{darkArtsDmg}}% Dark Arts damage.",
        "+{{darkArtsCD}} seconds to Dark Arts' cooldown."
    },
    ["node_darkarts_tearboost_name"] = "Dark Arts Tears Boost",
    ["node_darkarts_tearboost"] = {
        "+{{darkArtsTears}}% tears for 2.5 seconds after using Dark Arts.",
        "+{{darkArtsCD}} seconds to Dark Arts' cooldown."
    },
    ["node_nondarkartsdmg_name"] = "Non Dark Arts Damage",
    ["node_nondarkartsdmg"] = "+{{nonDarkArtsDmg}}% damage with sources that aren't Dark Arts.",
    ["node_darkarts_killboost_name"] = "Dark Arts Kill Stat Boost",
    ["node_darkarts_killboost"] = {
        "For every 10th enemy killed with Dark Arts, gain +{{darkArtsKillStat}}% to a random stat.",
        "Resets every floor."
    },
    ["node_trollbombprotect_name"] = "Troll Bomb Protection",
    ["node_trollbombprotect"] = "{{trollBombProtection}}% chance for troll bombs to deal no damage to you.",
    ["node_trollbombkill_luck_name"] = "Troll Bomb Kill Luck",
    ["node_trollbombkill_luck"] = "+{{trollBombKillLuck}} luck whenever a troll bomb kills an enemy.",


    -- T. BLUE BABY'S TREE --
    ["node_alacritouspurpose_name"] = "Alacritous Purpose",
    ["node_alacritouspurpose"] = {
        "+0.04 tears when destroying poop, up to +0.5. Resets every floor.",
        "+0.04 luck when destroying poop, up to +2. Resets every floor.",
        "The first poop you destroy per room spawns 3 blue flies, if you have less than 15",
        "active blue flies."
    },
    ["node_treasuredwaste_name"] = "Treasured Waste",
    ["node_treasuredwaste"] = {
        "Your currently held poop grants a buff based on its type:",
        "  - Normal: +0.02 all stats.",
        "  - Corn: +2% all stats.",
        "  - Flaming: hitting enemies has a 5% chance of applying burning.",
        "  - Stinky: hitting enemies has a 5% chance of poisoning.",
        "  - Black: hitting enemies has a 5% chance of confusing.",
        "  - White: +8% damage and tears.",
        "  - Stone: 8% chance to receive no damage when hit.",
        "  - Fart: 40% chance to trigger Butter Bean's effect when hit.",
        "  - Liquid: +6% speed."
    },
    ["node_asceticsoul_name"] = "Ascetic Soul",
    ["node_asceticsoul"] = {
        "While you have 8 or more poop bombs, killing an enemy has a 7% chance of dropping a",
        "1/2 soul heart, up to 5 per floor."
    },
    ["node_slothlegacy_name"] = "Sloth's Legacy",
    ["node_slothlegacy"] = {
        "Start with Bob's Rotten Head.",
        "Hitting a boss with Bob's Rotten Head spawns 3 friendly chargers, once per floor.",
        "Bob's Rotten Head deals 60% less damage."
    },

    ["node_holdpoopregain_name"] = "Hold Poop Regain",
    ["node_holdpoopregain"] = "{{holdPoopRegain}}% chance to regain the used poop when using Hold.",
    ["node_holdbuffs_name"] = "Hold Buffs",
    ["node_holdbuffs"] = {
        "+{{holdEmptySpeed}}% speed while Hold is empty.",
        "+{{holdFullLuck}}% luck while Hold is not empty."
    },
    ["node_poopdmgbuff_name"] = "Poop Damage Buff",
    ["node_poopdmgbuff"] = "Gain +{{poopDamageBuff}}% damage for 2 seconds after destroying room poops.",
    ["node_pooptransmutation_name"] = "Poop Transmutation",
    ["node_pooptransmutation"] = {
        "0.5% chance to transmute a random poop in your bar to a different version when obtaining a",
        "poop pickup, using the following order:",
        "Poop -> Fart -> Bomb -> Corn -> Stone -> Flaming -> Stinky -> Explosive Diarrhea ->",
        "Liquid -> Black -> White"
    },
    ["node_smallpoopupg_name"] = "Small Poop Pickup Upgrade",
    ["node_smallpoopupg"] = "{{poopPickupEnlarge}}% chance to turn small poop pickups into large poops.",
    ["node_rainbowpoopbless_name"] = "Rainbow Poop Blessing",
    ["node_rainbowpoopbless"] = {
        "+{{rainbowPoopLuck}}% luck when destroying a rainbow poop, up to +35%.",
        "Luck buff gets halved when entering a new floor.",
        "{{rainbowPoopSoul}}% chance to gain a soul heart when destroying a rainbow poop."
    },
    ["node_bobheadfly_name"] = "Bob's Head Fly Spawn",
    ["node_bobheadfly"] = "{{bobHeadFlySpawn}}% chance for Bob's Rotten Head to spawn a blue fly per enemy hit, up to 8 per room.",
    ["node_brownnuggethold_name"] = "Brown Nugget On Hold",
    ["node_brownnuggethold"] = "{{holdBrownNugget}}% chance to trigger Brown Nugget item's effect when emptying Hold, up to 5 times per room.",
    ["node_specialpoopfind_name"] = "Special Poop Find",
    ["node_specialpoopfind"] = {
        "{{specialPoopFind}}% chance for poops found in rooms to be replaced with special variants.",
        "Can affect up to 4 poops per room."
    }
}