return {
    ---- EXPEDITIONS ----
    -- UI --
    ["ui_boons"] = "Boons",
    ["ui_boonUpgPoints"] = "Boon upgrade points",
    ["ui_curses"] = "Curses",
    ["ui_deepSpaceSP"] = "Deep-Space Skill Points",
    ["ui_deepSpaceSP_optPlural"] = "Deep-Space skill point(s)",

    ["ui_obolReq"] = "Requires {{obolReq}} Arcane Obols to allocate.",
    ["ui_expDepthReq"] = "Requires completing expedition depth {{depthReq}}.",
    ["ui_uberExpDepthReq"] = "Requires completing uber expedition depth {{depthReq}}.",
    ["ui_charlvlReq"] = "Requires the current character ({{charName}}) to reach level {{lvlReq}}.",
    ["ui_crimsonCoreReq"] = "Requires 1 crimson starcore.",
    ["ui_deepSPReq"] = "Requires 1 Deep-Space Skill Point. (You have {{deepSP}})",
    ["ui_globalSPReq"] = "Requires 1 Global SP to allocate.",
    ["ui_expObjective"] = "Expedition objective",
    ["ui_ExpObjective"] = "Expedition Objective",
    ["ui_holdTabOrderObj"] = "hold TAB for order objectives",
    ["ui_expOrderObjectives"] = "Expedition Order Objectives",
    ["ui_order"] = "order",
    ["ui_Order"] = "Order",
    ["ui_entropy"] = "entropy",
    ["ui_Entropy"] = "Entropy",
    ["ui_expedDepth"] = "Expedition Depth",
    ["ui_expedDepthNum"] = "Expedition depth {{depth}}",
    ["ui_expedSelNode"] = "Selected expedition node.",
    ["ui_expReqCharSelLvl"] = "Selected character level {{reqLvl}}+",
    ["ui_expReqCharSelLvlExtra"] = "{{charName}} level: {{level}}",
    ["ui_expReqStarmight"] = "Starmight required",
    ["ui_expReqStarmightYourTotal"] = "your total",
    ["ui_expReqSocketAncJewel"] = "Socketed Ancient Starcursed Jewel.",
    ["ui_expReqs"] = "Expedition requirements:",
    ["ui_expReqNotMetWarn"] = "Warning: requirements not met! Next run can't be an expedition run.",

    ["ui_impMods"] = "Implicit modifiers:",
    ["ui_dsdMods"] = "Deep-Space Distortion modifiers:",

    ["ui_expNode"] = "Expedition Node",
    ["ui_rewardNode"] = "Reward Node",

    ["ui_expRespecReset"] = "Hold the Respec button for 3 seconds to reset and reroll this expedition.",
    ["ui_expRespecResetCost"] = "Resetting this expedition costs 1 global SP, {{obolCost}} Arcane Obols, and {{respecCost}} Respecs.",
    ["ui_expAllocToQueue"] = "Press Allocate to queue this node for automatic selection.",
    ["ui_expAllocToUnqueue"] = "Press Allocate to remove this and following nodes from the queue.",
    ["ui_expAllocToComp"] = "Press the Allocate button to complete this node and claim its rewards.",
    ["ui_expAllocToSwitch"] = "Press the Allocate button to switch selected node to this one.",
    ["ui_expSwitchingCosts"] = "Switching node selection costs",
    ["ui_expSwitchingWillCost"] = "Switching the selection to a different node afterwards will cost",
    ["ui_expAllocToSelect"] = "Press the Allocate button to select this node.",
    ["ui_expAllocToClaimReward"] = "Press the Allocate button to claim this reward.",
    ["ui_expResetOnClaim"] = "Once claimed, this expedition depth will be reset.",
    ["ui_expAllocToUpgBoon"] = "Press the Allocate button to upgrade this boon.",
    ["ui_expUpgBoonReq"] = "Requires 1 boon upgrade point.",
    ["ui_expItemStart"] = "Start with {{itemName}} in this expedition's runs.",
    ["ui_expCompPrevDepthUnlock"] = "Complete the previous depth level to unlock.",
    ["ui_expNotVisited"] = "Not visited yet.",
    ["ui_expAllocToggleUber"] = "Press Allocate to toggle Uber Expeditions.",
    ["ui_expAllocToggleUber2"] = "These are significantly more difficult expeditions with separate progress.",
    ["ui_expQToToggle"] = "Q / Menu Tab to toggle",
    ["ui_appliedExped"] = "Applied Expedition",
    ["ui_entropyMods"] = "Entropy modifier(s)",
    ["ui_orderMods"] = "Order modifier(s)",
    ["ui_expAttempts"] = "Expedition Attempt(s)",
    ["ui_starblessedPrism"] = "Starblessed Prism",

    ["ui_expRewardAddItem"] = "Add {{itemName}} to this Expedition",
    ["ui_expAddUnkItem"] = "Add shown item to this Expedition",
    ["ui_expRewardCharCrimsonCore"] = "Crimson Starcore with {{charName}}",
    ["ui_expRewardRandStarblessedWep"] = "Random Starblessed Ancient Weapon",
    ["ui_expRewardChoice"] = "Choice between various rewards",
    ["ui_expRewardBoonUpg"] = "Boon upgrade point",

    ["ui_upgAvailable"] = "Upgrade available",

    ["ui_expFinalNodeDesc"] = "Final Node: completing it will reset this expedition and unlock the next depth.",

    ["ui_uberExpeds"] = "Uber Expeditions",
    ["ui_expHoldShiftUberInfo"] = "Hold Shift to get info about these stats.",
    ["ui_uberInfo"] = "Uber Info",
    ["ui_expUberInfo1_v1"] = "At uber depths 5+, node columns are reduced to 7, and final reward is guaranteed",
    ["ui_expUberInfo2_v1"] = "to be a choice between rewards.",
    ["ui_expUberInfo_v2"] = "At uber depths 4+, final reward is guaranteed to be a choice between rewards.",

    ["ui_expUberInfoDesc_v1"] = {
        {"Order acts as a shield against Entropy. Whenever you gain Entropy, it is first deducted", PST.kcolors.TEAL1},
        {"from your Order instead, if you have any.", PST.kcolors.TEAL1},
        {"Entropy increases the difficulty of the expedition at certain intervals, and is gained through", PST.kcolors.RED1},
        {"modifiers within the expedition nodes.", PST.kcolors.RED1},
        {"Every 24 entropy: increase the magnitude of the expedition's implicit modifiers, up to 10 times.", PST.kcolors.RED2},
        {"Every 30 entropy: add a random curse to the expedition, up to 5 times.", PST.kcolors.RED2},
        {"Every 50 entropy: add a random Deep-Space Distortion modifier to the expedition, up to 3 times.", PST.kcolors.RED2},
        {"Deep-Space Distortion mods add a significant amount of challenge to the runs.", PST.kcolors.RED2},
        {"At 100 entropy, max attempts for the expedition is lowered by 1.", PST.kcolors.RED2}
    },
    ["ui_expUberInfoDesc_v2"] = {
        {"Order acts as a shield against Entropy. Whenever you gain Entropy, it is first deducted", PST.kcolors.TEAL1},
        {"from your Order instead, if you have any.", PST.kcolors.TEAL1},
        {"Entropy increases the difficulty of the expedition at certain intervals, and is gained through", PST.kcolors.RED1},
        {"modifiers within the expedition nodes.", PST.kcolors.RED1},
        {"Every 40 entropy: increase the magnitude of the expedition's implicit modifiers, up to 8 times.", PST.kcolors.RED2},
        {"Every 60 entropy: add a random curse to the expedition, up to 5 times.", PST.kcolors.RED2},
        {"Every 75 entropy: add a random Deep-Space Distortion modifier to the expedition, up to 3 times.", PST.kcolors.RED2},
        {"Deep-Space Distortion mods add a significant amount of challenge to the runs.", PST.kcolors.RED2},
        {"At 100 entropy, max attempts for the expedition is lowered by 1.", PST.kcolors.RED2}
    },

    ["ui_expInRunProgEnabled"] = "In run - Progress enabled",
    ["ui_expInRunProgDisabled"] = "In run - Progress disabled",

    -- BOONS --
    ["expboon_wellbeing"] = "Boon of Wellbeing",
    ["expboon_wellbeing_desc"] = "+{{allstatsPerc}}% all stats.",

    ["expboon_dmg"] = "Boon of Damage",
    ["expboon_dmg_desc"] = "+{{damagePerc}}% damage.",

    ["expboon_celerity"] = "Boon of Celerity",
    ["expboon_celerity_desc"] = "+{{speedPerc}}% speed.",

    ["expboon_tears"] = "Boon of Tears",
    ["expboon_tears_desc"] = "+{{tearsPerc}}% tears.",

    ["expboon_range"] = "Boon of Range",
    ["expboon_range_desc"] = "+{{rangePerc}}% range.",

    ["expboon_fortune"] = "Boon of Fortune",
    ["expboon_fortune_desc"] = "+{{luckPerc}}% luck.",

    ["expboon_abundantObols"] = "Boon of Abundant Obols",
    ["expboon_abundantObols_desc"] = "Obols are twice as likely to drop within runs. +{{boonAbundantObols}}% dropped obols.",

    ["expboon_intangibility"] = "Boon of Intangibility",
    ["expboon_intangibility_desc"] = "When hit by a monster, {{boonIntangibility}}% chance for the invincibility frames to last 2.5x as long.",

    ["expboon_mercy"] = "Boon of Mercy",
    ["expboon_mercy_desc"] = {
        "When hitting monsters and bosses affected by any status effect, {{boonMercyChance}}% chance to execute them if",
        "their HP is below {{boonMercyHP}}%.",
        "Hitting a boss halves their current status effect cooldown."
    },

    ["expboon_aegis"] = "Boon of the Aegis",
    ["expboon_aegis_desc"] = "Block the first {{boonAegis}} hits you receive every floor.",

    ["expboon_generosity"] = "Boon of Generosity",
    ["expboon_generosity_desc"] = "The first item or deal you purchase in the run costs 1 coin.",
    ["expboon_generosity_upgdesc"] = "The first {{boonGenerosity}} items or deals you purchase in the run cost 1 coin.",

    ["expboon_protection"] = "Boon of Protection",
    ["expboon_protection_desc"] = "Gain a Holy Mantle shield every 2 floors. +10% speed while holy mantle is active.",
    ["expboon_protection_upgdesc"] = "Gain a Holy Mantle shield every floor. +15% speed while holy mantle is active.",

    ["expboon_lethargy"] = "Boon of Lethargy",
    ["expboon_lethargy_desc"] = {
        "{{boonLethargyChance}}% chance to slow enemies for {{boonLethargyLen}} seconds on hit.",
        "Your minimum speed is now {{boonLethargyMinSpd}}."
    },

    ["expboon_horror"] = "Boon of Horror",
    ["expboon_horror_desc"] = {
        "{{boonHorrorChance}}% chance to fear enemies for {{boonHorrorLen}} seconds on hit.",
        "Feared enemies receive {{boonHorrorDmg}}% more damage."
    },

    ["expboon_hypnosis"] = "Boon of Hypnosis",
    ["expboon_hypnosis_desc"] = {
        "{{boonHypnoChance}}% chance to charm enemies for {{boonHypnoLen}} seconds on hit.",
        "Charmed enemies receive {{boonHypnoDmg}}% more damage."
    },

    ["expboon_paralysis"] = "Boon of Paralysis",
    ["expboon_paralysis_desc"] = {
        "{{boonParaChance}}% chance to paralyze enemies for {{boonParaLen}} seconds on hit.",
        "Paralyzed enemies take 30% more damage from explosions."
    },

    ["expboon_activity"] = "Boon of Activity",
    ["expboon_activity_desc"] = "When using an active item with at least 2 charges, become invulnerable for {{boonActivity}} seconds.",

    ["expboon_plentifulEmptiness"] = "Boon of Plentiful Emptiness",
    ["expboon_plentifulEmptiness_desc"] = {
        "+{{boonEmptinessDmg}}% damage while the active item slot is empty.",
        "+{{boonEmptinessTears}}% tears while the trinket slot is empty."
    },

    ["expboon_volatility"] = "Boon of Volatility",
    ["expboon_volatility_desc"] = {
        "Enemies take {{boonVolatilityDmg}}% more damage from explosions.",
        "Start with an additional {{boonVolatilityBombs}} bombs."
    },

    ["expboon_improvCharges"] = "Boon of Improvised Charges",
    ["expboon_improvCharges_desc"] = "Consuming a Card, Pill or Rune grants all your active items 1 charge.",
    ["expboon_improvCharges_upgdesc"] = "Consuming a Card, Pill or Rune on use grants all your active items {{boonImpCharges}} charges.",

    ["expboon_champSlayer"] = "Boon of the Champion Slayer",
    ["expboon_champSlayer_desc"] = "+{{boonChampSlayDmg}}% damage for the current floor when killing a champion monster, up to {{boonChampSlayMax}}%",

    ["expboon_meekGiants"] = "Boon of Meek Giants",
    ["expboon_meekGiants_desc"] = "Bosses start with {{boonMeekGiants}}% of their HP missing.",

    ["expboon_lastGasp"] = "Boon of the Last Gasp",
    ["expboon_lastGasp_desc"] = "Dying in any of the final boss floors no longer consumes expedition attempts.",
    ["expboon_lastGasp_upgdesc"] = "Dying at any point at or past Womb II (or alternates) no longer consumes expedition attempts.",

    ["expboon_blessedExp"] = "Boon of the Blessed Expedition",
    ["expboon_blessedExp_desc"] = "You can no longer gain Expedition Curses.",
    ["expboon_blessedExp_upgdesc"] = {
        "You can no longer gain Expedition Curses.",
        "For each existing Expedition Curse you have, gain +4% all stats, up to +20%"
    },

    ["expboon_wisdom"] = "Boon of Wisdom",
    ["expboon_wisdom_desc"] = "+{{xpgain}}% XP gain within expedition runs.",

    ["expboon_unexpectedGift"] = "Boon of the Unexpected Gift",
    ["expboon_unexpectedGift_desc"] = {
        "A random treasure room within the first 6 you visit will contain an additional passive item",
        "from the treasure or shop item pool."
    },
    ["expboon_unexpectedGift_upgdesc"] = {
        "A random treasure room within the first 6 you visit will contain an additional passive item",
        "from the angel or devil item pool."
    },

    -- EXPEDITION CURSES --
    ["expcurse_enfeeblement"] = "Curse of Enfeeblement",
    ["expcurse_enfeeblement_desc"] = "{{damagePerc}}% damage.",

    ["expcurse_lethargy"] = "Curse of Lethargy",
    ["expcurse_lethargy_desc"] = "{{speedPerc}}% speed.",

    ["expcurse_tearDepriv"] = "Curse of Tear Deprivation",
    ["expcurse_tearDepriv_desc"] = "{{tearsPerc}}% tears.",

    ["expcurse_unfortunate"] = "Curse of the Unfortunate",
    ["expcurse_unfortunate_desc"] = "{{luckPerc}}% luck.",

    ["expcurse_invFortune"] = "Curse of the Inverse Fortune",
    ["expcurse_invFortune_desc"] = {
        "If your luck is positive, apply {{curseInvFortune}}% of it as an all stats down percentage, up to -{{curseInvFortuneMax}}%.",
        "(e.g. 4 luck would apply -12% all stats, 10 luck would apply -30%, etc.)"
    },

    ["expcurse_resilience"] = "Curse of Resilience",
    ["expcurse_resilience_desc"] = "+{{curseResilience}}% monster HP.",

    ["expcurse_ephPieces"] = "Curse of Ephemeral Pieces",
    ["expcurse_ephPieces_desc"] = "All non-vanishing pickup drops now vanish after {{curseEphPieces}} seconds.",

    ["expcurse_powerDemand"] = "Curse of Power Demand",
    ["expcurse_powerDemand_desc"] = {
        "When clearing a room, {{cursePowerDemandCharges}}% chance to lose a charge from active items.",
        "Double this chance if you took damage within the room.",
        "+{{cursePowerDemandScarcity}}% battery scarcity."
    },

    ["expcurse_giantFort"] = "Curse of Giants' Fortification",
    ["expcurse_giantFort_desc"] = "Bosses block the first {{curseGiantsFort}} hits they receive.",

    ["expcurse_greaterExpenses"] = "Curse of Greater Expenses",
    ["expcurse_greaterExpenses_desc"] = "Non-pickup shop items are {{curseGreaterExpenses}}% more expensive.",

    ["expcurse_flimsyGadgets"] = "Curse of Flimsy Gadgets",
    ["expcurse_flimsyGadgets_desc"] = {
        "When hit, {{curseFlimGadgDrop}}% chance to drop held trinkets.",
        "{{curseFlimGadgVanish}}% chance for dropped trinkets to vanish instead."
    },

    ["expcurse_abundantMight"] = "Curse of Abundant Might",
    ["expcurse_abundantMight_desc"] = {
        "+{{curseAbundantMightChance}}% chance for monsters to be champions.",
        "Champion monsters gain {{curseAbundantMightDmgRed}}% damage reduction."
    },

    ["expcurse_vanishingWealth"] = "Curse of Vanishing Wealth",
    ["expcurse_vanishingWealth_desc"] = "When entering a floor, lose {{curseVanishingWealth}} coins.",

    ["expcurse_precariousness"] = "Curse of Precariousness",
    ["expcurse_precariousness_desc"] = "When first entering a shop room, remove {{cursePrecarious}} random sold items.",

    ["expcurse_unexpectedTax"] = "Curse of Unexpected Taxation",
    ["expcurse_unexpectedTax_desc"] = "When first entering a room with monsters, lose {{curseUnexpectedTax}} coin(s).",

    ["expcurse_fadingKeys"] = "Curse of Fading Keys",
    ["expcurse_fadingKeys_desc"] = "Whenever you spend a key, spend {{curseFadingKeys}} additional key(s).",

    ["expcurse_punishment"] = "Curse of Punishment",
    ["expcurse_punishment_desc"] = "Take 1/2 heart damage every {{cursePunishment}} rooms cleared. This cannot kill you.",

    ["expcurse_mortality"] = "Curse of Mortality",
    ["expcurse_mortality_desc"] = "Extra life items can no longer show up.",

    ["expcurse_ancientStars"] = "Curse of Ancient Stars",
    ["expcurse_ancientStars_desc"] = "Expedition runs now require an Ancient Starcursed Jewel to be socketed.",

    ["expcurse_diminishPower"] = "Curse of Diminished Power",
    ["expcurse_diminishPower_desc"] = {
        "Your lasers deal -{{curseDimPowerLaser}}% damage.",
        "Explosions deal -{{curseDimPowerExpl}}% damage."
    },

    ["expcurse_shrouding"] = "Curse of Shrouding",
    ["expcurse_shrouding_desc"] = "Expedition node rewards and curses are no longer known.",

    ["expcurse_boonless"] = "Curse of the Boonless",
    ["expcurse_boonless_desc"] = "You can no longer gain Expedition boons.",

    ["expcurse_heartbroken"] = "Curse of the Heartbroken",
    ["expcurse_heartbroken_desc"] = "Start with {{curseHeartbroken}} additional broken heart(s).",

    ["expcurse_witless"] = "Curse of the Witless",
    ["expcurse_witless_desc"] = "{{xpgain}}% XP gain within expedition runs.",

    ["expcurse_urgency"] = "Curse of Urgency",
    ["expcurse_urgency_desc"] = {
        "{{bossRushTimer}} minutes to the Boss Rush door timer.",
        "{{hushTimer}} minutes to Hush's door timer."
    },

    -- EXPEDITION OBJECTIVES --
    ["expobj_defeatMonsters"] = "Defeat {{progress}} monsters.",
    ["expobj_defeatChampions"] = "Defeat {{progress}} champion monsters.",
    ["expobj_defeatBosses"] = "Defeat {{progress}} bosses.",
    ["expobj_challengeRooms"] = "Clear {{progress}} challenge rooms.",
    ["expobj_experience"] = "Earn {{progress}} experience within runs.",
    ["expobj_obols"] = "Gather {{progress}} Arcane Obols.",
    ["expobj_coins"] = "Collect {{progress}} coins.",
    ["expobj_purchases"] = "Purchase {{progress}} items from shops or deals.",
    ["expobj_devilDeals"] = "Make {{progress}} deals with the devil.",
    ["expobj_keys"] = "Spend {{progress}} keys.",
    ["expobj_beggars"] = "Assist any type of beggar {{progress}} times.",
    ["expobj_explosions"] = "Kill {{progress}} enemies with explosions.",
    ["expobj_chests"] = "Open {{progress}} chests of any type.",
    ["expobj_goldChests"] = "Open {{progress}} golden chests.",
    ["expobj_redChests"] = "Open {{progress}} red chests.",
    ["expobj_stoneChests"] = "Open {{progress}} stone chests.",
    ["expobj_rooms"] = "Clear {{progress}} rooms containing at least 5 monsters.",
    ["expobj_bossRoomsNoDmg"] = "Clear {{progress}} boss rooms without taking damage.",
    ["expobj_cardsPillsRunes"] = "Use {{progress}} cards, pills or runes.",
    ["expobj_secretRooms"] = "Enter {{progress}} secret, super secret or ultra secret rooms.",
    ["expobj_hearts"] = "Pick up {{progress}} hearts of any type.",
    ["expobj_shopDonation"] = "Donate {{progress}} coins to the shop/greed donation machine.",
    ["expobj_curseRooms"] = "Enter {{progress}} curse rooms.",
    ["expobj_activeItems"] = "Use an active item with at least 3 charges {{progress}} times.",
    ["expobj_tintedRocks"] = "Destroy {{progress}} tinted rocks.",
    ["expobj_winRun"] = "Win a run having defeated at least 1 final boss.",

    ["expobj_bossRush"] = "Complete {{progress}} boss rush encounter(s).",
    ["expobj_hush"] = "Defeat Hush.",
    ["expobj_hushNoDmgTwice"] = "Defeat Hush without taking damage more than twice during the fight.",
    ["expobj_hushNoDmgOnce"] = "Defeat Hush without taking damage more than once during the fight.",
    ["expobj_finalBoss"] = {
        "Defeat any final boss {{progress}} time(s).",
        "Final bosses include Delirium, ???, The Lamb, Mega Satan, The Beast, Mother and Ultra Greed."
    },
    ["expobj_floorNoDmgTwice"] = "Clear {{progress}} floors without taking damage more than twice.",
    ["expobj_floorNoDmgOnce"] = "Clear {{progress}} floors without taking damage more than once.",
    ["expobj_bossesNoDmgC3"] = "Clear {{progress}} boss room(s) past Chapter 3 (Womb and beyond) without taking damage.",
    ["expobj_beastDeliNoDmg"] = "Defeat The Beast or Delirium without taking damage more than once.",

    -- EXPEDITION MODIFIERS --
    ["expedImp_mobHP"] = "+{{impVal}}% non-boss monster HP.",
    ["expedImp_bossHP"] = "+{{impVal}}% boss monster HP.",
    ["expedImp_mobSpeed"] = "+{{impVal}}% monster speed.",
    ["expedImp_floorCurse"] = "+{{impVal}}% chance to receive a curse when entering a floor.",
    ["expedImp_pickupScarcity"] = "+{{impVal}}% coin, key, bomb and heart scarcity.",
    ["expedImp_quality4Remove"] = "Remove {{impVal}} random quality 4 item(s) from the pool when starting a run.",
    ["expedImp_heartbreak"] = {
        "Start with {{impVal}} additional broken heart(s).",
        "Heartbreak can no longer show up."
    },
    ["lessAttempts"] = "-{{impVal}} max expedition attempt(s).",
    ["expedImp_mobDmgRed"] = "+{{impVal}}% boss monster damage reduction.",

    -- DEEP-SPACE DISTORTION MODIFIERS --
    ["dsdMod_finalDmgRed"] = "+30% final boss damage reduction",
    ["dsdMod_finalDmgImm"] = "Final bosses gain damage immunity for 5 seconds every 25% HP lost.",
    ["dsdMod_finalLastStand"] = "While final bosses are at 12% HP or less, all their hits instantly kill you.",
    ["dsdMod_pickupLimit"] = "You cannot have more than 35 coins, 8 keys or 8 bombs.",
    ["dsdMod_treeEffect"] = "Tree effects on stats are 35% as effective.",
    ["dsdMod_heartScarcity"] = "+33% heart scarcity.",
    ["dsdMod_pickupScarcity"] = "+33% coin, key and bomb scarcity.",

    -- ENTROPY MODIFIERS --
    ["expedEnt_actives"] = "Use active items with at least 3 charges: +2 entropy.",
    ["expedEnt_clearTime"] = "Take longer than 10 seconds to clear a regular room past floor 4: +1 entropy.",
    ["expedEnt_bossDmg"] = "Take damage from a champion or boss monster: +3 entropy.",
    ["expedEnt_purchases"] = "Purchase items or make devil deals more than 3 times within a floor: +7 entropy per item/deal.",
    ["expedEnt_passiveItems"] = {
        "Acquire passive items while having at least 12 passive items, excluding progression items:",
        "+4 entropy per new item."
    },
    ["expedEnt_hearts"] = "Pick up non-red hearts while having a total of at least 5 hearts of any type: +3 entropy.",
    ["expedEnt_trinketSwap"] = "After obtaining a trinket, lose or swap it: +4 entropy.",
    ["expedEnt_activeSwap"] = "After obtaining an active item (excluding starter items), lose or swap it: +6 entropy.",
    ["expedEnt_chests"] = {
        "Open a chest after having opened 5 chests within the floor, excluding Sidereal Caches:",
        "+3 entropy per chest."
    },
    ["expedEnt_specialDmg"] = "Take damage from explosions or lasers: +3 entropy.",
    ["expedEnt_tearDmg"] = "Take damage from tears: +2 entropy.",
    ["expedEnt_finalBossDmg"] = "Take damage from a final boss: +4 entropy.",
    ["expedEnt_loseRun"] = "Lose a run: +12 entropy.",
    ["expedEnt_noPickups"] = "Enter a floor past the first with 0 coins, 0 keys or 0 bombs: +5 entropy per pickup at 0.",
    ["expedEnt_compNode"] = "Complete this expedition node: +10 entropy.",

    -- ORDER MODIFIERS --
    ["expedOrd_defeatMonsters"] = "Defeat {{req}} monsters without taking damage in-between kills: +{{order}} order.",
    ["expedOrd_defeatChampions"] = "Defeat {{req}} champions without taking damage in-between kills: +{{order}} order.",
    ["expedOrd_actives"] = "Use a combined total of {{req}} active item charges without taking damage in-between: +{{order}} order.",
    ["expedOrd_floors"] = "Clear a floor past the first two without taking damage: +{{order}} order.",
    ["expedOrd_purchase"] = "Purchase {{req}} items worth at least 7 coins: +{{order}} order.",
    ["expedOrd_passiveItems"] = "Acquire passive items while having at least 15 passive items, excluding progression items: +{{order}} order per item.",
    ["expedOrd_roomClear"] = "Clear a room with at least 5 monsters past floor 5 within 7 seconds: +{{order}} order.",
    ["expedOrd_beggars"] = "Fully help a beggar: +{{order}} order.",
    ["expedOrd_challenge"] = "Clear a challenge room without taking damage: +{{order}} order.",
    ["expedOrd_bossRush"] = "Clear the Boss Rush without taking damage more than 3 times: +{{order}} order.",
    ["expedOrd_hush"] = "Defeat Hush without taking damage more than 3 times: +{{order}} order.",
    ["expedOrd_bossRooms"] = "Clear 4 boss rooms: +{{order}} order.",
    ["expedOrd_noAngels"] = "Win a run without having killed any Angel bosses: +{{order}} order.",
    ["expedOrd_chests"] = "Open any 5 chests without taking damage in-between: +{{order}} order.",
}