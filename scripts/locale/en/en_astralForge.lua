return {
    ---- ASTRAL FORGE (WEAPONS & UI) ----
    ["ui_astralForge"] = "Astral Forge",
    ["ui_astralwep"] = "Astral Weapon",

    ["ui_wepInv"] = "Weapon Inventory",
    ["ui_decon"] = "Decon", -- from 'Deconstructing'
    ["ui_Imprint"] = "Imprint",
    ["ui_equippedWeapon"] = "Equipped Weapon",
    ["ui_costs"] = "Costs",

    ["ui_missingYouHave"] = "missing, you have",

    ["ui_hoverMoreInfo"] = "Hover for more info.",
    ["ui_allocToSelect"] = "Allocate to select.",
    ["ui_shiftAllocUnequip"] = "Shift + Allocate to unequip.",
    ["ui_invEmpty"] = "Inventory Empty",
    ["ui_deconstructingWep"] = "Deconstructing Weapon",
    ["ui_respecDecon"] = "Press the Respec button to deconstruct this weapon and gain these materials.",
    ["ui_holdRespecDecon"] = "Hold the Respec button for 1 second to deconstruct this weapon and gain these materials.",

    ["ui_wepForging"] = "Weapon Forging",
    ["ui_selWepToForge"] = "Select a weapon from your inventory to begin forging.",
    ["ui_allocToSelHoverWepForge"] = "Press Allocate to select hovered weapon for forging.",
    ["ui_shiftAllocEquipHoverWep"] = "Shift + Allocate to equip hovered weapon.",
    ["ui_shiftHFavWep"] = "Shift + H to favorite hovered weapon.",
    ["ui_shiftHFavThisWep"] = "Press Shift + H to favorite this weapon.",
    ["ui_shiftAllocEquipWith"] = "Press Shift + Allocate to equip this weapon with {{charName}}.",

    ["ui_imprintNote1"] = "NOTE: Imprinting will destroy this weapon!",
    ["ui_imprintNote2"] = "Press Allocate to imprint this weapon into the currently selected Ancient weapon.",
    ["ui_imprintingWep"] = "Imprinting Weapon",

    ["ui_toggleDeconMode"] = "Toggle Deconstruction Mode",
    ["ui_forgeDeconDesc"] = {
        "Press the Allocate button to toggle Deconstruction Mode.",
        "While in deconstruction mode, hover over a weapon and press Respec to deconstruct it into",
        "forging materials, destroying it in the process."
    },
    ["ui_toggleMultiDecon"] = "Toggle Multi-Deconstruction",
    ["ui_multiDeconDesc"] = {
        "Press the Allocate button to toggle Multi-Deconstruction Mode.",
        "While in this mode, you may select multiple weapons with the Allocate button before mass-deconstructing",
        "them at once.",
        "Press Ctrl + Allocate while hovering a filter or a weapon to select all currently filtered weapons.",
        "Press Respec on a weapon to deconstruct all selected weapons.",
        {"Use with care! Make sure not to select weapons you might wish to keep.", PST.kcolors.STAR_ORANGE}
    },

    ["ui_Materials"] = "Materials",
    ["ui_forgeMaterial"] = "Forge Material",
    ["ui_mundaneEssence"] = "Mundane Essence",
    ["ui_sparklingEssence"] = "Sparkling Essence",
    ["ui_ancientEssence"] = "Ancient Essence",
    ["ui_sparklingStardust"] = "Sparkling Stardust",
    ["ui_ancientStardust"] = "Ancient Stardust",

    ["ui_filter"] = "Filter",
    ["ui_noHoning"] = "No Honing",
    ["ui_someHoning"] = "Some Honing",
    ["ui_maxHoning"] = "Maxed Honing",
    ["ui_favorited"] = "Favorited",
    ["ui_allocApplyFilter"] = "Press the Allocate button to apply this filter.",

    ["ui_source"] = "Source",
    ["ui_equippedBy"] = "Equipped by",

    ["ui_mundaneEssence_src"] = "Deconstructing normal weapons.",
    ["ui_sparklingEssence_src"] = "Deconstructing weapons with modifiers (magic/ancient).",
    ["ui_ancientEssence_src"] = "Deconstructing ancient weapons.",
    ["ui_sparklingStardust_src"] = "Killing bosses & clearing challenge rooms.",
    ["ui_ancientStardust_src"] = "Killing final bosses.",
    ["ui_starblessedPrism_src"] = "Uber Expedition rewards.",

    ["ui_Honing"] = "Honing",
    ["ui_Honing_desc"] = {"Hone the weapon, improving its implicit modifier. Each weapon can be honed up to 50 times."},
    ["ui_Transmutation"] = "Transmutation",
    ["ui_Transmutation_desc"] = {"Transform this normal weapon into a magic weapon, adding 1 random modifier."},
    ["ui_rerollMods"] = "Reroll Modifiers",
    ["ui_rerollMods_desc"] = {"Reroll the weapon's modifiers. Can result in 1 or 2 modifiers."},
    ["ui_addMod"] = "Add Modifier",
    ["ui_addMod_desc"] = {"Add a random modifier if the weapon only has 1."},
    ["ui_removeMod"] = "Remove Modifier",
    ["ui_removeMod_desc"] = {"Remove a random modifier if the weapon has 2."},
    ["ui_alterMods"] = "Alter Modifiers",
    ["ui_alterMods_desc"] = {"Randomise the values of the random, non-implicit modifiers on this weapon."},
    ["ui_ancImprint"] = "Ancient Imprinting",
    ["ui_ancImprint_desc"] = {
        "Imprint a random modifier from another magic weapon into this Ancient weapon.",
        "Target magic weapon must have more than 1 modifier.",
        "Can only imprint 1 modifier per Ancient weapon, or 2 if Starblessed.",
        "Imprinted modifiers can no longer be altered once applied."
    },
    ["ui_ancImprint_desc_imp"] = {
        "Hover over the magic weapon you wish to imprint from in the inventory, then press Allocate to imprint.",
        "Press Allocate on this button again to deactivate imprinting mode."
    },
    ["ui_ancUpgrade"] = "Ancient Upgrade",
    ["ui_ancUpgrade_desc"] = {"Improve this Ancient weapon's unique modifier."},
    ["ui_starblessing"] = "Starblessing",
    ["ui_starblessing_desc"] = {
        "Apply a Starblessed Prism to this weapon, allowing an additional modifier to be imprinted on it.",
        "Applicable once per ancient weapon, if not already Starblessed."
    },

    ["aforge_wepname_Longsword"] = "Longsword",
    ["aforge_wepname_Longswords"] = "Longswords",
    ["aforge_wepname_Estoc"] = "Estoc",
    ["aforge_wepname_Estocs"] = "Estocs",
    ["aforge_wepname_Dagger"] = "Dagger",
    ["aforge_wepname_Daggers"] = "Daggers",
    ["aforge_wepname_Quickblade"] = "Quickblade",
    ["aforge_wepname_Quickblades"] = "Quickblades",
    ["aforge_wepname_Spear"] = "Spear",
    ["aforge_wepname_Spears"] = "Spears",
    ["aforge_wepname_Trident"] = "Trident",
    ["aforge_wepname_Tridents"] = "Tridents",
    ["aforge_wepname_Scythe"] = "Scythe",
    ["aforge_wepname_Scythes"] = "Scythes",
    ["aforge_wepname_Axe"] = "Axe",
    ["aforge_wepname_Axes"] = "Axes",
    ["aforge_wepname_Greataxe"] = "Greataxe",
    ["aforge_wepname_Greataxes"] = "Greataxes",
    ["aforge_wepname_Shortbow"] = "Shortbow",
    ["aforge_wepname_Shortbows"] = "Shortbows",
    ["aforge_wepname_Bow"] = "Bow",
    ["aforge_wepname_Bows"] = "Bows",
    ["aforge_wepname_Crossbow"] = "Crossbow",
    ["aforge_wepname_Crossbows"] = "Crossbows",
    ["aforge_wepname_Gauntlet"] = "Gauntlet",
    ["aforge_wepname_Gauntlets"] = "Gauntlets",
    ["aforge_wepname_Great Mace"] = "Great Mace",
    ["aforge_wepname_Great Maces"] = "Great Maces",
    ["aforge_wepname_Whip"] = "Whip",
    ["aforge_wepname_Whips"] = "Whips",

    ["aforge_ancname_Grey Wind"] = "Grey Wind",
    ["aforge_ancname_Executioner"] = "Executioner",
    ["aforge_ancname_Sword of Song"] = "Sword of Song",
    ["aforge_ancname_Redbeak"] = "Redbeak",
    ["aforge_ancname_Glowing Moonblade"] = "Glowing Moonblade",
    ["aforge_ancname_Maxwell's Thermic Engine"] = "Maxwell's Thermic Engine",
    ["aforge_ancname_Glowing Sunblade"] = "Glowing Sunblade",
    ["aforge_ancname_Divine Interceptor"] = "Divine Interceptor",

    ["aforge_ancname_Arcing Needle"] = "Arcing Needle",
    ["aforge_ancname_Auric Persecutor"] = "Auric Persecutor",

    ["aforge_ancname_The Scrambler"] = "The Scrambler",
    ["aforge_ancname_Adrift Blade"] = "Adrift Blade",
    ["aforge_ancname_Ivory Vampire"] = "Ivory Vampire",

    ["aforge_ancname_Nimble Twins"] = "Nimble Twins",
    ["aforge_ancname_Crimson Altruist"] = "Crimson Altruist",
    ["aforge_ancname_Quicksilver"] = "Quicksilver",

    ["aforge_ancname_Beastbane"] = "Beastbane",
    ["aforge_ancname_Gravitas"] = "Gravitas",
    ["aforge_ancname_Boreal Frostspear"] = "Boreal Frostspear",
    ["aforge_ancname_Viper Stinger"] = "Viper Stinger",

    ["aforge_ancname_Consecrator"] = "Consecrator",
    ["aforge_ancname_Verdant Green"] = "Verdant Green",
    ["aforge_ancname_Lost Coral Trident"] = "Lost Coral Trident",
    ["aforge_ancname_Oceanic Might"] = "Oceanic Might",

    ["aforge_ancname_Tale Ender"] = "Tale Ender",
    ["aforge_ancname_Crimson Reaper"] = "Crimson Reaper",
    ["aforge_ancname_Mobripper"] = "Mobripper",

    ["aforge_ancname_Starsteel Broadaxe"] = "Starsteel Broadaxe",
    ["aforge_ancname_Ancient Runic Chopper"] = "Ancient Runic Chopper",
    ["aforge_ancname_Circuit Splitter"] = "Circuit Splitter",

    ["aforge_ancname_Berserker's Wrath"] = "Berserker's Wrath",
    ["aforge_ancname_Frozen Terror"] = "Frozen Terror",

    ["aforge_ancname_Storm's Advance"] = "Storm's Advance",
    ["aforge_ancname_Quill Rain"] = "Quill Rain",

    ["aforge_ancname_Gilded Seeker"] = "Gilded Seeker",
    ["aforge_ancname_Twisted Oakstring"] = "Twisted Oakstring",
    ["aforge_ancname_Brute's Onslaught"] = "Brute's Onslaught",
    ["aforge_ancname_Divine Messenger"] = "Divine Messenger",

    ["aforge_ancname_Volatile Arbalest"] = "Volatile Arbalest",
    ["aforge_ancname_Avelyn"] = "Avelyn",
    ["aforge_ancname_Precise Seeker"] = "Precise Seeker",

    ["aforge_ancname_Magefist"] = "Magefist",
    ["aforge_ancname_Ironhand"] = "Ironhand",
    ["aforge_ancname_Metamorphic Claw"] = "Metamorphic Claw",

    ["aforge_ancname_Mighty Purifier"] = "Mighty Purifier",
    ["aforge_ancname_Chaotic Tumult"] = "Chaotic Tumult",
    ["aforge_ancname_Firestarter"] = "Firestarter",
    ["aforge_ancname_Colossal Maul"] = "Colossal Maul",
    ["aforge_ancname_Tolling Bell"] = "Tolling Bell",

    ["aforge_ancname_Snakebite"] = "Snakebite",
    ["aforge_ancname_Devil's Tongue"] = "Devil's Tongue",
    ["aforge_ancname_Azurebinder"] = "Azurebinder",
    ["aforge_ancname_Sacred Scourge"] = "Sacred Scourge",


    ["aforge_mod_desc_longswordImp"] = "+{{roll1}}% damage dealt to enemies within 1.5 tiles.",
    ["aforge_mod_desc_estocImp"] = {
        "Consecutive hits against enemies within 2 tiles of you grants +{{roll1}}% tears, up to {{roll2}}%.",
        "Hitting an enemy beyond 2 tiles resets the bonus."
    },
    ["aforge_mod_desc_daggerImp"] = {
        "{{roll1}}% chance for hits to deal {{roll2}}% more damage.",
        "Double the chance against targets within 1.5 tiles."
    },
    ["aforge_mod_desc_quickbladeImp"] = {
        "+{{roll1}} tears for {{roll2}} second(s) when hitting an enemy, which stacks up to {{roll3}}.",
        "Double the duration if hitting targets within 1.5 tiles.",
        "Each stack has its own duration."
    },
    ["aforge_mod_desc_spearImp"] = {
        "+{{roll1}}% damage dealt to enemies between 1.5 and 2.5 tiles away from you.",
        "-{{roll2}}% damage dealt to enemies within 1.5 tiles."
    },
    ["aforge_mod_desc_tridentImp"] = {
        "Consecutive hits against enemies beyond 1.5 tiles of you grant +{{roll1}}% damage and tears, up to {{roll2}}%.",
        "Hitting an enemy within 1.5 tiles of you resets the bonus."
    },
    ["aforge_mod_desc_scytheImp"] = {
        "Hitting an enemy triggers a circular slash that hits nearby enemies for {{roll1}}% of the hit's damage.",
        "This effect has a {{roll2}} second cooldown."
    },
    ["aforge_mod_desc_axeImp"] = {
        "{{roll1}}% chance to cause bleeding for 3 seconds when hitting enemies.",
        "+{{roll2}}% damage with hits against bleeding enemies."
    },
    ["aforge_mod_desc_greataxeImp"] = {
        "Every {{roll1}} hits against each enemy causes them to bleed for 4 seconds.",
        "+{{roll2}}% damage for 2 seconds after hitting a bleeding enemy.",
        "{{roll3}}% tears."
    },
    ["aforge_mod_desc_shortbowImp"] = {
        "+{{roll1}} shot speed.",
        "{{roll2}}% of your shot speed above 1 becomes a tears multiplier, up to +80%."
    },
    ["aforge_mod_desc_bowImp"] = {
        "+{{roll1}} shot speed.",
        "Hits against enemies deal additional damage the farther away they are from you, up to {{roll2}}%."
    },
    ["aforge_mod_desc_crossbowImp"] = {
        "{{roll1}} tears.",
        "+{{roll2}} shot speed.",
        "Your total shot speed becomes a damage multiplier, up to {{roll3}}%."
    },
    ["aforge_mod_desc_gauntletImp"] = {
        "Can have an additional magic modifier. Magic modifiers are stronger.",
        "Transmutation cost is halved."
    },
    ["aforge_mod_desc_greatmaceImp"] = {
        "Hitting an enemy within 2.5 tiles causes a shockwave, paralyzing nearby enemies for {{roll1}} seconds.",
        "Already paralyzed enemies hit by the shockwave receive {{roll2}}% of your damage, capped at 50.",
        "{{roll3}} second cooldown."
    },
    ["aforge_mod_desc_whipImp"] = {
        "When hitting an enemy, shoot a stream of 5 tears in a line towards them.",
        "Hitting enemies with these tears randomly grants you either +{{roll1}}% speed or",
        "+{{roll1}}% tears, up to {{roll2}}%, for {{roll3}} seconds.",
        "2 second cooldown between tear shots."
    },

    ["aforge_mod_desc_dmgStatus"] = "+{{roll1}}% damage dealt to enemies affected by status effects.",
    ["aforge_mod_desc_dmgStatusSlow"] = "+{{roll1}}% damage dealt to slowed enemies.",
    ["aforge_mod_desc_dmgStatusCharm"] = "+{{roll1}}% damage dealt to charmed enemies.",
    ["aforge_mod_desc_dmgStatusPara"] = "+{{roll1}}% damage dealt to paralyzed enemies.",
    ["aforge_mod_desc_dmgStatusFear"] = "+{{roll1}}% damage dealt to feared enemies.",
    ["aforge_mod_desc_dmgStatusBleed"] = "+{{roll1}}% damage dealt to bleeding enemies.",
    ["aforge_mod_desc_dmgStatusPoison"] = "+{{roll1}}% damage dealt to poisoned enemies.",
    ["aforge_mod_desc_dmgStatusBurn"] = "+{{roll1}}% damage dealt to burning enemies.",
    ["aforge_mod_desc_consecFireDmg"] = "+{{roll1}}% damage dealt after firing consecutively for 2 seconds. Resets when you stop firing.",
    ["aforge_mod_desc_consecFireDmg2"] = {
        "+{{roll1}}% damage dealt after firing consecutively for 3 seconds.",
        "Resets 1 second after you stop firing."
    },
    ["aforge_mod_desc_farEnemyDmg"] = "+{{roll1}}% damage dealt to enemies beyond 2 tiles of you.",
    ["aforge_mod_desc_closeEnemyDmg"] = "+{{roll1}}% damage dealt to enemies within 2 tiles of you.",
    ["aforge_mod_desc_baseDmg"] = "+{{roll1}} base damage.",
    ["aforge_mod_desc_baseDmg2"] = "+{{roll1}} base damage, removed for {{roll2}} seconds when you get hit.",
    ["aforge_mod_desc_redHealDmg"] = {
        "When healing red hearts, +{{roll1}}% damage dealt for 5 seconds per 1/2 red heart recovered,",
        "which stacks up to {{roll2}}%."
    },
    ["aforge_mod_desc_soulHealDmg"] = {
        "When gaining soul hearts, +{{roll1}}% damage dealt for 5 seconds per 1/2 soul heart gained,",
        "which stacks up to {{roll2}}%."
    },
    ["aforge_mod_desc_blackHealDmg"] = {
        "When gaining black hearts, +{{roll1}}% damage dealt for 5 seconds per 1/2 black heart gained,",
        "which stacks up to {{roll2}}%."
    },
    ["aforge_mod_desc_purchaseDmg"] = {
        "+{{roll1}}% damage dealt for {{roll2}} seconds after purchasing an item, which stacks",
        "up to {{roll3}}%."
    },
    ["aforge_mod_desc_coinPickupDmg"] = {
        "+{{roll1}}% damage dealt for {{roll2}} seconds after picking up any coin, which stacks",
        "up to {{roll3}}%."
    },
    ["aforge_mod_desc_coinPermDmg"] = "+{{roll1}}% permanent damage after picking up any coin worth at least 5, up to {{roll2}}%.",
    ["aforge_mod_desc_onHitEnemyDmgTaken"] = "All enemies take {{roll1}}% more damage for {{roll2}} seconds after you get hit.",
    ["aforge_mod_desc_flyGroundDmg"] = {
        "+{{roll1}}% damage dealt to flying enemies if you're on the ground.",
        "+{{roll1}}% damage dealt to ground enemies if you're flying."
    },
    ["aforge_mod_desc_activeFamDmg"] = "+{{roll1}}% damage dealt per active familiar, up to 40%.",
    ["aforge_mod_desc_famKillDmg"] = "+{{roll1}}% damage dealt for {{roll2}} seconds after a familiar kills an enemy.",
    ["aforge_mod_desc_holyMantleDmg"] = "+{{roll1}}% damage dealt while you have a holy mantle shield.",
    ["aforge_mod_desc_eternalDmg"] = "+{{roll1}}% damage dealt while you have an eternal heart.",
    ["aforge_mod_desc_activeDmg"] = "+{{roll1}}% damage dealt for {{roll2}} seconds after using an active item.",
    ["aforge_mod_desc_healthyMobDmg"] = "+{{roll1}}% damage dealt to enemies above 90% HP.",
    ["aforge_mod_desc_injuredMobDmg"] = "+{{roll1}}% damage dealt to enemies below 15% HP.",
    ["aforge_mod_desc_creepDmg"] = "+{{roll1}}% damage dealt while standing on creep.",
    ["aforge_mod_desc_playerCreepDmg"] = "+{{roll1}}% damage dealt by player creep.",
    ["aforge_mod_desc_laserDmg"] = "+{{roll1}}% damage dealt with lasers.",
    ["aforge_mod_desc_explosionDmg"] = "+{{roll1}}% damage dealt with explosions.",
    ["aforge_mod_desc_injuredDmg"] = "+{{roll1}}% damage dealt while half or more of your total red heart containers are empty.",

    ["aforge_mod_desc_greyWind"] = {
        "{{roll1}}% chance on hit to slash all enemies within 2 tiles of the target, dealing {{roll2}}%",
        "of the hit's damage. This effect has a 2 second cooldown.",
        "If the slashes target 3 or less enemies, they deal 50% more damage, cause bleeding for 3 seconds,",
        "and the cooldown for that trigger is increased to 5 seconds.",
        "-0.6 base damage."
    },
    ["aforge_mod_desc_executioner"] = {
        "+{{roll1}}% damage.",
        "{{roll2}}% chance on hit to instantly kill enemies that are left with {{roll3}}% or less HP."
    },
    ["aforge_mod_desc_swordOfSong"] = {
        "{{roll1}}% chance on hit to cause an area pulse at the hit's location that charms nearby enemies for 4 seconds.",
        "+1% damage whenever you kill a charmed monster.",
        "Every {{roll2}} hits against charmed monsters, reset the damage bonus and trigger Isaac's Tears' item effect."
    },
    ["aforge_mod_desc_redbeak"] = {
        "If half or more of your total red heart containers are empty:",
        "    +{{roll1}}% damage dealt.",
        "    {{roll2}}% chance for hits to inflict bleed on enemies for 4 seconds.",
        "    {{roll3}}% chance for bleeding enemies to drop a 1/2 red heart on kill, which vanishes after 2 seconds."
    },
    ["aforge_mod_desc_glowingMoonblade"] = {
        "Start with innate Luna.",
        "-{{roll1}}% damage and tears.",
        "When first entering a secret room, remove these reductions for the current floor.",
        "Entering 2 secret rooms grants +{{roll2}} speed for the current floor, once per floor."
    },
    ["aforge_mod_desc_maxwellEngine"] = {
        "+0.5% damage for 3 seconds when hitting an enemy, which stacks up to {{roll1}}%.",
        "While the buff is maxed:",
        "    {{roll2}}% chance for hits to cause burning or slow for 3 seconds on hit.",
        "    15% chance for burning enemies to explode on death, dealing 30 damage to nearby enemies.",
        "    15% chance for slowed enemies to freeze on death."
    },
    ["aforge_mod_desc_glowingSunblade"] = {
        "Start with innate Sol.",
        "-{{roll1}}% damage and tears.",
        "When first entering the boss room, remove these reductions for the current floor.",
        "When first entering the treasure room, gain +{{roll2}} speed for the current floor."
    },
    ["aforge_mod_desc_divineInterceptor"] = {
        "When hitting an enemy within 2 tiles, fire a spread of sword projectiles towards them.",
        "Current upgrade level: {{roll1}}.",
        "Upgrade level 3: sword projectiles now pierce enemies.",
        "Upgrade level 6: sword projectiles gain homing.",
        "5 second cooldown."
    },
    ["aforge_mod_desc_arcingNeedle"] = {
        "Every 0.5 seconds spent firing, {{roll1}}% chance to gain Jacob's Ladder as an innate effect for {{roll2}} seconds.",
        "Chance goes up in 1% increments as you keep firing, and resets once you stop firing.",
        "Obtaining Jacob's Ladder naturally grants you +15% tears."
    },
    ["aforge_mod_desc_auricPersecutor"] = {
        "Half of your coin count now acts as a tears multiplier, up to {{roll1}}%.",
        "+{{roll2}}% damage for the current floor when picking up a coin worth at least 5, up to {{roll3}}%."
    },
    ["aforge_mod_desc_scrambler"] = {
        "3% chance on hit to confuse enemies for 4 seconds. Triple the chance against targets within 1.5 tiles.",
        "Increase this chance by 1% when entering a new floor.",
        "Deal {{roll1}}% more damage against confused enemies.",
        "Hitting confused enemies has a {{roll2}}% chance to remove their confusion."
    },
    ["aforge_mod_desc_adriftBlade"] = "{{roll1}}% chance on hit to deal between {{roll2}}% and {{roll3}}% of the original damage.",
    ["aforge_mod_desc_ivoryVampire"] = {
        "Red hearts can be picked up regardless of health status.",
        "Every 1/2 red heart picked up grants you {{roll1}}% speed, tears and damage for {{roll2}} seconds,",
        "which stacks up to 8 times.",
        "Buff timer is paused while in a room with no enemies."
    },
    ["aforge_mod_desc_nimbleTwins"] = {
        "+{{roll1}}% tears.",
        "When hitting an enemy, additionally fire a slow-moving red tear and a quick blue tear towards them.",
        "These tears deal {{roll2}}% of your damage.",
        "Gain +3% damage for 2 seconds when hitting enemies with the red tear, which stacks up to {{roll3}}%.",
        "Gain +3% tears for 2 seconds when hitting enemies with the blue tear, which stacks up to {{roll3}}%."
    },
    ["aforge_mod_desc_crimsonAltruist"] = {
        "+{{roll1}}% damage when using a blood donation machine, up to 100%.",
        "+{{roll2}} tears every {{roll3}} blood donation machine uses.",
        "Halve the active bonuses when entering a new floor."
    },
    ["aforge_mod_desc_quicksilver"] = {
        "Press the Drop button to briefly perform a Parry. Parrying blocks up to 1 incoming hit if timed right.",
        "Parrying has a {{roll1}} second cooldown. You can only parry monster hits.",
        "When successfully parrying a hit:",
        "- Your next hit deals double damage. This doesn't stack.",
        "- Gain +{{roll2}}% tears and speed for 3 seconds."
    },
    ["aforge_mod_desc_beastbane"] = {
        "+{{roll1}}% damage dealt to bosses.",
        "Defeating a boss grants you a permanent +{{roll2}}% damage, once every 2 floors."
    },
    ["aforge_mod_desc_gravitas"] = {
        "When hitting enemies beyond 2 tiles from you, {{roll1}}% chance to additionally fire",
        "3 homing tears dealing {{roll2}}% of your damage. 0.5 seconds cooldown.",
        "When hitting enemies with the homing tears, 3% chance to gain Spoon Bender for the current room.",
        "-{{roll3}}% tears while you have Spoon Bender."
    },
    ["aforge_mod_desc_borealSpear"] = {
        "{{roll1}}% chance on hit to slow enemies for 3 seconds.",
        "When you hit a slowed enemy beyond {{roll2}} tiles of you, +1% chance to freeze that enemy.",
        "Hitting enemies repeatedly increases the chance to freeze them, with the freeze chance being",
        "individual to each enemy."
    },
    ["aforge_mod_desc_viperStinger"] = {
        "{{roll1}}% chance to paralyze enemies on hit for 2 seconds.",
        "Double the chance and duration against poisoned enemies.",
        "Killing a paralyzed enemy releases a toxic cloud, poisoning for 4 seconds and dealing {{roll2}}%",
        "of your damage to nearby enemies.",
    },
    ["aforge_mod_desc_consecrator"] = {
        "Gain +{{roll1}}% damage when entering a devil room, up to {{roll2}}%.",
        "Gain +{{roll1}}% tears when entering an angel room, up to {{roll2}}%.",
        "Active buffs get halved when clearing a boss room.",
        "+{{roll3}}% chance for angel/devil rooms to show up."
    },
    ["aforge_mod_desc_verdantGreen"] = {
        "{{roll1}}% chance on hit to create a poison cloud.",
        "This chance receives a flat increase from your tears stat, up to +5%.",
        "Poison clouds periodically poison enemies within it for 4 seconds. Poisoned enemies instead take {{roll2}}%",
        "of your damage."
    },
    ["aforge_mod_desc_lostCoralTrident"] = {
        "Start with innate Neptunus.",
        "-{{roll1}}% damage."
    },
    ["aforge_mod_desc_oceanicMight"] = {
        "Start with innate Aquarius.",
        "Player creep deals {{roll1}}% more damage to enemies.",
        "Hitting enemies standing on creep created by you has a 10% chance to trigger a water explosion, dealing",
        "25 damage to nearby enemies. 2.5 second cooldown.",
        "Explosion trigger chance becomes 40% against flying enemies."
    },
    ["aforge_mod_desc_taleEnder"] = {
        "+{{roll1}}% damage dealt to full health enemies.",
        "{{roll2}}% chance to instantly kill the first non-boss enemy you hit in each room.",
        "Halve this chance when the effect triggers, and reset it when entering a new floor."
    },
    ["aforge_mod_desc_crimsonReaper"] = {
        "When hitting a full health enemy, apply bleed to them for {{roll1}} seconds.",
        "Double this duration against bosses.",
        "Bleeding enemies below {{roll2}}% HP take increased damage based on their missing HP below {{roll2}}%."
    },
    ["aforge_mod_desc_mobripper"] = {
        "Circular slashes from the implicit modifier now deal {{roll1}}% of the hit's damage instead.",
        "If the circular slash kills any enemy or hits a boss, fear all enemies hit by it for 3 seconds.",
        "-{{roll2}}% damage."
    },
    ["aforge_mod_desc_starsteelBroadaxe"] = {
        "+2% tears for the current room when hitting bleeding enemies, up to {{roll1}}%.",
        "Hitting a boss reduces their status effect cooldown by 0.5 seconds."
    },
    ["aforge_mod_desc_ancientRunicChopper"] = {
        "+{{roll1}}% permanent damage whenever you use a full rune, up to {{roll2}}%.",
        "+{{roll3}}% tears for 10 seconds whenever you use a rune or rune shard."
    },
    ["aforge_mod_desc_circuitSplitter"] = {
        "Hitting a bleeding enemy creates a laser ring that follows them, damaging nearby enemies",
        "for {{roll1}}% of your damage per tick, capped at 5.",
        "Laser rings last {{roll2}} seconds and can linger in place after the enemy dies.",
        "Up to 3 laser rings from this effect can be in the room simultaneously."
    },
    ["aforge_mod_desc_berserkerWrath"] = {
        "Trigger Berserk! when first entering a room with monsters, once per floor.",
        "Entering the boss room causes Berserk! to stop.",
        "+{{roll1}} seconds to Berserk!'s duration."
    },
    ["aforge_mod_desc_frozenTerror"] = {
        "When hitting bleeding enemies, {{roll1}}% chance to slow them for 3 seconds.",
        "When hitting slowed enemies within {{roll2}} tile(s) of you, perform a circular slash",
        "around you that can freeze slowed enemies. 1.5 second cooldown.",
        "Slash deals {{roll3}}% of your damage."
    },
    ["aforge_mod_desc_stormAdvance"] = {
        "Start with innate 120 Volt.",
        "Every {{roll1}} hits against enemies, launch a fan of electrified tears towards the last target hit.",
        "These tears deal {{roll2}}% of your damage.",
        "Effect has a 2 second cooldown."
    },
    ["aforge_mod_desc_quillRain"] = {
        "Start with innate Soy Milk.",
        "-{{roll2}}% damage dealt to enemies within {{roll1}} tiles of you."
    },
    ["aforge_mod_desc_gildedSeeker"] = {
        "Start with innate Head of the Keeper.",
        "+1% damage when collecting any coin while there are monsters in the room, up to {{roll1}}%.",
        "Halve your current bonus when clearing a room.",
    },
    ["aforge_mod_desc_twistedOakstring"] = {
        "When hitting enemies beyond {{roll1}} tiles of you, create an additional homing, spectral and",
        "fearing tear at their position. 0.5 second cooldown.",
        "This tear deals {{roll2}}% of the hit's damage."
    },
    ["aforge_mod_desc_bruteOnslaught"] = {
        "When using an active item, for each charge used, boost the next 5 hits' damage by {{roll1}}%.",
        "+{{roll2}}% tears for 5 seconds after using an active item."
    },
    ["aforge_mod_desc_divineMessenger"] = {
        "When hitting an enemy beyond 3 tiles from you for the first time in a room, create a Holy Aura",
        "at their position.",
        "Holy Aura lasts for the rest of the room, slowly moves towards you, and grant +1 damage, +0.4 tears,",
        "and +{{roll1}}% damage and tears while in it."
    },
    ["aforge_mod_desc_volatileArbalest"] = {
        "{{roll1}}% chance to cause a small explosion when hitting enemies beyond 2.5 tiles of you,",
        "dealing {{roll2}}% of your damage. 1 second cooldown."
    },
    ["aforge_mod_desc_avelyn"] = {
        "Every {{roll1}} total seconds spent firing, shoot 3 tears towards a nearby enemy, each dealing {{roll2}}%",
        "of your damage."
    },
    ["aforge_mod_desc_preciseSeeker"] = {
        "Every second, mark a random enemy if available, prioritizing bosses.",
        "Every {{roll1}} seconds, fire a very quick piercing and spectral tear towards the marked enemy.",
        "Fired tear deals {{roll2}}% of your damage, up to 60."
    },
    ["aforge_mod_desc_magefist"] = {
        "Can imprint up to 3 modifiers on this weapon.",
        "Imprinting cost is halved.",
        "+{{roll1}}% all stats per modifier on this weapon."
    },
    ["aforge_mod_desc_ironhand"] = {
        "Rolls 3 random weapon implicits.",
        "Cannot imprint modifiers into this weapon.",
        "+{{roll1}}% all stats for every 10 honing on this weapon."
    },
    ["aforge_mod_desc_metamorphicClaw"] = {
        "Mimics the effect of a random non-Gauntlet ancient weapon.",
        "Effect changes every floor.",
        "Ancient upgrade level used for chosen effects: {{roll1}}."
    },
    ["aforge_mod_desc_mightyPurifier"] = {
        "Paralyze undead enemies for {{roll1}} second(s) when first hitting them.",
        "{{roll2}}% chance to block hits from undead enemies.",
        "+{{roll3}}% damage dealt to undead enemies."
    },
    ["aforge_mod_desc_chaoticTumult"] = {
        "The implicit shockwave now triggers a random status effect on hit for twice as long, instead of paralysis.",
        "When hitting an enemy affected by a status effect, 15% chance to spread the effect to a",
        "random enemy within {{roll1}} tiles of the hit.",
        "+1% damage for the current room when killing enemies affected by status effects, up to {{roll2}}%."
    },
    ["aforge_mod_desc_firestarter"] = {
        "{{roll1}}% chance to inflict burning for 5 seconds on hit.",
        "Chance is tripled for explosion hits.",
        "Killing a burning enemy has a 35% chance to cause an explosion dealing {{roll2}}% of your damage, capped",
        "at 50.",
        "Getting hit by a burning enemy grants you +15% speed for 3 seconds."
    },
    ["aforge_mod_desc_colossalMaul"] = {
        "Double the implicit shockwave's damage.",
        "+{{roll3}}% implicit shockwave size.",
        "Implicit shockwave's damage can affect enemies regardless of paralysis status.",
        "+{{roll1}} seconds to the implicit shockwave's cooldown.",
        "-{{roll2}}% speed and tears while the implicit shockwave is on cooldown."
    },
    ["aforge_mod_desc_tollingBell"] = {
        "Start with innate Leo.",
        "When certain sounds play, gain a temporary buff:",
        "- Explosion sounds: +{{roll1}}% speed for 3 seconds.",
        "- Broken rock sounds: +{{roll2}}% damage for 4 seconds.",
        "- Boss door closing: +{{roll3}}% tears for 7 seconds."
    },
    ["aforge_mod_desc_snakebite"] = {
        "Implicit instead fires 3 tears that poison on hit.",
        "These deal {{roll1}}% increased damage to already poisoned enemies."
    },
    ["aforge_mod_desc_devilTongue"] = {
        "Implicit tears petrify enemies for {{roll1}} second(s) on hit.",
        "Already petrified enemies are inflicted with burning for 3 seconds on hit.",
        "Implicit cooldown is raised to 3 seconds.",
        "+{{roll2}}% damage against burning enemies."
    },
    ["aforge_mod_desc_azurebinder"] = {
        "Implicit tears gain Lost Contact and Tiny Planet's effects.",
        "Implicit tears fly for longer.",
        "+{{roll1}}% damage for the current room per blocked tear, up to {{roll2}}%."
    },
    ["aforge_mod_desc_sacredScourge"] = {
        "After killing an undead enemy, for {{roll1}} seconds gain the following:",
        "   - Implicit fires an additional 2 tears.",
        "   - Implicit tears fly for longer.",
        "   - Halve implicit cooldown."
    },


    ["ui_ancwepBounties"] = "Ancient Weapon Bounties",
    ["ui_bounty"] = "Bounty",
    ["ui_selType"] = "Selected type",
    ["ui_leftRightSel"] = "Left/Right to select",
    ["ui_noCurrentBounty"] = "No current bounty",
    ["ui_generateBounty1"] = "Select a weapon type then hold Allocate for 1 second to generate",
    ["ui_generateBounty2"] = "a bounty. Generated bounty will pick a random ancient weapon of",
    ["ui_generateBounty3"] = "the selected type as a reward.",
    ["ui_generateBountyCost"] = "Generating/rerolling a bounty costs {{obolCost}} arcane obols.",
    ["ui_bountyObjectivesTip"] = "Bounty objectives (press TAB to view ancient weapon modifier)",
    ["ui_allocFinishBounty"] = "Hold Allocate for 1 second when finished to complete.",
    ["ui_respecAbandonBounty"] = "Hold Respec for 1 second to abandon this bounty.",
    ["ui_cannotProgBounty"] = "Current run cannot progress this bounty (not an expedition).",
    ["ui_weaponModBountyTip"] = "Weapon Modifier (press TAB to view bounty objectives)"
}