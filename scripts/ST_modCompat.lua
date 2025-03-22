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

		-- Dice Items
		table.insert(PST.diceItems, Epiphany.Item.D5)
		table.insert(PST.diceItems, Epiphany.Item.BLIGHTED_DICE)
		table.insert(PST.diceItems, Epiphany.Item.CHANCE_CUBE)

		-- Beggars
		table.insert(PST.beggarTypes, Epiphany.Slot.CONVERTER_BEGGAR)
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
        table.insert(PST.noChampionMobs, PST_getCustomMobTable("Bowler"))
        table.insert(PST.noChampionMobs, PST_getCustomMobTable("Mr. Gurgle"))
        table.insert(PST.noChampionMobs, PST_getCustomMobTable("Flagpole"))

		-- No, really, no champions!
		table.insert(PST.noChampionMobsJewel, PST_getCustomMobTable("Fishaac"))
        table.insert(PST.noChampionMobsJewel, PST_getCustomMobTable("Missing Link"))
		table.insert(PST.noChampionMobsJewel, PST_getCustomMobTable("Mr. Horf"))
        table.insert(PST.noChampionMobsJewel, PST_getCustomMobTable("Mr. Red Horf"))
        table.insert(PST.noChampionMobsJewel, PST_getCustomMobTable("Mr. Sub Horf"))
		table.insert(PST.noChampionMobsJewel, PST_getCustomMobTable("Mr. Gurgle"))
		table.insert(PST.noChampionMobsJewel, PST_getCustomMobTable("Mr. Gob"))

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
            "The Organization", "Dusk", "Mr. Dead", "Cacophobia", "Gravedigger", "Drainer"
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
        table.insert(PST.lockedChests, Isaac.GetEntityVariantByName("Shop Chest"))
        table.insert(PST.lockedChests, Isaac.GetEntityVariantByName("Glass Chest"))

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

        -- Special sacks
        table.insert(PST.specialSacks, Isaac.GetEntityVariantByName("Blood Sack"))
        table.insert(PST.specialSacks, Isaac.GetEntityVariantByName("Trash Bag"))
        table.insert(PST.specialSacks, Isaac.GetEntityVariantByName("52 Deck"))

		-- Dice Items
		table.insert(PST.diceItems, Isaac.GetItemIdByName("D2"))
		table.insert(PST.diceItems, Isaac.GetItemIdByName("Eternal D12"))
		table.insert(PST.diceItems, Isaac.GetItemIdByName("Eternal D10"))
		table.insert(PST.diceItems, Isaac.GetItemIdByName("Loaded D6"))
		table.insert(PST.diceItems, Isaac.GetItemIdByName("Dusty D10"))
		table.insert(PST.diceItems, Isaac.GetItemIdByName("Azurite Spindown"))

		-- Wisp Actives -- todo: figure out how to get them to work
		--[[
		table.insert(PST.wispActives, FiendFolio.ITEM.MARIAS_IPAD) -- it's a joke item but the wisp is perfectly legit - wooky
		table.insert(PST.wispActives, FiendFolio.ITEM.GOLEMS_ROCK)
		table.insert(PST.wispActives, FiendFolio.ITEM.SANGUINE_HOOK)
		table.insert(PST.wispActives, FiendFolio.ITEM.AVGM)
		table.insert(PST.wispActives, FiendFolio.ITEM.BEDTIME_STORY)
		table.insert(PST.wispActives, FiendFolio.ITEM.PURPLE_PUTTY)
		table.insert(PST.wispActives, FiendFolio.ITEM.FIEND_MIX)
		table.insert(PST.wispActives, FiendFolio.ITEM.WHITE_PEPPER)
		
		table.insert(PST.wispActives, FiendFolio.ITEM.PERFECTLY_GENERIC_OBJECT_1) -- listed multiple times, as these are actually multiple different items with the same name) - wooky
		table.insert(PST.wispActives, FiendFolio.ITEM.PERFECTLY_GENERIC_OBJECT_2)
		table.insert(PST.wispActives, FiendFolio.ITEM.PERFECTLY_GENERIC_OBJECT_3)
		table.insert(PST.wispActives, FiendFolio.ITEM.PERFECTLY_GENERIC_OBJECT_4)
		table.insert(PST.wispActives, FiendFolio.ITEM.PERFECTLY_GENERIC_OBJECT_5)
		table.insert(PST.wispActives, FiendFolio.ITEM.PERFECTLY_GENERIC_OBJECT_6)
		table.insert(PST.wispActives, FiendFolio.ITEM.PERFECTLY_GENERIC_OBJECT_8)
		table.insert(PST.wispActives, FiendFolio.ITEM.PERFECTLY_GENERIC_OBJECT_12)

		table.insert(PST.wispActives, FiendFolio.ITEM.ETERNAL_D10)
		table.insert(PST.wispActives, FiendFolio.ITEM.ETERNAL_D12)
		table.insert(PST.wispActives, FiendFolio.ITEM.CHERRY_BOMB)
		table.insert(PST.wispActives, FiendFolio.ITEM.ASTROPULVIS)
		table.insert(PST.wispActives, FiendFolio.ITEM.GAMMA_GLOVES)
		table.insert(PST.wispActives, FiendFolio.ITEM.SHREDDER)
		table.insert(PST.wispActives, FiendFolio.ITEM.DUSTY_D10)
		table.insert(PST.wispActives, FiendFolio.ITEM.ERRORS_CRAZY_SLOTS)
		]]

		-- Beggars
		table.insert(PST.beggarTypes, FiendFolio.FF.PokerTable)
		table.insert(PST.beggarTypes, FiendFolio.FF.Blacksmith)
		table.insert(PST.beggarTypes, FiendFolio.FF.EvilBeggar)
		table.insert(PST.beggarTypes, FiendFolio.FF.ZodiacBeggar)
		table.insert(PST.beggarTypes, FiendFolio.FF.FakeBeggar)
		table.insert(PST.beggarTypes, FiendFolio.FF.HugBeggar)
		table.insert(PST.beggarTypes, FiendFolio.FF.CosplayBeggar)
		table.insert(PST.beggarTypes, FiendFolio.FF.Sweetpuss)
		table.insert(PST.beggarTypes, FiendFolio.FF.Midarizer) -- not quite a machine, not quite a beggar... i'll just say beggar for them - wooky

        -- Extra life items
        table.insert(PST.extraLifeItems, Isaac.GetItemIdByName("The Devil's Harvest"))
        table.insert(PST.extraLifeItems, Isaac.GetItemIdByName("Isaac.chr"))

        -- Extra life trinkets
        table.insert(PST.extraLifeTrinkets, Isaac.GetTrinketIdByName("Jesus Rock"))

		-- Trinket entropy blacklist
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Sand Dollar"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Brick Rock"))
    end

    -- Last Judgement
    if LastJudgement and not initMods.lastJudgement then
        initMods.lastJudgement = true

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
    if CrabbyCretins and not initMods.crabbyCretins then
        initMods.crabbyCretins = true

        local tmpUndead = {
            "?.Fly", "Enraged Bones", "Zealot", "Flood Cap", "Dank Gazing Globin", "Flooder",
            "Tainted Hanger", "Vessel", "Spec-Soul", "The Blighted", "Rib Fly", "Rib Fly",
            "Globlobber", "Ramble Gag"
        }
        PST_addUndeadMobs(tmpUndead)
    end

    -- Restored Monster Pack
    if RestoredMonsterPack and not initMods.rmp then
        initMods.rmp = true

        local tmpUndead = {
            "Skinling", "Scab", "Mortling", "Scorchling", "Sporeling", "Stillborn", "Chubby Bunny", "Swapper",
			"Barfy", "Screamer", "Splashy Long Legs", "​Carrion Rider", "Beard Bat", "​Rag Creep",
			"​Vessel (Antibirth)", "Vessel (RM)"
        }
        PST_addUndeadMobs(tmpUndead)
    end

    -- Fall From Grace
    if FallFromGrace and not initMods.fallFromGrace then
        initMods.fallFromGrace = true

        local tmpUndead = {
            "Mulliboil", "Puff Bat", "Hotshot", "Sourdough", "Hyph Man", "Hypher Man", "Fungori", "Gluey",
            "Valve Guy", "Wraith (Reimplemented)", "Braapinfly", "Robert", "Bobert", "Bursti", "Plumey",
            "Affusion", "Salmon", "Ms. Guano", "Bumblebat"
        }
        PST_addUndeadMobs(tmpUndead)
    end

    -- Repentance Plus! (MOD)
	if RepentancePlusMod and not initMods.repPlus then
        initMods.repPlus = true

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
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Fighting Siblings"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Toy Tank 1"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Toy Tank 2"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Toy Helicopter 1"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Toy Helicopter 2"))
		-- possible synergies: Bag-O-Trash (has a chance to break on damage) - wooky

        -- Bone items
        table.insert(PST.boneItems, Isaac.GetItemIdByName("Dead Weight"))

        -- Special sacks
        table.insert(PST.specialSacks, Isaac.GetEntityVariantByName("White Sack"))
        table.insert(PST.specialSacks, Isaac.GetEntityVariantByName("Stomack"))
        table.insert(PST.specialSacks, Isaac.GetEntityVariantByName("Golden Sack"))

		-- Dice Items
		table.insert(PST.diceItems, Isaac.GetItemIdByName("Magic Cube"))

		-- Beggars
		table.insert(PST.beggarTypes, Isaac.GetEntityVariantByName("Stargazer"))
		table.insert(PST.beggarTypes, Isaac.GetEntityVariantByName("Stargazer (Christmas)"))

        -- Extra life items
        table.insert(PST.extraLifeItems, Isaac.GetItemIdByName("The Mark of Cain"))
        table.insert(PST.extraLifeItems, Isaac.GetItemIdByName("A Bird of Hope"))
        table.insert(PST.extraLifeItems, Isaac.GetItemIdByName("DNA Redactor"))

        -- Extra life trinkets
        table.insert(PST.extraLifeTrinkets, Isaac.GetTrinketIdByName("Adam's Rib"))
	end

	-- Reverie
	if Reverie and not initMods.reverie then
        initMods.reverie = true

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
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lightning Orb"))

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
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Lightning Orb"))
		--[[interested in seeing synergies for:
		
			- Thunder Drum (activates its effect when taking damage probably)
			- Mobile Satellite (Spelunker Hat map reveal effect?)
		
		]] -- wooky

        -- Undead mobs
		local tmpUndead = {
            "Necrospyder", "Pyroplume 2", "Pyroplume 3", "The Immortal", "Guppet",
			"Reverie Note (Sekibanki)", "Reverie Note (Flandre 1)", "Reverie Note (Flandre 2)",
			"Reverie Note (Flandre 3)", "Reverie Note (Flandre 4)", "Yin-Yang Greed",
        }
        PST_addUndeadMobs(tmpUndead)

        -- Segmented bosses
        table.insert(PST.segmentBosses, Isaac.GetEntityTypeByName("The Centipede"))

		-- Soul stones
        local tmpSoulstones = {
            {"Eika", "Soul of Eika"}, {"Satori", "Soul of Satori"}, {"Seija", "Soul of Seija"}, {"Hourai", "Soul of Hourai"}
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

		-- Dice items
		table.insert(PST.diceItems, Isaac.GetItemIdByName("D-Flip"))
		table.insert(PST.diceItems, Isaac.GetItemIdByName("D-Cheat"))

        -- Extra life items
        table.insert(PST.extraLifeItems, Isaac.GetItemIdByName("Fan of the Dead"))
        table.insert(PST.extraLifeItems, Isaac.GetItemIdByName("Ash of Phoenix"))
        table.insert(PST.extraLifeItems, Isaac.GetItemIdByName("Continue?"))
        table.insert(PST.extraLifeItems, Isaac.GetItemIdByName("Hourai Doll"))

        -- Extra life trinkets
        table.insert(PST.extraLifeTrinkets, Isaac.GetTrinketIdByName("Aromatic Flower"))

		-- Trinket entropy blacklist
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Flawed Ruby")) -- the chipped/flawed/etc gems are designed to merge with each other, then drop the next level of gem - wooky
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Ruby"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Flawless Ruby"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Perfect Ruby"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Flawed Sapphire"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Sapphire"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Flawless Sapphire"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Perfect Sapphire"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Flawed Topaz"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Topaz"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Flawless Topaz"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Perfect Topaz"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Flawed Emerald"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Emerald"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Flawless Emerald"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Perfect Emerald"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Flawed Amethyst"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Amethyst"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Flawless Amethyst"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Perfect Amethyst"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Flawed Diamond"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Diamond"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Flawless Diamond"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Perfect Diamond"))
	end

    -- Revelations
	if REVEL and not initMods.revelations then
        initMods.revelations = true

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

		-- Dice items
		table.insert(PST.diceItems, Isaac.GetItemIdByName("Hyper Dice"))

        -- Extra life items
        table.insert(PST.extraLifeItems, Isaac.GetItemIdByName("Heavenly Bell"))
        table.insert(PST.extraLifeItems, Isaac.GetItemIdByName("Ferryman's Toll"))
        table.insert(PST.extraLifeItems, Isaac.GetItemIdByName("Virgil"))
	end

	-- Community Remix
	if communityRemix and not initMods.communityRemix then
        initMods.communityRemix = true

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
		-- Interested in seeing synergies for: Conqueror Baby (like dry baby), 

        -- Bean items
        table.insert(PST.beanActives, Isaac.GetItemIdByName("Spring Bean"))
        table.insert(PST.beanActives, Isaac.GetItemIdByName("Chilly Bean"))
        table.insert(PST.beanActives, Isaac.GetItemIdByName("Bowl o' Beans"))

        -- Bone items
        table.insert(PST.boneItems, Isaac.GetItemIdByName("Adam's Rib"))
        table.insert(PST.boneItems, Isaac.GetItemIdByName("Donkey's Jawbone"))
		table.insert(PST.boneItems, Isaac.GetItemIdByName("Boner Baby"))

		-- Dice items
		table.insert(PST.diceItems, Isaac.GetItemIdByName("D3"))
		table.insert(PST.diceItems, Isaac.GetItemIdByName("Snake Eyes"))
		table.insert(PST.diceItems, Isaac.GetItemIdByName("Moldy D6"))

		-- Beggars
		table.insert(PST.beggarTypes, Isaac.GetEntityVariantByName("Fat Beggar"))
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

	-- Retribution 
	if Retribution and not initMods.retribution then
        initMods.retribution = true

		-- Baby Familiars
		table.insert(PST.babyFamiliarItems, Retribution.Item.AXOLOTL)

		-- Poop items
		table.insert(PST.poopItems, Retribution.Item.CHOLERA)
		table.insert(PST.poopItems, Retribution.Item.BROWNIE)
		table.insert(PST.poopItems, Retribution.Item.MELENA)

		-- Poop Trinkets
		table.insert(PST.poopTrinkets, Retribution.Trinket.RUSTED_PIPE) -- not a poop itself, but affects poops so im counting it - wooky
		table.insert(PST.poopTrinkets, Retribution.Trinket.TRAINING_SEAT)

		-- Evil Trinkets
		-- I'm tempted to just say the entire set of Tainted Mammon's Cursed Trinkets, but I think there'd need to be a specific synergy to make it remotely worth it - wooky

		--HP Ups
        if Retribution.Item.BLEEDING_HEART then
            PST.heartUpItems[Retribution.Item.BLEEDING_HEART] = 1
        end
		if Retribution.Item.PACKAGED_HAM then
            PST.heartUpItems[Retribution.Item.PACKAGED_HAM] = 1
        end
		if Retribution.Item.BAR_OF_SOAP then
            PST.heartUpItems[Retribution.Item.BAR_OF_SOAP] = 1
        end
		if Retribution.Item.BUCKET_OF_BLOOD then
            PST.heartUpItems[Retribution.Item.BUCKET_OF_BLOOD] = 3
        end
		if Retribution.Item.CHIMERISM then
            PST.heartUpItems[Retribution.Item.CHIMERISM] = 2
        end
		if Retribution.Item.HUNDRED_DOLLAR_STEAK then
            PST.heartUpItems[Retribution.Item.HUNDRED_DOLLAR_STEAK] = 1
			-- TODO: Make it grant an extra stats up every thirty minutes - wooky
        end
		if Retribution.Item.MUSTARD_SEED then
            PST.heartUpItems[Retribution.Item.MUSTARD_SEED] = 1
        end
		if Retribution.Item.PEASHY then
            PST.heartUpItems[Retribution.Item.PEASHY] = 1
        end
		if Retribution.Item.PHILOSOPHERS_STONE then
            PST.heartUpItems[Retribution.Item.PHILOSOPHERS_STONE] = 1
        end
		if Retribution.Item.HAM then
            PST.heartUpItems[Retribution.Item.HAM] = 1
        end
		if Retribution.Item.BRUNCH then
            PST.heartUpItems[Retribution.Item.BRUNCH] = 1
        end
		if Retribution.Item.MILK_OF_BAPHOMET then
            PST.heartUpItems[Retribution.Item.MILK_OF_BAPHOMET] = 1
        end
		if Retribution.Item.BOOTLICKER then
            PST.heartUpItems[Retribution.Item.BOOTLICKER] = 1
        end
		if Retribution.Item.SCULPTED_SOAPSTONE then
            PST.heartUpItems[Retribution.Item.SCULPTED_SOAPSTONE] = 0
			-- TODO: Make it grant the stats up at the start of every floor - wooky
        end

		-- No splitting
        local noDupeMobs = {"Drowned Grub"}
        for _, tmpMobName in ipairs(noDupeMobs) do
            table.insert(PST.noSplitMobsSpec, PST_getCustomMobTable(tmpMobName))
            -- Just in case, include no-duplication mobs into no-champion mobs
            table.insert(PST.noChampionMobs, PST_getCustomMobTable(tmpMobName))
        end

		-- Runes
        table.insert(PST.allRunes, Retribution.Rune.WUNJO) -- I wunjo, you wunjo, he, she, me WUNJO? Wunjology, the study of Wunjo? It's first grade, Spongebob! - wooky
		table.insert(PST.allRunes, Retribution.Rune.THURISAZ)
		table.insert(PST.allRunes, Retribution.Rune.MANNAZ)
		table.insert(PST.allRunes, Retribution.Rune.NAUDIZ)

		-- Penny Trinkets
		table.insert(PST.pennyTrinkets, Retribution.Trinket.GRUBBY_PENNY)
		table.insert(PST.pennyTrinkets, Retribution.Trinket.RAINBOW_PENNY)
		table.insert(PST.pennyTrinkets, Retribution.Trinket.YEN_PENNY)

		-- Soul stones
        local tmpSoulstones = {
            {"Mammon", "Soul of Mammon"}
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

		-- Song of the Few
		table.insert(PST.songOfTheFewFamiliars, Retribution.Item.AXOLOTL)
		table.insert(PST.songOfTheFewFamiliars, Retribution.Item.BARON_FLY)
		table.insert(PST.songOfTheFewFamiliars, Retribution.Item.BEDBUG)
		table.insert(PST.songOfTheFewFamiliars, Retribution.Item.BOBS_HEART)
		table.insert(PST.songOfTheFewFamiliars, Retribution.Item.CACTUS)
		table.insert(PST.songOfTheFewFamiliars, Retribution.Item.CHUNK_OF_TOFU)
		table.insert(PST.songOfTheFewFamiliars, Retribution.Item.COIL)
		table.insert(PST.songOfTheFewFamiliars, Retribution.Item.FRAIL_FLY)
		table.insert(PST.songOfTheFewFamiliars, Retribution.Item.FRIENDLY_MONSTER)
		table.insert(PST.songOfTheFewFamiliars, Retribution.Item.GUPPYS_PRIDE)
		table.insert(PST.songOfTheFewFamiliars, Retribution.Item.FRIEND_FOLIO)
		table.insert(PST.songOfTheFewFamiliars, Retribution.Item.DOMINICUS)

		-- Grand Consonance
		table.insert(PST.grandConsonanceWhitelist, Retribution.FamiliarVariant.GUPPYS_PRIDE)
		table.insert(PST.grandConsonanceWhitelist, Retribution.FamiliarVariant.FALSE_IDOL)
		table.insert(PST.grandConsonanceWhitelist, Retribution.FamiliarVariant.FRIEND)
		table.insert(PST.grandConsonanceWhitelist, Retribution.FamiliarVariant.FRIENDLY_MONSTER)
		-- Interested in seeing synergies for: Bob's Heart/Intestine (like a stronger version of bobs brain?), Cactus, Coil, Dominicus - wooky

		-- Undead
		local tmpUndead = {
            "Spirit", "Lifeseed Spirit", "Bloated Fly", "Drowned Grub", "Drowned Maggot", "Drowned Spitty", "Drowned Conjoined Spitty",
			"Huskie", "Pinprick", "Walking Blue Boil", "Stumbling Blue Boil", "Samael", "Samael Angel", "Hogma"
        }
        PST_addUndeadMobs(tmpUndead)

		-- Coin Machines
		table.insert(PST.coinMachines, Retribution.SlotVariant.GASHAPON)
		table.insert(PST.coinMachines, Retribution.SlotVariant.RESTOCK_MACHINE)

		-- Bone Items
		table.insert(PST.boneItems, Retribution.Item.HEEL_SPUR)
		table.insert(PST.boneItems, Retribution.Item.BANDAGE_BINDER)
		table.insert(PST.boneItems, Retribution.Item.FOP)

		-- Special Sacks
		table.insert(PST.specialSacks, Retribution.PickupVariant.WOODEN_BOX)

		-- Beggars
		table.insert(PST.beggarTypes, Retribution.SlotVariant.SWINE_BEGGAR)
		table.insert(PST.beggarTypes, Retribution.SlotVariant.ANGEL_SWINE)
		table.insert(PST.beggarTypes, Retribution.SlotVariant.DEMON_SWINE)
		table.insert(PST.beggarTypes, Retribution.SlotVariant.CURSE_TRADER)

        -- Trinket entropy blacklist
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.TWELVE_GAUGE_CLAY)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.BLOODIED_FEATHER)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.CALTROP)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.FLAGELLANT_WHIP)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.ASHEN_EYE)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.SHY_ONION)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.LAME_SUNGLASSES)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.LAMENT)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.ANTIMONIAL_COMMUNION)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.ROTTEN_GUT)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.BLOWN_FUSE)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.FADED_MAP)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.IMPISH_MAIZE)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.DEAD_CANARY)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.HEART_TRANSPLANT)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.CHALLENGE_LOCK)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.ANARCHIST_RECIPE)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.LOVE_LETTER)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.SALT_LICK)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.MIRROR_SHARD)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.LEAKING_BATTERY)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.WILTED_MYOSOTIS)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.DETOXIFIER)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.GRAB_BAG)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.DIET_PILL)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.PINK_WAFER)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.PRIMORDIAL_GENESIS)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.VISCALIS)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.ANTIDEPRESSANTS)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.ESTROGEN_PATCH)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.BLINDFOLD)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.UNION_CONTRACT)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.PETTITOE)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.LEAD_STANDARD)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.BROKEN_COMPASS)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.PEARLS_OF_SWINE)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.TAFFY_HEART)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.HEART_OF_ICHOR)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.HEARTY_STEW)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.FOSSILIZED_COAL)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.DADS_LUCKY_BOWLING_BALL)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.RIGGED_GASHAPON)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.CROW_MASK)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.SACRAMENTAL_WINE)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.JOYCON)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.CURSED_CAPSULE)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.BANANA_PEPPER)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.UNKNOWN)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.GUPPYS_WARBLE)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.DIRTY_ERASER)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.NUMBER_ONE_2)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.MS_TICK)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.DADS_NUKE)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.ANIMAL_CROSSING_JOYCON)

        -- Non-Cursed Trinkets that need to be dropped to take effect
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.TURNIP)
        table.insert(PST.expedEntropyTrinketBlacklist, Retribution.Trinket.ROTTEN_TURNIP)
	end

	-- Reverie: Make Good Omissions
	if ReverieMGO and not initMods.reverieMGO then
        initMods.reverieMGO = true

		-- Dice items
		table.insert(PST.diceItems, Isaac.GetItemIdByName("D58"))

		-- Soul stones
        local tmpSoulstones = {
            {"Flandre", "Soul of Flandre"}
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

		-- Beggars
		table.insert(PST.beggarTypes, Isaac.GetEntityVariantByName("Shion Beggar"))
	end

	-- THE FUTURE
	if TheFuture and not initMods.theFuture then
        initMods.theFuture = true

		-- Cause converter blacklist
        table.insert(PST.causeConverterBossBlacklist, TheFuture.Monsters.Nevermore)
		table.insert(PST.causeConverterBossBlacklist, TheFuture.Monsters.Anguish)
		table.insert(PST.causeConverterBossBlacklist, TheFuture.Monsters.Gloom)
		table.insert(PST.causeConverterBossBlacklist, TheFuture.Monsters.Blight)
		table.insert(PST.causeConverterBossBlacklist, TheFuture.Monsters.Ruin)
		table.insert(PST.causeConverterBossBlacklist, TheFuture.Monsters.Acceptance)
		table.insert(PST.causeConverterBossBlacklist, TheFuture.Monsters.Mother)

		-- Undead enemies
		local tmpUndead = {
			"Rubber", "Spookie", "Wicked Spookie", "Ol' Spookie", "Future Tumor", "Future Tumor Small", "Kuko", "Kuko Jr.",
			"Wailer (The Future)", "Family Baby", "Mongrel", "Betus", "Metabolite", "Metabulon", "Pile o' Bones", "Ferryman",
			"Monger", "Half Monger", "Anchorfish", "Sisyphus", "Carcinoma Heart", "Carcinoma Mask", "Nevermore", "Anguish", "Gloom",
			"Blight", "Ruin", "Acceptance", "Mother (The Future)"
        }
        PST_addUndeadMobs(tmpUndead)

		-- HP up items
		if TheFuture.Items.IronCart then
            PST.heartUpItems[TheFuture.Items.IronCart] = 1
        end

		-- Beggars
		table.insert(PST.beggarTypes, TheFuture.Monsters.HungrySteven) -- it's listed as a monster for some reason even though it's a beggar /shrug - wooky

		-- Final Bosses
		-- table.insert(PST.finalBosses, TheFuture.Monsters.Nevermore)
	end

	-- The Siren (wait how did i not do this one first - wooky)
	if Isaac.GetPlayerTypeByName("Siren") ~= -1 and not initMods.siren then
        initMods.siren = true

		-- Baby Familiars
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Little Siren"))
		table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Little Little Horn"))

		-- Poop Items
        table.insert(PST.poopItems, Isaac.GetItemIdByName("Poo Bum"))

		-- Demon familiars
        table.insert(PST.demonFamiliars, Isaac.GetItemIdByName("Little Siren"))
        table.insert(PST.demonFamiliars, Isaac.GetItemIdByName("Little Little Horn"))

		-- Song of the Few
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Little Siren"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Little Little Horn"))

		-- Grand Consonance
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetEntityVariantByName("Little Siren"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetEntityVariantByName("Little Little Horn"))
		-- TODO: Poo Bum synergy (like regular bum synergies, but poop, can probably just have the same number of poops as non-consonance) - wooky
	end

	-- Andromeda
	if ANDROMEDA and not initMods.andromeda then
        initMods.andromeda = true

		-- Baby Familiars
		table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Baby Pluto"))

		--HP Ups
        local tmpHPUpItems = {
            {"Chiron", 1}
        }
        for _, tmpItem in ipairs(tmpHPUpItems) do
            local tmpItemID = Isaac.GetItemIdByName(tmpItem[1])
            if tmpItemID ~= -1 then
                PST.heartUpItems[tmpItemID] = tmpItem[2]
            end
        end

		-- Runes
		table.insert(PST.allRunes, Isaac.GetCardIdByName("Betelgeuse"))
		table.insert(PST.allRunes, Isaac.GetCardIdByName("Alpha Centauri"))
		table.insert(PST.allRunes, Isaac.GetCardIdByName("Sirius"))

		local tmpCards = {
            "XXII - The Unknown"
        }
        for _, tmpCard in ipairs(tmpCards) do
            local tmpCardID = Isaac.GetCardIdByName(tmpCard)
            if tmpCardID then
                table.insert(PST.blueGambitCards, tmpCardID)
            end
        end

		-- Planetarium items
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Juno"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Pallas"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Ceres"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Vesta"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Chiron"))

		-- Soul stones
        local tmpSoulstones = {
            {"Andromeda", "Soul of Andromeda"}
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

		-- Song of the Few
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Luminary Flare"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Baby Pluto"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Plutonium"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Mega Plutonium"))

		-- Grand Consonance
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Luminary Flare"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Baby Pluto"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Plutonium"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Mega Plutonium"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Charon"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Nix"))

		-- Beggars
		table.insert(PST.beggarTypes, Isaac.GetEntityVariantByName("Wisp Wizard"))
	end

	-- Samael
	if SamaelMod and not initMods.samael then
        initMods.samael = true

		-- Blue Gambit
		local tmpCards = {
            "XIII", "XIII?"
        }
        for _, tmpCard in ipairs(tmpCards) do
            local tmpCardID = Isaac.GetCardIdByName(tmpCard)
            if tmpCardID then
                table.insert(PST.blueGambitCards, tmpCardID)
            end
        end

		-- Soul stones
        local tmpSoulstones = {
            {"Samael", "Soul of Samael"}
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

		-- Bone items
		table.insert(PST.boneItems, Isaac.GetItemIdByName("Thanatophobia"))
		table.insert(PST.boneItems, Isaac.GetItemIdByName("Thanatophilia"))

		-- Sacks
		table.insert(PST.specialSacks, Isaac.GetEntityVariantByName("(Samael) Bag o' Bones"))

		-- Beggars
		table.insert(PST.beggarTypes, Isaac.GetEntityVariantByName("(Samael) Ferryman Beggar"))

        -- Extra life items
        table.insert(PST.extraLifeItems, Isaac.GetItemIdByName("Punishment of the Grave"))
	end

	-- Bertran
	if Isaac.GetPlayerTypeByName("Bertran") ~= -1 and not initMods.bertran then
        initMods.bertran = true

		-- Progression items
        table.insert(PST.progressionItems, Isaac.GetItemIdByName("Bert's Homemade Cake")) -- technically not a plot item, but Bertran cant access his alternate bonus mode without it - wooky
	end

	-- Mastema
	if MASTEMA and not initMods.mastema then
        initMods.mastema = true

		-- Dice items
		table.insert(PST.diceItems, Isaac.GetItemIdByName("Broken Dice"))

		-- Runes
		table.insert(PST.allRunes, Isaac.GetCardIdByName("Sanguine Jewel"))

		-- Soul stones
        local tmpSoulstones = {
            {"Mastema", "Soul of Mastema"}
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
	end

	-- D!Edith
	if dedith and not initMods.dedith then
        initMods.dedith = true

		-- Baby Familiars
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("​​​Salty Baby"))

		--HP Ups
        local tmpHPUpItems = {
            {"Epic Bacon", 3}
        }
        for _, tmpItem in ipairs(tmpHPUpItems) do
            local tmpItemID = Isaac.GetItemIdByName(tmpItem[1])
            if tmpItemID ~= -1 then
                PST.heartUpItems[tmpItemID] = tmpItem[2]
            end
        end

		-- Song of the Few
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("​​​Salty Baby"))

		-- Grand Consonance
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Salty Baby (D!Edith)"))
	end

	-- Red Baby
	if RedBaby and not initMods.redBaby then
        initMods.redBaby = true

		-- Baby Familiars
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Jester Baby"))
		table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Scarlet Infant"))
		table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Lil !!!"))

		-- Poop items
		table.insert(PST.poopItems, Isaac.GetItemIdByName("Lemon Brownie Bombs"))

		--HP Ups
        local tmpHPUpItems = {
            {"Pig's Heart", 1}
        }
        for _, tmpItem in ipairs(tmpHPUpItems) do
            local tmpItemID = Isaac.GetItemIdByName(tmpItem[1])
            if tmpItemID ~= -1 then
                PST.heartUpItems[tmpItemID] = tmpItem[2]
            end
        end

		-- Dice items
		table.insert(PST.diceItems, Isaac.GetItemIdByName("Fudge Dice"))

		-- Planetarium items
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Phobos"))

		-- Penny trinkets
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Pissed Penny"))

		-- Song of the Few
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Jester Baby"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Scarlet Infant"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil !!!"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Isaac's Skin"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("!!!'s Last Friend"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("The Fistuloids"))

		-- Grand Consonance
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Jester Baby"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("The Fistuloids"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Lil' Red Baby"))

		-- Coin machines
        table.insert(PST.coinMachines, Isaac.GetEntityVariantByName("Wheel of Life"))

		-- Bone items
		table.insert(PST.boneItems, Isaac.GetItemIdByName("Hush's Scythe"))
		table.insert(PST.boneItems, Isaac.GetItemIdByName("...'s Spine"))

		-- Beggars
		table.insert(PST.beggarTypes, Isaac.GetEntityVariantByName("Piss Beggar"))

		-- Soul stones
        local tmpSoulstones = {
            {"!!!", "Soul of !!!"}
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

        -- Extra life items
        table.insert(PST.extraLifeItems, Isaac.GetItemIdByName("!!!'s Heart"))
	end

	-- The Sheriff
	if Sheriff and not initMods.sheriff then
        initMods.sheriff = true

		-- Soul stones
        local tmpSoulstones = {
            {"The Sheriff", "Soul of the Sheriff"}
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

		-- Song of the Few
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Spirit of the West"))

		-- Grand Consonance
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Spirit of the West"))

		-- Beggars
		table.insert(PST.beggarTypes, Isaac.GetEntityVariantByName("Rancher"))
	end

	-- Duke
	if dukeMod and not initMods.duke then
        initMods.duke = true

		-- Blue Gambit
		local tmpCards = {
            "Tapeworm Card", "Red Tapeworm Card"
        }
        for _, tmpCard in ipairs(tmpCards) do
            local tmpCardID = Isaac.GetCardIdByName(tmpCard)
            if tmpCardID then
                table.insert(PST.blueGambitCards, tmpCardID)
            end
        end

		-- Soul stones
        local tmpSoulstones = {
            {"Duke", "Soul of Duke"}
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

		-- Song of the Few
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Duke"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Sharty McFly"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Husk"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("The Invader"))
	end

	-- Martha of Bethany
	if Isaac.GetPlayerTypeByName("Martha") ~= -1 and not initMods.martha then
        initMods.martha = true

		-- Baby Familiars
		table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Ragged Baby"))

		-- Demon familiars
		table.insert(PST.demonFamiliars, Isaac.GetItemIdByName("Tarasque"))

		-- Locked chests
		table.insert(PST.lockedChests, Isaac.GetEntityVariantByName("Tithe Chest"))

		-- Blue Gambit
		table.insert(PST.blueGambitCards, Isaac.GetCardIdByName("Year of Plenty"))
		table.insert(PST.blueGambitCards, Isaac.GetCardIdByName("China Card"))
		if REVEL then -- oh boy time for martha's Weird Compatability Exclusive Stuff:tm:
			table.insert(PST.blueGambitCards, Isaac.GetCardIdByName("Kremlin Flu"))
			table.insert(PST.blueGambitCards, Isaac.GetCardIdByName("&quot;We will bury you...&quot;"))
		end
		if Retribution then
			table.insert(PST.blueGambitCards, Isaac.GetCardIdByName("Che Guevara"))
			table.insert(PST.blueGambitCards, Isaac.GetCardIdByName("&quot;One small step...&quot;"))
		end

		-- Soul stones
        local tmpSoulstones = {
            {"Martha", "Soul of Martha"}
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

		-- Song of the Few
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Ragged Baby"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Tarasque"))

        -- Trinket entropy blacklist
        table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Cuba Missile Crisis"))
        table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("False Hope"))
        table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("The Real Left Hand"))
        table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Salted Fish"))
        table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Daemon's Trail"))
        table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Iron Lotus"))
	end

	-- Arachna
	if ARACHNAMOD and not initMods.arachna then
        initMods.arachna = true

		-- Baby familiars
		table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Lil Arachna"))

		-- Blue Gambit
		table.insert(PST.blueGambitCards, Isaac.GetCardIdByName("Merged Card"))

		-- Penny trinkets
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Infested Penny"))

		-- Soul stones
        local tmpSoulstones = {
            {"Arachna", "Soul of Arachna"}
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

		-- Song of the Few
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Arachna"))

		-- Grand Consonance
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Lil Arachna"))

		-- Beggars
		table.insert(PST.beggarTypes, Isaac.GetEntityVariantByName("Spiderboi (beggar)"))
	end

	-- Eclipsed
	if EclipsedMod and not initMods.eclipsed then
        initMods.eclipsed = true

		-- Baby familiars
		table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Lililith"))
		table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Cultist Baby"))

		-- Demon familiars
		table.insert(PST.demonFamiliars, Isaac.GetItemIdByName("Lililith"))

		--HP Ups
        local tmpHPUpItems = {
            {"Potato", 1}, {"Muscle Meat", 1}, {"Holy Ravioli", 1}, {"Angry Meal", 1},
			{"Bacon Pancakes", 1}, {"Aurora", 1}, {"Wonder Waffle", 1}, {"Loaf of Bread", 1},
			{"Jelly-Filled Donut", 1}, {"Onigirya", 1}
        }
        for _, tmpItem in ipairs(tmpHPUpItems) do
            local tmpItemID = Isaac.GetItemIdByName(tmpItem[1])
            if tmpItemID ~= -1 then
                PST.heartUpItems[tmpItemID] = tmpItem[2]
            end
        end

		-- Dice items
		table.insert(PST.diceItems, Isaac.GetItemIdByName("Rubik's Dice"))
		table.insert(PST.diceItems, Isaac.GetItemIdByName("Tetracube"))
		table.insert(PST.diceItems, Isaac.GetItemIdByName("Tech D6"))
		table.insert(PST.diceItems, Isaac.GetItemIdByName("Astral Dice"))
		table.insert(PST.diceItems, Isaac.GetItemIdByName("L.D.R."))

		-- Runes
		table.insert(PST.allRunes, Isaac.GetCardIdByName("Trapezohedron"))
        table.insert(PST.allRunes, Isaac.GetCardIdByName("Ghost Gem"))
		table.insert(PST.allRunes, Isaac.GetCardIdByName("Cursed Emerald"))
		table.insert(PST.allRunes, Isaac.GetCardIdByName("Lunar Silver"))
		table.insert(PST.allRunes, Isaac.GetCardIdByName("Bloody Gem"))
		table.insert(PST.allRunes, Isaac.GetCardIdByName("Lovely Gem"))
		table.insert(PST.allRunes, Isaac.GetCardIdByName("Golden Bronze"))
		table.insert(PST.allRunes, Isaac.GetCardIdByName("Glistening Gold"))
		table.insert(PST.allRunes, Isaac.GetCardIdByName("Charming Gem"))

		-- Blue Gambit cards (the duplicates are intentional, they have spaces after them so they can work as different cards - wooky)
        local tmpCards = {
            "Apocalypse", "Banned Card", "Ascender's Bane", "Multi-Cast", "Wish",
			"Offering", "Infinite Blades", "Transmutation", "Ritual Dagger", "Fusion",
			"Deus Ex Machina", "Adrenaline", "Corruption", "Decay", "Exploding Kitten",
			"Defuse Card", "See the Future Card", "Nope Card", "Skip Card", "Favor Card",
			"Shuffle Card", "Attack Card", "Exploding Kitten ", "Defuse Card ", "See the Future Card ",
			"Nope Card ", "Skip Card ", "Favor Card ", "Attack Card ", "Shuffle Card ", "Arsenal Card",
			"Bookery Card", "Outpost Card", "Oblivion Card", "Treasury Card", "Battlefield Card", "Blood Grove Card",
			"Storm Temple Card", "Zero Milestone Card", "Ancestral Crypt Card", "Ancestral Crypt Card", "Cemetery Card",
			"Village Card", "Grove Card", "Spider Cocoon Card", "Vampire Mansion Card", "Wheat Fields Card", "Swamp Card",
			"Ruins Card", "Road Lantern Card", "Smith's Forge Card", "Chrono Crystals Card", "Witch Hut Card", "Beacon Card",
			"Temporal Beacon Card"
        }
        for _, tmpCard in ipairs(tmpCards) do
            local tmpCardID = Isaac.GetCardIdByName(tmpCard)
            if tmpCardID then
                table.insert(PST.blueGambitCards, tmpCardID)
            end
        end

		-- Planetarium items
        table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Eclipse"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Khepri"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Varg"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Aurora"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Sarbokan"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Tindal"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Horoles"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Bufo"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Lutos"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Levitan"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Jaudaz"))

		-- Soul stones
        local tmpSoulstones = {
            {"Unbidden", "Soul of Unbidden"}, {"Nadab", "Soul of Nadab and Abihu"}, {"Abihu", "Soul of Nadab and Abihu"}
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

		-- Song of the Few Familiars
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Long Elk"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lililith"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Abihu"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Nadab's Brain"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Stone Frog"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Cultist Baby"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Magician's Top"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Betty Sweetooth"))

		-- Grand Consonance
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Red Bag"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Stone Frog fam"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Cultist Baby"))

		-- Beggars
		table.insert(PST.beggarTypes, Isaac.GetEntityVariantByName("Mongo Beggar"))
		table.insert(PST.beggarTypes, Isaac.GetEntityVariantByName("Delirious Bum"))
		table.insert(PST.beggarTypes, Isaac.GetEntityVariantByName("Void Beggar"))
		table.insert(PST.beggarTypes, Isaac.GetEntityVariantByName("Gimpy Beggar"))
		table.insert(PST.beggarTypes, Isaac.GetEntityVariantByName("Candy Beggar"))
		table.insert(PST.beggarTypes, Isaac.GetEntityVariantByName("Meat Beggar"))
		table.insert(PST.beggarTypes, Isaac.GetEntityVariantByName("Warlock Beggar"))
		table.insert(PST.beggarTypes, Isaac.GetEntityVariantByName("Necromancer Beggar"))

        -- Extra life items
        table.insert(PST.extraLifeItems, Isaac.GetItemIdByName("Limbus"))
        table.insert(PST.extraLifeItems, Isaac.GetItemIdByName("Angry Meal"))
        table.insert(PST.extraLifeItems, Isaac.GetItemIdByName("False Certificate"))

        -- Extra life trinkets
        table.insert(PST.extraLifeTrinkets, Isaac.GetTrinketIdByName("Witch Paper"))
        table.insert(PST.extraLifeTrinkets, Isaac.GetTrinketIdByName("Cartridge?"))

		-- Trinket entropy blacklist
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Xmas Letter"))
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Fool of Hearts"))
	end

	-- Kicks and Giggles
	if Diepio and not initMods.diepio then
        initMods.diepio = true

	    --HP Ups
        local tmpHPUpItems = {
            {"Miscarriage", 1}
        }
        for _, tmpItem in ipairs(tmpHPUpItems) do
            local tmpItemID = Isaac.GetItemIdByName(tmpItem[1])
            if tmpItemID ~= -1 then
                PST.heartUpItems[tmpItemID] = tmpItem[2]
            end
        end

		-- Blue Gambit cards
        local tmpCards = {
            "0 Card", "76 Card", "Cow on a Trash Farm" , "-10 Card"
        }
        for _, tmpCard in ipairs(tmpCards) do
            local tmpCardID = Isaac.GetCardIdByName(tmpCard)
            if tmpCardID then
                table.insert(PST.blueGambitCards, tmpCardID)
            end
        end

		-- Planetarium items
        table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Eros"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Haumea"))

		-- Penny trinkets
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Stolen Penny"))

		-- Soul stones
        local tmpSoulstones = {
            {"Lewis", "Soul of Lewis"}, {"Wynne", "Soul of Winifred"}, {"Shuko", "Soul of Shuko"}
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

        -- Extra life items
        table.insert(PST.extraLifeItems, Isaac.GetItemIdByName("​Paramedic's Medikit"))

        -- Extra life trinkets
        table.insert(PST.extraLifeTrinkets, Isaac.GetTrinketIdByName("Shuko's Severed Head"))
        table.insert(PST.extraLifeTrinkets, Isaac.GetTrinketIdByName("R Key Plush"))
        table.insert(PST.extraLifeTrinkets, Isaac.GetTrinketIdByName("Tormented Soul"))

		-- Trinket entropy blacklist
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("A Pipe Wrench"))
	end

	-- Lost and Forgotten
	if LNF and not initMods.lnf then
        initMods.lnf = true

        -- Baby familiars
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Followers"))
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Lil Guardian"))
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Divided Baby"))
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Munitus Baby"))
        table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Robo-Baby X"))

        -- Poop items
        table.insert(PST.poopItems, Isaac.GetItemIdByName("Colitis"))

        --HP Ups
        local tmpHPUpItems = {
            {"Gray Fruit", 1}, {"Cuisine", 1}, {"Wealthy Heart", 1},
            {"Rotten Potato", 1}, {"Carrot Sticks", 1}, {"Dry Biscuit", 1}
        }
        for _, tmpItem in ipairs(tmpHPUpItems) do
            local tmpItemID = Isaac.GetItemIdByName(tmpItem[1])
            if tmpItemID ~= -1 then
                PST.heartUpItems[tmpItemID] = tmpItem[2]
            end
        end

        -- Dice items
        table.insert(PST.diceItems, Isaac.GetItemIdByName("Cursed Dice"))

        -- Runes
        table.insert(PST.allRunes, Isaac.GetCardIdByName("Tenebris"))
        table.insert(PST.allRunes, Isaac.GetCardIdByName("Caecus"))
        table.insert(PST.allRunes, Isaac.GetCardIdByName("Perdita"))
        table.insert(PST.allRunes, Isaac.GetCardIdByName("Miserere"))
        table.insert(PST.allRunes, Isaac.GetCardIdByName("Gigas"))
        table.insert(PST.allRunes, Isaac.GetCardIdByName("Blank Cursed Rune"))
        table.insert(PST.allRunes, Isaac.GetCardIdByName("Glyph Of Hagalaz"))
        table.insert(PST.allRunes, Isaac.GetCardIdByName("Glyph Of Ehwaz"))
        table.insert(PST.allRunes, Isaac.GetCardIdByName("Glyph Of Berkano"))
        table.insert(PST.allRunes, Isaac.GetCardIdByName("Glyph Of Perthro"))
        table.insert(PST.allRunes, Isaac.GetCardIdByName("Glyph Of Jera"))
        table.insert(PST.allRunes, Isaac.GetCardIdByName("Glyph Of Dagaz"))
        table.insert(PST.allRunes, Isaac.GetCardIdByName("Glyph Of Algiz"))
        table.insert(PST.allRunes, Isaac.GetCardIdByName("Glyph Of Ansuz"))
        table.insert(PST.allRunes, Isaac.GetCardIdByName("Blank Glyph"))
        table.insert(PST.allRunes, Isaac.GetCardIdByName("Moon Shard"))

        -- Soul stones
        local tmpSoulstones = {
            {"Joseph", "Soul of Joseph"}, {"Robot", "Soul of Robot"}
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

        -- Song of the Few familiars
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Followers"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Guardian"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Divided Baby"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Munitus Baby"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Robo-Baby X"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Blood Ball"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Forsaken"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Maw"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Dry Bones"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Ladygrub"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Mashy"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Drizzle Maker"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Revenant's Head"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Fruit of Eden"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Low Priest"))
        table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Mark I"))

        -- Grand Consonance
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Lil Guardian"))
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Follower"))
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Munitus Baby"))
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Munitus Protector"))
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Drizzle Maker"))
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Revenant's Head"))
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Robo-Baby X"))
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Low Priest"))

        -- Coin Machines
        table.insert(PST.coinMachines, Isaac.GetEntityVariantByName("Stat Wheel"))

        -- Bone items
        table.insert(PST.boneItems, Isaac.GetItemIdByName("Dry Bones"))

        -- Beggar
        table.insert(PST.beggarTypes, Isaac.GetEntityVariantByName("Weird Beggar"))

        -- No HP modifier mobs
        table.insert(PST.mobHPBlacklist, PST_getCustomMobTable("Nightmare Gaper"))
	end

	-- Reshaken Vol. 1
	if MilkshakeVol1 and not initMods.reshaken then
        initMods.reshaken = true

		-- Baby familiars
		table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("Spirit Bum"))

		-- Poop items
		table.insert(PST.poopItems, Isaac.GetItemIdByName("Doggy Bag"))

		-- HP ups
        local tmpHPUpItems = {
            {"Milkshake!", 1}, {"Spoiled Breakfast", 1}, {"Balanced Breakfast", 1},
			{"Hearty Breakfast", 1}, {"Golden Breakfast", 12}, {"Saataa Andagii", 0.5} -- yes really - wooky
        }
        for _, tmpItem in ipairs(tmpHPUpItems) do
            local tmpItemID = Isaac.GetItemIdByName(tmpItem[1])
            if tmpItemID ~= -1 then
                PST.heartUpItems[tmpItemID] = tmpItem[2]
            end
        end

		-- Dice items
		table.insert(PST.diceItems, Isaac.GetItemIdByName("Prismatic Dice"))
		table.insert(PST.diceItems, Isaac.GetItemIdByName("Dice Dice"))

        -- Planetarium items
        table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Lyra"))

        -- Penny trinkets
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Acid Penny"))
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Crystal Penny"))

		-- Song of the Few familiars
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Sharp Cursor"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Celestial Mirror")) -- OST: Mirror Magic B-side mix (Celeste) - wooky
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Scripulous Fingore"))

        -- Extra life items
        table.insert(PST.extraLifeItems, Isaac.GetItemIdByName("Glass Idol"))

		-- Trinket entropy blacklist
		table.insert(PST.expedEntropyTrinketBlacklist, Isaac.GetTrinketIdByName("Tungsten Cube"))
	end

	-- Tainted Treasure Rooms
	if TaintedTreasure and not initMods.taintedTreasure then
        initMods.taintedTreasure = true

		-- Baby familiars
		table.insert(PST.babyFamiliarItems, Isaac.GetItemIdByName("The Basilisk"))

		-- Poop items
		table.insert(PST.poopItems, Isaac.GetItemIdByName("Salt of Magnesium"))
		table.insert(PST.poopItems, Isaac.GetItemIdByName("The Leviathan"))

		-- Demon familiars
		table.insert(PST.demonFamiliars, Isaac.GetItemIdByName("The Basilisk"))

        -- Progression items
        table.insert(PST.progressionItems, Isaac.GetItemIdByName("Finale"))

		-- Song of the Few familiars
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("The Sword"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("The Basilisk"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Abyss"))

        -- Bone items
        table.insert(PST.boneItems, Isaac.GetItemIdByName("Cricket's Cranium"))
		table.insert(PST.boneItems, Isaac.GetItemIdByName("Crystal Skull"))

		-- Beggar types
		table.insert(PST.beggarTypes, Isaac.GetEntityVariantByName("Tainted Beggar"))

        -- Extra life items
        table.insert(PST.extraLifeItems, Isaac.GetItemIdByName("Crystal Skull"))
	end

	-- Heaven's Call
	if HeavensCall and not initMods.HeavensCall then
        initMods.HeavensCall = true

		-- Poop items
		table.insert(PST.poopItems, Isaac.GetItemIdByName("Uranus?"))

		-- Planetarium items
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Mercurius?"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Venus?"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Terra?"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Mars?"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Jupiter?"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Saturnus?"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Uranus?"))
		table.insert(PST.planetariumItems, Isaac.GetItemIdByName("Neptunus?"))

		-- Song of the Few
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Venus?"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Neptunus?"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Jupiter"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Saturn"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Uranus"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Neptune"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Mercury"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Venus"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Terra"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Mars"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Luna"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Errant"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Ceres"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Io"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Europa"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Ganymede"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Callisto"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Titan"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Titania"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Oberon"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Triton"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Pluto"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Charon"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Eris"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Makemake"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Haumea"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil Iris"))
		table.insert(PST.songOfTheFewFamiliars, Isaac.GetItemIdByName("Lil End"))

		-- Grand Consonance
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Mercury (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Venus (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Terra (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Mars (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Jupiter (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Saturn (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Uranus (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Neptune (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Errant (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Luna (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Ceres (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Io (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Europa (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Ganymede (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Callisto (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Titan (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Titania (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Triton (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Pluto (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Charon (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Eris (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Makemake (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Haumea (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon Iris (HC)"))
		table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Moon End (HC)"))

		-- Coin machines
		table.insert(PST.coinMachines, Isaac.GetEntityVariantByName("Telescope (HC)"))
	end

    -- More Penny Trinkets
    if MorePennyTrinketsMod and not initMods.morePennyTrinkets then
        initMods.morePennyTrinkets = true

        -- Penny trinkets (shocking, i know - wooky)
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Wisp Penny"))
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Sharp Penny"))
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Boosted Penny"))
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Crystalized Penny"))
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Angelic Penny"))
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Wrapped Penny"))
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Glitched Penny"))
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Moonstone Penny"))
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Rectangular Penny"))
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Experimental Penny"))
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Shadow Penny"))
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Fractal Penny"))
        table.insert(PST.pennyTrinkets, Isaac.GetTrinketIdByName("Playdough Penny"))
    end

    -- Sewing Machine
    if SewnMod and not initMods.sewing then
        initMods.sewing = true

        -- Coin machines
        table.insert(PST.coinMachines, Isaac.GetEntityVariantByName("Sewing machine"))
        table.insert(PST.coinMachines, Isaac.GetEntityVariantByName("Sewing machine (Shop)"))
        table.insert(PST.coinMachines, Isaac.GetEntityVariantByName("Sewing machine (Angelic)"))
        table.insert(PST.coinMachines, Isaac.GetEntityVariantByName("Sewing machine (Evil)"))
    end

    -- Bael
    if BaelMOD and not initMods.bael then
        initMods.bael = true

        -- Poop items
        table.insert(PST.poopItems, Isaac.GetItemIdByName("Cat's Laxative"))

        --HP Ups
        local tmpHPUpItems = {
            {"Cat's Lunch", 1}, {"Cat's Dinner", 1}, {"Cat's Snack", 1},
            {"Cat's Blood", 1}
        }
        for _, tmpItem in ipairs(tmpHPUpItems) do
            local tmpItemID = Isaac.GetItemIdByName(tmpItem[1])
            if tmpItemID ~= -1 then
                PST.heartUpItems[tmpItemID] = tmpItem[2]
            end
        end

        -- Dice items
        table.insert(PST.diceItems, Isaac.GetItemIdByName("Cat's Polygon"))

        -- Soul stones
        local tmpSoulstones = {
            {"Bael", "Soul of Bael"}
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

        -- Bone items
        table.insert(PST.boneItems, Isaac.GetItemIdByName("Cat's Skeleton"))
        table.insert(PST.boneItems, Isaac.GetItemIdByName("Guppy's Skeleton"))	-- basically cats skeleton as a regular unlock lol - wooky

        -- Beggar
        table.insert(PST.beggarTypes, Isaac.GetEntityVariantByName("Cat Boy"))

        -- CAT WUZ HERE	
    end

    -- Malware the Forgotten Modern Horseman
    if MalwareHorseman then
        -- Locust trinkets
        table.insert(PST.locustTrinkets, Isaac.GetTrinketIdByName("Locust of Malware"))
        table.insert(PST.locustTrinkets, Isaac.GetTrinketIdByName("Locust of Malware") | TrinketType.TRINKET_GOLDEN_FLAG)

        -- Locust trinkets (non-gold)
        table.insert(PST.locustTrinketsNonGold, Isaac.GetTrinketIdByName("Locust of Malware"))
    end

    -- Add songOfTheFewFamiliars items to T. Siren's Chromatic Dissonance familiar list
    if not initMods.songOfTheFew then
        initMods.songOfTheFew = true
        for _, tmpID in ipairs(PST.songOfTheFewFamiliars) do
            table.insert(PST.sirenDissonanceFamiliars, tmpID)
        end
    end
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

	-- Retribution Blue Items
	if Retribution then
		table.insert(PST.blueItemPool, Retribution.Item.BOOK_OF_MORMON)
		table.insert(PST.blueItemPool, Retribution.Item.FALSE_IDOL)
		table.insert(PST.blueItemPool, Retribution.Item.LIFEBLOOD_SYRINGE)
		table.insert(PST.blueItemPool, Retribution.Item.BYGONE_ARM)
		table.insert(PST.blueItemPool, Retribution.Item.BEDBUG)
		table.insert(PST.blueItemPool, Retribution.Item.HYPEROPIA)
		table.insert(PST.blueItemPool, Retribution.Item.OLD_BELL)
		table.insert(PST.blueItemPool, Retribution.Item.RAPTURE)
		table.insert(PST.blueItemPool, Retribution.Item.SUNKEN_FLY)
		table.insert(PST.blueItemPool, Retribution.Item.TOY_DRUM)
		table.insert(PST.blueItemPool, Retribution.Item.CARAPACE)
	end

	-- Reverie: Make Good Omissions blue items
	if ReverieMGO then
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("The Positive Singyoku"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Fantasy Talisman"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Sing-Along Buddy"))
	end

	-- Andromeda blue items
	if ANDROMEDA then
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Gravity Shift"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("The Sporepedia"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Juno"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Pallas"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Ceres"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Vesta"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Chiron"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Ophiuchus"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Harmonic Convergence"))
	end

	-- Samael blue items
	if SamaelMod then
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Spirit of Depression"))
	end

	-- D!Edith blue items
	if dedith then
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Cool Aid"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("The Blue Berry"))
	end

	-- Red Baby blue items
	if RedBaby then
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Phobos"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Fudge Dice")) -- hey the entire reason we have the blue item pool to begin with is finally in here
	end

	-- The Sheriff blue items
	if Sheriff then
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Spirit of the West"))
	end

	-- Duke blue items
	if dukeMod then
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Queen Fly"))
	end

	-- Martha of Bethany blue items
	if Isaac.GetPlayerTypeByName("Martha") ~= -1 then
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Faith"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Tarasque"))
	end

	-- Eclipsed blue items
	if EclipsedMod then
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Unicorn"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("VVV"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Ice Cube Bombs"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Pandora's Jar"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Ritual Manuscripts"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Stitched Papers"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Alchemic Notes"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Ignite"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Varg"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Jaudaz"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Witch's Cap"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Blue Soup"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Fool Moon"))
	end

	-- Kicks and Giggles blue items
	if Diepio then
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Eros"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Haumea"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Monstromagnetic Energy Drink"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Lewis's Replica Headband"))
	end

	-- Lost and Forgotten blue items
	if LNF then
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Conscience"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Hydrosis"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Fire And Ice"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Sugared Cereal"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Dissolving Cat"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Tube Milk"))
	end

	-- Reshaken Vol. 1 blue items
	if MilkshakeVol1 then
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Lyra"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Shattered Orb"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Spirit Bum"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Glass Idol"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Leviticus"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Scripulous Fingore"))
	end

	-- Tainted Treasure Rooms blue items
	if TaintedTreasure then
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Steamy Surprise"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Whore of Galilee"))
		table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Blue Canary"))
	end

    -- Sewing Machine blue items
    if SewnMod then
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Doll's Pure Body"))
    end

    -- Malware blue items
    if MalwareHorseman then
        table.insert(PST.blueItemPool, Isaac.GetItemIdByName("Digital Pony"))
    end
end