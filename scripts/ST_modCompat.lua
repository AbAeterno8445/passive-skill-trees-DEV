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

        -- Locked chests
        table.insert(PST.lockedChests, Epiphany.Pickup.DUSTY_CHEST.ID)

        -- Non-championable mobs
        table.insert(PST.noChampionMobs, {Epiphany.Npc.REVOLT.KNIGHT.ID, Epiphany.Npc.REVOLT.KNIGHT.Variant})
        table.insert(PST.noChampionMobs, {Epiphany.Npc.REVOLT.GRUNT.ID, Epiphany.Npc.REVOLT.GRUNT.Variant})
        table.insert(PST.noChampionMobs, {Epiphany.Npc.REVOLT.BRUTE.ID, Epiphany.Npc.REVOLT.BRUTE.Variant})
        table.insert(PST.noChampionMobs, {Epiphany.Npc.REVOLT.COMMANDER.ID, Epiphany.Npc.REVOLT.COMMANDER.Variant})
        table.insert(PST.noChampionMobs, {EntityType.ENTITY_GAPER, Epiphany.Npc.EDEN_GLITCH.ID})
        table.insert(PST.noChampionMobs, {Epiphany.Npc.ABEL.ID, Epiphany.Npc.ABEL.SHEEP_VAR})

        -- Non-championable bosses
        table.insert(PST.noChampionBosses, Epiphany.Npc.ABEL.ID)

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

        -- Cause converter blacklist
        table.insert(PST.causeConverterBossBlacklist, Epiphany.Npc.ABEL.ID)

        -- Song of the Few node familiars
        table.insert(PST.songOfTheFewFamiliars, Epiphany.Item.LIL_GUPPY.ID)
        table.insert(PST.songOfTheFewFamiliars, Epiphany.Item.OLD_KNIFE.ID)

        -- Grand Consonance node whitelist
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Old Knife"))
	end

    -- Fiend Folio
    if FiendFolio and not initMods.fiendFolio then
        initMods.fiendFolio = true

        local function PST_getCustomMobTable(mobName)
            return {Isaac.GetEntityTypeByName(mobName), Isaac.GetEntityVariantByName(mobName)}
        end

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

        -- No-champion bosses (added everyone just in case)
        local noChampBosses = {
            "Buck", "The Whispers", "Honeydrop", "Griddle Horn", "Buster", "Meltdown", "Ghostbuster",
            "Cacamancer", "Battie", "Kingpin", "Slinger", "Monsoon", "Aquagob", "Chaser", "Speedy",
            "Bashful", "Pokey", "Gutso", "Luncheon", "Pollution", "Tsar", "Junkstrap", "Warp Zone",
            "Dusk", "Madomme", "Basco", "The Sun", "Peeping", "Cacophobia", "Mr. Dead"
        }
        for _, tmpMobName in ipairs(noChampBosses) do
            table.insert(PST.noChampionBosses, PST_getCustomMobTable(tmpMobName))
        end

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
        for _, tmpMobName in ipairs(tmpUndead) do
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
end