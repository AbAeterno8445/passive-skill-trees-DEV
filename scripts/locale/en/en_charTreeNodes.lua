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


    -- MAGDALENE'S TREE
    ["node_magdaleneblessing_name"] = "Magdalene's Blessing",
    ["node_magdaleneblessing"] = {
        "+{{speed}} speed.",
        "{{damage}} damage.",
        "-0.02 speed and +0.2 damage for every red heart container after the 4th one."
    },
    ["node_crystalheart_name"] = "Crystal Heart",
    ["node_crystalheart"] = {
        "Yum heart heals an additional 1/2 heart.",
        "7% chance for Yum Heart to turn a red heart into a bone heart."
    },
    ["node_blood_donor_name"] = "Blood Donor",
    ["node_blood_donor"] = {
        "Blood donation machines grant 1 charge to your active item.",
        "If using Yum Heart, 50% chance to gain 2 charges instead."
    },
    ["node_blesserheart_name"] = "Blesser Heart",
    ["node_blesserheart"] = "Using Yum Heart while at full health turns up to 3 chests in the room into Heart-blessed chests.",
    ["node_innerglow_name"] = "Inner Glow",
    ["node_innerglow"] = {
        "When using an active item with at least 3 charges, 33% chance to additionally trigger",
        "Yum Heart's effect."
    },

    ["node_yumheartheal_name"] = "Yum Heart Healing",
    ["node_yumheartheal"] = "{{yumHeartHealHalf}}% chance for Yum Heart to heal an additional 1/2 heart.",
    ["node_bloodmachinespawn_name"] = "Blood Donation Machine Spawn",
    ["node_bloodmachinespawn"] = {
        "{{bloodMachineSpawn}}% chance to spawn a Blood Donation Machine at the start of a floor.",
        "Doesn't apply to first floor."
    },
    ["node_blooddonoluck_name"] = "Blood Donation Luck",
    ["node_blooddono"] = {
        "+{{bloodDonationLuck}} luck when using a Blood Donation Machine.",
        "Halve this bonus when entering the next floor."
    },
    ["node_blooddononickel_name"] = "Blood Donation Nickel",
    ["node_blooddononickel"] = "{{bloodDonationNickel}}% chance to spawn an additional Nickel when using a Blood Donation Machine.",
    ["node_roomclearheal_name"] = "Room Clear Heal",
    ["node_roomclearheal"] = {
        "{{healOnClear}}% chance to heal 1/2 red heart when clearing a room.",
        "Double the chance and healing on boss rooms."
    },
    ["node_heartblessedchests_name"] = "Heart-blessed Chests",
    ["node_heartblessedchests"] = {
        "+{{heartblessedChests}}% chance for chests to become Heart-blessed when appearing.",
        "Heart-blessed chests drop an additional 1-2 random hearts, each having a 70% chance",
        "of being red."
    },
    ["node_heartblessedspeed_name"] = "Heart-blessed Speed Buff",
    ["node_heartblessedspeed"] = "+{{heartblessedSpeed}}% speed for the current floor when opening a Heart-blessed chest, up to 12%.",
    ["node_fullhpcharging_name"] = "Full Health Charging",
    ["node_fullhpcharging"] = {
        "When using an active item, {{fullHealthCharge}}% chance to keep 1 charge per red heart container if",
        "you're at full health."
    },
    ["node_allstatfullhp_name"] = "All Stats On Full Health",
    ["node_allstatfullhp"] = "+{{allstatsFullRed}} all stats while you have at least 1 red heart container and are at full health.",


    -- CAIN'S TREE --
    ["node_impromptugambler_name"] = "Impromptu Gambler",
    ["node_impromptugambler"] = {
        "Spawn a crane game in treasure rooms. These can draw items from the Treasure, Shop, Devil",
        "and Angel pools, but take an additional 2 coins on use, if possible.",
        "Interacting with the crane game removes the room's regular item.",
        "Grabbing the room's regular item removes the crane game."
    },
    ["node_thievery_name"] = "Thievery",
    ["node_thievery"] = {
        "+{{stealChance}}% chance to steal items from the shop instead of purchasing.",
        "If you steal an item, Greed will have a chance to show up",
        "after the floor's boss is defeated.",
        "Each stolen item increases Greed's chance to show up based on its price (price * 3)%."
    },
    ["node_ficklefortune_name"] = "Fickle Fortune",
    ["node_ficklefortune"] = {
        "+7% luck while holding a trinket.",
        "Minimum luck is 1 while holding a trinket.",
        "7% chance when hit for your trinket to be dropped.",
        "7% chance for dropped trinkets to vanish."
    },
    ["node_goldengimmick_name"] = "Golden Gimmick",
    ["node_goldengimmick"] = {
        "When entering a floor, 15% chance to spawn a random Gilded machine, up to twice per run.",
        "Every 4 uses of a Gilded machine consumes an additional coin and grants +2% damage",
        "for the current floor, up to 12%."
    },
    ["node_wealthsmith_name"] = "Wealthsmith",
    ["node_wealthsmith"] = {
        "While you have at least 20 coins and less than 10 keys, gain Pay to Play.",
        "+0.2% tears per difference between coins and keys, up to 15%.",
        "Pay to Play no longer shows up naturally."
    },

    ["node_stealchance_name"] = "Stealing Chance",
    ["node_stealchance"] = "+{{stealChance}}% chance to steal items from the shop instead of purchasing.",
    ["node_randtrinketonclear_name"] = "Random Trinket On Clear",
    ["node_randtrinketonclear"] = "{{trinketOnClear}}% chance to drop a random trinket on room clear while you're not holding one.",
    ["node_freemachine_name"] = "Free Machine Use",
    ["node_freemachine"] = "{{freeMachinesChance}}% chance for machines that use coins to cost nothing on use.",
    ["node_arcadereveal_name"] = "Arcade Reveal",
    ["node_arcadereveal"] = "{{arcadeReveal}}% chance to reveal the arcade room's location if it's present on a floor.",
    ["node_shopreveal_name"] = "Shop Reveal",
    ["node_shopreveal"] = "{{shopReveal}}% chance to reveal the shop room's location if it's present on a floor.",
    ["node_roomclearnickel_name"] = "Room Clear Nickel",
    ["node_roomclearnickel"] = {
        "{{nickelOnClear}}% chance to spawn an additional nickel when clearing a room.",
        "Double the chance on boss rooms."
    },
    ["node_gildedmachines_name"] = "Gilded Machines",
    ["node_gildedmachines"] = {
        "2% chance for machines that use coins to become Gilded when first found.",
        "Gilded machines have a 50% chance to be free on use, and grant +0.5% luck for the",
        "current floor on use."
    }
}