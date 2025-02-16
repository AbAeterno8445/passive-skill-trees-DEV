local function PST_getCustomMobTable(mobName)
    return {Isaac.GetEntityTypeByName(mobName), Isaac.GetEntityVariantByName(mobName)}
end

local function PST_addUndeadMobs(mobList)
    for _, tmpMobName in ipairs(mobList) do
        local mobType, mobVariant = table.unpack(PST_getCustomMobTable(tmpMobName))
        if not PST.undeadEnemiesSpec[mobType] then
            PST.undeadEnemiesSpec[mobType] = {}
        elseif type(PST.undeadEnemiesSpec[mobType]) ~= "table" then
            PST.undeadEnemiesSpec[mobType] = {PST.undeadEnemiesSpec[mobType]}
        end
        ---@diagnostic disable-next-line: param-type-mismatch
        table.insert(PST.undeadEnemiesSpec[mobType], mobVariant)
    end
end

-- Mod compatibility helper
local initMods = {}
function PST:initModCompat()
	-- Epiphany
	if Epiphany and not initMods.epiphany then
		initMods.epiphany = true

		-- Tarnished Keeper blacklisted pickups
		Epiphany.Character.KEEPER.DisallowedPickUpVariants[Isaac.GetEntityVariantByName("Sidereal Cache")] = 0
		if not Epiphany.Character.KEEPER.DisallowedPickUpVariants[PickupVariant.PICKUP_TRINKET] then
			Epiphany.Character.KEEPER.DisallowedPickUpVariants[PickupVariant.PICKUP_TRINKET] = {}
		end
		local tmpBlacklist = Epiphany.Character.KEEPER.DisallowedPickUpVariants[PickupVariant.PICKUP_TRINKET]
		tmpBlacklist[Isaac.GetTrinketIdByName("Azure Starcursed Jewel")] = 0
		tmpBlacklist[Isaac.GetTrinketIdByName("Crimson Starcursed Jewel")] = 0
		tmpBlacklist[Isaac.GetTrinketIdByName("Viridian Starcursed Jewel")] = 0
		tmpBlacklist[Isaac.GetTrinketIdByName("Ancient Starcursed Jewel")] = 0
		for i=1,8 do
			tmpBlacklist[Isaac.GetTrinketIdByName("Arcane Obols " .. tostring(i))] = 0
		end
		local wepPrefix = "Astral weapon: "
		for _, wepData in pairs(PST.astralWepData) do
			tmpBlacklist[Isaac.GetTrinketIdByName(wepPrefix .. wepData.name)] = 0
			tmpBlacklist[Isaac.GetTrinketIdByName(wepPrefix .. wepData.name .. " (magic)")] = 0
			for _, tmpAncient in ipairs(wepData.ancients) do
				tmpBlacklist[Isaac.GetTrinketIdByName(wepPrefix .. tmpAncient.name)] = 0
			end
		end

        -- HP Up items
        if Epiphany.Item.WARM_COAT.ID then
            PST.heartUpItems[Epiphany.Item.WARM_COAT.ID] = 1
        end

        -- Progression items
        table.insert(PST.progressionItems, Epiphany.Item.DIMENSIONAL_KEY.ID)
        table.insert(PST.progressionItems, Epiphany.Item.BLIGHTED_PHOTO.ID)
        table.insert(PST.progressionItems, Epiphany.Item.BLIGHTED_PHOTO.CHILDS_DRAWING)
        table.insert(PST.progressionItems, Epiphany.Item.BLEEDING_HEART.ID)
        table.insert(PST.progressionItems, Epiphany.Item.SHARP_ROCK.ID)
        table.insert(PST.progressionItems, Epiphany.Item.DELILAHS_RAZOR.ID)
        table.insert(PST.progressionItems, Epiphany.Item.GlitchedPhotoID)
        table.insert(PST.progressionItems, Epiphany.Item.BROKEN_ORB.ID)
        table.insert(PST.progressionItems, Epiphany.Item.KAEK.ID)
        table.insert(PST.progressionItems, Epiphany.Item.KAEK.ID2)
		table.insert(PST.progressionItems, Epiphany.Item.SHRED.ID)
		table.insert(PST.progressionItems, Epiphany.Item.SHRED.BUNDLED_PHOTOS)
		table.insert(PST.progressionItems, Epiphany.Item.SHADOW_REMNANTS)

        -- Locked chests
        table.insert(PST.lockedChests, Epiphany.Pickup.DUSTY_CHEST.ID)

        -- Non-championable mobs
        table.insert(PST.noChampionMobs, {Epiphany.Npc.REVOLT.KNIGHT.ID, Epiphany.Npc.REVOLT.KNIGHT.Variant})
        table.insert(PST.noChampionMobs, {Epiphany.Npc.REVOLT.GRUNT.ID, Epiphany.Npc.REVOLT.GRUNT.Variant})
        table.insert(PST.noChampionMobs, {Epiphany.Npc.REVOLT.BRUTE.ID, Epiphany.Npc.REVOLT.BRUTE.Variant})
        table.insert(PST.noChampionMobs, {Epiphany.Npc.REVOLT.COMMANDER.ID, Epiphany.Npc.REVOLT.COMMANDER.Variant})
        table.insert(PST.noChampionMobs, {EntityType.ENTITY_GAPER, Epiphany.Npc.EDEN_GLITCH.ID})
        table.insert(PST.noChampionMobs, {Epiphany.Npc.ABEL.ID, Epiphany.Npc.ABEL.SHEEP_VAR})

        -- Poop items
        table.insert(PST.poopItems, Epiphany.Item.MIX.ID)
		table.insert(PST.poopItems, Epiphany.Item.ANAL_FISSURE.ID)

		-- Poop Trinkets
		table.insert(PST.poopTrinkets, Epiphany.Trinket.IED.ID)

        -- Blue Gambit cards
        table.insert(PST.blueGambitCards, Epiphany.Card.HOUSE_QUEEN_OF_HEARTS.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.HOUSE_TWO_OF_SPADES.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.HOUSE_TWO_OF_CLUBS.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.HOUSE_TWO_OF_DIAMONDS.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.HOUSE_TWO_OF_HEARTS.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.DRAW_ONE.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.REVERSE.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.MINUS_ONE.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.INVERSE.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.DRAWN_CARD.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.GO_TO_JAIL.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.EXCLAMATION_MARK.ID)
		table.insert(PST.blueGambitCards, Epiphany.Card.AGAINST_HUMANITY.ID)

        -- Cause converter blacklist
        table.insert(PST.causeConverterBossBlacklist, Epiphany.Npc.ABEL.ID)

        -- Song of the Few node familiars
        table.insert(PST.songOfTheFewFamiliars, Epiphany.Item.LIL_GUPPY.ID)
        table.insert(PST.songOfTheFewFamiliars, Epiphany.Item.OLD_KNIFE.ID)
		table.insert(PST.songOfTheFewFamiliars, Epiphany.Item.CARDBOARD_CUTOUT.ID)

        -- Grand Consonance node whitelist
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Old Knife"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Cardboard Cutout"))

        -- Coin machines
        table.insert(PST.coinMachines, Epiphany.Slot.DICE_MACHINE)
        table.insert(PST.coinMachines, Epiphany.Slot.PAIN_O_MATIC)
	end

    -- Fiend Folio
    if FiendFolio and not initMods.fiendFolio then
        initMods.fiendFolio = true

        -- No-duplication mobs
        local noDupeMobs = {
            "Mr. Horf", "Mr. Red Horf", "Mr. Sub Horf", "Ossularry", "Clickety Clash", "Flagpole", "Mr. Bones",
            "Mr. Gob", "Bola", "Rotspin", "Cherubskull"
        }
        for _, tmpMobName in ipairs(noDupeMobs) do
            table.insert(PST.noSplitMobsSpec, PST_getCustomMobTable(tmpMobName))
            -- Just in case, include no-duplication mobs into no-champion mobs
            table.insert(PST.noChampionMobs, PST_getCustomMobTable(tmpMobName))
        end

        -- No HP modifier mobs
        table.insert(PST.mobHPBlacklist, PST_getCustomMobTable("Fishaac"))
        table.insert(PST.mobHPBlacklist, PST_getCustomMobTable("Missing Link"))

        -- No-champion mobs
        table.insert(PST.noChampionMobs, PST_getCustomMobTable("Fishaac"))
        table.insert(PST.noChampionMobs, PST_getCustomMobTable("Missing Link"))
        table.insert(PST.noChampionMobs, PST_getCustomMobTable("Alfil"))
        table.insert(PST.noChampionMobs, PST_getCustomMobTable("Mr. Horf"))
        table.insert(PST.noChampionMobs, PST_getCustomMobTable("Mr. Red Horf"))
        table.insert(PST.noChampionMobs, PST_getCustomMobTable("Mr. Sub Horf"))
        table.insert(PST.noChampionMobs, PST_getCustomMobTable("Bowler"))
        table.insert(PST.noChampionMobs, PST_getCustomMobTable("Mr. Gurgle"))
        table.insert(PST.noChampionMobs, PST_getCustomMobTable("Flagpole"))
        table.insert(PST.noChampionMobs, PST_getCustomMobTable("Mr. Bones"))
        table.insert(PST.noChampionMobs, PST_getCustomMobTable("Mr. Gob"))

        -- Segmented bosses
        table.insert(PST.segmentBosses, Isaac.GetEntityTypeByName("Kingpin"))

        -- Undead mobs
        local tmpUndead = {
            "Yawner", "Shirk", "Spoop", "Buckethead", "Mr. Sub Horf", "Rift Walker", "Cushion", "Skipper",
            "Archer", "Deathany", "Tango", "Onlyfan", "Zephyr", "Cuffs", "Fish", "Slick", "Stump",
            "Jim", "Pale Limb", "Dr. Shambles", "Nimbus", "Floodface", "Tubby", "Bubble Bat", "Cistern",
            "Bubble Blowing Double Baby", "Offal", "Eroded Host", "Eroded Smidgen", "Fishface", "Aquabab",
            "Fireswirl", "Pyroclasm", "Dry Wheeze", "Marlin", "Fishfreak", "Clickety Clash", "Ossularry",
            "Skitter Skull", "Dried Offal", "Phoenix", "Gritty", "Flanks", "Flagpole", "Blare", "Striker",
            "Pale Loafer", "Smasher", "Ghostse", "Gnawful", "Peek-a-boo", "Temper", "Banshee", "G. Host",
            "Thousand Eyes", "Scythe Rider", "Bone Worm", "Sternum", "Splodum", "Doom Fly", "Crepitus",
            "Mr. Bones", "Possessed", "Cracker", "Jawbone", "Ribbone", "Ribeye", "Unpawtunate", "Fracture",
            "Molar System", "Spinny", "Creepterum", "Dangler", "Gravin", "Shaker", "Clergy", "Alfil",
            "Zealot", "Pale Gaper", "Pale Gusher", "Pale Horf", "Pale Clotty", "Morvid", "Skulltist",
            "Zissuru", "Shi", "Empath", "Discy", "Nobody", "Drooler", "Marzlammer", "Rotdrink", "Rotskull",
            "Rotspin", "Spoilie", "Sagging Spit", "Droolie", "Diagetic", "Gut Knight", "Fingore",
            "Bamboo Cutter", "Frayed Nerve", "Torment", "Putrefatty", "Coconut", "Wheezer", "Whale",
            "Whale Guts", "Weeper", "Cancer Boy", "Musk", "Foetus", "Foetu", "Bub", "Molly", "Toma Chunk",
            "Small Conglobberate", "Medium Conglobberate", "Large Conglobberate", "Molargan", "Oralid",
            "Oralopede", "Tommy", "Benny", "Steralis", "Lurker", "Enlightened", "Effigy",
            "Deadfly", "Cherub", "Cherubskull", "Congression", "Specturn", "Dizzy", "Reaper", "Buck",
            "The Whispers", "Griddle Horn", "Meltdown", "Ghostbuster", "Slinger", "Aquagob", "Junkstrap",
            "The Organization", "Dusk", "Mr. Dead", "Cacophobia", "Gravedigger"
        }
        PST_addUndeadMobs(tmpUndead)

        -- Progression items
        table.insert(PST.progressionItems, Isaac.GetItemIdByName("Contraband"))

        -- Baby Familiars
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Lil Fiend"))
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Lil Lamb"))
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Baby Crater"))
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Deimos"))
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Sibling Syl"))
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Robo-Baby 3.0"))
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Bag of Bobbies"))

        -- Demon familiars
        table.insert(PST.demonFamiliars, Isaac.GetItemIdByName("Lil Fiend"))
        table.insert(PST.demonFamiliars, Isaac.GetItemIdByName("Lil Lamb"))

        -- Poop items
        table.insert(PST.poopItems, Isaac.GetItemIdByName("Nugget Bombs"))
        table.insert(PST.poopItems, Isaac.GetItemIdByName("The Brown Horn"))

        -- Poop trinkets
        table.insert(PST.poopTrinkets, Isaac.GetTrinketIdByName("Petrified Gel"))
        table.insert(PST.poopTrinkets, Isaac.GetTrinketIdByName("Coprolite Fossil"))

        local tmpHPUpItems = {
            {"GMO Corn", 1}, {"Bacon Grease", 1}, {"Leftover Takeout", 1}, {"Glizzy", 1}, {"Tea", 1}, {"Fraudulent Fungus", 1},
            {"Strange Red Object", 1}, {"Chomp Chomp!", 10}, {"Kinda Egg", 1}, {"Dad's Dip", 1}, {"Goldshi Lunch", 1},
            {"Reheated Pizza", 1}, {"Chirumiru", 1}, {"Spare Ribs", 1}, {"The Deluxe", 3}, {"Bottle of Water", 2}
        }
        for _, tmpItem in ipairs(tmpHPUpItems) do
            local tmpItemID = Isaac.GetItemIdByName(tmpItem[1])
            if tmpItemID ~= -1 then
                PST.heartUpItems[tmpItemID] = tmpItem[2]
            end
        end

        -- Regular chests
        table.insert(PST.regularChests, Isaac.GetEntityVariantByName("Dire Chest"))

        -- Locked chests
        table.insert(PST.regularChests, Isaac.GetEntityVariantByName("Shop Chest"))
        table.insert(PST.regularChests, Isaac.GetEntityVariantByName("Glass Chest"))

        -- Runes
        table.insert(PST.allRunes, Isaac.GetCardIdByName("Ansus"))

        -- Blue Gambit cards
        local tmpCards = {
            "3 of Clubs", "3 of Spades", "3 of Hearts", "3 of Diamonds", "Queen of Clubs", "Queen of Spades",
            "Queen of Diamonds", "King of Clubs", "King of Spades", "King of Diamonds", "Jack of Clubs",
            "Jack of Spades", "Jack of Hearts", "Jack of Diamonds", "+3 Fireballs", "Imp-losion", "Skip Card",
            "Thirteen of Stars", "Misprinted Joker", "Misprinted Jack of Clubs", "Misprinted Two of Clubs",
            "3 of Wands", "3 of Swords", "3 of Pentacles", "3 of Cups", "King of Wands", "King of Swords",
            "King of Pentacles", "King of Cups", "Grass Energy", "Fire Energy", "Water Energy", "Lightning Energy",
            "Fighting Energy", "Psychic Energy", "Colorless Energy", "Darkness Energy", "Metal Energy",
            "Dragon Energy", "Fairy Energy"
        }
        for _, tmpCard in ipairs(tmpCards) do
            local tmpCardID = Isaac.GetCardIdByName(tmpCard)
            if tmpCardID then
                table.insert(PST.blueGambitCards, tmpCardID)
            end
        end

        -- Planetarium items
        table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Nyx"))
        table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Deimos"))
        table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Monas Hieroglyphica"))

        -- Penny trinkets
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Egg Penny"))
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("GMO Penny"))
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Sharp Penny"))
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Molten Penny"))
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Fuzzy Penny"))
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Ore Penny"))

        -- Soul stones
        local tmpSoulstones = {
            {"Fiend", "Soul of Fiend"}, {"Golem", "Soul of Golem"}
        }
        for _, tmpSoulData in ipairs(tmpSoulstones) do
            for i=1,2 do
                local plType = Isaac.GetPlayerTypeByName(tmpSoulData[1], i == 2)
                local soulstoneID = Isaac.GetCardIdByName(tmpSoulData[2])
                if plType ~= -1 and soulstoneID ~= -1 then
                    PST.playerSoulstones[plType] = soulstoneID
                end
            end
        end

        -- Song of the Few node familiars
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Fiend"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Baby Crater"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Mrs. Spooter"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Randy the Snail"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Lamb"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Grabber"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Peach Creep"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Deimos"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Minx"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Sibling Syl"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Familiar Fly"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Wimpy Bro"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Robo-Baby 3.0"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("D3"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Clutch's Curse"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Pet Peeve"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Bag of Bobbies"))

        -- Grand Consonance node whitelist
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Baby Crater"))
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Mrs. Spooter"))
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Peach Creep"))
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Deimos"))
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Sibling Syl"))
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Dice Bag"))
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Token Bag"))
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Bag of Bobbies"))
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Fetal Stone"))

        -- Coin machines
        table.insert(PST.coinMachines, Isaac.GetEntityVariantByName("Robot Teller"))
        table.insert(PST.coinMachines, Isaac.GetEntityVariantByName("Vending Machine (Vanilla)"))
        table.insert(PST.coinMachines, Isaac.GetEntityVariantByName("Vending Machine (Fiend Folio)"))
        table.insert(PST.coinMachines, Isaac.GetEntityVariantByName("Golden Slot Machine"))
        table.insert(PST.coinMachines, Isaac.GetEntityVariantByName("Midarizer"))

        -- Bone items
        table.insert(PST.boneItems, Isaac.GetItemIdByName("Spare Ribs"))
    end

    -- Last Judgement
    if LastJudgement then
        local noDupeMobs = {"Tainted Mr. Maw" , "Coil (LJ)", "Cyabin"}
        for _, tmpMobName in ipairs(noDupeMobs) do
            table.insert(PST.noSplitMobsSpec, PST_getCustomMobTable(tmpMobName))
            -- Just in case, include no-duplication mobs into no-champion mobs
            table.insert(PST.noChampionMobs, PST_getCustomMobTable(tmpMobName))
        end

        local tmpUndead = {
            "Cage Vis", "Exorcist (LJ)", "Remnant", "Coil (LJ)", "Donor", "Slinking Guts", "Hulking Guts",
            "Pathetic Guts", "Popper", "Lobodious", "Heap", "Gash", "Jibble", "Cyabin", "Cyabin Goo", "D.O.C.",
            "Ministro II", "Skinburster", "AIDS", "Carnis", "Patho", "Cadavra (LJ)", "Chubs (LJ)", "Nibs (LJ)",
            "Cadavra Gut", "Pinky", "Haemotoxia", "Tainted Mr. Maw", "Tainted Maw"
        }
        PST_addUndeadMobs(tmpUndead)
    end

    -- Crabby Cretins
    if CrabbyCretins then
        local tmpUndead = {
            "?.Fly", "Enraged Bones", "Zealot", "Flood Cap", "Dank Gazing Globin", "Flooder",
            "Tainted Hanger", "Vessel", "Spec-Soul", "The Blighted", "Rib Fly", "Rib Fly",
            "Globlobber", "Ramble Gag"
        }
        PST_addUndeadMobs(tmpUndead)
    end

    -- Restored Monster Pack
    if RestoredMonsterPack then
        local tmpUndead = {
            "Skinling", "Scab", "Mortling", "Scorchling", "Sporeling", "Stillborn", "Chubby Bunny", "Swapper",
			"Barfy", "Screamer", "Splashy Long Legs", "​Carrion Rider", "Beard Bat", "​Rag Creep",
			"​Vessel (Antibirth)", "Vessel (RM)"
        }
        PST_addUndeadMobs(tmpUndead)
    end

    -- Fall From Grace
    if FallFromGrace then
        local tmpUndead = {
            "Mulliboil", "Puff Bat", "Hotshot", "Sourdough", "Hyph Man", "Hypher Man", "Fungori", "Gluey",
            "Valve Guy", "Wraith (Reimplemented)", "Braapinfly", "Robert", "Bobert", "Bursti", "Plumey",
            "Affusion", "Salmon", "Ms. Guano", "Bumblebat"
        }
        PST_addUndeadMobs(tmpUndead)
    end

    -- Repentance Plus! (MOD)
	if RepentancePlusMod then
		-- Baby Familiars
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Cherubim"))

		-- Poop trinkets
        table.insert(PST.poopTrinkets, Isaac.GetTrinketIdByName("Night Soil"))

		-- Locked Chests
		table.insert(PST.lockedChests, Isaac.GetItemIdByName("Scarlet Chest"))

		-- Runes
        table.insert(PST.allRunes, Isaac.GetCardIdByName("Red Rune"))
		table.insert(PST.allRunes, Isaac.GetCardIdByName("Quasar Shard"))
		table.insert(PST.allRunes, Isaac.GetCardIdByName("Flower of Lust"))
		table.insert(PST.allRunes, Isaac.GetCardIdByName("Canine of Wrath"))
		table.insert(PST.allRunes, Isaac.GetCardIdByName("Acid of Sloth"))
		table.insert(PST.allRunes, Isaac.GetCardIdByName("Void of Gluttony"))
		table.insert(PST.allRunes, Isaac.GetCardIdByName("Apple of Pride"))
		table.insert(PST.allRunes, Isaac.GetCardIdByName("Mask of Envy"))
		table.insert(PST.allRunes, Isaac.GetCardIdByName("Crown of Greed"))

		-- Blue Gambit Cards
		local tmpCards = {
            "Bedside Queen", "Queen of Spades",
            "Queen of Diamonds", "King of Clubs", "King of Spades", "King of Diamonds", "Jack of Clubs",
            "Jack of Spades", "Jack of Hearts", "Jack of Diamonds", "Reverse Card",
            "Antimaterial Card", "Fiend Fire", "Demon Form", "Spiritual Reserves", "Mirrored Landscape",
        }
        for _, tmpCard in ipairs(tmpCards) do
            local tmpCardID = Isaac.GetCardIdByName(tmpCard)
            if tmpCardID then
                table.insert(PST.blueGambitCards, tmpCardID)
            end
        end

		-- Penny Trinkets
		table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Trick Penny"))

		-- Song of the Few Familiars
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Cherubim"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Rejection"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("The Mark of Cain"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Ultra Flesh Kid!"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Enraged Soul"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Sibling Rivalry"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Keeper's Annoying Fly"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Tank Boys"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Helicopter Boys"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Dead Weight"))

		-- Grand Consonance Familiars
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Cherubim"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Enoch"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Enoch (Tainted)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Friendly Sack"))

        -- Bone items
        table.insert(PST.boneItems, Isaac.GetItemIdByName("Dead Weight"))
	end

	-- Reverie
	if Reverie then
		-- Final Bosses
		table.insert(PST.finalBosses, Isaac.GetEntityVariantByName("Doremy Sweet"))

		-- Baby Familiars
		table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Koakuma Baby"))
		table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Chen Baby"))
		table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Sunny Fairy"))
		table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Luna Fairy"))
		table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Star Fairy"))
		table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Dancer Servants"))

		-- Demon Familiars
		table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Koakuma Baby"))

		local tmpHPUpItems = {
            {"Fried Tofu", 1}, {"Dark Sushi", 1}, {"Baked Sweet Potato", 1}
        }
        for _, tmpItem in ipairs(tmpHPUpItems) do
            local tmpItemID = Isaac.GetItemIdByName(tmpItem[1])
            if tmpItemID ~= -1 then
                PST.heartUpItems[tmpItemID] = tmpItem[2]
            end
        end

		-- Progression Items
		table.insert(PST.progressionItems, Isaac.GetItemIdByName("Reverie Music"))
		table.insert(PST.progressionItems, Isaac.GetItemIdByName("Dream Soul"))

		-- Blue Gambit Cards
		local tmpCards = {
           "A Small Stone", "Spirit Mirror", "Situation Twist", "Death Bind"
        }
        for _, tmpCard in ipairs(tmpCards) do
            local tmpCardID = Isaac.GetCardIdByName(tmpCard)
            if tmpCardID then
                table.insert(PST.blueGambitCards, tmpCardID)
            end
        end

		-- Planetarium Items
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Hekate"))

		-- Song of the Few Familiars
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Koakuma Baby"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Chen Baby"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Sunny Fairy"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Luna Fairy"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Star Fairy"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Dancer Servant"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Sekibanki Head"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Jelly the Rock"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lightning Orb"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Shanghai Doll"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Isaac Golem"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Rabbit Illusion"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Hell Planet"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Thunder Drum"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Possessed Qin"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Possessed Pipa"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Robe Fire"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Young Native God"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Unzan"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Rusted Rod"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Steel Rod"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Resplendent Rod"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("The Golden Cudgel"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Queen of the Clan"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("The Eel"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Weaver's Needle"))

		-- Grand Consonance Familiars
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Koakuma Baby"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Sunny Fairy"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Luna Fairy"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Star Fairy"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Dancer Servant"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Sekibanki Head"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Jelly the Rock"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Possessed Qin"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Possessed Pipa"))

        -- Undead mobs
		local tmpUndead = {
            "Necrospyder", "Pyroplume 2", "Pyroplume 3", "The Immortal", "Guppet", 
			"Reverie Note (Sekibanki)", "Reverie Note (Flandre 1)", "Reverie Note (Flandre 2)",
			"Reverie Note (Flandre 3)", "Reverie Note (Flandre 4)", "Yin-Yang Greed", 
        }
        PST_addUndeadMobs(tmpUndead)

        -- Segmented bosses
        table.insert(PST.segmentBosses, Isaac.GetEntityTypeByName("The Centipede"))
	end

    -- Revelations
	if REVEL then
		local tmpUndead = {
            "Blockhead", "Cardinal Blockhead", "Yellow Blockhead", "Yellow Cardinal Blockhead", "Block Gaper", "Cardinal Block Gaper", 
			"Yellow Block Gaper", "Yellow Cardinal Block Gaper", "Block Block Block Gaper", "Ice Hazard Brother Bloody", "Brother Bloody", 
			"Frost Rider", "Frost Rider Phase 2", "Wendy", "Rag Tag", "Arrowhead", "Rag Gaper", "Rag Gaper (Head)", "Rag Gusher", 
			"Cricket (boss)", "Tammy (boss)", "Guppy (boss)", "Moxie (boss)", "Pyramid Head", "Aragnid", "Aragnid Innard", "Anima", 
			"Rag Bony", "Rag Trite", "Innard", "Necragmancer", "Wretcher", "Urny", "Rag Fatty", "Sarcophaguts", "Sarcophaguts Head", "Sarcgut", 
			"Rag Drifty", "Pseudo Rag Drifty", "Draugr", "Haugr", "Jaugr", "Juniaugr", "Snowst", "Ragtime", "Rag Dancer", "Ragma"
        }
        PST_addUndeadMobs(tmpUndead)

        -- Baby Familiars
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Lil Belial"))
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Bandage Baby"))
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Lil Michael"))

        -- Poop Items
        table.insert(PST.poopItems, Isaac.GetItemIdByName("Fecal Freak"))

        -- Demon Familiars
        table.insert(PST.demonFamiliars, Isaac.GetItemIdByName("Lil Belial"))

        -- Progression Items
        table.insert(PST.progressionItems, Isaac.GetItemIdByName("Mirror Shard"))
        table.insert(PST.progressionItems, Isaac.GetItemIdByName("Mirror Fragment"))

        -- Song of the Few
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Frost Rider"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Michael"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Hungry Grub"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Envy's Enmity"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Bargainer's Burden"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Willo"))

        -- Grand Consonance
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Willo Familiar"))

        -- Coin machines
        table.insert(PST.coinMachines, Isaac.GetEntityVariantByName("Revending Machine"))

        -- Bone items
        table.insert(PST.boneItems, Isaac.GetItemIdByName("Death Mask"))
	end

	-- Community Remix
	if communityRemix then
		-- Baby Familiars
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Cousin Cletus"))
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Conqueror Baby"))
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Boner Baby"))
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Burnt Baby"))

        -- Poop Items
        table.insert(PST.poopItems, Isaac.GetItemIdByName("Potty"))

        -- Poop Trinkets
        table.insert(PST.poopTrinkets, Isaac.GetTrinketIdByName("Suppository"))

        --HP Ups
        local tmpHPUpItems = {
            {"Taco", 1}, {"Gummy Bear", 1}, {"Croissant", 1}, {"Brunch", 1}, {"Mystery Meat", 1}, {"Akedah", 3}, {"Mudpie", 1}, {"Old Bib", 1}
        }
        for _, tmpItem in ipairs(tmpHPUpItems) do
            local tmpItemID = Isaac.GetItemIdByName(tmpItem[1])
            if tmpItemID ~= -1 then
                PST.heartUpItems[tmpItemID] = tmpItem[2]
            end
        end

		-- Blue Gambit Cards
		local tmpCards = {
            "I - The Cold" , "II - The Servant", "III - Wisdom", "IV - Repentance", "V - Eternity", "VI - Corruption",
			"VII - Immolation", "VIII - Worship", "IX - Dissension", "X - The Damned", "XI - Occult"
        }
        for _, tmpCard in ipairs(tmpCards) do
            local tmpCardID = Isaac.GetCardIdByName(tmpCard)
            if tmpCardID then
                table.insert(PST.blueGambitCards, tmpCardID)
            end
        end

		-- Planetarium Items (hexed planetarium items but whatever)
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Dagon"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Cthulhu"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Tulzscha"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Kassogtha"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Azathoth"))

		-- Penny Trinkets
		table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Penny on a String"))
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Dark Penny"))
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Sharpened Penny"))

		-- Song of the Few
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Cousin Cletus"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Conqueror Baby"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Boner Baby"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Burnt Baby"))

		-- Grand Consonance
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Cousin Cletus"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Boner Baby"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Burnt Baby"))

        -- Bean items
        table.insert(PST.beanActives, Isaac.GetItemIdByName("Spring Bean"))
        table.insert(PST.beanActives, Isaac.GetItemIdByName("Chilly Bean"))
        table.insert(PST.beanActives, Isaac.GetItemIdByName("Bowl o' Beans"))

        -- Bone items
        table.insert(PST.boneItems, Isaac.GetItemIdByName("Adam's Rib"))
        table.insert(PST.boneItems, Isaac.GetItemIdByName("Donkey's Jawbone"))
	end

    -- God's Gambit (TODO: review interactions with effects such as Challenger's Starpiece + check if GetEntityTypeByName works instead)
    --[[if GodsGambit then
        -- Deadly "Sins"
        table.insert(PST.deadlySinBosses, Isaac.GetEntityVariantByName("Kindness"))
        table.insert(PST.deadlySinBosses, Isaac.GetEntityVariantByName("Chastity"))
        table.insert(PST.deadlySinBosses, Isaac.GetEntityVariantByName("Charity"))
        table.insert(PST.deadlySinBosses, Isaac.GetEntityVariantByName("Humility"))
        table.insert(PST.deadlySinBosses, Isaac.GetEntityVariantByName("Diligence"))
        table.insert(PST.deadlySinBosses, Isaac.GetEntityVariantByName("Temperance"))
        table.insert(PST.deadlySinBosses, Isaac.GetEntityVariantByName("Patience"))
    end]]
