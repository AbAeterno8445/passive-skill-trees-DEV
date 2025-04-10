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
    },


    -- JUDAS' TREE --
    ["node_darkheart_name"] = "Dark Heart",
    ["node_darkheart"] = {
        "Start with an additional black heart.",
        "Soul hearts count as black hearts for tree effects' purposes.",
        "-6% damage and speed while you have no black hearts.",
        "Book of belial removes this reduction for the current room."
    },
    ["node_innerdemon_name"] = "Inner Demon",
    ["node_innerdemon"] = {
        "Start with Judas' Shadow.",
        "-45% damage as Dark Judas."
    },
    ["node_sacrificedarkness_name"] = "Sacrifice Darkness",
    ["node_sacrificedarkness"] = {
        "When collecting a black heart, trigger it and receive a soul heart instead.",
        "+1% all stats per sacrificed black heart, up to 6%. Resets every floor.",
        "35% chance to convert dropped soul hearts to black hearts."
    },
    ["node_tenetofbelial_name"] = "Tenet of Belial",
    ["node_tenetofbelial"] = {
        "Using an active item with at least 4 charges additionally triggers Book of",
        "Belial's effect.",
        "After triggering this effect 15 times, it becomes inactive and you gain Birthright,",
        "if you don't already have it.",
        "Triggering Book of Belial's effect has a 50% chance to remove overcharges.",
        "Birthright can no longer show up."
    },
    ["node_darkapotheosis_name"] = "Dark Apotheosis",
    ["node_darkapotheosis"] = {
        "Using Book of Belial turns you into Dark Judas for the current room.",
        "When this effect is triggered, red heart containers are converted to black hearts.",
        "Judas' Shadow can no longer show up naturally."
    },

    ["node_darkjudas_speed_name"] = "Dark Judas Speed",
    ["node_darkjudas_speed"] = "+{{darkJudasSpeed}}% speed as Dark Judas.",
    ["node_darkjudas_shotspdrange_name"] = "Dark Judas Shot Speed and Range",
    ["node_darkjudas_shotspdrange"] = "+{{darkJudasShotspeedRange}}% shot speed and range as Dark Judas.",
    ["node_darkcharges_name"] = "Dark Charges",
    ["node_darkcharges"] = {
        "{{belialBossHitCharge}}% chance for active items to gain a charge when hitting a boss while you have black hearts.",
        "Generates a maximum of 12 charges per room."
    },
    ["node_luckyblackhearts_name"] = "Lucky Black Hearts On Kill",
    ["node_luckyblackhearts"] = {
        "{{blackHeartLuckDrop}}% chance every 0.5 luck for monsters with at least 50 HP to drop a black heart",
        "on death.",
        "If you have at least 5 luck, reduce the HP threshold to 30.",
        "This effect can trigger up to 3 times per floor."
    },
    ["node_blackheartconv_name"] = "Black Heart Conversion",
    ["node_blackheartconv"] = "{{node_blackheartconv}}% chance to replace dropped hearts of any type with black hearts.",


    -- BLUE BABY'S TREE --
    ["node_bluegambit_name"] = "Blue Gambit",
    ["node_bluegambit"] = {
        "The first card you find is guaranteed to be V - The Hierophant.",
        "The first pill you find is guaranteed to be Balls of Steel.",
        "20% chance to take 1/2 heart damage when using a card or pill that isn't either of the above.",
        "Reverse cards do not trigger this damage effect."
    },
    ["node_brownblessing_name"] = "Brown Blessing",
    ["node_brownblessing"] = {
        "Start with Petrified Poop.",
        "Using The Poop has a 7% chance to spawn a poop item. Doesn't apply in the first floor."
    },
    ["node_slippingessence_name"] = "Slipping Essence",
    ["node_slippingessence"] = {
        "Losing a soul heart has a 40% chance to spawn a full soul heart.",
        "When this happens, halve this chance and receive -0.6 luck."
    },
    ["node_beandiet_name"] = "Bean Diet",
    ["node_beandiet"] = {
        "Start with a smelted Gigante Bean.",
        "When using The Poop, additionally trigger the effect of a random Bean active."
    },

    ["node_souloncardpill_name"] = "Soul Heart On Pill/Card",
    ["node_souloncardpill"] = "{{soulOnCardPill}}% chance to receive half a soul heart when using a pill or card.",
    ["node_poopitemluck_name"] = "Poop Item Luck",
    ["node_poopitemluck"] = "+{{poopItemLuck}} luck per held poop item.",
    ["node_pooptrinketluck_name"] = "Poop Trinket Luck",
    ["node_pooptrinketluck"] = "+{{poopTrinketLuck}} luck while holding a poop trinket.",
    ["node_poopallstats_name"] = "The Poop All Stats",
    ["node_poopallstats"] = {
        "+{{thePoopAllStats}} all stats after using The Poop (once per room).",
        "Resets every room."
    },
    ["node_soultearsrange_name"] = "Soul Heart Tears And Range",
    ["node_soultearsrange"] = {
        "+{{soulHeartTearsRange}}% tears and range whenever you gain soul hearts, up to 10%.",
        "Resets every floor."
    },
    ["node_cardpillpoop_name"] = "Poop On Card/Pill Usage",
    ["node_cardpillpoop"] = "{{cardPillPoop}}% chance to trigger The Poop's effect when using any card/pill.",
    ["node_beanspeedbuff_name"] = "Speed Buff On Bean Use",
    ["node_beanspeedbuff"] = "+{{beanActiveSpeed}}% speed for 5 seconds after using any Bean active.",


    -- EVE'S TREE --
    ["node_heartless_name"] = "Heartless",
    ["node_heartless"] = {
        "Every room you clear grants +0.5% all stats, up to 10%.",
        "Picking up any heart halves your current bonus."
    },
    ["node_darkprotection_name"] = "Dark Protection",
    ["node_darkprotection"] = {
        "When first reaching 1 heart or less, gain a black heart.",
        "Resets when defeating Mom's Heart/It Lives."
    },
    ["node_carrionavian_name"] = "Carrion Avian",
    ["node_carrionavian"] = {
        "+0.15 damage when dead bird kills an enemy, up to +3. Resets every floor.",
        "If dead bird kills a boss, gain a permanent +0.6 damage instead (up to +1.2",
        "per room)."
    },
    ["node_phantomcrows_name"] = "Phantomcrows",
    ["node_phantomcrows"] = {
        "Start with a smelted Eve's Bird Foot.",
        "0.5% chance to spawn an additional phantom dead bird for the current room whenever",
        "a dead bird deals damage, once per room."
    },

    ["node_deadbirdshield_name"] = "Dead Bird Shield",
    ["node_deadbirdshield"] = "{{deadBirdNullify}}% chance for the hit that wakes dead bird to be nullified.",
    ["node_deadbird_dmg_name"] = "Active Dead Bird Damage",
    ["node_deadbird_dmg"] = "+{{activeDeadBirdDamage}} damage while dead bird is active.",
    ["node_deadbird_speed_name"] = "Active Dead Bird Speed",
    ["node_deadbird_speed"] = "+{{activeDeadBirdSpeed}} speed while dead bird is active.",
    ["node_deadbird_tears_name"] = "Active Dead Bird Tears",
    ["node_deadbird_tears"] = "+{{activeDeadBirdTears}} tears while dead bird is active.",
    ["node_deadbird_range_name"] = "Active Dead Bird Range",
    ["node_deadbird_range"] = "+{{activeDeadBirdRange}} range while dead bird is active.",
    ["node_deadbird_shotspeed_name"] = "Active Dead Bird Shot Speed",
    ["node_deadbird_shotspeed"] = "+{{activeDeadBirdShotspeed}} shot speed while dead bird is active.",
    ["node_deadbird_famdmg_name"] = "Dead Bird Damage",
    ["node_deadbird_famdmg"] = "Dead bird deals an additional {{deadBirdInheritDamage}}% of your damage per tick.",
    ["node_roomclearluck_belowfull_name"] = "Luck On Room Clear Below Full",
    ["node_roomclearluck_belowfull"] = {
        "+{{luckOnClearBelowFull}} luck when clearing a room below full red hearts.",
        "Resets every floor.",
    },
    ["node_allstatoneheart_name"] = "All Stats - One Heart",
    ["node_allstatoneheart"] = "+{{allstatsOneRed}} all stats while you have only 1 red heart.",
    ["node_evemascarachamp_name"] = "Eve's Mascara On Champion Kill",
    ["node_evemascarachamp"] = "{{eveMascaraChamp}}% chance to gain Eve's Mascara for the current room when killing a champion monster.",


    -- SAMSON'S TREE --
    ["node_hasted_name"] = "Hasted",
    ["node_hasted"] = {
        "+10% tears and shot speed",
        "Taking damage reduces this bonus by 1.5%, up to 5 times.",
        "Resets every floor."
    },
    ["node_ragebuildup_name"] = "Rage Buildup",
    ["node_ragebuildup"] = {
        "+0.02 damage when hitting an enemy, up to +3.",
        "Getting hit resets the bonus."
    },
    ["node_hearty_name"] = "Hearty",
    ["node_hearty"] = {
        "Start with an additional red heart.",
        "+1.5% damage per missing 1/2 red heart."
    },
    ["node_bloodcrowned_name"] = "Blood-Crowned",
    ["node_bloodcrowned"] = {
        "Start with a smelted Bloody Crown.",
        "When entering a new floor, 2% chance to lose the Bloody Crown per missing 1/2 red heart.",
        "Entering a chapter 4 floor with full health and a Bloody Crown spawns a Devil's Crown."
    },

    ["node_samsontempdmg_name"] = "Temporary Damage",
    ["node_samsontempdmg"] = {
        "+{{samsonTempDamage}}% damage for 2.5 seconds after killing an enemy, or after hitting a boss 8 times.",
        "Doesn't stack."
    },
    ["node_samsontempspeed_name"] = "Temporary Speed",
    ["node_samsontempspeed"] = {
        "+{{samsonTempSpeed}}% speed for 2.5 seconds after killing an enemy, or after hitting a boss 8 times.",
        "Doesn't stack."
    },
    ["node_speedwhenhit_name"] = "Speed When Hit",
    ["node_speedwhenhit"] = "+{{speedWhenHit}}% speed when hit, up to 15%. Resets every room.",
    ["node_bossculling_name"] = "Boss Culling",
    ["node_bossculling"] = "{{bossCulling}}% chance on hit to deal 10x damage to bosses below 10% HP.",
    ["node_quickbossluck_name"] = "Boss Quick Kill Luck",
    ["node_quickbossluck"] = "+{{bossQuickKillLuck}} luck if you clear the boss room within 30 seconds of entering it, up to a total +3.",
    ["node_bossflawlessluck_name"] = "Boss Flawless Luck",
    ["node_bossflawlessluck"] = "+{{bossFlawlessLuck}} luck if you clear the boss room without getting hit, up to a total +3.",
    ["node_treasuredoubleheart_name"] = "Treasure Room Double Red Hearts",
    ["node_treasuredoubleheart"] = "{{treasureDoubleHeart}}% chance for treasure rooms to additionally contain a double red heart pickup.",


    -- AZAZEL'S TREE --
    ["node_bloodcharge_name"] = "Bloodcharge",
    ["node_bloodcharge"] = {
        "+{{range}} range.",
        "{{tearsPerc}}% tears."
    },
    ["node_demonicsouvenirs_name"] = "Demonic Souvenirs",
    ["node_demonicsouvenirs"] = {
        "Spawn III - The Empress at the beginning of every other floor, starting from the first.",
        "Spawn a random evil trinket at the beginning of the second floor you enter.",
        "+6% damage and tears while holding an evil trinket."
    },
    ["node_demonhelpers_name"] = "Demon Helpers",
    ["node_demonhelpers"] = {
        "{{devilBeggarBlackHeart}}% chance to receive half a black heart back when helping a Devil Beggar.",
        "Once a Devil Beggar gives a reward, 33% chance to additionally spawn a demon familiar.",
        "5% chance to spawn a devil beggar at the beginning of a floor, starting from second floor.",
        "This chance doubles every floor up to 40%, and resets when one spawns."
    },
    ["node_demonicambition_name"] = "Demonic Ambition",
    ["node_demonicambition"] = {
        "Gain Goat's Head while you have 4 black hearts or more.",
        "Goat's Head can no longer show up naturally."
    },
    ["node_earlybird_name"] = "Early Bird",
    ["node_earlybird"] = {
        "Start with an additional black heart.",
        "When exiting the first floor, lose a black/soul heart if you have more than 1 total heart container",
        "of any type."
    },

    ["node_blackheartdeals_name"] = "Black Heart On Deals",
    ["node_blackheartdeals"] = "{{blackHeartOnDeals}}% chance to gain an additional black heart when spending hearts for items, such as devil deals.",
    ["node_eviltrinketluck_name"] = "Evil Trinket Luck",
    ["node_eviltrinketluck"] = "+{{evilTrinketLuck}} luck while holding an evil trinket.",
    ["node_freedevilbeggar_name"] = "Free Devil Beggar Help",
    ["node_freedevilbeggar"] = "{{devilBeggarBlackHeart}}% chance for devil beggars to return half a black heart when helped.",
    ["node_cardusedmg_name"] = "Card Use Damage",
    ["node_cardusedmg"] = "+{{cardFloorDamage}} damage when using a card, up to +3. Resets every floor.",
    ["node_cardusetears_name"] = "Card Use Tears",
    ["node_cardusetears"] = "+{{cardFloorTears}} tears when using a card, up to +3. Resets every floor.",


    -- LAZARUS' TREE --
    ["node_soulfulawakening_name"] = "Soulful Awakening",
    ["node_soulfulawakening"] = {
        "Spawn a soul heart on death.",
        "+2 luck.",
        "-0.5 luck on death.",
    },
    ["node_kingcurse_name"] = "King's Curse",
    ["node_kingcurse"] = {
        "Start with Damocles activated.",
        "When entering a new floor, remove Damocles if you have it, or re-add it if you don't.",
        "-10% all stats while not Lazarus Risen.",
        "-1 luck while not Lazarus Risen."
    },
    ["node_trueending_name"] = "A True Ending?",
    ["node_trueending"] = {
        "First floor's boss, Mom and Mom's Heart drop a Suicide King card when defeated.",
        "+2% all stats as Lazarus Risen per Suicide King card used."
    },
    ["node_growingcontrition_name"] = "Growing Contrition",
    ["node_growingcontrition"] = {
        "Start with Birthright.",
        "Lose Birthright after dying 3 times.",
        "If you don't have Birthright, clearing a boss room without taking damage has a 10% chance",
        "to grant you Birthright.",
        "Birthright can no longer show up."
    },

    ["node_lazdmg_name"] = "Lazarus Damage",
    ["node_lazdmg"] = "+{{lazarusDamage}} damage. Halve this bonus as Lazarus Risen.",
    ["node_laztears_name"] = "Lazarus Tears",
    ["node_laztears"] = "+{{lazarusTears}} tears. Halve this bonus as Lazarus Risen.",
    ["node_lazrange_name"] = "Lazarus Range",
    ["node_lazrange"] = "+{{lazarusRange}} range. Halve this bonus as Lazarus Risen.",
    ["node_lazspeed_name"] = "Lazarus Speed",
    ["node_lazspeed"] = "+{{lazarusSpeed}} speed. Halve this bonus as Lazarus Risen.",
    ["node_lazluck_name"] = "Lazarus Luck",
    ["node_lazluck"] = "+{{lazarusLuck}} luck. Halve this bonus as Lazarus Risen.",
    ["node_luckyallstat_name"] = "Lucky All Stats",
    ["node_luckyallstat"] = "+{{luckyAllStats}} all stats while luck is positive.",
    ["node_planc_name"] = "Plan C",
    ["node_planc"] = "{{momPlanC}}% chance for Mom to drop Plan C when defeated.",
    ["node_lazclearhearts_name"] = "Lazarus Hearts On Room Clear",
    ["node_lazclearhearts"] = {
        "{{lazarusClearHearts}}% chance to drop an additional 1/2 red heart on room clear as Lazarus.",
        "{{lazarusClearHearts}}% chance to drop an additional 1/2 soul heart on room clear as Lazarus Risen."
    },


    -- EDEN'S TREE --
    ["node_chaotictreasury_name"] = "Chaotic Treasury",
    ["node_chaotictreasury"] = {
        "First floor's treasure room contains an additional Chaos item pedestal.",
        "While you have Chaos, treasure rooms spawn an additional item.",
        "Grabbing an item in a treasure room removes all other items in the room."
    },
    ["node_sporadicgrowth_name"] = "Sporadic Growth",
    ["node_sporadicgrowth"] = {
        "Start with a smelted Broken Syringe.",
        "When starting a run, apply +1% to a random stat 6 times.",
        "When entering a floor past the first, apply +1% to a random stat 2 times."
    },
    ["node_starblessed_name"] = "Starblessed",
    ["node_starblessed"] = {
        "Start with an additional random item from the treasure room pool.",
        "First floor's boss drops an additional XVII - The Stars card."
    },
    ["node_edenhairdo_name"] = "Eden Hairdo",
    ["node_edenhairdo"] = {
        "Once allocated, press Allocate to choose a hairstyle for Eden.",
        "Chosen hairstyle is always active.",
        "Costs no skill points."
    },
    ["node_spaghettification_name"] = "Spaghettification",
    ["node_spaghettification"] = {
        "Start with 3 Dollar Bill, which gets removed once you get hit.",
        "When you get hit:",
        "   - For 5 seconds, innately gain Fruit Cake's effect.",
        "   - Afterwards, for 5 seconds, innately gain Playdough Cookie's effect.",
        "20% chance to trigger this effect when clearing a room without taking damage."
    },
    ["node_clayshaping_name"] = "Clayshaping",
    ["node_clayshaping"] = "Start with a smelted Modeling Clay.",

    ["node_treasurechaoticepi_name"] = "Treasure/Shop Item Chaotic Epiphany",
    ["node_treasurechaoticepi"] = "{{treasureItemCEpiphany}}% chance to trigger Chaotic Epiphany when first obtaining a treasure or shop room item.",
    ["node_specialitemchaoticepi_name"] = "Special Item Chaotic Epiphany",
    ["node_specialitemchaoticepi"] = "{{devilItemCEpiphany}}% chance to trigger Chaotic Epiphany when first obtaining a devil, angel or boss room item.",
    ["node_passiveitemluck_name"] = "Passive Item Luck",
    ["node_passiveitemluck"] = "-0.01 to +{{itemRandLuck}} luck when first obtaining any passive item.",
    ["node_passiveitemluck2"] = "-0.5% to +{{itemRandLuckPerc}}% luck when first obtaining any passive item.",
    ["node_trinketluck_name"] = "Trinket Luck",
    ["node_trinketluck"] = "-0.01 to +{{trinketRandLuck}} luck when first obtaining any trinket.",
    ["node_randstartpickup_name"] = "Additional Coin/Key/Bomb",
    ["node_randstartpickup"] = "{{startCoinKeyBomb}}% chance to start with an additional coin, key or bomb.",
    ["node_edenblessing_name"] = "Eden's Blessing Spawn",
    ["node_edenblessing"] = {
        "{{edenBlessingSpawn}}% chance for Eden's Blessing to spawn at the beginning of a floor, starting from the second floor.",
        "Can only happen once per run."
    },
    ["node_myosotisonclear_name"] = "Myosotis On Room Clear",
    ["node_myosotisonclear"] = {
        "{{myosotisOnClear}}% chance to gain a smelted Myosotis when clearing a room without taking damage,",
        "if you don't already have one.",
        "Lose any smelted Myosotis after entering a new floor."
    },
    ["node_cursechaoticepi_name"] = "Curse Room Chaotic Epiphany",
    ["node_cursechaoticepi"] = {
        "{{curseRoomCEpiphany}}% chance to trigger Chaotic Epiphany when entering a Curse Room.",
        "Chaotic Epiphany:",
        "   - 25% chance to add +2-4% to a random stat.",
        "   - 25% chance to spawn a double coin/key/bomb.",
        "   - 20% chance to spawn a random heart.",
        "   - 20% chance to spawn a regular chest.",
        "   - 10% chance to spawn a special chest."
    },


    -- THE LOST'S TREE --
    ["node_spectraladvantage_name"] = "Spectral Advantage",
    ["node_spectraladvantage"] = {
        "+2% damage and +0.15 luck for each heart you would've gained from items you pick up,",
        "up to a total 40% damage, +3 luck.",
        "If you obtain birthright, gain +8% tears.",
        "Does not work on active items that grant hearts."
    },
    ["node_sacredaegis_name"] = "Sacred Aegis",
    ["node_sacredaegis"] = {
        "Unlock Holy Mantle with The Lost when allocating this node.",
        "Holy mantle regenerates after 7 seconds, once per room.",
        "-7% all stats each time you lose holy mantle, up to 2 times. Resets every room."
    },
    ["node_heartseekerphantasm_name"] = "Heartseeker Phantasm",
    ["node_heartseekerphantasm"] = {
        "Dropped red and eternal hearts are converted to soul hearts.",
        "Collecting a soul or black heart pickup grants +0.1 luck, up to a total +3.",
        "+1% all stats for every 3 heart pickups collected, up to a total +20%."
    },
    ["node_vagrantsoul_name"] = "Vagrant Soul",
    ["node_vagrantsoul"] = {
        "Start with The Soul.",
        "When entering a floor, 10% chance to lose The Soul.",
        "The Soul can no longer show up naturally."
    },

    ["node_killinghitneg_name"] = "Killing Hit Negation",
    ["node_killinghitneg"] = "{{killingHitNegation}}% chance to negate an incoming hit if it would've killed you.",
    ["node_inactivemantlestats_name"] = "Inactive Holy Mantle All Stats",
    ["node_inactivemantlestats"] = "+{{noHolyMantleAllStats}} all stats while holy mantle is inactive.",
    ["node_soulheart_tears_name"] = "Soul Hearts Tears",
    ["node_soulheart_tears"] = "Soul hearts grant +{{soulHeartTears}} tears when collected, up to a total +1.",
    ["node_blackheart_dmg_name"] = "Black Hearts Damage",
    ["node_blackheart_dmg"] = "Black hearts grant +{{blackHeartDamage}} damage when collected, up to a total +3.",
    ["node_eternald6charge_name"] = "Eternal D6 Charge",
    ["node_eternald6charge"] = "{{eternalD6Charge}}% chance for the Eternal D6 to not consume charges on use.",
    ["node_soulonclear_name"] = "Soul Heart On Room Clear",
    ["node_soulonclear"] = {
        "{{soulHeartOnClear}}% chance to drop an additional soul heart when clearing a room without taking damage,",
        "up to 4 per floor."
    },
    ["node_blessedpennyconv_name"] = "Penny To Blessed Penny",
    ["node_blessedpennyconv"] = {
        "{{pennyToBlessed}}% chance to convert dropped pennies into a Blessed Penny if you don't currently have one,",
        "once per floor."
    },


    -- LILITH'S TREE --
    ["node_minionmaneuver_name"] = "Minion Maneuvering",
    ["node_minionmaneuver"] = {
        "+3% speed per active familiar, up to 15%.",
        "Using the box of friends doubles the maximum bonus for the current room."
    },
    ["node_heavyfriends_name"] = "Heavy Friends",
    ["node_heavyfriends"] = {
        "Start with BFFS!",
        "{{speedPerc}}% speed.",
        "{{damagePerc}}% damage."
    },
    ["node_daemonarmy_name"] = "Daemon Army",
    ["node_daemonarmy"] = {
        "Start with an additional Incubus.",
        "Mom drops an additional Incubus on defeat if you took no damage throughout the run until",
        "this point.",
        "Baby familiar items other than Incubus no longer show up."
    },
    ["node_companionshipgravitas_name"] = "Companionship Gravitas",
    ["node_companionshipgravitas"] = "Start with a smelted Friendship Necklace.",

    ["node_famkillsoul_name"] = "Familiar Kill Soul Heart",
    ["node_famkillsoul"] = "{{familiarKillSoulHeart}}% chance for enemies killed by familiars to drop an additional 1/2 soul heart.",
    ["node_activefamluck_name"] = "Active Familiars Luck",
    ["node_activefamluck"] = "+{{activeFamiliarsLuck}} luck per currently active familiar.",
    ["node_incubusdmg_name"] = "Incubus Damage",
    ["node_incubusdmg"] = "+{{activeIncubusDamage}}% damage per active incubus.",
    ["node_incubustears_name"] = "Incubus Tears",
    ["node_incubustears"] = "+{{activeIncubusTears}}% tears per active incubus.",
    ["node_boxfriendcharge_name"] = "Box Of Friends Charge",
    ["node_boxfriendcharge"] = "{{boxOfFriendsCharge}}% chance for box of friends to keep 1 charge on use.",
    ["node_boxfriendstats_name"] = "Box Of Friends All Stats",
    ["node_boxfriendstats"] = "+{{boxOfFriendsAllStats}} all stats after using box of friends. Resets every room.",
    ["node_monstermanualclear_name"] = "Monster Manual On Clear",
    ["node_monstermanualclear"] = {
        "{{monsterManualOnClear}}% chance to trigger Monster Manual's effect when clearing a room without taking",
        "damage within 7 seconds of entering, up to 3 times per floor."
    },


    -- KEEPER'S TREE --
    ["node_keeperblessing_name"] = "Keeper's Blessing",
    ["node_keeperblessing"] = {
        "Healing from a coin grants you an additional coin, up to 4 times per room.",
        "20% chance for Wooden Nickel to spawn an additional penny when used."
    },
    ["node_gulp_name"] = "Gulp!",
    ["node_gulp"] = {
        "Spawn a Swallowed Penny at the start of every other floor, starting from the first.",
        "+1.5 luck while holding Swallowed Penny.",
        "30% chance to lose the Swallowed Penny when hit, if held.",
        "Gain 1-4 coins when losing the Swallowed Penny this way."
    },
    ["node_avidshopper_name"] = "Avid Shopper",
    ["node_avidshopper"] = {
        "Start with Steam Sale.",
        "Start with an additional 5 coins.",
        "Lose 1-3 coins when hit, up to 5 times per floor."
    },
    ["node_bluekin_name"] = "Blue Kin",
    ["node_bluekin"] = {
        "Start with Infestation.",
        "When hit, 30% chance to gain The Mulligan for the current room."
    },

    ["node_coinshield_name"] = "Coin Shield",
    ["node_coinshield"] = {
        "{{coinShield}}% chance to negate a hit that would've killed you, if you have more than 0 coins.",
        "Negating a hit removes all your coins and fully discharges your active item."
    },
    ["node_purchaseluck_name"] = "Item Purchase Luck",
    ["node_purchaseluck"] = {
        "+{{itemPurchaseLuck}} luck when you purchase an item.",
        "When entering a floor, halve your current bonus."
    },
    ["node_purchasekeepcoins_name"] = "Keep Coins On Purchase",
    ["node_purchasekeepcoins"] = "{{purchaseKeepCoins}}% chance to keep 1-3 coins when purchasing an item.",
    ["node_greedboss_name"] = "Greed Boss",
    ["node_greedboss"] = "{{firstBossGreed}}% chance for Greed to spawn after defeating the first floor's boss.",
    ["node_greedlesshp_name"] = "Greed Lower Health",
    ["node_greedlesshp"] = "Greed has {{greedLowerHealth}}% lower health.",
    ["node_greedcoins_name"] = "Greed Additional Coin Drops",
    ["node_greedcoins"] = {
        "{{greedNickelDrop}}% chance for Greed to drop an additional nickel.",
        "{{greedDimeDrop}}% chance for Greed to drop an additional dime."
    },
    ["node_blueflydeath_dmg_name"] = "Blue Fly Death Damage",
    ["node_blueflydeath"] = "+{{blueFlyDeathDamage}} damage whenever a blue fly dies, up to +1.2. Resets every floor.",


    -- APOLLYON'S TREE --
    ["node_apollyonblessing_name"] = "Apollyon's Blessing",
    ["node_apollyonblessing"] = {
        "40% chance to keep half of the charge when using Void.",
        "Cannot be cursed with Curse of the Blind."
    },
    ["node_null_name"] = "Null",
    ["node_null"] = {
        "When entering a floor, if Void hasn't absorbed any active items, gain +5% all stats, up to 15%.",
        "If Void has absorbed active items, 50% chance to gain an extra charge when clearing a room.",
        "-10% all stats while not holding Void."
    },
    ["node_harbingerlocusts_name"] = "Harbinger Locusts",
    ["node_harbingerlocusts"] = {
        "Spawn a random locust trinket in the second floor you enter.",
        "Spawn a random locust trinket after defeating Mom.",
        "2% chance for champion monsters to drop a random locust trinket on death, once per floor.",
        "Using void consumes all locust trinkets dropped in the room, applying their",
        "effects to you passively."
    },
    ["node_reverseannihilation_name"] = "Reverse Annihilation",
    ["node_reverseannihilation"] = "When erasing a monster, trigger Friend Finder's effect, up to 3 times per floor.",

    ["node_voidblueflies_name"] = "Void Blue Flies",
    ["node_voidblueflies"] = "{{voidBlueFlies}}% chance for Void to spawn 4 blue flies on use.",
    ["node_voidbluespiders_name"] = "Void Blue Spiders",
    ["node_voidbluespiders"] = "{{voidBlueSpiders}}% chance for Void to spawn 3 blue spiders on use.",
    ["node_voidannihilation_name"] = "Void Annihilation",
    ["node_voidannihilation"] = "{{voidAnnihilation}}% chance for Void to instantly kill a random non-boss enemy in the room on use.",
    ["node_eraserspawn_name"] = "Eraser Spawn",
    ["node_eraserspawn"] = {
        "{{eraserSecondFloor}}% chance for the second and fifth floor's treasure room to additionally contain an Eraser",
        "item pedestal."
    },
    ["node_locustsluck_name"] = "Locusts Luck",
    ["node_locustsluck"] = "+{{locustHeldLuck}} luck while holding a locust. Consuming a locust grants a permanent +{{locustConsumedLuck}} luck instead.",
    ["node_locustconquestboon_name"] = "Locust Of Conquest Boon",
    ["node_locustconquestboon"] = "+{{locustConquestSpeed}}% speed per Locust of Conquest held/consumed, up to 15%.",
    ["node_locustdeathboon"] = "Locust Of Death Boon",
    ["node_locustdeath"] = "+{{deathLocustTears}}% tears per Locust of Death held/consumed, up to 15%.",
    ["node_locustfamineboon_name"] = "Locust Of Famine Boon",
    ["node_locustfamineboon"] = "+{{famineLocustRangeShotspeed}}% range and shot speed per Locust of Famine held/consumed, up to 15%.",
    ["node_locustpestilence_boon"] = "Locust Of Pestilence Boon",
    ["node_locustpestilence"] = "+{{pestilenceLocustLuck}}% luck per Locust of Pestilence held/consumed, up to 12%.",
    ["node_locustwarboon_name"] = "Locust Of War Boon",
    ["node_locustwarboon"] = "+{{warLocustDamage}}% damage per Locust of War held/consumed, up to 15%.",


    -- THE FORGOTTEN'S TREE --
    ["node_soulful_name"] = "Soulful",
    ["node_soulful"] = {
        "Losing a bone heart spawns a soul heart.",
        "-0.25 luck when you lose a bone heart."
    },
    ["node_innerflare_name"] = "Inner Flare",
    ["node_innerflare"] = {
        "The Soul deals 15% more damage against slowed enemies.",
        "Switching to The Soul slows enemies in the room for 2 seconds. Can only happen once per room."
    },
    ["node_spiritbringer_name"] = "Spirit-bringer",
    ["node_spiritbringer"] = {
        "Gain Ghost Bombs as an innate effect.",
        "While The Soul is out, innately gain Quints' effect.",
        "[Spiritful] Can only allocate one Spiritful node at a time."
    },
    ["node_spirit_taker_name"] = "Spirit-taker",
    ["node_spirit_taker"] = {
        "Gain Vade Retro as an innate effect.",
        "Switching characters triggers Vade Retro.",
        "[Spiritful] Can only allocate one Spiritful node at a time."
    },
    ["node_spiritreaper_name"] = "Spirit-reaper",
    ["node_spiritreaper"] = {
        "Gain Purgatory and Hungry Soul as innate effects.",
        "[Spiritful] Can only allocate one Spiritful node at a time."
    },
    ["node_spiritprotector_name"] = "Spirit-protector",
    ["node_spiritprotector"] = {
        "Gain Lost Soul as an innate effect.",
        "Gain a smelted Found Soul and Your Soul.",
        "[Spiritful] Can only allocate one Spiritful node at a time."
    },
    ["node_spiritgambler_name"] = "Spirit-gambler",
    ["node_spiritgambler"] = {
        "When entering a floor, apply a random Spiritful node.",
        "[Spiritful] Can only allocate one Spiritful node at a time."
    },
    ["node_osteomancy_name"] = "Osteomancy",
    ["node_osteomancy"] = {
        "When entering a floor, innately gain the effect of a random Bone item if you don't",
        "currently have it.",
        "Entering a new floor replaces the old item(s).",
        "If you took no damage in the previous floor, apply 2 random Bone items instead.",
        "Bone items:",
        "   Bone Spurs, Slipped Rib, Pointy Rib, Jaw Bone, Brittle Bones, Compound Fracture, Host Hat,",
        "Dry Baby."
    },
    ["node_necromancy_name"] = "Necromancy",
    ["node_necromancy"] = {
        "Start with Book of the Dead.",
        "Using an active item that isn't Book of the Dead has a 7% chance to trigger the",
        "latter's effect per used charge.",
        "While you have 3 or more bone hearts, friendly monsters become immune to explosions."
    },

    ["node_boneitemdmg_name"] = "Melee Damage Per Bone Item",
    ["node_boneitemdmg"] = "+{{boneItemMelee}}% melee damage with The Forgotten per Bone Item obtained.",
    ["node_innerflareslowdur_name"] = "Inner Flare Slow Duration",
    ["node_innerflareslowdur"] = "+{{innerFlareSlowDuration}} seconds to Inner Flare slow duration.",
    ["node_forgbirthright_name"] = "Birthright On Clear",
    ["node_forgbirthright"] = {
        "{{forgBirthright}}% chance to gain Birthright for the current floor when clearing a room without taking",
        "damage within 7 seconds."
    },
    ["node_soulwispclear_name"] = "Soul Wisp On Clear",
    ["node_soulwispclear"] = "While The Soul has at least 4 soul hearts, {{soulWispOnClear}}% chance to spawn a Wisp when clearing rooms.",
    ["node_redtoboneconv_name"] = "Red Heart To Bone Conversion",
    ["node_redtoboneconv"] = {
        "{{redFullToBone}}% chance to convert dropped full red hearts into bone hearts if you have 2 bone hearts or less.",
        "This effect can only trigger once per room."
    },
    ["node_treasureboneitem_name"] = "Treasure Room Bone Item",
    ["node_treasureboneitem"] = {
        "When entering the treasure room, {{treasureBoneItem}}% chance to replace the item with a random Bone Item, up to",
        "twice per run."
    },
    ["node_carrionprincessclear_name"] = "Carrion Princess On Clear",
    ["node_carrionprincessclear"] = {
        "While The Forgotten has at least 2 bone hearts, {{forgCarrionPrincess}}% chance to spawn a friendly Carrion Princess",
        "when clearing rooms, up to 4."
    },
    ["node_soultearswisp_name"] = "Soul Tears Per Wisp",
    ["node_soultearswisp"] = "+{{soulWispTears}}% tears per active Wisp.",
    ["node_flawlessclearpbone_name"] = "Flawless Clear Polished Bone",
    ["node_flawlessclearpbone"] = {
        "{{flawlessClearPBone}}% chance to gain a smelted Polished Bone for the rest of the floor when clearing a room without",
        "taking damage.",
        "When hit by a monster, same chance to lose a smelted Polished Bone."
    }
}