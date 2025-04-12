return {
    ---- SIDEREAL TREE NODE MODIFIERS ----
    ["node_siderealvicinity_name"] = "Sidereal Vicinity",
    ["node_siderealregion_name"] = "Sidereal Region",
    ["node_siderealexpanse_name"] = "Sidereal Expanse",
    ["node_siderealtravel"] = "Sidereal tree travel node. Costs no global SP to allocate, and costs Arcane Obols instead.",

    ["node_astralforge_name"] = "Astral Forge",
    ["node_astralforge"] = {
        "Unlocks the Astral Forge and Astral Weapons.",
        "Once allocated, press the Allocate button to access the forge menu."
    },
    ["node_bossastralweprate_name"] = "Boss Astral Weapon Drop Rate",
    ["node_bossastralweprate"] = {
        "+{{astralWepBossRate}}% chance for bosses to drop an Astral Weapon on death, up to 4 per room.",
        "Above 100% total chance, roll for multiple weapon drops."
    },
    ["node_magicastralweps_name"] = "Magic Astral Weapons",
    ["node_magicastralweps"] = "+{{astralWepMagicRate}}% chance for dropped Astral Weapons to be Magic.",
    ["node_ancientastralweps_name"] = "Ancient Astral Weapons",
    ["node_ancientastralweps"] = "+{{astralWepAncientRate}}% chance for dropped Astral Weapons to be Ancient.",

    ["node_wepdrop_longsword_name"] = "Astral Weapon Drops: Longswords",
    ["node_wepdrop_longsword"] = "+{{astralWepRateLongsword}}% chance for dropped Astral Weapons to be Longswords.",
    ["node_wepdrop_estoc_name"] = "Astral Weapon Drops: Estocs",
    ["node_wepdrop_estoc"] = "+{{astralWepRateEstoc}}% chance for dropped Astral Weapons to be Estocs.",
    ["node_wepdrop_dagger_name"] = "Astral Weapon Drops: Daggers",
    ["node_wepdrop_dagger"] = "+{{astralWepRateDagger}}% chance for dropped Astral Weapons to be Daggers.",
    ["node_wepdrop_quickblade_name"] = "Astral Weapon Drops: Quickblades",
    ["node_wepdrop_quickblade"] = "+{{astralWepRateQuickblade}}% chance for dropped Astral Weapons to be Quickblades.",
    ["node_wepdrop_spear_name"] = "Astral Weapon Drops: Spears",
    ["node_wepdrop_spear"] = "+{{astralWepRateSpear}}% chance for dropped Astral Weapons to be Spears.",
    ["node_wepdrop_trident_name"] = "Astral Weapon Drops: Tridents",
    ["node_wepdrop_trident"] = "+{{astralWepRateTrident}}% chance for dropped Astral Weapons to be Tridents.",
    ["node_wepdrop_scythe_name"] = "Astral Weapon Drops: Scythes",
    ["node_wepdrop_scythe"] = "+{{astralWepRateScythe}}% chance for dropped Astral Weapons to be Scythes.",
    ["node_wepdrop_axe_name"] = "Astral Weapon Drops: Axes",
    ["node_wepdrop_axe"] = "+{{astralWepRateAxe}}% chance for dropped Astral Weapons to be Axes.",
    ["node_wepdrop_greataxe_name"] = "Astral Weapon Drops: Greataxes",
    ["node_wepdrop_greataxe"] = "+{{astralWepRateGreataxe}}% chance for dropped Astral Weapons to be Greataxes.",
    ["node_wepdrop_shortbow_name"] = "Astral Weapon Drops: Shortbows",
    ["node_wepdrop_shortbow"] = "+{{astralWepRateShortbow}}% chance for dropped Astral Weapons to be Shortbows.",
    ["node_wepdrop_bow_name"] = "Astral Weapon Drops: Bows",
    ["node_wepdrop_bow"] = "+{{astralWepRateBow}}% chance for dropped Astral Weapons to be Bows.",
    ["node_wepdrop_crossbow_name"] = "Astral Weapon Drops: Crossbows",
    ["node_wepdrop_crossbow"] = "+{{astralWepRateCrossbow}}% chance for dropped Astral Weapons to be Crossbows.",
    ["node_wepdrop_gauntlet_name"] = "Astral Weapon Drops: Gauntlets",
    ["node_wepdrop_gauntlet"] = "+{{astralWepRateGauntlet}}% chance for dropped Astral Weapons to be Gauntlets.",
    ["node_wepdrop_greatmace_name"] = "Astral Weapon Drops: Great Maces",
    ["node_wepdrop_greatmace"] = "+{{astralWepRateGreatMace}}% chance for dropped Astral Weapons to be Great Maces.",
    ["node_wepdrop_whip_name"] = "Astral Weapon Drops: Whips",
    ["node_wepdrop_whip"] = "+{{astralWepRateWhip}}% chance for dropped Astral Weapons to be Whips.",

    ["node_sidecachechanceboost_name"] = "Sidereal Caches Chance Boost",
    ["node_sidecachechanceboost"] = {
        "When entering a new floor, +{{sideCacheFloorChance}}% chance added to all Sidereal Cache sources from other nodes.",
        "Does not apply during the Ascent."
    },
    ["node_sidecachechall_name"] = "Sidereal Caches - Challenge Rooms",
    ["node_sidecachechall"] = "{{sideCacheChallenge}}% chance for a Sidereal Cache to drop when clearing a challenge room.",
    ["node_sidecachebossroom_name"] = "Sidereal Caches - Boss Room Clear",
    ["node_sidecachebossroom"] = "{{sideCacheBoss}}% chance for a Sidereal Cache to drop when clearing a boss room past the first floor.",
    ["node_sidecacheregchest_name"] = "Sidereal Caches - Regular Chests",
    ["node_sidecacheregchest"] = {
        "{{sideCacheRegChest}}% chance for regular chests to be replaced with a Sidereal Cache when spawned.",
        "Affects up to 2 chests per room."
    },
    ["node_sidecachekeycons_name"] = "Sidereal Caches Key Consumption",
    ["node_sidecachekeycons"] = "{{sideCacheNoKey}}% chance for Sidereal Caches to consume no keys when opened.",
    ["node_sidecachereplica_name"] = "Sidereal Cache Replication",
    ["node_sidecachereplica"] = "{{sideCacheReplica}}% chance for Sidereal Caches to drop an additional cache when opened, once per room.",
    ["node_sidecachesacks_name"] = "Sidereal Cache Sacks",
    ["node_sidecachesacks"] = "{{sideCacheSacks}}% chance for Sidereal Caches to additionally drop 1-2 sacks when opened.",
    ["node_sidecacheastralweps_name"] = "Sidereal Cache Astral Weapons",
    ["node_sidecacheastralweps"] = {
        "{{sideCacheAstralWep}}% chance for Sidereal Caches to additionally drop a random Astral Weapon.",
        "Above 100% total chance, roll for multiple weapon drops."
    },
    ["node_sidecachejewels_name"] = "Sidereal Cache Starcursed Jewels",
    ["node_sidecachejewels"] = "{{sideCacheJewel}}% chance for Sidereal Caches to additionally drop a Starcursed Jewel when opened.",
    ["node_sidecachekeyret_name"] = "Sidereal Caches Key Return",
    ["node_sidecachekeyret"] = "{{sideCacheKeyReturn}}% chance for Sidereal Caches to return 1-2 keys when opened.",

    ["node_bosssparkdust_name"] = "Boss Sparkling Stardust",
    ["node_bosssparkdust"] = "+{{bossSparkStardust}}% chance for Bosses to grant Sparkling Stardust on death.",
    ["node_finalbossdust_name"] = "Final Boss Ancient Stardust",
    ["node_finalbossdust"] = "+{{bossExtraAncientStardust}}% chance for Final Bosses to grant an additional Ancient Stardust on death.",
    ["node_prehonedweps_name"] = "Pre-honed Weapon Drops",
    ["node_prehonedweps"] = {
        "{{preHonedWeps}}% chance for dropped Astral Weapons to have +1 Honing.",
        "This chance is applied once per allocated node of this type."
    },

    ["node_siderealuniv_name"] = "Sidereal Universalization",
    ["node_siderealuniv"] = {
        "Sidereal tree effects can now affect normal, non-expedition runs.",
        "Can't respec this node once allocated."
    },

    ["node_timelessbazaar_name"] = "Timeless Bazaar",
    ["node_timelessbazaar"] = {
        "Once allocated, press the Allocate button to access the Timeless Bazaar Menu.",
        "The Timeless Bazaar allows you to spend global SP and obols to purchase one-time items",
        "to be added to the next run you start."
    },
    ["node_bazaarqual0to1_name"] = "Bazaar Item Quality 0 to 1",
    ["node_bazaarqual0to1"] = "{{bazaarQual1}}% chance on Bazaar refresh to upgrade quality 0 items to quality 1.",
    ["node_bazaarqual1to2_name"] = "Bazaar Item Quality 1 to 2",
    ["node_bazaarqual1to2"] = "{{bazaarQual2}}% chance on Bazaar refresh to upgrade quality 1 items to quality 2.",
    ["node_bazaarqual2to3_name"] = "Bazaar Item Quality 2 to 3",
    ["node_bazaarqual2to3"] = "{{bazaarQual3}}% chance on Bazaar refresh to upgrade quality 2 items to quality 3.",
    ["node_bazaaraddoffer_name"] = "Bazaar Additional Offerings",
    ["node_bazaaraddoffer"] = {
        "{{bazaarExtraItem}}% chance on Bazaar refresh to include an additional item choice.",
        "Past 100% total chance, roll multiple times."
    },
    ["node_bazaarselkeep_name"] = "Bazaar Selection Keeping",
    ["node_bazaarselkeep"] = "{{bazaarSelKeep}}% chance to keep the other item choices when purchasing an item in the Bazaar.",
    ["node_bazaardevilitem_name"] = "Bazaar Devil Items",
    ["node_bazaardevilitem"] = "{{bazaarDevil}}% chance for offered items to be Devil pool items on Bazaar refresh.",
    ["node_bazaarangelitem_name"] = "Bazaar Angel Items",
    ["node_bazaarangelitem"] = "{{bazaarAngel}}% chance for offered items to be Angel pool items on Bazaar refresh.",
    ["node_bazaarrefresh_name"] = "Bazaar Refresh",
    ["node_bazaarrefresh"] = {
        "Enables the Bazaar's \"Refresh\" functionality, allowing you to spend global SP and obols",
        "to reroll the item selection."
    },
    ["node_bazaarrefreshkeep_name"] = "Bazaar Refresh Keeper",
    ["node_bazaarrefreshkeep"] = "{{bazaarRefreshKeep}}% chance to keep the Bazaar's Refresh button enabled on use.",

    ["node_charspconv_name"] = "Character SP Conversion",
    ["node_charspconv"] = "Once allocated, press the Allocate button to convert 1 character SP into 1 global SP.",
    ["node_globalspexchange_name"] = "Global Skill Point Exchange",
    ["node_obolexchange_name"] = "Obol Exchange",
    ["node_obolexchange"] = "Once allocated, press the Allocate button to convert 1 global SP into 10 Arcane Obols.",

    ["node_ancwepbounties_name"] = "Ancient Weapon Bounties",
    ["node_ancwepbounties"] = {
        "Allocate to unlock Ancient Weapon Bounties.",
        "This allows you to spend obols to generate a bounty for a chosen weapon type.",
        "Bounties provide a series of objectives you need to complete, and reward a random",
        "Ancient weapon of the chosen type on completion."
    },

    ["node_crimsonconvergence_name"] = "Crimson Convergence",
    ["node_crimsonconvergence"] = {
        "Once allocated, press Allocate to select one of multiple buffs.",
        "These buffs become more powerful the more Crimson Starcores you own with this character."
    },

    ["node_siderealartifact_name"] = "Sidereal Artifact",
    ["node_siderealartifact"] = {
        "Enables the selection of Artifacts that provide a condition to generate Energy, and",
        "an effect to trigger once enough energy is generated.",
        "By default you may only allocate 1 Septentrional and 1 Meridional Artifact.",
        "Artifacts can be allocated/respecced freely."
    },
    ["node_bloodseptentrion_name"] = "Blood Septentrion",
    ["node_taintbloodseptentrion_name"] = "Taintblood Septentrion",
    ["node_icyseptentrion_name"] = "Icy Septentrion",
    ["node_beastseekerseptentrion_name"] = "Beastseeker Septentrion",
    ["node_giantseekerseptentrion_name"] = "Giantseeker Septentrion",
    ["node_rotseekerseptentrion_name"] = "Rotseeker Septentrion",
    ["node_titanseekerseptentrion_name"] = "Titanseeker Septentrion",
    ["node_assassinseptentrion_name"] = "Assassin Septentrion",
    ["node_deathseekerseptentrion_name"] = "Deathseeker Septentrion",
    ["node_allianceseptentrion_name"] = "Alliance Septentrion",
    ["node_slayerseptentrion_name"] = "Slayer Septentrion",
    ["node_magicseptentrion_name"] = "Magic Septentrion",
    ["node_solarseptentrion_name"] = "Solar Septentrion",
    ["node_lunarseptentrion_name"] = "Lunar Septentrion",
    ["node_superstitiousseptentrion_name"] = "Superstitious Septentrion",

    ["node_galvanicmeridion_name"] = "Galvanic Meridion",
    ["node_glacialmeridion_name"] = "Glacial Meridion",
    ["node_smitingmeridion_name"] = "Smiting Meridion",
    ["node_infectiousmeridion_name"] = "Infectious Meridion",
    ["node_virtuousmeridion_name"] = "Virtuous Meridion",
    ["node_stonemeridion_name"] = "Stone Meridion",
    ["node_infernalmeridion_name"] = "Infernal Meridion",
    ["node_deadseameridion_name"] = "Dead Sea Meridion",
    ["node_flowingmeridion_name"] = "Flowing Meridion",
    ["node_osseousmeridion_name"] = "Osseous Meridion",
    ["node_monstrousmeridion_name"] = "Monstrous Meridion",
    ["node_brimmeridion_name"] = "Brim Meridion",
    ["node_executionermeridion_name"] = "Executioner Meridion",
    ["node_blastingmeridion_name"] = "Blasting Meridion",
    ["node_gildedmeridion_name"] = "Gilded Meridion",
    ["node_smeltermeridion_name"] = "Smelter Meridion",
    ["node_siderealmeridion_name"] = "Sidereal Meridion",
    ["node_snakeeyemeridion_name"] = "Snake-Eye Meridion",
    ["node_bloodmoonmeridion_name"] = "Bloodmoon Meridion",

    ["node_addseptentrional_name"] = "Additional Septentrional Choice",
    ["node_addseptentrional"] = "Allows allocating an additional Septentrional Artifact.",

    ["node_obolmagnetism_name"] = "Obol Magnetism",
    ["node_obolmagnetism"] = "Dropped arcane obols are now slowly attracted towards you.",

    ["node_ancwepcompendium_name"] = "Ancient Weapon Compendium",
    ["node_ancwepcompendium"] = {
        "Once allocated, press Allocate to open a list of all available Ancient Weapons for each",
        "weapon type."
    }
}