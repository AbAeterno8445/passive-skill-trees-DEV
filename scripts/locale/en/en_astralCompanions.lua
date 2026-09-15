return {
    ---- ASTRAL COMPANIONS UI ----
    ["astralcomp_ui_allocEquipEgg"] = "Press Allocate to equip this egg in this incubator.",
    ["astralcomp_ui_allocUnequipEgg"] = "Press Allocate to unequip this egg from this incubator.",
    ["astralcomp_ui_eggHatchReady"] = "Ready. Press Allocate to hatch this egg!",

    ["astralcomp_ui_allocEquipComp"] = "Press Allocate to equip this companion in this slot.",
    ["astralcomp_ui_allocUnequipComp"] = "Press Allocate to unequip this companion from this slot.",
    ["astralcomp_ui_compLevelReady"] = "Ready to level up! Press Allocate to level up this companion.",

    ["astralcomp_ui_equippedEgg"] = "Equipped egg",
    ["astralcomp_ui_equippedComp"] = "Equipped companion",

    ["astralcomp_ui_lv3effect"] = "Level 3 effect",
    ["astralcomp_ui_lv3rewards"] = "Level 3 rewards",
    ["astralcomp_ui_eggHatchObj"] = "Egg hatching objective",
    ["astralcomp_ui_hatchingPaused"] = "Hatching paused. Equip the egg to progress its hatching.",
    ["astralcomp_ui_currentlyHatching"] = "Currently hatching.",
    ["astralcomp_ui_hatchComplete"] = "Hatching complete!",
    ["astralcomp_ui_eggHatchInto"] = "Egg hatched into",
    ["astralcomp_ui_hatchCompHint"] = "You may now equip the hatched companion in one of the Companion Slot nodes to the right.",
    ["astralcomp_ui_eggNotFound"] = "Egg not found yet.",
    ["astralcomp_ui_locHint"] = "Location hint",
    ["astralcomp_ui_scavengedObols"] = "Scavenged obols",
    ["astralcomp_ui_cannotSwitchComp"] = "Cannot switch companions while in a run.",
    ["astralcomp_foundEgg"] = "Found Egg",

    ["astralcomp_ui_slotActiveWarn1"] = "Companions in this slot are only active between floors 1 and 5.",
    ["astralcomp_ui_slotActiveWarn2"] = "Companions in this slot are only active between floors 6 and 10.",
    ["astralcomp_ui_slotActiveWarn3"] = "Companions in this slot are always active.",

    ---- ASTRAL COMPANIONS ----
    ["astralcomp_rat_name"] = "Rat",
    ["astralcomp_rat_eggname"] = "Skittish Brown Egg",
    ["astralcomp_rat_obj"] = "Collect coins of any type.",
    ["astralcomp_rat_eggHint"] = "Floor 1 or 2 bosses.",
    ["astralcomp_rat_scavenge"] = "Scavenges {{obolCount}} arcane obols when collecting coins, up to {{floorLimit}} times per floor.",
    ["astralcomp_rat_maxeffects"] = {
        "7% chance to spawn an additional coin when clearing a room."
    },

    ["astralcomp_riverrat_name"] = "River Rat",
    ["astralcomp_riverrat_eggname"] = "Damp Green Egg",
    ["astralcomp_riverrat_obj"] = "Collect unusual coins (any non-regular such as doubles, lucky, nickels, etc.).",
    ["astralcomp_riverrat_eggHint"] = "Bosses in Downpour, Dross or Flooded Caves.",
    ["astralcomp_riverrat_scavenge"] = "Scavenges {{obolCount}} arcane obols when collecting unusual coins, up to {{floorLimit}} times per floor.",
    ["astralcomp_riverrat_maxeffects"] = {
        "15% chance for pennies to be converted to double pennies on spawn."
    },

    ["astralcomp_hellrat_name"] = "Hell Rat",
    ["astralcomp_hellrat_eggname"] = "Sulphurous Skittish Egg",
    ["astralcomp_hellrat_obj"] = "Collect coins at or past the Womb.",
    ["astralcomp_hellrat_eggHint"] = "Mom.",
    ["astralcomp_hellrat_scavenge"] = "Scavenges {{obolCount}} arcane obols when collecting coins at or past the Womb, up to {{floorLimit}} times per floor.",
    ["astralcomp_hellrat_maxeffects"] = {
        "8% chance for champion monsters to drop an additional coin on death, increased by 1% per completed floor."
    },

    ["astralcomp_quokka_name"] = "Quokka",
    ["astralcomp_quokka_eggname"] = "Light Mundane Egg",
    ["astralcomp_quokka_obj"] = "Collect pickups.",
    ["astralcomp_quokka_eggHint"] = "Floor 1 or 2 bosses without taking damage.",
    ["astralcomp_quokka_scavenge"] = "Scavenges {{obolCount}} arcane obols when collecting pickups, up to {{floorLimit}} times per floor.",
    ["astralcomp_quokka_maxeffects"] = {
        "7% chance for coins/keys/bombs to give an additional one when collected."
    },

    ["astralcomp_jackal_name"] = "Jackal",
    ["astralcomp_jackal_eggname"] = "Cackling Egg",
    ["astralcomp_jackal_obj"] = "Open regular chests.",
    ["astralcomp_jackal_eggHint"] = "Regular chests (Rate: 10% of the total chance to find eggs).",
    ["astralcomp_jackal_scavenge"] = "Scavenges {{obolCount}} arcane obols when opening regular chests, up to {{floorLimit}} times per floor.",
    ["astralcomp_jackal_maxeffects"] = {
        "+10% chance for champion monsters to drop a regular chest on death."
    },

    ["astralcomp_hound_name"] = "Hound",
    ["astralcomp_hound_eggname"] = "Loyal Egg",
    ["astralcomp_hound_obj"] = "Open golden chests.",
    ["astralcomp_hound_eggHint"] = "Golden chests (Rate: 10% of the total chance to find eggs).",
    ["astralcomp_hound_scavenge"] = "Scavenges {{obolCount}} arcane obols when opening golden chests, up to {{floorLimit}} times per floor.",
    ["astralcomp_hound_maxeffects"] = {
        "+10% chance to additionally spawn a golden chest when clearing a room, up to twice per floor."
    },

    ["astralcomp_wolf_name"] = "Wolf",
    ["astralcomp_wolf_eggname"] = "Howling Egg",
    ["astralcomp_wolf_obj"] = "Open non-regular chests.",
    ["astralcomp_wolf_eggHint"] = "Stone chests (Rate: 10% of the total chance to find eggs).",
    ["astralcomp_wolf_scavenge"] = "Scavenges {{obolCount}} arcane obols when opening non-regular chests, up to {{floorLimit}} times per floor.",
    ["astralcomp_wolf_maxeffects"] = {
        "+7% chance for chests to re-close when opened."
    },

    ["astralcomp_cosmichound_name"] = "Cosmic Hound",
    ["astralcomp_cosmichound_eggname"] = "Egg of Tindalos",
    ["astralcomp_cosmichound_obj"] = "Open Sidereal Caches.",
    ["astralcomp_cosmichound_eggHint"] = "Sidereal caches (Rate: 25% of the total chance to find eggs).",
    ["astralcomp_cosmichound_scavenge"] = "Scavenges {{obolCount}} arcane obols when opening Sidereal Caches, up to {{floorLimit}} times per floor.",
    ["astralcomp_cosmichound_maxeffects"] = {
        "+5% chance to additionally spawn a Sidereal Cache when clearing a room past the first floor, up to twice per floor."
    },

    ["astralcomp_hellhound_name"] = "Hell Hound",
    ["astralcomp_hellhound_eggname"] = "Brim Egg",
    ["astralcomp_hellhound_obj"] = "Kill burning enemies.",
    ["astralcomp_hellhound_eggHint"] = "Kill a boss at or past the Womb while it is burning.",
    ["astralcomp_hellhound_scavenge"] = "Scavenges {{obolCount}} arcane obols when killing burning enemies, up to {{floorLimit}} times per floor.",
    ["astralcomp_hellhound_maxeffects"] = {
        "+0.5% damage for the room when killing burning enemies, up to 8%."
    },

    ["astralcomp_raiju_name"] = "Raiju",
    ["astralcomp_raiju_eggname"] = "Galvanic Egg",
    ["astralcomp_raiju_obj"] = "Collect batteries and use battery actives.",
    ["astralcomp_raiju_eggHint"] = "Hidden amongst charged keys (Rate: 33% of the total chance to find eggs).",
    ["astralcomp_raiju_scavenge"] = "Scavenges {{obolCount}} arcane obols when collecting batteries or using battery actives with at least 1 charge, up to {{floorLimit}} times per floor.",
    ["astralcomp_raiju_maxeffects"] = {
        "Spawn an Old Capacitor at the beginning of the first floor.",
        "While you have Old Capacitor, champions and bosses have a 20% chance to drop a micro battery on death, which vanishes after 7 seconds.",
        "7% chance to spawn an additional lil battery when clearing a room, up to 3 times per floor."
    },

    ["astralcomp_boulderbeetle_name"] = "Boulder Beetle",
    ["astralcomp_boulderbeetle_eggname"] = "Rocky Egg",
    ["astralcomp_boulderbeetle_obj"] = "Destroy tinted rocks.",
    ["astralcomp_boulderbeetle_eggHint"] = "Tinted rocks (Rate: 25% of the total chance to find eggs).",
    ["astralcomp_boulderbeetle_scavenge"] = "Scavenges {{obolCount}} arcane obols when destroying tinted rocks.",
    ["astralcomp_boulderbeetle_maxeffects"] = {
        "When entering a room, +7% chance to replace a random rock with a tinted rock, up to 5 times per floor."
    },

    ["astralcomp_bombardierbeetle_name"] = "Bombardier Beetle",
    ["astralcomp_bombardierbeetle_eggname"] = "Chitinous Powdery Egg",
    ["astralcomp_bombardierbeetle_obj"] = "Destroy urns.",
    ["astralcomp_bombardierbeetle_eggHint"] = "Urns (Rate: 10% of the total chance to find eggs).",
    ["astralcomp_bombardierbeetle_scavenge"] = "Scavenges {{obolCount}} arcane obols when destroying urns, up to {{floorLimit}} times per floor.",
    ["astralcomp_bombardierbeetle_maxeffects"] = {
        "Start with an additional bomb."
    },

    ["astralcomp_deathscarab_name"] = "Death Scarab",
    ["astralcomp_deathscarab_eggname"] = "Chitinous Deathly Egg",
    ["astralcomp_deathscarab_obj"] = "Destroy skulls and hosts.",
    ["astralcomp_deathscarab_eggHint"] = "Skulls and Hosts (Rate: 10% of the total chance to find eggs).",
    ["astralcomp_deathscarab_scavenge"] = "Scavenges {{obolCount}} arcane obols when destroying skulls or killing hosts, up to {{floorLimit}} times per floor.",
    ["astralcomp_deathscarab_maxeffects"] = {
        "+7% damage against undead enemies.",
        "15% chance to create a blue fly when killing undead enemies, up to 10 times per room."
    },

    ["astralcomp_pharaohant_name"] = "Pharaoh Ant",
    ["astralcomp_pharaohant_eggname"] = "Chitinous Mummified Egg",
    ["astralcomp_pharaohant_obj"] = "Kill undead enemies.",
    ["astralcomp_pharaohant_eggHint"] = "Undead bosses (Rate: 40% of the total chance to find eggs).",
    ["astralcomp_pharaohant_scavenge"] = "{{scavChance}}% chance to scavenge {{obolCount}} arcane obols when killing undead enemies, up to {{floorLimit}} times per floor.",
    ["astralcomp_pharaohant_maxeffects"] = {
        "+15% chance for undead enemies to become champions."
    },

    ["astralcomp_clockroach_name"] = "Clockroach",
    ["astralcomp_clockroach_eggname"] = "Chitinous Untimely Egg",
    ["astralcomp_clockroach_obj"] = "Kill slowed and frozen enemies.",
    ["astralcomp_clockroach_eggHint"] = "Slowed champions (Rate: 10% of the total chance to find eggs).",
    ["astralcomp_clockroach_scavenge"] = "{{scavChance}}% chance to scavenge {{obolCount}} arcane obols when killing slowed or frozen enemies, up to {{floorLimit}} times per floor.",
    ["astralcomp_clockroach_maxeffects"] = {
        "The first enemy you hit in a room is slowed for 8 seconds. Ignores boss status cooldown."
    },

    ["astralcomp_butterfly_name"] = "Butterfly",
    ["astralcomp_butterfly_eggname"] = "Fluttering Egg",
    ["astralcomp_butterfly_obj"] = "Enter non-regular rooms.",
    ["astralcomp_butterfly_eggHint"] = "Secret rooms at or past the Womb.",
    ["astralcomp_butterfly_scavenge"] = "Scavenges {{obolCount}} arcane obols when first entering non-regular rooms.",
    ["astralcomp_butterfly_maxeffects"] = {
        "+0.01 speed for the current floor when first entering non-regular rooms."
    },

    ["astralcomp_lunarmoth_name"] = "Lunar Moth",
    ["astralcomp_lunarmoth_eggname"] = "Chitinous Lunar Egg",
    ["astralcomp_lunarmoth_obj"] = "Enter any kind of secret room.",
    ["astralcomp_lunarmoth_eggHint"] = "Super secret rooms (Rate: 33% of the total chance to find eggs).",
    ["astralcomp_lunarmoth_scavenge"] = "Scavenges {{obolCount}} arcane obols when first entering any kind of secret room.",
    ["astralcomp_lunarmoth_maxeffects"] = {
        "+1% all stats when first entering a secret room, up to 5%. Total bonus is halved when entering a new floor."
    },

    ["astralcomp_crimsonmoth_name"] = "Crimson Moth",
    ["astralcomp_crimsonmoth_eggname"] = "Chitinous Otherside Egg",
    ["astralcomp_crimsonmoth_obj"] = "Enter red rooms.",
    ["astralcomp_crimsonmoth_eggHint"] = "Red rooms (Rate: 8% of the total chance to find eggs).",
    ["astralcomp_crimsonmoth_scavenge"] = "{{scavChance}}% chance to scavenge {{obolCount}} arcane obols when entering red rooms with monsters, up to {{floorLimit}} times per floor.",
    ["astralcomp_crimsonmoth_maxeffects"] = {
        "Innately gain Glyph of Balance's effect while in red rooms, if you don't already have it.",
        "+3% speed while in red rooms."
    },

    ["astralcomp_adder_name"] = "Adder",
    ["astralcomp_adder_eggname"] = "Green Egg",
    ["astralcomp_adder_obj"] = "Inflict poison on enemies.",
    ["astralcomp_adder_eggHint"] = "Poisoned champions (Rate: 8% of the total chance to find eggs).",
    ["astralcomp_adder_scavenge"] = "{{scavChance}}% chance to scavenge {{obolCount}} arcane obols when killing poisoned enemies, up to {{floorLimit}} times per floor.",
    ["astralcomp_adder_maxeffects"] = {
        "Enemies take 1% more damage per second of remaining poison.",
        "Poisoned champions are 7% more likely to drop obols on death."
    },

    ["astralcomp_watermoccasin_name"] = "Water Moccasin",
    ["astralcomp_watermoccasin_eggname"] = "Damp Brown Egg",
    ["astralcomp_watermoccasin_obj"] = "Poison enemies with at least 40 HP.",
    ["astralcomp_watermoccasin_eggHint"] = "Flooded Caves bosses (Rate: 50% of the total chance to find eggs).",
    ["astralcomp_watermoccasin_scavenge"] = "{{scavChance}}% chance to scavenge {{obolCount}} arcane obols when killing poisoned enemies with at least 40 HP, up to {{floorLimit}} times per floor.",
    ["astralcomp_watermoccasin_maxeffects"] = {
        "+0.5% damage for the room when killing poisoned enemies, up to 10%.",
        "+0.05 luck for the current floor when killing poisoned enemies, up to +3."
    },

    ["astralcomp_blackmamba_name"] = "Black Mamba",
    ["astralcomp_blackmamba_eggname"] = "Indigo Egg",
    ["astralcomp_blackmamba_obj"] = "Kill poisoned enemies.",
    ["astralcomp_blackmamba_eggHint"] = "Poisoned bosses past floor 2 (Rate: 40% of the total chance to find eggs).",
    ["astralcomp_blackmamba_scavenge"] = "Scavenges {{obolCount}} arcane obols when killing poisoned champions, up to {{floorLimit}} times per floor.",
    ["astralcomp_blackmamba_maxeffects"] = {
        "+0.05 luck for the current floor when killing poisoned enemies, up to +3.",
        "Poisoned champions are 7% more likely to drop obols on death."
    },

    ["astralcomp_manaviper_name"] = "Mana Viper",
    ["astralcomp_manaviper_eggname"] = "Mana Egg",
    ["astralcomp_manaviper_obj"] = "Use active items. Progresses 1 per used charge.",
    ["astralcomp_manaviper_eggHint"] = "Hidden amongst sold shop pickups (Rate: 10% of the total chance to find eggs).",
    ["astralcomp_manaviper_scavenge"] = "Scavenges {{obolCount}} arcane obols when using active items, up to {{floorLimit}} times per floor.",
    ["astralcomp_manaviper_maxeffects"] = {
        "7% chance to spawn a micro battery when using an active item with at least 2 charges."
    },

    ["astralcomp_anaconda_name"] = "Anaconda",
    ["astralcomp_anaconda_eggname"] = "Constricting Egg",
    ["astralcomp_anaconda_obj"] = "Petrify enemies.",
    ["astralcomp_anaconda_eggHint"] = "Petrified champions (Rate: 7% of the total chance to find eggs).",
    ["astralcomp_anaconda_scavenge"] = "{{scavChance}}% chance to scavenge {{obolCount}} arcane obols when first inflicting petrification on enemies, up to {{floorLimit}} times per floor.",
    ["astralcomp_anaconda_maxeffects"] = {
        "+0.5% damage for the room when killing petrified enemies, up to 8%.",
        "Enemies take 1% more damage per second of remaining petrification."
    },

    ["astralcomp_snappingturtle_name"] = "Snapping Turtle",
    ["astralcomp_snappingturtle_eggname"] = "Snapping Egg",
    ["astralcomp_snappingturtle_obj"] = "Kill boss monsters outside boss rooms.",
    ["astralcomp_snappingturtle_eggHint"] = "Boss monsters outside boss rooms at or past the Womb (Rate: 10% of the total chance to find eggs).",
    ["astralcomp_snappingturtle_scavenge"] = "{{scavChance}}% chance to scavenge {{obolCount}} arcane obols when killing boss monsters outside boss rooms, up to {{floorLimit}} times per floor.",
    ["astralcomp_snappingturtle_maxeffects"] = {
        "50% chance to block damage received by bosses outside boss rooms. Once triggered, chance gets halved for the rest of the run."
    },

    ["astralcomp_alligatorsnappingturtle_name"] = "Alligator Snapping Turtle",
    ["astralcomp_alligatorsnappingturtle_eggname"] = "Large Snapping Egg",
    ["astralcomp_alligatorsnappingturtle_obj"] = "Clear boss rooms.",
    ["astralcomp_alligatorsnappingturtle_eggHint"] = "Cleared boss rooms past floor 1 (Rate: 5% of the total chance to find eggs).",
    ["astralcomp_alligatorsnappingturtle_scavenge"] = "Scavenges {{obolCount}} arcane obols when clearing boss rooms.",
    ["astralcomp_alligatorsnappingturtle_maxeffects"] = {
        "25% chance to block damage received in boss rooms, once per room."
    },

    ["astralcomp_mountainshell_name"] = "Mountainshell",
    ["astralcomp_mountainshell_eggname"] = "Mountain Egg",
    ["astralcomp_mountainshell_obj"] = "Clear boss rooms without taking damage.",
    ["astralcomp_mountainshell_eggHint"] = "Boss rooms cleared without taking damage past floor 2 (Rate: 33% of the total chance to find eggs).",
    ["astralcomp_mountainshell_scavenge"] = "Scavenges {{obolCount}} arcane obols when clearing boss rooms without taking damage.",
    ["astralcomp_mountainshell_maxeffects"] = {
        "Block the first two hits you receive from final bosses."
    },

    ["astralcomp_culicivora_name"] = "Culicivora",
    ["astralcomp_culicivora_eggname"] = "Skittering Dark Egg",
    ["astralcomp_culicivora_obj"] = "Kill bleeding enemies.",
    ["astralcomp_culicivora_eggHint"] = "Bleeding champions past floor 2 (Rate: 8% of the total chance to find eggs).",
    ["astralcomp_culicivora_scavenge"] = "Scavenges {{obolCount}} arcane obols when killing bleeding enemies, up to {{floorLimit}} times per floor.",
    ["astralcomp_culicivora_maxeffects"] = {
        "+0.5% damage for the room when killing bleeding enemies, up to 8%.",
        "Enemies take 1% more damage per second of remaining bleed."
    },

    ["astralcomp_abyssaltarantula_name"] = "Abyssal Tarantula",
    ["astralcomp_abyssaltarantula_eggname"] = "Skittering Abyssal Egg",
    ["astralcomp_abyssaltarantula_obj"] = "Inflict fear on enemies.",
    ["astralcomp_abyssaltarantula_eggHint"] = "Feared champions past floor 2 (Rate: 8% of the total chance to find eggs).",
    ["astralcomp_abyssaltarantula_scavenge"] = "{{scavChance}}% chance to scavenge {{obolCount}} arcane obols when killing feared enemies, up to {{floorLimit}} times per floor.",
    ["astralcomp_abyssaltarantula_maxeffects"] = {
        "+0.5% damage for the room when killing feared enemies, up to 8%.",
        "Enemies take 1% more damage per second of remaining fear."
    },

    ["astralcomp_jumpingspider_name"] = "Jumping Spider",
    ["astralcomp_jumpingspider_eggname"] = "Skittering Jumpy Egg",
    ["astralcomp_jumpingspider_obj"] = "Inflict slow on enemies more than 3 tiles away from you.",
    ["astralcomp_jumpingspider_eggHint"] = "Spider bosses (Rate: 40% of the total chance to find eggs).",
    ["astralcomp_jumpingspider_scavenge"] = "Scavenges {{obolCount}} arcane obols when killing slowed champions and bosses, up to {{floorLimit}} times per floor.",
    ["astralcomp_jumpingspider_maxeffects"] = {
        "+0.5% damage for the room when killing slowed enemies, up to 8%.",
        "Enemies take 1% more damage per second of remaining slow."
    },

    ["astralcomp_scorpion_name"] = "Scorpion",
    ["astralcomp_scorpion_eggname"] = "Chitinous Brown Egg",
    ["astralcomp_scorpion_obj"] = "Kill enemies with 6 base HP or less.",
    ["astralcomp_scorpion_eggHint"] = "Deadly sin bosses (Rate: 40% of the total chance to find eggs).",
    ["astralcomp_scorpion_scavenge"] = "{{scavChance}}% chance to scavenge {{obolCount}} arcane obols when killing enemies with 6 base HP or less, up to {{floorLimit}} times per floor.",
    ["astralcomp_scorpion_maxeffects"] = {
        "1% chance to drop a 1/2 heart when killing enemies with 6 base HP or less, up to 3 times per floor."
    },

    ["astralcomp_emperorscorpion_name"] = "Emperor Scorpion",
    ["astralcomp_emperorscorpion_eggname"] = "Regal Chitinous Egg",
    ["astralcomp_emperorscorpion_obj"] = "Kill enemies with base HP between 10 and 30.",
    ["astralcomp_emperorscorpion_eggHint"] = "Super deadly sin bosses (Rate: 33% of the total chance to find eggs).",
    ["astralcomp_emperorscorpion_scavenge"] = "{{scavChance}}% chance to scavenge {{obolCount}} arcane obols when killing enemies with base HP between 10 and 30, up to {{floorLimit}} times per floor.",
    ["astralcomp_emperorscorpion_maxeffects"] = {
        "1% chance to drop a 1/2 soul heart when killing enemies with base HP between 10 and 30, up to twice per floor."
    },

    ["astralcomp_cosmicjellyfish_name"] = "Cosmic Jellyfish",
    ["astralcomp_cosmicjellyfish_eggname"] = "Cosmic Graceful Egg",
    ["astralcomp_cosmicjellyfish_obj"] = "Clear floors past the first with any remaining soul hearts.",
    ["astralcomp_cosmicjellyfish_eggHint"] = "Hidden amongst blue passive items (Rate: 8% of the total chance to find eggs).",
    ["astralcomp_cosmicjellyfish_scavenge"] = "{{scavChance}}% chance per 1/2 soul heart you have to scavenge {{obolCount}} arcane obols when clearing a floor past the first.",
    ["astralcomp_cosmicjellyfish_maxeffects"] = {
        "When entering a floor past the first, +1% speed and shot speed for that floor per full soul heart you have, up to 7%."
    },

    ["astralcomp_manticore_name"] = "Manticore",
    ["astralcomp_manticore_eggname"] = "Cross-bred Egg",
    ["astralcomp_manticore_obj"] = "Kill enemies affected by any status effect.",
    ["astralcomp_manticore_eggHint"] = "Hidden amongst red passive items (Rate: 8% of the total chance to find eggs).",
    ["astralcomp_manticore_scavenge"] = "{{scavChance}}% chance to scavenge {{obolCount}} arcane obols when first inflicting status effects on boss monsters, up to {{floorLimit}} times per floor.",
    ["astralcomp_manticore_maxeffects"] = {
        "Boss monsters take 2% increased damage for each different status effect they've received."
    },

    ["astralcomp_catoblepas_name"] = "Catoblepas",
    ["astralcomp_catoblepas_eggname"] = "Strange Petrified Egg",
    ["astralcomp_catoblepas_obj"] = "Inflict petrification on boss monsters.",
    ["astralcomp_catoblepas_eggHint"] = "Regular Sheol rooms with monsters (Rate: 5% of the total chance to find eggs).",
    ["astralcomp_catoblepas_scavenge"] = "{{scavChance}}% chance to scavenge {{obolCount}} arcane obols when first inflicting petrification on boss monsters, up to {{floorLimit}} times per floor.",
    ["astralcomp_catoblepas_maxeffects"] = {
        "Petrified champions are 15% more likely to drop obols on death."
    },

    ["astralcomp_skyshark_name"] = "Skyshark",
    ["astralcomp_skyshark_eggname"] = "Floaty Incisive Egg",
    ["astralcomp_skyshark_obj"] = "Kill bleeding flying enemies.",
    ["astralcomp_skyshark_eggHint"] = "Bleeding flying tainted enemies (Rate: 20% of the total chance to find eggs).",
    ["astralcomp_skyshark_scavenge"] = "{{scavChance}}% chance to scavenge {{obolCount}} arcane obols when killing bleeding flying enemies, up to {{floorLimit}} times per floor.",
    ["astralcomp_skyshark_maxeffects"] = {
        "Killing bleeding flying enemies grants +1% damage for 7 seconds, which stacks up to 8%.",
        "Bleeding champions are 7% more likely to drop obols on death."
    },

    ["astralcomp_goldendragon_name"] = "Golden Dragon",
    ["astralcomp_goldendragon_eggname"] = "Gilded Egg",
    ["astralcomp_goldendragon_obj"] = "Defeat final bosses.",
    ["astralcomp_goldendragon_eggHint"] = "Final bosses (Rate: 50% of the total chance to find eggs).",
    ["astralcomp_goldendragon_scavenge"] = "Scavenges {{obolCount}} arcane obols when defeating a final boss, once per run.",
    ["astralcomp_goldendragon_maxeffects"] = {
        "+7% damage dealt to final bosses."
    },

    ["astralcomp_shadowdragon_name"] = "Shadow Dragon",
    ["astralcomp_shadowdragon_eggname"] = "Shadow Egg",
    ["astralcomp_shadowdragon_obj"] = "Perform deals with the devil.",
    ["astralcomp_shadowdragon_eggHint"] = "Hidden amongst devil deals (Rate: 10% of the total chance to find eggs).",
    ["astralcomp_shadowdragon_scavenge"] = "Scavenges {{obolCount}} arcane obols when performing devil deals.",
    ["astralcomp_shadowdragon_maxeffects"] = {
        "+2% damage per devil deal performed, up to 16%."
    },

    ["astralcomp_pearldragon_name"] = "Pearl Dragon",
    ["astralcomp_pearldragon_eggname"] = "Pearly Egg",
    ["astralcomp_pearldragon_obj"] = "Obtain angelic passive items and defeat Angel bosses.",
    ["astralcomp_pearldragon_eggHint"] = "Angel rooms (Rate: 20% of the total chance to find eggs).",
    ["astralcomp_pearldragon_scavenge"] = "Scavenges {{obolCount}} arcane obols when first obtaining angelic passive items or defeating Angel bosses.",
    ["astralcomp_pearldragon_maxeffects"] = {
        "+2% damage when first entering an angel room in a floor, up to 10%."
    },

    ["astralcomp_icebeast_name"] = "Ice Beast",
    ["astralcomp_icebeast_eggname"] = "Icy Egg",
    ["astralcomp_icebeast_obj"] = "Destroy frozen monsters.",
    ["astralcomp_icebeast_eggHint"] = "Frozen monsters with at least 20 HP (Rate: 10% of the total chance to find eggs).",
    ["astralcomp_icebeast_scavenge"] = "{{scavChance}}% chance to scavenge {{obolCount}} arcane obols when destroying frozen monsters with at least 20 HP, up to {{floorLimit}} times per floor.",
    ["astralcomp_icebeast_maxeffects"] = {
        "+1% damage for the floor for every 8 frozen monsters you destroy, up to 8%."
    },

    ["astralcomp_gildedgolem_name"] = "Gilded Golem",
    ["astralcomp_gildedgolem_eggname"] = "Solid Gold Egg",
    ["astralcomp_gildedgolem_obj"] = "Purchase shop items.",
    ["astralcomp_gildedgolem_eggHint"] = "Hidden amongst shop items worth at least 10 coins (Rate: 10% of the total chance to find eggs).",
    ["astralcomp_gildedgolem_scavenge"] = "Scavenges {{obolCount}} arcane obol(s) per coin spent in shops, up to {{floorLimit}} per floor.",
    ["astralcomp_gildedgolem_maxeffects"] = {
        "+1% damage for the floor per item purchased in the shop, up to 10%."
    },

    ["astralcomp_salamander_name"] = "Salamander",
    ["astralcomp_salamander_eggname"] = "Hearty Egg",
    ["astralcomp_salamander_obj"] = "Collect red hearts.",
    ["astralcomp_salamander_eggHint"] = "Hidden amongst red heart pickups (Rate: 2% of the total chance to find eggs).",
    ["astralcomp_salamander_scavenge"] = "Scavenges {{obolCount}} arcane obols when collecting red hearts, up to {{floorLimit}} times per floor.",
    ["astralcomp_salamander_maxeffects"] = {
        "+1% luck for the floor when collecting red hearts, up to 20%."
    },

    ["astralcomp_warg_name"] = "Warg",
    ["astralcomp_warg_eggname"] = "Challenger Egg",
    ["astralcomp_warg_obj"] = "Clear challenge rooms.",
    ["astralcomp_warg_eggHint"] = "Challenge rooms.",
    ["astralcomp_warg_scavenge"] = "Scavenges {{obolCount}} arcane obols when clearing challenge rooms.",
    ["astralcomp_warg_maxeffects"] = {
        "+1% all stats when clearing challenge rooms, up to 7% per run."
    },

    ["astralcomp_dreamsheep_name"] = "Dream Sheep",
    ["astralcomp_dreamsheep_eggname"] = "Dreamy Egg",
    ["astralcomp_dreamsheep_obj"] = "Earn experience.",
    ["astralcomp_dreamsheep_eggHint"] = "Clean bedroom.",
    ["astralcomp_dreamsheep_scavenge"] = "Scavenges ({{obolCount}} + floor) arcane obols when clearing a room while you haven't taken damage in the current floor.",
    ["astralcomp_dreamsheep_maxeffects"] = {
        "+15% exp and obols found while you haven't taken damage in the current floor.",
        "When first taking damage in a floor, 15% chance to spawn a 1/2 soul heart if you have less than 2 soul hearts."
    },

    ["astralcomp_bluecap_name"] = "Bluecap",
    ["astralcomp_bluecap_eggname"] = "Blue Fungal Egg",
    ["astralcomp_bluecap_obj"] = "Use pills and destroy mushrooms.",
    ["astralcomp_bluecap_eggHint"] = "Mushrooms (Rate: 10% of the total chance to find eggs).",
    ["astralcomp_bluecap_scavenge"] = "Scavenges {{obolCount}} arcane obols when using pills and destroying mushrooms, up to {{floorLimit}} times per floor.",
    ["astralcomp_bluecap_maxeffects"] = {
        "+1% damage when using a pill, up to 7%. Resets when entering a new floor.",
        "Champions have a 7% chance to drop an additional random pill on death, once per floor."
    }
}