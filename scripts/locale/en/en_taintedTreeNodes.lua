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
    ["node_heartdraincd_name"] = "Heart Drain Delay",
    ["node_heartdraincd"] = {
        "+{{heartDrainCD}} seconds before excess red hearts are drained."
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
    },


    -- T. EVE'S TREE --
    ["node_bloodwrath_name"] = "Bloodwrath",
    ["node_bloodwrath"] = {
        "Start with an additional red heart container.",
        "-1.5% damage per 1/2 remaining red heart.",
        "Whenever you lose red hearts, turn this reduction positive for 5 seconds."
    },
    ["node_resilientblood_name"] = "Resilient Blood",
    ["node_resilientblood"] = {
        "Blood clots have a 25% chance to receive no damage when hit.",
        "Blood clots receive 50% less damage from hits."
    },
    ["node_blessedblood_name"] = "Blessed Blood",
    ["node_blessedblood"] = "When entering a floor, if you don't have an eternal blood clot, spawn one.",
    ["node_congealedbuddy_name"] = "Congealed Buddy",
    ["node_congealedbuddy"] = {
        "Start with a smelted Lil Clot.",
        "Lil Clot deals 20% more damage.",
        "You deal 30% less damage."
    },
    ["node_mysticvampirism_name"] = "Mystic Vampirism",
    ["node_mysticvampirism"] = {
        "Start with Charm of the Vampire.",
        "Every 13 kills, 20% chance to transform an existing red heart clot into a random different",
        "type of clot, up to 8 times per floor."
    },

    ["node_clotheartdrop_name"] = "Blood Clot Heart Drop",
    ["node_clotheartdrop"] = {
        "Blood clots have a {{clotHeartDrop}}% chance to drop their respective heart type when destroyed.",
        "Dropped heart vanishes after 3 seconds."
    },
    ["node_clotpulsedmg_name"] = "Blood Clot Pulse Damage",
    ["node_clotpulsedmg"] = "Blood clot pulse gains an additional {{clotPulseDmgInherit}}% of your damage.",
    ["node_clothitpulse_name"] = "Blood Clot On-Hit Pulse",
    ["node_clothitpulse"] = "Blood clots release a damaging pulse when hit, dealing 3 damage to nearby enemies.",
    ["node_lilclotdmg_name"] = "Lil Clot Damage",
    ["node_lilclotdmg"] = "+{{lilClotDmg}}% Lil Clot damage.",
    ["node_redclotdmgabsorb_name"] = "Red Clot Absorption Damage",
    ["node_redclotdmgabsorb"] = {
        "+{{redClotAbsorbDmg}}% damage for the current room per absorbed red clot.",
        "Spawning a red clot reduces the current buff by this amount."
    },
    ["node_soulclotabsorbtears_name"] = "Soul Clot Absorption Tears",
    ["node_soulclotabsorbtears"] = {
        "+{{soulClotAbsorbTears}}% tears for the current room per absorbed soul clot.",
        "Spawning a soul clot reduces the current buff by this amount."
    },
    ["node_clotdmg_name"] = "Blood Clot Damage",
    ["node_clotdmg"] = "+{{clotDmg}}% damage dealt by all blood clots.",
    ["node_redclotheartdmg_name"] = "Red Clot Damage Per Heart",
    ["node_redclotheartdmg"] = "+{{redClotHeartDmg}}% damage dealt by red clots per 1/2 remaining red heart.",
    ["node_soulclotheartdmg_name"] = "Soul Clot Damage Per Soul Heart",
    ["node_soulclotheartdmg"] = "+{{soulClotHeartDmg}}% damage dealt by soul clots per 1/2 remaining soul heart.",
    ["node_blackclotbabylon_name"] = "Black Clot Babylon Spawn",
    ["node_blackclotbabylon"] = {
        "{{blackClotBabylon}}% chance to spawn a black clot when killing enemies while Whore of Babylon is active, if you",
        "have less than 3 active black clots."
    },
    ["node_clotdestroyluck_name"] = "Clot Destroyed Luck",
    ["node_clotdestroyluck"] = "{{clotDestroyedLuck}}% chance to gain +0.03 luck when any clot is destroyed.",


    -- T. SAMSON'S TREE --
    ["node_balancedapproach_name"] = "Balanced Approach",
    ["node_balancedapproach"] = "Start with Libra.",
    ["node_tempered_name"] = "Tempered",
    ["node_tempered"] = {
        "When you enter a room with monsters, lose 30% of the current berserk charge.",
        "Gain tears for the current room based on the lost charge.",
        "If Absolute Rage is allocated, +30% tears while berserk."
    },
    ["node_violentmarauder_name"] = "Violent Marauder",
    ["node_violentmarauder"] = {
        "Start with Suplex!.",
        "Suplex! can only be used while berserk.",
        "Using Suplex! while berserk is about to end removes it for the rest of the current floor."
    },
    ["node_absoluterage_name"] = "Absolute Rage",
    ["node_absoluterage"] = {
        "You are now berserk by default, and dealing damage reduces berserk's duration.",
        "Once berserk runs out, passively gain berserk charge.",
        "{{berserkDmg}}% damage while berserk.",
        "{{berserkSpeed}}% speed while berserk.",
        "-30% tears while berserk.",
        "If you obtain Birthright, halve the damage and speed reduction while berserk, and halve",
        "the rate at which berserk's duration runs out on hit."
    },

    ["node_tsamsonmeleedmg_name"] = "Melee Damage",
    ["node_tsamsonmeleedmg"] = {
        "+{{meleeDmg}}% melee damage.",
        "{{nonMeleeDmg}}% non-melee damage."
    },
    ["node_berserkonhitcharge_name"] = "Berserk On-Hit Charge Gain",
    ["node_berserkonhitcharge"] = "When hitting enemies, gain an additional {{berserkHitChargeGain}}% berserk charge.",
    ["node_berserkdur_name"] = "Berserk Duration",
    ["node_berserkdur"] = "+{{berserkDuration}} seconds to total berserk duration.",
    ["node_berserkdmgvsdur_name"] = "Berserk Damage Vs Duration",
    ["node_berserkdmgvsdur"] = {
        "+{{berserkDmg}}% damage during berserk.",
        "{{berserkDuration}} seconds to berserk duration."
    },
    ["node_suplexcd_name"] = "Suplex Cooldown",
    ["node_suplexcd"] = "{{suplexCooldown}} seconds to Suplex's cooldown.",
    ["node_berserkcharsize_name"] = "Berserk Character Size",
    ["node_berserkcharsize"] = {
        "+{{berserkSize}}% character size while berserk.",
        "(Suplex! damage increases with character size)"
    },
    ["node_berserkkilltempheart_name"] = "Berserk Kill Vanishing Heart Drop",
    ["node_berserkkilltempheart"] = "{{berserkKillTempHeart}}% chance for enemies to drop a 1/2 red heart on kill while berserk, which vanishes after 2 seconds.",
    ["node_redheartpickupluck_name"] = "Red Heart Pickup Luck",
    ["node_redheartpickupluck"] = {
        "{{redHeartLuckSamson}}% chance to gain +0.03 luck when picking up red hearts, up to +1 per floor.",
        "Triple the chance for vanishing red hearts."
    },
    ["node_berserkspeedtrade_name"] = "Berserk Speed Tradeoff",
    ["node_berserkspeedtrade"] = {
        "+{{berserkSpdTradeoff}}% speed while not berserk.",
        "-0.0{{berserkSpdTradeoff}} maximum speed while berserk"
    },


    -- T. AZAZEL'S TREE --
    ["node_curseborne_name"] = "Curseborne",
    ["node_curseborne"] = {
        "When entering a room with monsters, apply Hemoptysis' curse to 1 random enemy for every 0.8 tears",
        "stat you have.",
        "Affects at least 1 monster.",
        "{{tears}} tears."
    },
    ["node_gildedregrowth_name"] = "Gilded Regrowth",
    ["node_gildedregrowth"] = {
        "Start with a smelted golden Bat Wing.",
        "Gain demon wings if you kill 5 marked enemies in the current room.",
        "-0.1 speed while you don't have flight."
    },
    ["node_brimsoul_name"] = "Brimsoul",
    ["node_brimsoul"] = {
        "Gain Brimstone while you have exactly 2 total black hearts.",
        "Lose Brimstone while this condition is not met.",
        "{{brimstoneDmg}}% damage while you have Brimstone.",
        "Brimstone can no longer show up naturally."
    },
    ["node_darkbestowal_name"] = "Dark Bestowal",
    ["node_darkbestowal"] = {
        "Every 20 cursed enemies killed, gain a random passive devil pool item.",
        "Can only trigger once per room, and stops counting kills until you lose the granted item.",
        "Lose the granted item after clearing 3 rooms while holding it."
    },

    ["node_hemoptysis_slow_name"] = "Hemoptysis Slow Chance",
    ["node_hemoptysis_slow"] = "{{hemoptysisSlowChance}}% chance to slow enemies for 2 seconds when hitting them with Hemoptysis.",
    ["node_cursedkilltears_name"] = "Cursed Enemy Kill Tears",
    ["node_cursedkilltears"] = "{{cursedKillTears}}% chance to gain +0.01 tears for the current floor when killing cursed enemies, up to +1.",
    ["node_proximitydmg_name"] = "Proximity Damage",
    ["node_proximitydmg"] = "+{{proximityDamage}}% damage dealt to enemies, which falls off the further they are.",
    ["node_hemoptysis_speed_name"] = "Hemoptysis Speed",
    ["node_hemoptysis_speed"] = "+{{hemoptysisSpeed}}% speed for 1 second after hitting enemies with Hemoptysis.",
    ["node_brimstonedmg_name"] = "Brimstone Damage",
    ["node_brimstonedmg"] = "+{{brimstoneDmg}}% damage while you have Brimstone.",
    ["node_flightlessdevildeal_name"] = "Flightless Free Devil Deal Chance",
    ["node_flightlessdevildeal"] = "{{flightlessDevilDeal}}% chance for devil deals to be free while you don't have flight.",
    ["node_hemoptysisluck_name"] = "Hemoptysis Kill Luck",
    ["node_hemoptysisluck"] = {
        "{{hemoptysisKillLuck}}% chance to gain +0.03 luck when killing enemies with Hemoptysis.",
        "Double the chance while you have flight."
    },


    -- T. LAZARUS' TREE --
    ["node_ephemeralbond_name"] = "Ephemeral Bond",
    ["node_ephemeralbond"] = {
        "+{{ephemeralBond}} Ephemeral Bond.",
        "When entering a floor, for each Ephemeral Bond, copy a random passive item you",
        "currently have to your opposite form.",
        "Copied items are removed when entering the next floor."
    },
    ["node_greatoverlap_name"] = "Great Overlap",
    ["node_greatoverlap"] = {
        "Clearing a room without taking damage restores an additional charge of Flip.",
        "30% chance to keep 2 charges of Flip on use. If charges aren't kept by this, roll a 50%",
        "chance to keep 1 charge instead.",
        "Taking damage has a 50% chance to remove 1 charge from Flip."
    },
    ["node_entanglement_name"] = "Entanglement",
    ["node_entanglement"] = {
        "Tainted Lazarus and Dead Tainted Lazarus' stats become the average between the two.",
        "+{{allstatsPerc}}% all stats.",
        "When you receive fatal damage, trigger Flip instead of dying, and set the resulting form's",
        "health to a 1/2 soul heart. This can only trigger once per run."
    },
    ["node_spiritus_name"] = "Spiritus",
    ["node_spiritus"] = {
        "Completing a floor without taking damage grants you Birthright for the next floor.",
        "Birthright can no longer show up naturally."
    },

    ["node_ephemeralbondboss_name"] = "Ephemeral Bond On Hitless Boss",
    ["node_ephemeralbondboss"] = {
        "When entering a floor, {{ephBondBossHitless}}% chance to gain 1 Ephemeral Bond if you defeated the last floor's",
        "boss without taking damage.",
        "Gained Ephemeral Bond lasts until next floor."
    },
    ["node_floorephbond_name"] = "Floor Ephemeral Bond",
    ["node_floorephbond"] = "When entering a floor, {{ephBondFloor}}% chance to gain 1 Ephemeral Bond for the current floor.",
    ["node_flipbosshitcharge_name"] = "Flip Boss Hit Charge Recovery",
    ["node_flipbosshitcharge"] = "{{flipBossHitCharge}}% chance to recover 1 charge of Flip when hitting a Boss.",
    ["node_flipspecialroomcharge_name"] = "Flip Special Room Charge",
    ["node_flipspecialroomcharge"] = "{{flipSpecialRoomCharge}}% chance to fully charge Flip when first entering a treasure, shop, devil or angel room.",
    ["node_flipmobhpdown_name"] = "Monster HP Down On Flip",
    ["node_flipmobhpdown"] = "-{{flipMobHPDown}}% to all room monsters' hp when using Flip, up to 4 times per room.",
    ["node_floorwoodchest_name"] = "Wooden Chest On Floor",
    ["node_floorwoodchest"] = {
        "{{floorWoodenChest}}% chance to spawn a wooden chest when entering a floor.",
        "Doesn't trigger on the first floor."
    },
    ["node_formstatupkill_name"] = "Form Stat Up On Kills",
    ["node_formstatupkill"] = {
        "+{{lazFormKillStat}}% to a random stat for the current form, every 8 kills with the current form.",
        "Resets every floor.",
        "Triggers up to 8 times per floor."
    },
    ["node_formhpdiffluck_name"] = "Form Heart Difference Luck",
    ["node_formhpdiffluck"] = {
        "+{{formHeartDiffLuck}} luck for every 1/2 heart difference between the two forms, up to +2.",
        "Counts total hearts of any type."
    },


    -- T. EDEN'S TREE --
    ["node_serendipitoussoul_name"] = "Serendipitous Soul",
    ["node_serendipitoussoul"] = {
        "Start with Eden's Soul.",
        "Eden's Soul cannot be re-rolled, and you cannot grab other active items while holding it.",
        "Empty Eden's Soul's charges when hit.",
        "When using Eden's Soul, gain Birthright if you don't currently have it.",
        "While holding Birthright, using any active item has a {{birthrightActiveRemoveChance}}% chance of removing it.",
        "Birthright can no longer show up naturally."
    },
    ["node_blessedcrucifix_name"] = "Blessed Crucifix",
    ["node_blessedcrucifix"] = {
        "Start with a smelted Wooden Cross.",
        "When you receive fatal damage while having a Wooden Cross (smelted or otherwise),",
        "block the incoming hit and remove one Wooden Cross."
    },
    ["node_normalizedvitality_name"] = "Normalized Vitality",
    ["node_normalizedvitality"] = {
        "When entering a floor:",
        "  - If you have less than 3 red hearts, gain a red heart container.",
        "  - If you have more than 5 red hearts, lose a red heart container.",
        "  - If you have less than 2 soul/black hearts, gain a soul heart.",
        "  - If you have more than 4 soul/black hearts, lose a soul/black heart.",
        "  - If you have broken hearts, remove one.",
    },
    ["node_chaostaketheworld_name"] = "Chaos Take The World",
    ["node_chaostaketheworld"] = {
        "Start with Chaos as an innate effect.",
        "Getting hit triggers the effect of D10, once per room.",
        "Using an active item with at least 2 charges additionally triggers the effect of Dead Sea Scrolls."
    },

    ["node_itemrerollavoid_name"] = "Item Reroll Avoidance",
    ["node_itemrerollavoid"] = "{{rerollAvoidance}}% chance to not reroll items when hit by monsters.",
    ["node_devilactiveonhit_name"] = "Devil Active On Hit",
    ["node_devilactiveonhit"] = "{{devilActiveOnHit}}% chance to trigger a random active item effect from the Devil item pool when hit, once per room.",
    ["node_angelactiveonhit_name"] = "Angel Active On Hit",
    ["node_angelactiveonhit"] = "{{angelActiveOnHit}}% chance to trigger a random active item effect from the Angel item pool when hit, once per room.",
    ["node_birthrightactiverem_name"] = "Birthright Removal Chance",
    ["node_birthrightactiverem"] = "{{birthrightActiveRemoveChance}}% chance to remove Birthright when using an active item.",
    ["node_shieldactivestat_name"] = "Shield Active Stat",
    ["node_shieldactivestat"] = {
        "+{{shieldActiveStat}}% to a random stat when using an active item while having a holy mantle or wooden cross",
        "shield and there are monsters in the room, once per room.",
        "Resets every floor."
    },
    ["node_treasureitemonhit_name"] = "Treasure Item On Hit",
    ["node_treasureitemonhit"] = {
        "When hit, {{treasureItemOnHit}}% chance to gain a random passive item from the treasure room pool for the current",
        "room as an innate effect, excluding HP up items and items you already have.",
        "This effect can only trigger once per room."
    },
    ["node_higherqualreroll_name"] = "Higher Quality Reroll Chance",
    ["node_higherqualreroll"] = {
        "When items are re-rolled, {{higherQualityReroll}}% chance to additionally reroll one of the resulting items into an item",
        "that's 1 quality higher.",
        "This effect can only trigger up to 5 times per floor."
    },
    ["node_minluck_name"] = "Minimum Luck",
    ["node_minluck"] = {
        "+{{minLuck}} minimum luck.",
        "Requires allocating the \"Base Minimum Luck\" node to have any effect."
    },
    ["node_baseminluck_name"] = "Base Minimum Luck",
    ["node_baseminluck"] = "Your minimum luck is now {{minLuck}}.",


    -- T. LOST'S TREE --
    ["node_glass_specter_name"] = "Glass Specter",
    ["node_glass_specter"] = {
        "+{{damage}} speed and damage.",
        "Your speed becomes a damage multiplier when above 1.",
        "Halve the damage bonus while having a shield.",
        "Every 4 rooms cleared while having any type of shield, remove all shields.",
        "You no longer start with a Holy Card."
    },
    ["node_helpinghands_name"] = "Helping Hands",
    ["node_helpinghands"] = {
        "Devil/Angel rooms have a 50% chance of containing an additional Holy Card if you're not",
        "currently holding one.",
        "Picking up a Holy Card removes all other items in Devil/Angel rooms.",
        "Picking up an item or deal in Devil/Angel rooms removes all dropped Holy Cards.",
        "When defeating Mom, spawn a Holy Card if you're not currently holding one.",
        "You can now stack Holy Cards by picking more up while holding one."
    },
    ["node_deferredaegis_name"] = "Deferred Aegis",
    ["node_deferredaegis"] = {
        "Completing an entire floor without using more than 1 Holy Card grants you a holy mantle shield.",
        "If Glass Specter is allocated, increase its shield removal delay by another 4 rooms."
    },
    ["node_spindown_name"] = "Spin-down",
    ["node_spindown"] = {
        "Start with Spindown Dice.",
        "Remove Spindown Dice after using it twice.",
        "-0.05 speed for each affected item in the room when using Spindown Dice, up to a total -0.35."
    },

    ["node_qual0upg_name"] = "Quality 0 Upgrade",
    ["node_qual0upg"] = {
        "When first entering a room, {{quality0Upgrade}}% chance to reroll quality 0 items into a random quality 1 item",
        "of the same pool.",
        "Quality upgrade nodes only proc once depending on the item's initial quality."
    },
    ["node_qual1upg_name"] = "Quality 1 Upgrade",
    ["node_qual1upg"] = {
        "When first entering a room, {{quality1Upgrade}}% chance to reroll quality 1 items into a random quality 2 item",
        "of the same pool.",
        "Quality upgrade nodes only proc once depending on the item's initial quality."
    },
    ["node_qual2upg_name"] = "Quality 2 Upgrade",
    ["node_qual2upg"] = {
        "When first entering a room, {{quality2Upgrade}}% chance to reroll quality 2 items into a random quality 3 item",
        "of the same pool.",
        "Quality upgrade nodes only proc once depending on the item's initial quality."
    },
    ["node_roomenterspeed_name"] = "Room Enter Speed",
    ["node_roomenterspeed"] = "+{{roomEnterSpd}}% speed when entering a room with monsters, which decays to 0 over 4 seconds.",
    ["node_speed_decaydur_name"] = "Speed Decay Duration",
    ["node_speed_decaydur"] = "+{{roomEnterSpdDecayDur}} seconds to the speed decay timer.",
    ["node_shieldlessboss_speed_name"] = "Shieldless Boss Speed",
    ["node_shieldlessboss_speed"] = {
        "+{{shieldlessBossSpeed}} speed for the next floor if you clear the boss room without having or receiving shields",
        "at any point in the fight."
    },
    ["node_champholycard_name"] = "Champion Holy Card Drop",
    ["node_champholycard"] = "{{champHolyCardDrop}}% chance for champion monsters to drop a Holy Card on death, once every 2 floors.",
    ["node_stairwayboon_name"] = "Stairway Boon",
    ["node_stairwayboon"] = {
        "{{stairwayBoon}}% chance to receive The Stairway when clearing a boss room.",
        "Getting hit halves the total chance for this effect to trigger, even if shields are present.",
        "Entering a devil/angel room halves the total chance for this effect to trigger.",
        "Remove The Stairway once it triggers when entering a floor."
    },
    ["node_deathtrial_name"] = "Death's Trial",
    ["node_deathtrial"] = {
        "When receiving a fatal blow at or past the 4th floor you enter, {{deathTrial}}% chance to trigger Forget Me Now's effect instead of dying.",
        "After this happens:",
        "  - Spawn Death. Death receives 66% less damage during this fight.",
        "  - Lose all holy cards and present shields.",
        "This effect can only trigger once per run.",
    },
    ["node_holycardluck_name"] = "Holy Card Luck",
    ["node_holycardluck"] = "+{{holyCardLuck}} luck for the current floor when using a Holy Card.",


    -- T. LILITH'S TREE --
    ["node_chargingbehemoth_name"] = "Charging Behemoth",
    ["node_chargingbehemoth"] = {
        "Deal {{whipDmg}}% increased damage with the whip attack.",
        "Enemies hit by the whip attack are slowed for 1 second.",
        "{{tearsPerc}}% tears.",
        "{{nonWhipDmg}}% damage with non-whip hits."
    },
    ["node_mightygestation_name"] = "Mighty Gestation",
    ["node_mightygestation"] = {
        "Start with a smelted Baby-Bender.",
        "+{{tearsPerc}}% tears.",
        "+{{nonWhipDmg}}% non-whip damage.",
        "{{whipDmg}}% damage with the whip attack."
    },
    ["node_coordinated_demons_name"] = "Coordinated Demons",
    ["node_coordinated_demons"] = {
        "While firing, periodically trigger a pulse around Gello dealing 70% of your damage to nearby enemies.",
        "Delay between pulses is based on your tears stat.",
        "After retracting Gello, waiting 2 seconds increases the damage of your next whip attack by 30%.",
        "-0.15 speed while firing."
    },
    ["node_chimericamalgam_name"] = "Chimeric Amalgam",
    ["node_chimericamalgam"] = {
        "Every 2 floors, spawn Birthright in the first room if you don't currently have it.",
        "When obtaining Birthright, turn all your current familiar items into Lil Delirium.",
        "When obtaining Birthright, receive -40% damage.",
        "While holding Birthright, +8% damage when entering a new floor, up to a total +50%.",
        "Birthright can no longer show up naturally."
    },

    ["node_whipdmgvstears_name"] = "Whip Damage Vs Tears",
    ["node_whipdmgvstears"] = {
        "+{{whipDmg}}% whip attack damage.",
        "{{tearsPerc}}% tears."
    },
    ["node_tlilith_pulsedmg_name"] = "Pulse Damage",
    ["node_tlilith_pulsedmg"] = "Damaging pulse inherits an additional {{gelloPulseDmg}}% of your damage.",
    ["node_pulsekillblackheart_name"] = "Black Heart On Pulse Kill",
    ["node_pulsekillblackheart"] = {
        "Enemies killed by the damaging pulse have a {{pulseKillBlackHeart}}% chance to drop a black heart, if you have",
        "less than 2 black hearts, up to once per room.",
        "Black heart dropped from this effect vanish after 3 seconds."
    },
    ["node_whipspeedbuff_name"] = "Whip Speed Buff",
    ["node_whipspeedbuff"] = "+{{whipSpeed}}% speed for 1 second after using the whip attack.",
    ["node_gellotearbonus_name"] = "Gello Tears Bonus",
    ["node_gellotearbonus"] = {
        "Slowly gain up to +{{gelloTearsBonus}} tears while Gello is retracted.",
        "While firing, bonus decays to 0 over 3 seconds."
    },
    ["node_cord_dmg_name"] = "Cord Damage",
    ["node_cord_dmg"] = {
        "While Gello is held out, deal {{cordDamage}}% of your damage to enemies caught in the cord every second.",
        "{{cordBleed}}% chance to inflict bleed for 4 seconds on caught enemies."
    },
    ["node_treasurefamiliar_name"] = "Treasure Room Familiar",
    ["node_treasurefamiliar"] = {
        "While not holding Birthright, {{tLilithTreasureBaby}}% chance to replace non-progression treasure room items",
        "with a random baby familiar."
    },
    ["node_nearbykill_luck_name"] = "Nearby Kill Luck",
    ["node_nearbykill_luck"] = {
        "{{nearbyKillLuck}}% chance to gain +0.03 luck when killing enemies within 1.5 tiles of you.",
        "Halve the total bonus when entering a new floor."
    },
    ["node_famitemallstat_name"] = "Familiar Items - All Stats",
    ["node_famitemallstat"] = "+{{familiarItemAllstats}}% all stats per familiar item obtained.",


    -- T. KEEPER'S TREE --
    ["node_fortunatespender_name"] = "Fortunate Spender",
    ["node_fortunatespender"] = {
        "+1.5 luck for the current floor while you haven't purchased items.",
        "+0.02 luck per coin spent on purchases, up to a total +3.",
        "When entering a floor, -0.5 luck if you made less than 4 purchases in the previous floor.",
        "Luck reduction doesn't apply during the Ascent."
    },
    ["node_marquessofflies_name"] = "Marquess Of Flies",
    ["node_marquessofflies"] = {
        "Whenever you gain coins, 50% chance to spawn a blue fly if you have less than 20 blue flies.",
        "Whenever a coin heals you, 20% chance to gain Hive Mind for the current room if you don't",
        "have it.",
        "Increase damage dealt by blue flies by 1% per coin you own, up to 50%.",
        "-1% speed and tears per active blue fly."
    },
    ["node_strangecoupon_name"] = "Strange Coupon",
    ["node_strangecoupon"] = {
        "Start with Coupon.",
        "Whenever you gain charges with Coupon, {{couponNullifyChance}}% chance to nullify the gained charges.",
        "After using Coupon a total of 4 times, replace it with Steam Sale.",
        "Purchasing 4 items while holding Steam Sale removes it."
    },
    ["node_blessedpennies_name"] = "Blessed Pennies",
    ["node_blessedpennies"] = {
        "Shops have a 25% chance to sell an additional penny trinket, at twice its regular price.",
        "When defeating a floor's boss, if you took no damage in the rest of the floor, smelt your",
        "currently held penny trinkets, if present.",
        "Spawn a penny when a penny trinket gets smelted this way.",
        "When hit, 20% chance to lose held penny trinkets (not smelted)."
    },
    ["node_voodootrick_name"] = "Voodoo Trick",
    ["node_voodootrick"] = {
        "Completing a floor without getting hit more than 3 times grants you Voodoo Head for the next floor.",
        "Voodoo Head can no longer show up naturally."
    },

    ["node_tempcointimer_name"] = "Vanishing Coins Time",
    ["node_tempcointimer"] = "+{{vanishCoinTimer}} seconds to vanishing coins' timer.",
    ["node_cointearchance_name"] = "Coin Tears Chance",
    ["node_cointearchance"] = {
        "{{coinTearsChance}}% chance for fired tears to be coin tears from Head of the Keeper.",
        "If total chance is above 40%, Head of the Keeper can no longer show up.",
        "Coin tears deal 10% increased damage against gilded monsters."
    },
    ["node_gildmobpennydrop_name"] = "Gilded Monster Penny Drop",
    ["node_gildmobpennydrop"] = "{{gildMonsterPenny}}% chance for Gilded monsters to drop an additional non-vanishing penny on death.",
    ["node_gildmobluck_name"] = "Gilded Monster Luck",
    ["node_gildmobluck"] = "{{gildMonsterLuck}}% chance to gain +0.05 luck for the current floor when killing a Gilded monster.",
    ["node_gildmobspeed_name"] = "Gilded Monster Speed Buff",
    ["node_gildmobspeed"] = "+{{gildMonsterSpeed}}% speed for the current room when killing a Gilded monster.",
    ["node_gildmobpennyupg_name"] = "Gilded Monster Penny Trinket Upgrade",
    ["node_gildmobpennyupg"] = {
        "{{gildMonsterPennyUpgrade}}% chance to upgrade 1 held penny trinket into its golden version when killing a",
        "Gilded monster."
    },
    ["node_gildmobs_name"] = "Gilded Monsters",
    ["node_gildmobs"] = "{{gildMonsters}}% chance for room monsters to be Gilded. Cannot affect bosses.",
    ["node_voodoocursenickel_name"] = "Voodoo Curse Room Nickel",
    ["node_voodoocursenickel"] = "While holding Voodoo Head, {{voodooCurseNickel}}% chance for curse rooms to contain an additional nickel.",
    ["node_couponchargenull_name"] = "Coupon Charge Nullification Chance",
    ["node_couponchargenull"] = "{{couponNullifyChance}}% chance to nullify gained charges with Coupon.",
    ["node_blueflydmg_name"] = "Blue Fly Damage",
    ["node_blueflydmg"] = "+{{blueFlyDamage}}% damage dealt by blue flies.",
    ["node_steamsalekeep_name"] = "Steam Sale Keep Chance",
    ["node_steamsalekeep"] = "{{steamSaleKeep}}% chance to keep Steam Sale when purchasing more than 4 items while holding it.",


    -- T. APOLLYON'S TREE --
    ["node_electrifiedswarm_name"] = "Electrified Swarm",
    ["node_electrifiedswarm"] = {
        "Start with a smelted Extension Cord.",
        "Tears fired by locusts have a 33% chance to be electrified.",
        "Extension Cord beams deal 33% less damage."
    },
    ["node_closekeeper_name"] = "Close Keeper",
    ["node_closekeeper"] = {
        "Locusts follow you much more closely.",
        "+2% damage received by enemies per locust near it, up to 20%."
    },
    ["node_carrionlocusts_name"] = "Carrion Locusts",
    ["node_carrionlocusts"] = {
        "+1% to a random stat whenever a locust kills an enemy, up to +12% of each stat.",
        "For every 20 enemies killed by locusts, gain a random smelted Locust trinket you",
        "don't currently have.",
        "Entering a floor halves your current bonuses and removes smelted Locust trinkets."
    },
    ["node_greatdevourer_name"] = "Great Devourer",
    ["node_greatdevourer"] = {
        "You can now only have up to 1 locust.",
        "Whenever you would have gained a locust, instead add +8% damage and speed to the existing locust,",
        "up to a total 200%.",
        "Double extension cord beam damage if it targets a locust.",
        "Triple your total chance for locusts to fire tears, and these inherit an additional {{locustTearDmgInherit}}%",
        "of your damage.",
        "If Electrified Swarm is allocated, locust tears are always electrified."
    },

    ["node_extensioncorddmg_name"] = "Extension Cord Beam Damage",
    ["node_extensioncorddmg"] = "Extension Cord beams deal an additional {{extCordDmgInherit}}% of your damage if they target a locust.",
    ["node_extensioncordslow_name"] = "Extension Cord Beam Slow",
    ["node_extensioncordslow"] = "{{extCordSlow}}% chance for Extension Cord beams to slow enemies for 2 seconds on hit if they target a locust.",
    ["node_locusttears_name"] = "Locust Tears",
    ["node_locusttears"] = {
        "1.5% chance for locusts to shoot a small tear towards enemies close to them whenever you shoot.",
        "Locust tears deal a base 20% of your damage."
    },
    ["node_locustteardmg_name"] = "Locust Tear Damage",
    ["node_locustteardmg"] = "Locust tears gain an additional {{locustTearDmgInherit}}% of your damage.",
    ["node_locustlostcontact_name"] = "Locust Lost Contact Tears",
    ["node_locustlostcontact"] = "{{locustTearSpectral}}% chance for tears fired by locusts to be spectral and piercing.",
    ["node_locustkillpickup_name"] = "Locust Kill Pickup Drop",
    ["node_locustkillpickup"] = {
        "{{locustKillPickup}}% chance for enemies killed by locusts to drop an additional coin/key/bomb, up to twice",
        "per room."
    },
    ["node_locustkilltears_name"] = "Locust Kill Tear Boost",
    ["node_locustkilltears"] = "+{{locustKillTears}}% tears for 2 seconds when a locust kills an enemy.",
    ["node_cricketlegonkill_name"] = "Cricket Leg On Kill",
    ["node_cricketlegonkill"] = "{{killCricketLeg}}% chance to gain a smelted Cricket Leg for the current room when you kill an enemy.",
    ["node_cricketlegspeed_name"] = "Cricket Leg Speed",
    ["node_cricketlegspeed"] = "+{{cricketLegSpeed}}% speed while you have Cricket Leg.",
    ["node_locustdmg_name"] = "Locust Damage",
    ["node_locustdmg"] = "+{{locustDmg}}% damage dealt by locusts.",
    ["node_locustkill_luck_name"] = "Locust Kill Luck",
    ["node_locustkill_luck"] = {
        "{{locustKillLuck}}% chance to gain +0.04 luck when a locust kills an enemy.",
        "Halve your total bonus when entering a new floor."
    },


    -- T. FORGOTTEN'S TREE --
    ["node_recall_name"] = "Recall!",
    ["node_recall"] = {
        "Start with Birthright.",
        "+0.4 seconds to Recall's cooldown on use, up to +4.",
        "Reset Recall's cooldown when entering a new floor.",
        "Birthright can no longer show up naturally."
    },
    ["node_harmonizedspecters_name"] = "Harmonized Specters",
    ["node_harmonizedspecters"] = {
        "+8% damage dealt by Tainted Forgotten while on the floor.",
        "+8% damage dealt by Tainted Forgotten to enemies near Tainted Soul.",
        "+8% damage dealt by Tainted Forgotten while a friendly Bony (any variant) is present."
    },
    ["node_ballistosseous_name"] = "Ballistosseous",
    ["node_ballistosseous"] = {
        "Tainted Forgotten shoots homing bone tears towards Tainted Soul while on the ground, if",
        "there are monsters in the room.",
        "While holding Tainted Forgotten, fire bone tears towards nearby enemies instead, at 40%",
        "fire rate.",
        "Bone tears deal 50% of your damage on hit."
    },
    ["node_magnetizedshell_name"] = "Magnetized Shell",
    ["node_magnetizedshell"] = {
        "Start with Strange Attractor.",
        "{{speedPerc}}% speed.",
        "+2% speed for the current room when killing an enemy near Tainted Forgotten, up to +20%."
    },

    ["node_forgholdspeed_name"] = "Held Forgotten Speed Boost",
    ["node_forgholdspeed"] = "+{{forgHoldSpeed}}% speed while holding Tainted Forgotten.",
    ["node_forgboneteardmg_name"] = "Forgotten Bone Tear Damage",
    ["node_forgboneteardmg"] = "Tainted Forgotten's bone tears gain an additional {{forgBoneTearDmg}}% of your damage.",
    ["node_forgbonetearpara_name"] = "Forgotten Bone Tear Paralysis",
    ["node_forgbonetearpara"] = "{{forgBoneTearPara}}% chance for Tainted Forgotten's bone tears to paralyze enemies for 1 second on hit.",
    ["node_forgbonetearslow_name"] = "Forgotten Bone Tear Speed Debuff",
    ["node_forgbonetearslow"] = "{{forgBoneTearSlow}}% chance for Tainted Forgotten's bone tears to slow enemies on hit for 2 seconds.",
    ["node_paramobdmg_name"] = "Paralyzed Enemy Damage",
    ["node_paramobdmg"] = "+{{paraEnemyDmg}}% damage received by paralyzed enemies.",
    ["node_recalldmg_name"] = "Recall Damage Buff",
    ["node_recalldmg"] = "+{{recallDmg}}% damage for 2 seconds after using Recall.",
    ["node_forgtele_name"] = "Forgotten Launch Telekinesis",
    ["node_forgtele"] = "{{forgTelekinesis}}% chance to trigger Telekinesis' effect when launching Tainted Forgotten.",
    ["node_forgbonetearluck_name"] = "Forgotten Bone Tear Kill Luck",
    ["node_forgbonetearluck"] = {
        "{{forgBoneTearKillLuck}}% chance to gain +0.03 luck when Tainted Forgotten's bone tears kill an enemy.",
        "Halve your total bonus when entering a new floor."
    },


    -- T. BETHANY'S TREE --
    ["node_bloodharvest_name"] = "Blood Harvest",
    ["node_bloodharvest"] = {
        "Killing an enemy with at least 12 HP has a 25% chance of dropping a 1/2 red heart, which",
        "vanishes after 3 seconds, up to 6 per room.",
        "Hitting a boss has a 7% chance of dropping a 1/2 red heart, which vanishes after 3 seconds,",
        "up to 4 per room.",
        "These chances are reduced by 0.3% per blood charge past 30."
    },
    ["node_resilientflickers_name"] = "Resilient Flickers",
    ["node_resilientflickers"] = {
        "Lemegeton wisps take 60% reduced damage.",
        "Lemegeton wisps deal 35% increased contact damage.",
        "Fully heal a wisp when it kills an enemy with contact damage.",
        "-0.03 luck per active wisp past 5."
    },
    ["node_othersideseeker_name"] = "Otherside Seeker",
    ["node_othersideseeker"] = {
        "Start with 3 smelted Crystal Keys.",
        "Defeating Mom without taking damage grants you an additional smelted Crystal Key.",
        "+1% all stats for the current floor when clearing a red room, up to +10%."
    },
    ["node_inheritedchaos_name"] = "Inherited Chaos",
    ["node_inheritedchaos"] = {
        "When entering a floor, spawn a Chaos wisp if you don't currently have one.",
        "Chaos wisps receive 200% more damage when hit.",
        "-3% all stats whenever a Chaos wisp is destroyed, up to -12%."
    },

    ["node_redheartroomdmg_name"] = "Red Heart Room Damage",
    ["node_redheartroomdmg"] = "+{{redHeartRoomDmg}}% damage for the current room when picking up a red heart, up to +15%.",
    ["node_wisptearretal_name"] = "Wisp Homing Tear Retaliation",
    ["node_wisptearretal"] = {
        "{{wispHomingTearRetal}}% chance for Wisps to fire a homing tear away from you when they get hit.",
        "These tears deal 5 damage."
    },
    ["node_wispactivehomtears_name"] = "Wisp Active Homing Tears",
    ["node_wispactivehomtears"] = {
        "{{wispActiveTears}}% chance for Wisps to fire a small homing tear towards you when using an active item.",
        "These tears deal 30% of your damage + an additional 2 damage per used charge."
    },
    ["node_destroywispitem_name"] = "Destroyed Wisp Item",
    ["node_destroywispitem"] = "{{destroyedWispItem}}% chance to gain a destroyed wisp's item for the rest of the floor.",
    ["node_bluekeyonred_name"] = "Blue Key On Red Clear",
    ["node_bluekeyonred"] = {
        "{{blueKeyRedClear}}% chance to gain a smelted Blue Key for the current floor when clearing a red room, if",
        "you don't already have one."
    },
    ["node_bloodchargestat_name"] = "Stat Boost On Blood Charge",
    ["node_bloodchargestat"] = "{{bloodChargeStat}}% chance to gain +0.4% to a random stat per consumed blood charge, up to 30 times per floor.",
    ["node_wispkillsoul_name"] = "Wisp Kill Soul Heart",
    ["node_wispkillsoul"] = {
        "{{wispKillSoul}}% chance for enemies killed by Wisps or their tears to drop a 1/2 soul heart if you have",
        "less than 3 soul hearts, up to 4 per room."
    },
    ["node_homingtearfirereq_name"] = "Homing Tear Firing Time Requirement",
    ["node_homingtearfirereq"] = {
        "{{tBethHomingTear}} seconds to Coalescing Homing Tear's total firing time required.",
        "{{tBethHomingTearFear}}% chance for the shot tear to cause fear on enemies it hits."
    },
    ["node_coalescinghomtear_name"] = "Coalescing Homing Tear",
    ["node_coalescinghomtear"] = {
        "Every {{tBethHomingTear}} total seconds spent firing, shoot an additional piercing and homing tear that deals",
        "150% of your damage."
    },
    ["node_tbethkill_luck_name"] = "Luck On Kill",
    ["node_tbethkill_luck"] = {
        "{{tBethKillLuck}}% chance to gain +0.03 luck when killing enemies while you have 1 soul/black heart or less.",
        "Triple the chance and luck gain against bosses."
    },


    -- T. JACOB'S TREE --
    ["node_reaperwraiths_name"] = "Reaper Wraiths",
    ["node_reaperwraiths"] = {
        "Start with Holy Mantle.",
        "Start with an additional eternal heart. Entering a floor grants you an eternal heart if",
        "you don't have one.",
        "When entering a floor, remove all soul/black hearts.",
        "Tainted Jacob now starts in his dead spirit state, and entering a floor no longer revives you.",
        "Dark Esau no longer deals contact damage to you."
    },
    ["node_wrathfulchains_name"] = "Wrathful Chains",
    ["node_wrathfulchains"] = {
        "When Dark Esau is unchained from Anima Sola, all non-boss enemies are slowed for 3 seconds.",
        "Using Anima Sola while Dark Esau is present additionally chains another random enemy in the room.",
        "Enemies chained by Anima Sola receive {{chainedEnemyDmg}}% more damage.",
        "Hitting an enemy chained by Anima Sola deals 40% of the damage to other nearby enemies."
    },
    ["node_spiritualcovenant_name"] = "Spiritual Covenant",
    ["node_spiritualcovenant"] = {
        "Hitting an enemy causes Dark Esau to target it if Tainted Jacob is in the dead spirit state.",
        "Dark Esau's base contact damage is now 200% of your damage stat, capped at 40."
    },
    ["node_kineticvengeance_name"] = "Kinetic Vengeance",
    ["node_kineticvengeance"] = {
        "Dark Esau deals 25% increased damage while charging.",
        "Dark Esau deals 25% reduced damage while not charging."
    },

    ["node_darkesauproxbuff_name"] = "Dark Esau Proximity Buff",
    ["node_darkesauproxbuff"] = {
        "+{{darkEsauProxDmgSpeed}}% speed and damage when near Dark Esau.",
        "Buff lingers for 2 seconds when the condition is no longer met."
    },
    ["node_darkesaudmg_name"] = "Dark Esau Damage",
    ["node_darkesaudmg"] = "+{{darkEsauDmg}}% damage dealt by Dark Esau to monsters.",
    ["node_animasolacd_name"] = "Anima Sola Cooldown",
    ["node_animasolacd"] = "{{animaSolaCooldown}} seconds to Anima Sola's cooldown.",
    ["node_animasolatears_name"] = "Anima Sola Tears Buff",
    ["node_animasolatears"] = "+{{animaSolaKillTears}}% tears for the current floor when killing an enemy chained by Anima Sola, up to +15%.",
    ["node_eternalheartconv_name"] = "Eternal Heart Drop Conversion",
    ["node_eternalheartconv"] = {
        "{{heartEternalConv}}% chance for dropped red heart pickups to be replaced with eternal hearts while Jacob is in his",
        "dead spirit state.",
        "While Jacob is in dead spirit state, eternal hearts act as shields, akin to Holy Cards."
    },
    ["node_slowedmobdmg_name"] = "Slowed Enemies Damage",
    ["node_slowedmobdmg"] = "Slowed enemies receive {{slowEnemyDmg}}% more damage.",
    ["node_animasoladur_name"] = "Anima Sola Duration",
    ["node_animasoladur"] = "+{{animaSolaDuration}}% to Anima Sola's chains duration.",
    ["node_darkesaukill_luck_name"] = "Dark Esau Kill Luck",
    ["node_darkesaukill_luck"] = "{{darkEsauKillLuck}}% chance to gain +0.04 luck for the current floor when Dark Esau kills an enemy.",
    ["node_animasolachains_name"] = "Anima Sola Additional Chaining",
    ["node_animasolachains"] = {
        "{{animaAddChains}}% chance for Anima Sola to chain an additional enemy on use.",
        "Effect rolls multiple times above 100% chance."
    },


    -- T. SIREN'S TREE --
    ["node_soulofthesiren_name"] = "Soul Of The Siren",
    ["node_soulofthesiren"] = {
        "Allocate this to unlock Soul Of The Siren as a soul stone variant.",
        "Requires Boss Rush and Hush completion marks on Tainted Siren.",
        "Soul of the Siren: charm monsters in the room for 10 seconds. For the next 60 seconds,",
        "gain 3 random baby familiars, a smelted Friendship Necklace, and charm monsters for",
        "10 seconds when entering a room."
    },
    ["node_shadowmeld_name"] = "Shadowmeld",
    ["node_shadowmeld"] = {
        "While in a room with monsters, Manifest Melody becomes Shadowmeld.",
        "Shadowmeld creates a marked shadow at your current position.",
        "Re-using Shadowmeld causes you to sink into the shadows then reappear at the marked shadow's",
        "location.",
        "While sinking or reappearing, and for 0.5 seconds afterwards, you can't be damaged.",
        "Press the Drop key to remove placed markers."
    },
    ["node_darkarpeggio_name"] = "Dark Arpeggio",
    ["node_darkarpeggio"] = {
        "Every 4 total seconds spent firing, your Siren Minions fire a homing tear that inflicts fear",
        "on enemies hit."
    },
    ["node_chromaticblessing_name"] = "Chromatic Blessing",
    ["node_chromaticblessing"] = {
        "When successfully summoning a familiar through Manifest Melody, gain stats based on the",
        "used notes:",
        "  - Left: +0.5% speed",
        "  - Right: +0.5% tears",
        "  - Up: +0.5% damage",
        "  - Down: +0.5% range and luck",
        "Each individual buff has a limit of 15%."
    },
    ["node_grandconsonance_name"] = "Grand Consonance",
    ["node_grandconsonance"] = {
        "Whenever you gain a familiar, instead absorb its power and gain an effect based on the familiar.",
        "-4% damage dealt to enemies for each damage-dealing familiar you obtain, up to -48%."
    },
    ["node_songofthefew_name"] = "Song Of The Few",
    ["node_songofthefew"] = {
        "Start with a smelted Forgotten Lullaby.",
        "Once you have at least 2 damage-dealing familiar items, 20% chance to lose a smelted",
        "Forgotten Lullaby when obtaining more familiar items.",
        "This chance increases by 15% per familiar item obtained past 3."
    },
    ["node_chromaticdissonance_name"] = "Chromatic Dissonance",
    ["node_chromaticdissonance"] = {
        "Whenever you first obtain a familiar item, replace it with a different random familiar",
        "of the same quality instead, if possible.",
        "After this effect has been triggered 10 times, obtaining a familiar item removes a",
        "random different familiar item of the same quality."
    },

    ["node_fearedmobdmg_name"] = "Feared Enemy Damage",
    ["node_fearedmobdmg"] = "Feared enemies receive {{fearedDmg}}% more damage.",
    ["node_fearedtearburst_name"] = "Tear Burst On Feared Death",
    ["node_fearedtearburst"] = {
        "{{fearedTearBurst}}% chance for feared enemies to release 3-4 homing tears on death that cause fear.",
        "These tears deal 4% of the killed monster's HP as damage on hit, minimum 3 damage."
    },
    ["node_acridgaze_name"] = "Acrid Gaze",
    ["node_acridgaze"] = {
        "Every 1.5 total seconds spent firing, unleash a pulse that damages and fears nearby enemies",
        "for 2 seconds.",
        "Damage dealt by the pulse is 120% of your luck stat, up to 10.",
        "+{{acridGaze}}% pulse size."
    },
    ["node_sirenminiondmg_name"] = "Siren Minion Damage",
    ["node_sirenminiondmg"] = "{{sirenMinionDmg}}% more damage dealt by your Siren Minions.",
    ["node_darkarpeggiodelay_name"] = "Dark Arpeggio Tear Delay",
    ["node_darkarpeggiodelay"] = "{{darkArpeggioTearDelay}} total seconds required for Siren Minions to fire the Dark Arpeggio tear.",
    ["node_shadowmeldexplosion_name"] = "Shadowmeld Explosion",
    ["node_shadowmeldexplosion"] = {
        "{{shadowmeldExplosion}}% chance to cause a dark explosion when reappearing with Shadowmeld, dealing 100% of your",
        "damage to nearby enemies and fearing them."
    },
    ["node_shadowmelddmg_name"] = "Shadowmeld Explosion Damage",
    ["node_shadowmelddmg"] = "Shadowmeld explosion deals an additional {{shadowmeldExplosionDmg}}% of your damage.",
    ["node_fearedkillblackheart_name"] = "Black Heart On Feared Kill",
    ["node_fearedkillblackheart"] = {
        "{{blackHeartFearKill}}% chance to receive 1/2 a black heart when killing a feared enemy, if you have less than",
        "3 black hearts, up to twice per room."
    },
    ["node_fearedkill_luck_name"] = "Luck On Feared Kill",
    ["node_fearedkill_luck"] = "{{fearedKillLuck}}% chance to gain +0.02 luck when killing a feared enemy, up to a total +3."
}