end

-- Add mod items to the 'blue' item pool
function PST:initModBlueItems()
    -- Epiphany blue items
    if Epiphany then
        table.insert(PST.blueItemPool, Epiphany.Item.DIVINE_REMNANTS.ID)
        table.insert(PST.blueItemPool, Epiphany.Item.CHANCE_CUBE.ID)
        table.insert(PST.blueItemPool, Epiphany.Item.D5.ID)
    end

    -- Fiend Folio blue items
    if FiendFolio then
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Golem's Orb"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Peach Creep"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Ophiuchus"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Cetus"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Deimos"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Page of Virtues"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Musca"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Robo-Baby 3.0"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Nyx"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Spindle"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Azurite Spindown"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("D3"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Bag of Bobbies"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Bottle of Water"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Dad's Battery"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Mama Spooter"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Pinhead"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Chirumiru"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Bedtime Story"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Telebombs"))
    end

    -- Revelations blue items
    if REVEL then
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Mint Gum"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Penance"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Ice Tray"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Death Mask"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Mirror Bombs"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Lil Frost Rider"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Spirit of Patience"))
    end

    -- Repentance Plus MOD blue items
    if RepentancePlusMod then
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("A Bird of Hope"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Nerve Pinch"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Soul Bond"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Pure Soul"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Handicapped Placard"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Spiritual Amends"))
    end

    -- Reverie blue items
    if Reverie then
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Great Fairy Fountain"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Maid Uniform"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Frozen Sakura"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Shanghai Doll"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Starseeker"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Gourd-Shroom"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Star Fairy"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Guppy's Corpse Cart"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Sorcerer's Scroll"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Geomantic Detector"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Hekate"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Ice Sculpture"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Androgen"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Corrupt Heart"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Zhou Interprets Dreams"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Alpha and Omega"))
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Pegasus"))
    end

	-- Community Remix blue items
	if communityRemix then
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Chilly Bean"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Cryobombs"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("The Hive"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Heartache"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Ophiuchus"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Blue Waffle"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Conqueror Baby"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("_NULL"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Twin Candles"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Power Ball"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Holy Glaive"))
	end
end