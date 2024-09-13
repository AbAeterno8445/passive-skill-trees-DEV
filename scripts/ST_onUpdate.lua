local sfx = SFXManager()

local inDeathCertificate = false

local function PST_causeConvBossSpawn()
	local player = PST:getPlayer()
	local tmpBoss = PST:getTreeSnapshotMod("SC_causeConvBoss", nil)
	if tmpBoss then
		local bossVariant = PST:getTreeSnapshotMod("SC_causeConvBossVariant", 0)
		PST.specialNodes.SC_causeConvBossEnt = Isaac.Spawn(
			tmpBoss,
			bossVariant, 0,
			player.Position,
			Vector.Zero,
			player
		)
		PST.specialNodes.SC_causeConvBossEnt:AddCharmed(EntityRef(player), -1)
	end
end

local hasDarkArtsEffect = false

-- On update
local modResetUpdate = false
function PST:onUpdate()
	local level = PST:getLevel()
	local room = PST:getRoom()
	local player = PST:getPlayer()

	if inDeathCertificate and level:GetDimension() ~= Dimension.DEATH_CERTIFICATE then
		-- Left death certificate dimension, re-update level
		PST.floorFirstUpdate = true
	end
	inDeathCertificate = level:GetDimension() == Dimension.DEATH_CERTIFICATE

	local updateTrackers = PST:getTreeSnapshotMod("updateTrackers", PST.treeMods.updateTrackers)

	if PST.floorFirstUpdate or not modResetUpdate then
		updateTrackers.charTracker = PST:getCurrentCharName()
		if updateTrackers.isBerserk == nil then updateTrackers.isBerserk = PST:isBerserk() end
		PST:resetHeartUpdater()
		modResetUpdate = true
	end

	-- First update when entering floor
	if PST.floorFirstUpdate then
		PST.floorFirstUpdate = false
		updateTrackers.jacobHeartDiffTracker = 0
		updateTrackers.luckTracker = 0
		updateTrackers.familiarsTracker = 0
		updateTrackers.lvlCurseTracker = -1
		updateTrackers.pocketTracker = 0
		PST.specialNodes.jacobHeartLuckVal = 0
		PST.specialNodes.SC_causeConvBossEnt = nil

		-- Ancient starcursed jewel: Sanguinis
		if PST:SC_getSnapshotMod("sanguinis", false) and not PST:isFirstOrigStage() and player:GetBrokenHearts() < 4 then
			player:AddBrokenHearts(1)
		end

		-- Ancient starcursed jewel: Luminescent Die
		if PST:SC_getSnapshotMod("luminescentDie", false) and not level:IsAscent() then
			if PST:getTreeSnapshotMod("SC_luminescentUsedCard", false) then
				PST:addModifiers({ SC_luminescentUsedCard = false }, true)
			else
				local tmpMod = PST:getTreeSnapshotMod("SC_luminescentDebuff", 0)
				if tmpMod < 40 then
					local tmpAdd = math.min(10, 40 - tmpMod)
					PST:addModifiers({ allstatsPerc = -tmpAdd, SC_luminescentDebuff = tmpAdd }, true)
				end
			end
		end

		-- Ancient starcursed jewel: Chronicler Stone
		if PST:SC_getSnapshotMod("chroniclerStone", false) then
			if level:GetDimension() == Dimension.DEATH_CERTIFICATE then
				PST:addModifiers({ SC_chroniclerRooms = { value = 0, set = true } }, true)
			else
				tmpMod = PST:getTreeSnapshotMod("SC_chroniclerRooms", 0)
				if tmpMod > 0 and PST:getTreeSnapshotMod("SC_chroniclerDebuff", 0) < 50 then
					local tmpAdd = math.min(tmpMod * 4, 50 - PST:getTreeSnapshotMod("SC_chroniclerDebuff", 0))
					PST:addModifiers({ allstatsPerc = -tmpAdd, SC_chroniclerDebuff = tmpAdd }, true)
				end
				local countedRooms = 0
				local countedSpecial = 0
				local levelRooms = level:GetRooms()
				for i=0,levelRooms.Size-1 do
					local roomData = levelRooms:Get(i).Data
					if roomData and PST:arrHasValue(PST.chroniclerRoomTypes, roomData.Type) then
						local tmpSub = roomData.Subtype
						if tmpSub ~= RoomSubType.DEATH_CERTIFICATE_ENTRANCE and tmpSub ~= RoomSubType.DEATH_CERTIFICATE_NORMAL then
							local tmpType = roomData.Type
							if tmpType == RoomType.ROOM_SHOP or tmpType == RoomType.ROOM_TREASURE or
							tmpType == RoomType.ROOM_ARCADE or tmpType == RoomType.ROOM_LIBRARY or tmpType == RoomType.ROOM_DICE or
							tmpType == RoomType.ROOM_PLANETARIUM or tmpType == RoomType.ROOM_SECRET then
								-- Chance to count special/locked rooms towards counter
								countedSpecial = countedSpecial + 1

								local tmpChance = (level:GetStage() - 1) * 15 + countedSpecial * 15
								if tmpChance >= 100 or 100 * math.random() < tmpChance then
									countedRooms = countedRooms + 1
								end
							else
								countedRooms = countedRooms + 1
							end
						end
					end
				end
				PST:addModifiers({ SC_chroniclerRooms = { value = countedRooms, set = true } }, true)
			end
		end

		-- Ancient starcursed jewel: Glace
		if PST:SC_getSnapshotMod("glace", false) then
			local tmpDebuff = 50 - PST:getTreeSnapshotMod("SC_glaceDebuff", 0)
			PST:addModifiers({ tearsPerc = -tmpDebuff, speedPerc = -tmpDebuff, SC_glaceDebuff = tmpDebuff }, true)
		end

		-- Ancient starcursed jewel: Crimson Warpstone
		if PST:SC_getSnapshotMod("crimsonWarpstone", false) and level:GetDimension() ~= Dimension.DEATH_CERTIFICATE then
			local debuffAmt = 30
			local ultraIdx = level:QueryRoomTypeIndex(RoomType.ROOM_ULTRASECRET, false, RNG())
			local ultraSecretRoom = level:GetRoomByIdx(ultraIdx)
			if ultraSecretRoom and ultraSecretRoom.Data.Type == RoomType.ROOM_ULTRASECRET then
				debuffAmt = 20
			end
			local tmpDebuff = debuffAmt - PST:getTreeSnapshotMod("SC_crimsonWarpDebuff", 0)
			PST:addModifiers({ allstatsPerc = -tmpDebuff, SC_crimsonWarpDebuff = tmpDebuff }, true)
		end

		-- Mod: chance to reveal the arcade room's location if it is present
		local tmpMod = PST:getTreeSnapshotMod("arcadeReveal", 0)
		if tmpMod > 0 and 100 * math.random() < tmpMod then
			local arcadeIdx = level:QueryRoomTypeIndex(RoomType.ROOM_ARCADE, false, RNG())
			local arcadeRoom = level:GetRoomByIdx(arcadeIdx)
			if arcadeRoom and arcadeRoom.Data.Type == RoomType.ROOM_ARCADE then
				arcadeRoom.DisplayFlags = 1 << 2
				level:UpdateVisibility()
			end
		end

		-- Mod: chance to reveal the shop room's location if it is present
		tmpMod = PST:getTreeSnapshotMod("shopReveal", 0)
		if tmpMod > 0 and 100 * math.random() < tmpMod then
			local shopIdx = level:QueryRoomTypeIndex(RoomType.ROOM_SHOP, false, RNG())
			local shopRoom = level:GetRoomByIdx(shopIdx)
			if shopRoom and shopRoom.Data.Type == RoomType.ROOM_SHOP then
				shopRoom.DisplayFlags = 1 << 2
				level:UpdateVisibility()
			end
		end

		-- Demonic Souvenirs node (Azazel's tree)
		if PST:getTreeSnapshotMod("demonicSouvenirs", false) then
			-- Spawn The Empress card every other floor, and spawn a random unlocked evil trinket on the second floor you enter
			if not PST:getTreeSnapshotMod("demonicSouvenirsProc", false) then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.CARD_EMPRESS, Random() + 1)
				PST:addModifiers({ demonicSouvenirsProc = true }, true)
			else
				PST:addModifiers({ demonicSouvenirsProc = false }, true)
			end
		end

		-- Gulp! node (Keeper's tree)
		if PST:getTreeSnapshotMod("gulp") and level:GetStage() % 2 ~= 0 then
			local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
       		Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpPos, Vector.Zero, nil, TrinketType.TRINKET_SWALLOWED_PENNY, Random() + 1)
		end

		-- Mod: chance to cleanse natural curses (proc)
		if PST:getTreeSnapshotMod("naturalCurseCleanseProc", false) then
			PST:createFloatTextFX("Natural curse cleansed!", Vector.Zero, Color(1, 1, 1, 1), 0.12, 70, true)
		end

		-- Mod: +luck when clearing a room below full red hearts (reset)
		local tmpLuckBuff = PST:getTreeSnapshotMod("luckOnClearBelowFullBuff", 0)
		if tmpLuckBuff > 0 then
			PST:addModifiers({ luck = -tmpLuckBuff, luckOnClearBelowFullBuff = { value = 0, set = true } }, true)
		end

		-- Mod: +luck whenever you lose black hearts (reset)
		tmpLuckBuff = PST:getTreeSnapshotMod("lostBlackHeartsLuckBuff", 0)
		if tmpLuckBuff > 0 then
			PST:addModifiers({ luck = -tmpLuckBuff, lostBlackHeartsLuckBuff = -tmpLuckBuff }, true)
		end

		-- Mod: +luck when purchasing an item (halve on entering floor)
		tmpLuckBuff = PST:getTreeSnapshotMod("itemPurchaseLuckBuff", 0)
		if tmpLuckBuff > 0 then
			PST:addModifiers({ luck = -tmpLuckBuff / 2, itemPurchaseLuckBuff = -tmpLuckBuff / 2 }, true)
		end

		-- Mod: +luck when donating to a blood machine (halve on entering floor)
		tmpLuckBuff = PST:getTreeSnapshotMod("bloodDonationLuckBuff", 0)
		if tmpLuckBuff > 0 then
			PST:addModifiers({ luck = -tmpLuckBuff / 2, bloodDonationLuckBuff = -tmpLuckBuff / 2 }, true)
		end

		-- Blessed Blood node (T. Eve's tree)
		if PST:getTreeSnapshotMod("blessedBlood", false) then
			local tmpClots = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 3)
			if #tmpClots == 0 then
				local newClot = Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, player.Position, Vector.Zero, nil, 3, Random() + 1)
				newClot:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
			end
		end

		-- Violent Marauder node (T. Samson's tree)
		if PST:getTreeSnapshotMod("violentMarauderRemoved", false) then
			local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
			Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpPos, Vector.Zero, nil, 0, 0)
			Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_SUPLEX, Random() + 1)
			PST:addModifiers({ violentMarauderRemoved = false }, true)
		end

		-- First update - After first floor
		if not PST:isFirstOrigStage() then
			-- Ancient starcursed jewel: Challenger Starpiece
			if PST:SC_getSnapshotMod("challengerStarpiece", false) then
				local tmpRoomIdx = level:QueryRoomTypeIndex(RoomType.ROOM_CHALLENGE, false, RNG())
				local challRoom = level:GetRoomByIdx(tmpRoomIdx)
				if challRoom and challRoom.Data.Type == RoomType.ROOM_CHALLENGE then
					PST:addModifiers({ SC_levelHasChall = true }, true)

					-- Check for curse of maze before teleport
					if (level:GetCurses() & LevelCurse.CURSE_OF_MAZE) > 0 then
						level:RemoveCurses(LevelCurse.CURSE_OF_MAZE)
						PST.specialNodes.levelMazeCurseProc = true
					end
					Game():StartRoomTransition(tmpRoomIdx, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT)
				else
					PST:addModifiers({ SC_levelHasChall = false }, true)
				end
			end

			-- Ancient starcursed jewel: Cursed Starpiece
			if PST:SC_getSnapshotMod("cursedStarpiece", false) and not PST:isFirstOrigStage() then
				if not PST:getTreeSnapshotMod("SC_cursedStarpieceDebuff", false) then
					-- Halve debuff if no treasure room in level
					local tmpRoomIdx = level:QueryRoomTypeIndex(RoomType.ROOM_TREASURE, false, RNG())
					local treasureRoom = level:GetRoomByIdx(tmpRoomIdx)
					if treasureRoom and treasureRoom.Data.Type == RoomType.ROOM_TREASURE then
						PST:addModifiers({ allstatsPerc = -12, SC_cursedStarpieceDebuff = true }, true)
					else
						PST:addModifiers({ allstatsPerc = -6, SC_cursedStarpieceDebuff = true }, true)
					end
				end
			end

			-- Ancient starcursed jewel: Twisted Emperor's Heirloom
			if PST:SC_getSnapshotMod("twistedEmperorHeirloom", false) then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
       			Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.CARD_REVERSE_EMPEROR, Random() + 1)
				if not PST:getTreeSnapshotMod("SC_empHeirloomActive", false) then
					PST:addModifiers({ SC_empHeirloomActive = true }, true)
				end
			end

			-- Ancient starcursed jewel: Glowing Glass Piece
			if PST:SC_getSnapshotMod("glowingGlassPiece", false) then
				if PST:getTreeSnapshotMod("SC_glowingGlassProcs", 0) < 3 and PST:getTreeSnapshotMod("SC_glowingGlassDebuff", 0) < 30 then
					PST:addModifiers({ allstatsPerc = -6, SC_glowingGlassDebuff = 6 }, true)
				end
				PST:addModifiers({ SC_glowingGlassProcs = { value = 0, set = true } }, true)
			end

			-- Mod: chance to reveal map
			if PST:getTreeSnapshotMod("mapRevealed", false) then
				level:ShowMap()
				PST:createFloatTextFX("Map revealed!", Vector.Zero, Color(1, 1, 1, 1), 0.12, 70, true)
			end

			-- Mod: chance to smelt currently held trinkets
			tmpMod = PST:getTreeSnapshotMod("floorSmeltTrinket", 0)
			if tmpMod > 0 and 100 * math.random() < tmpMod then
				local tmpTrinket = player:GetTrinket(0)
				if tmpTrinket and tmpTrinket > 0 then
					if player:AddSmeltedTrinket(tmpTrinket) then
						player:TryRemoveTrinket(tmpTrinket)
						PST:createFloatTextFX("Trinket smelted!", Vector.Zero, Color(1, 1, 1, 1), 0.12, 70, true)
					end
				end
			end

			-- Mod: chance to spawn a Blood Donation Machine at the start of a floor
			tmpMod = PST:getTreeSnapshotMod("bloodMachineSpawn", 0)
			if tmpMod > 0 and 100 * math.random() < tmpMod then
				local tmpPos = room:GetCenterPos()
				tmpPos.Y = tmpPos.Y - 40
				Game():Spawn(EntityType.ENTITY_SLOT, SlotVariant.BLOOD_DONATION_MACHINE, tmpPos, Vector.Zero, nil, 0, Random() + 1)
				Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpPos, Vector.Zero, nil, 0, 0)
				SFXManager():Play(SoundEffect.SOUND_SUMMONSOUND, 0.7)
			end

			-- Mod: chance to spawn a random trinket at the start of a floor
			tmpMod = PST:getTreeSnapshotMod("trinketSpawn", 0)
			if tmpMod > 0 and 100 * math.random() < tmpMod then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
       			Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpPos, Vector.Zero, nil, Game():GetItemPool():GetTrinket(), Random() + 1)
			end

			-- Demonic Souvenirs node (Azazel's tree)
			if PST:getTreeSnapshotMod("demonicSouvenirs", false) and not PST:getTreeSnapshotMod("demonicSouvenirsTrinket", false) then
				-- Spawn random evil trinket on the second floor you enter
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				local tmpTrinket = PST.evilTrinkets[math.random(#PST.evilTrinkets)]
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpPos, Vector.Zero, nil, tmpTrinket, Random() + 1)
				PST:addModifiers({ demonicSouvenirsTrinket = true }, true)
			end

			-- Demon Helpers node (Azazel's tree)
			if PST:getTreeSnapshotMod("demonHelpers", false) then
				-- Chance to spawn devil beggar at the beginning of the floor
				local tmpChance = PST:getTreeSnapshotMod("demonHelpersBeggarChance", 0)
				if 100 * math.random() < tmpChance then
					local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
					Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpPos, Vector.Zero, nil, 0, 0)
					Game():Spawn(EntityType.ENTITY_SLOT, SlotVariant.DEVIL_BEGGAR, tmpPos, Vector.Zero, nil, 0, Random() + 1)
					PST:addModifiers({ demonHelpersBeggarChance = { value = 5, set = true } }, true)
				elseif tmpChance < 40 then
					PST:addModifiers({ demonHelpersBeggarChance = math.min(tmpChance, 40 - tmpChance) }, true)
				end
			end

			-- Mod: chance to spawn Eden's Blessing at the beginning of the floor
			tmpMod = PST:getTreeSnapshotMod("edenBlessingSpawn", 0)
			if tmpMod > 0 and 100 * math.random() < tmpMod and not PST:getTreeSnapshotMod("edenBlessingSpawned", false) then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpPos, Vector.Zero, nil, 0, 0)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_EDENS_BLESSING, Random() + 1)
				PST:addModifiers({ edenBlessingSpawned = true }, true)
			end

			-- Harbinger Locusts node (Apollyon's tree)
			if PST:getTreeSnapshotMod("harbingerLocusts", false) and not PST:isFirstOrigStage() and not PST:getTreeSnapshotMod("harbingerLocustsFloorProc", false) then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				local tmpLocust = PST.locustTrinkets[math.random(#PST.locustTrinkets)]
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpPos, Vector.Zero, nil, tmpLocust, Random() + 1)
				PST:addModifiers({ harbingerLocustsFloorProc = true }, true)
			end

			-- Coalescing Soul node
			tmpMod = PST:getTreeSnapshotMod("coalescingSoulChance", 0)
			if tmpMod > 0 and 100 * math.random() < tmpMod and PST:getTreeSnapshotMod("coalescingSoulProcs", 0) > 0 then
				local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos())
				local tmpPlayerType = player:GetPlayerType()
				if PST:getTreeSnapshotMod("warpedCoalescence", false) and 100 * math.random() < 40 then
					tmpPlayerType = -1
				end
				local stoneType = PST:getMatchingSoulstone(tmpPlayerType)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, stoneType, Random() + 1)
				PST:addModifiers({ coalescingSoulProcs = -1 }, true)
			end

			-- Consuming Void node (T. Isaac's tree)
			if PST:getTreeSnapshotMod("consumingVoid", false) then
				if PST:getTreeSnapshotMod("consumingVoidConsumed", 0) < 2 and not level:IsAscent() and PST:isTIsaacInvFull() then
					player:RemoveCollectible(CollectibleType.COLLECTIBLE_VOID)
					local tmpCollectibles = {}
					for tmpItem, tmpItemNum in pairs(player:GetCollectiblesList()) do
						if tmpItemNum > 0 then
							table.insert(tmpCollectibles, tmpItem)
						end
					end
					player:RemoveCollectible(tmpCollectibles[math.random(#tmpCollectibles)])
					PST:createFloatTextFX("The void consumes...", Vector.Zero, Color(0.5, 0.1, 0.8, 1), 0.12, 90, true)
					SFXManager():Play(SoundEffect.SOUND_DEATH_CARD, 1, 2, false, 0.8)
				end
				PST:addModifiers({ consumingVoidConsumed = { value = 0, set = true } }, true)
			end

			-- Ephemeral Bond node (T. Lazarus' tree)
			tmpMod = PST:getTreeSnapshotMod("ephemeralBond", 0)
			if tmpMod > 0 then
				local otherForm = PST:getTLazOtherForm()
				if otherForm then
					-- Build list of player items (no actives or birthright)
					local plItems = {}
					for itemID, itemAmt in pairs(player:GetCollectiblesList()) do
						if itemAmt > 0 and itemID ~= CollectibleType.COLLECTIBLE_BIRTHRIGHT and Isaac.GetItemConfig():GetCollectible(itemID).Type ~= ItemType.ITEM_ACTIVE then
							table.insert(plItems, itemID)
						end
					end
					if #plItems > 0 then
						-- Get ephemeral bond items list, and remove items from the form that received these items if set
						local ephItems = PST:getTreeSnapshotMod("ephemeralBondItems", {})
						if #ephItems > 0 then
							local formWithEphItems = player
							if otherForm:GetPlayerType() == PST:getTreeSnapshotMod("ephemeralBondForm", 0) then
								formWithEphItems = otherForm
							end
							for _, tmpItem in ipairs(ephItems) do
								formWithEphItems:RemoveCollectible(tmpItem)
							end
							PST:addModifiers({ ephemeralBondItems = { value = {}, set = true } }, true)
						end
						PST:addModifiers({ ephemeralBondForm = { value = otherForm:GetPlayerType(), set = true } }, true)
						-- Copy a random item per Ephemeral Bond to the opposite form
						for _=1,math.min(#plItems, tmpMod) do
							local copied = false
							local failsafe = 0
							while not copied and failsafe < 200 do
								local randItem = math.random(#plItems)
								if not otherForm:HasCollectible(plItems[randItem]) then
									otherForm:AddCollectible(plItems[randItem], 0, false)
									table.insert(ephItems, plItems[randItem])
									copied = true

									local itemName = Isaac.GetLocalizedString("Items", Isaac.GetItemConfig():GetCollectible(plItems[randItem]).Name, "en")
									if itemName ~= "StringTable::InvalidKey" then
										PST:createFloatTextFX("Ephemeral Bond: " .. itemName, Vector.Zero, Color(0.8, 0.8, 1, 1), 0.14, 90, true)
									end
									table.remove(plItems, randItem)
								end
								failsafe = failsafe + 1
							end
						end
					end
				end

				-- Remove temporary Ephemeral Bonds
				tmpMod = PST:getTreeSnapshotMod("gainedTempEphBond", 0)
				if tmpMod > 0 then
					PST:addModifiers({ ephemeralBond = -tmpMod, gainedTempEphBond = { value = 0, set = true } }, true)
				end
			end

			-- Mod: chance to spawn a Wooden Chest when entering a floor
			tmpMod = PST:getTreeSnapshotMod("floorWoodenChest", 0)
			if tmpMod > 0 and 100 * math.random() < tmpMod then
				local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 40, true)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_WOODENCHEST, tmpPos, Vector.Zero, nil, 0, Random() + 1)
			end
		end
	end

	-- Detect character change (e.g. using Clicker)
	local tmpCharName = PST:getCurrentCharName()
	if tmpCharName ~= updateTrackers.charTracker then
		-- Unapply old character's tree
		if updateTrackers.charTracker ~= nil and PST.trees[updateTrackers.charTracker] ~= nil then
			for nodeID, node in pairs(PST.trees[updateTrackers.charTracker]) do
				if PST:isNodeAllocated(updateTrackers.charTracker, nodeID) then
					local modsTable = {}
					for modName, modVal in pairs(node.modifiers) do
						if type(modVal) == "number" then
							modsTable[modName] = -modVal
						elseif type(modVal) == "boolean" then
							modsTable[modName] = not modVal
						end
					end
					PST:addModifiers(modsTable, true)
				end
            end
		end
		-- Apply new character's tree if it exists
		if tmpCharName ~= nil and PST.trees[tmpCharName] then
			for nodeID, node in pairs(PST.trees[tmpCharName]) do
				if PST:isNodeAllocated(tmpCharName, nodeID) then
					PST:addModifiers(node.modifiers, true)
				end
            end
		end
		PST:updateCacheDelayed()
		updateTrackers.charTracker = tmpCharName
	end

	-- First update per room
	if room:GetFrameCount() == 1 then
		-- Update familiars
		local tmpFamiliars = PST:getRoomFamiliars()
		if tmpFamiliars ~= PST:getTreeSnapshotMod("totalFamiliars", 0) then
			PST:addModifiers({ totalFamiliars = { value = tmpFamiliars, set = true } }, true)
		end

		-- Ancient starcursed jewel: Martian Ultimatum
		if PST:SC_getSnapshotMod("martianUltimatum", false) and PST.specialNodes.SC_martianTimer == 0 then
			PST.specialNodes.SC_martianTimer = 30 * (3 + math.random(5))
		end

		-- Ancient starcursed jewel: Saturnian Luminite
		if PST:SC_getSnapshotMod("saturnianLuminite", false) then
			if not PST:inMineshaftPuzzle() then
				player:SetCanShoot(false)
			else
				player:SetCanShoot(true)
			end
			if not player:IsFlying() then
				player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_TRANSCENDENCE, false)
				player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_FATE)
				if not PST:getTreeSnapshotMod("SC_saturnianSpeedDown", false) then
					PST:addModifiers({ speedPerc = -15, SC_saturnianSpeedDown = true }, true)
				end
			elseif PST:getTreeSnapshotMod("SC_saturnianSpeedDown", false) then
				PST:addModifiers({ speedPerc = 15, SC_saturnianSpeedDown = false }, true)
			end
		end

		-- Ancient starcursed jewel: Nullstone
		if PST:SC_getSnapshotMod("nullstone", false) then
			-- Spawn first nullified enemy in boss room
			if room:GetType() == RoomType.ROOM_BOSS and room:GetAliveBossesCount() > 0 and
			not PST:getTreeSnapshotMod("SC_nullstoneClear", false) then
				local nullstoneList = PST:getTreeSnapshotMod("SC_nullstoneEnemies", nil)
				local currentSpawn = PST.specialNodes.SC_nullstoneCurrentSpawn
				if nullstoneList and #nullstoneList > 0 and not currentSpawn then
					local spawnEntry = nullstoneList[1]
					local centerPos = room:GetCenterPos()
					local newX = centerPos.X - (player.Position.X - centerPos.X)
					local newY = centerPos.Y - (player.Position.Y - centerPos.Y)
					local tmpPos = Isaac.GetFreeNearPosition(Vector(newX, newY), 10)
					local newSpawn = Game():Spawn(spawnEntry.type, spawnEntry.variant, tmpPos, Vector.Zero, nil, spawnEntry.subtype, Random() + 1)
					if spawnEntry.champion >= 0 then
						newSpawn:ToNPC():MakeChampion(Random() + 1, spawnEntry.champion, true)
					end
					newSpawn.Color = Color(0.1, 0.1, 0.1, 1, 0.1, 0.1, 0.1)
					PST.specialNodes.SC_nullstoneCurrentSpawn = newSpawn
					PST.specialNodes.SC_nullstoneSpawned = 2
				end
			end
		end

		-- Ancient starcursed jewel: Unusually Small Starstone
		if PST:SC_getSnapshotMod("unusuallySmallStarstone", false) then
			for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
				local tmpNPC = tmpEntity:ToNPC()
				if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not PST:arrHasValue(PST.noSplitMobs, tmpNPC.Type) and
				not PST:arrHasValue(PST.causeConverterBossBlacklist, tmpNPC.Type) and not tmpNPC.Parent and not tmpNPC.Child then
					---@diagnostic disable-next-line: undefined-field
					tmpNPC:TrySplit(0, EntityRef(player))
				end
			end
		end

		-- Ancient starcursed jewel: Cause Converter
		PST_causeConvBossSpawn()

		-- Cosmic Realignment node
		if PST:cosmicRCharPicked(PlayerType.PLAYER_MAGDALENE_B) then
			-- Tainted Magdalene, if room has monsters and you have more than 2 red hearts, take 1/2 heart damage
			if room:GetAliveEnemiesCount() > 0 and player:GetHearts() > 4 then
				player:TakeDamage(1, 0, EntityRef(player), 0)
			end
		end
	end

	-- First heart-related functions update
	if not PST.modData.firstHeartUpdate then
		PST:onHeartUpdate(true)
		PST.modData.firstHeartUpdate = true
	end

	-- Boss jewel drop proc
	if PST.specialNodes.bossJewelDropProc > 0 and Game():GetFrameCount() >= PST.specialNodes.bossJewelDropProc + 20 then
		local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 40)
		PST:SC_dropRandomJewelAt(tmpPos, PST.SCDropRates.boss(level:GetStage()).ancient)
		PST.specialNodes.bossJewelDropProc = 0
	end

	-- Starcursed mod: monster status cleanse every X seconds
	local tmpMod = PST:SC_getSnapshotMod("statusCleanse", 0)
	if tmpMod > 0 and room:GetFrameCount() % (tmpMod * 30) == 0 then
		for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not EntityRef(tmpNPC).IsFriendly and not tmpNPC:HasEntityFlags(EntityFlag.FLAG_ICE_FROZEN) then
				tmpNPC:RemoveStatusEffects()
				tmpNPC:SetColor(Color(0.5, 0.8, 1, 1), 30, 1, true, false)
			end
		end
	end
	-- Starcursed mod: normal monsters regen X HP every Y seconds
	tmpMod = PST:SC_getSnapshotMod("mobRegen", {0, 0})
	if tmpMod[1] > 0 and tmpMod[2] > 0 and room:GetFrameCount() % (tmpMod[2] * 30) == 0 then
		for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not tmpNPC:IsBoss() and not tmpNPC:HasFullHealth() and tmpNPC.Type ~= EntityType.ENTITY_GIDEON then
				tmpNPC.HitPoints = math.min(tmpNPC.MaxHitPoints, tmpNPC.HitPoints + tmpMod[1])
				tmpNPC:SetColor(Color(1, 0.5, 0.5, 1), 30, 1, true, false)
			end
		end
	end
	-- Starcursed mod: boss monsters regen X HP every Y seconds
	tmpMod = PST:SC_getSnapshotMod("bossRegen", {0, 0})
	if tmpMod[1] > 0 and tmpMod[2] > 0 and room:GetFrameCount() % (tmpMod[2] * 30) == 0 then
		for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and tmpNPC:IsBoss() and not tmpNPC:HasFullHealth() and tmpNPC.Type ~= EntityType.ENTITY_GIDEON then
				tmpNPC.HitPoints = math.min(tmpNPC.MaxHitPoints, tmpNPC.HitPoints + tmpMod[1])
				tmpNPC:SetColor(Color(1, 0.5, 0.5, 1), 30, 1, true, false)
			end
		end
	end
	-- Starcursed mod: champions heal 15% HP to nearby non-champion monsters every X seconds
	tmpMod = PST:SC_getSnapshotMod("championHealers", {0, 0})
	if type(tmpMod) == "table" and tmpMod[1] > 0 and tmpMod[2] > 0 and room:GetFrameCount() % (tmpMod * 30) == 0 then
		local tmpEntities = Isaac.GetRoomEntities()
		local tmpChamps = {}
		for _, tmpEntity in ipairs(tmpEntities) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsChampion() then
				Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, tmpNPC.Position, Vector.Zero, nil, 1, Random() + 1)
				table.insert(tmpChamps, tmpNPC)
			end
		end
		for _, tmpEntity in ipairs(tmpEntities) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not tmpNPC:IsChampion() and tmpNPC.Type ~= EntityType.ENTITY_GIDEON then
				for _, tmpChamp in ipairs(tmpChamps) do
					local dist = PST:distBetweenPoints(tmpNPC.Position, tmpChamp.Position)
					if dist <= 80 then
						tmpNPC.HitPoints = math.min(tmpNPC.MaxHitPoints, tmpNPC.HitPoints + tmpNPC.MaxHitPoints * 0.15)
						tmpNPC:SetColor(Color(1, 0.5, 0.5, 1), 30, 1, true, false)
						break
					end
				end
			end
		end
	end
	-- Starcursed mod: monsters receive no damage for 2 seconds every 10 seconds
	tmpMod = PST:SC_getSnapshotMod("mobPeriodicShield", nil)
	if tmpMod ~= nil then
		if room:GetFrameCount() % 300 >= 240 and room:GetFrameCount() % 300 <= 300 then
			PST.specialNodes.mobPeriodicShield = true
		else
			PST.specialNodes.mobPeriodicShield = false
		end
	end
	-- Starcursed mod: monsters have a chance to reduce your damage by 20% for 3 seconds
	if PST.specialNodes.mobHitReduceDmg > 0 then
		PST.specialNodes.mobHitReduceDmg = PST.specialNodes.mobHitReduceDmg - 1
		if PST.specialNodes.mobHitReduceDmg == 0 then
			PST:addModifiers({ damagePerc = 20 }, true)
		end
	end
	-- Ancient starcursed jewel: Circadian Destructor
	if PST:SC_getSnapshotMod("circadianDestructor", false) then
		if not PST.specialNodes.SC_circadianSpawnProc then
			PST.specialNodes.SC_circadianSpawnTime = PST.specialNodes.SC_circadianSpawnTime + 1
			if PST.specialNodes.SC_circadianSpawnTime >= 1440 then
				if room:GetAliveEnemiesCount() > 0 then
					Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, player.Position, Vector.Zero, nil, Card.CARD_TOWER, Random() + 1)
					PST.specialNodes.SC_circadianSpawnProc = true
				end
				PST.specialNodes.SC_circadianSpawnTime = 0
			end
		elseif room:GetFrameCount() % 30 == 0 and PST:getTreeSnapshotMod("SC_circadianStatsDown", 0) < 20 then
			PST:addModifiers({ allstatsPerc = -1, SC_circadianStatsDown = 1 }, true)
		end
		if PST.specialNodes.SC_circadianExplImmune > 0 then
			PST.specialNodes.SC_circadianExplImmune = PST.specialNodes.SC_circadianExplImmune - 1
		end
	end
	-- Ancient starcursed jewel: Soul Watcher
	if PST:SC_getSnapshotMod("soulWatcher", false) then
		if room:GetFrameCount() % 300 == 0 and #PST.specialNodes.SC_soulEaterMobs > 0 then
			for _, tmpSoulEater in ipairs(PST.specialNodes.SC_soulEaterMobs) do
				if not EntityRef(tmpSoulEater.mob).IsFriendly and tmpSoulEater.mob:IsBoss()
				and tmpSoulEater.mob.Type ~= EntityType.ENTITY_GIDEON then
					Game():Spawn(EntityType.ENTITY_ATTACKFLY, 0, tmpSoulEater.mob.Position, Vector.Zero, nil, 0, Random() + 1)
					break
				end
			end
		end
	end
	-- Ancient starcursed jewel: Martian Ultimatum
	if PST:SC_getSnapshotMod("martianUltimatum", false) then
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_MARS) then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_MARS)
			if player:GetOtherTwin() and not player:GetOtherTwin():HasCollectible(CollectibleType.COLLECTIBLE_MARS) then
				player:GetOtherTwin():AddInnateCollectible(CollectibleType.COLLECTIBLE_MARS)
			end
		end
		if room:GetFrameCount() > 1 then
			if PST.specialNodes.SC_martianTimer > 0 then
				PST.specialNodes.SC_martianTimer = PST.specialNodes.SC_martianTimer - 1
				for _, tmpTear in ipairs(PST.specialNodes.SC_martianTears) do
					if tmpTear then
						tmpTear.Color = Color(1, 0.25, 0.25, tmpTear.Color.A + 0.01)
					end
				end
				for _, tmpSprite in ipairs(PST.specialNodes.SC_martianFX) do
					if not tmpSprite.sprite:IsFinished() then
						tmpSprite.sprite:Render(room:WorldToScreenPosition(tmpSprite.pos))
						tmpSprite.sprite:Update()
					end
				end
			elseif not PST.specialNodes.SC_martianProc and room:GetAliveEnemiesCount() > 0 then
				PST.specialNodes.SC_martianTimer = 60
				PST.specialNodes.SC_martianProc = true
				local tearAmt = 2 + math.random(7)
				local tearDist = 140
				for i=1,tearAmt do
					local tmpFXSprite = Sprite("gfx/items/martian_ultimatum_fx.anm2", true)
					tmpFXSprite:Play("Default", true)
					local tearAng = (2 * math.pi) / tearAmt * (i - 1)
					local tearX = player.Position.X + tearDist * math.cos(tearAng)
					local tearY = player.Position.Y + tearDist * math.sin(tearAng)
					local newTear = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_TEAR, Vector(tearX, tearY), Vector.Zero, nil, 0, Random() + 1)
					newTear:ToProjectile().FallingAccel = -0.1
					newTear:ToProjectile():AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER)
					newTear.Color = Color(1, 0.25, 0.25, 0.1)
					table.insert(PST.specialNodes.SC_martianTears, newTear)
					table.insert(PST.specialNodes.SC_martianFX, {
						sprite = tmpFXSprite,
						pos = Vector(tearX, tearY)
					})
				end
				SFXManager():Play(SoundEffect.SOUND_LIGHTBOLT_CHARGE, 0.85, 2, false, 0.8)
			end
		end
	end
	-- Ancient starcursed jewel: Nightmare Projector
	if PST:SC_getSnapshotMod("nightmareProjector", false) and PST:getTreeSnapshotMod("SC_nightProjProc", false) then
		if PST.specialNodes.SC_nightProjTimer > 0 then
			PST.specialNodes.SC_nightProjTimer = PST.specialNodes.SC_nightProjTimer - 1
		else
			player:UseCard(Card.CARD_REVERSE_HIGH_PRIESTESS, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
			SFXManager():Play(SoundEffect.SOUND_REVERSE_HIGH_PRIESTESS)
			PST.specialNodes.SC_nightProjTimer = 3600
		end
	end

	if PST.specialNodes.SC_martianProc and PST.specialNodes.SC_martianTimer == 0 then
		if room:GetAliveEnemiesCount() > 0 then
			PST.specialNodes.SC_martianTimer = 30 * (3 + math.random(5))
		end
		PST.specialNodes.SC_martianProc = false
		PST.specialNodes.SC_martianFX = {}

		local tearSpeed = 7
		for _, tmpTear in ipairs(PST.specialNodes.SC_martianTears) do
			if tmpTear:Exists() then
				local tearVel = (player.Position - tmpTear.Position):Normalized() * tearSpeed
				local newTear = Game():Spawn(
					EntityType.ENTITY_PROJECTILE,
					ProjectileVariant.PROJECTILE_TEAR,
					tmpTear.Position,
					tearVel,
					nil,
					0,
					Random() + 1
				)
				newTear.Color = tmpTear.Color
				tmpTear:Remove()
			end
		end
		SFXManager():Play(SoundEffect.SOUND_TEARS_FIRE)
		PST.specialNodes.SC_martianTears = {}
	end

	-- Ancient starcursed jewel: Saturnian Luminite
	if PST:SC_getSnapshotMod("saturnianLuminite", false) and room:GetAliveEnemiesCount() > 0 then
		local tmpDelay = 120
		if room:GetFrameCount() % tmpDelay == 0 then
			player:RemoveCollectible(CollectibleType.COLLECTIBLE_SATURNUS)
			player:AddCollectible(CollectibleType.COLLECTIBLE_SATURNUS)
		end
	end

	-- Ancient starcursed jewel: Cursed Auric Shard
	if PST:SC_getSnapshotMod("cursedAuricShard", false) and not player:HasCollectible(CollectibleType.COLLECTIBLE_CARD_READING) then
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_CARD_READING)
	end
	local tmpTimer = PST:getTreeSnapshotMod("SC_cursedAuricTimer", 0)
	if tmpTimer > 0 and Game():GetFrameCount() >= tmpTimer + 15 then
		PST:addModifiers({ SC_cursedAuricTimer = { value = 0, set = true } }, true)
		player:UseActiveItem(CollectibleType.COLLECTIBLE_TELEPORT_2, UseFlag.USE_NOANIM)
	end

	-- Ancient starcursed jewel: Unusually Small Starstone
	if PST:SC_getSnapshotMod("unusuallySmallStarstone", false) and not player:HasCollectible(CollectibleType.COLLECTIBLE_PLUTO) then
		player:AddInnateCollectible(CollectibleType.COLLECTIBLE_PLUTO)
		if player:GetOtherTwin() and not player:GetOtherTwin():HasCollectible(CollectibleType.COLLECTIBLE_PLUTO) then
			player:GetOtherTwin():AddInnateCollectible(CollectibleType.COLLECTIBLE_MARS)
		end
	end

	-- Ancient starcursed jewel: Primordial Kaleidoscope
	if PST:SC_getSnapshotMod("primordialKaleidoscope", false) then
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE)
		end
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_FRUIT_CAKE) then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_FRUIT_CAKE)
		end
		if player:GetOtherTwin() then
			if not player:GetOtherTwin():HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
				player:GetOtherTwin():AddInnateCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE)
			end
			if not player:GetOtherTwin():HasCollectible(CollectibleType.COLLECTIBLE_FRUIT_CAKE) then
				player:GetOtherTwin():AddInnateCollectible(CollectibleType.COLLECTIBLE_FRUIT_CAKE)
			end
		end
	end

	-- Ancient starcursed jewel: Teprucord Tenican Eljwe
	if PST:SC_getSnapshotMod("teprucordTenicanEljwe", false) then
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_TMTRAINER) then
			player:AddCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
		end
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_MISSING_NO) then
			player:AddCollectible(CollectibleType.COLLECTIBLE_MISSING_NO)
		end
	end

	-- Ancient starcursed jewel: Cause Converter
	if PST.specialNodes.SC_causeConvRespawnTimer > 0 then
		PST.specialNodes.SC_causeConvRespawnTimer = PST.specialNodes.SC_causeConvRespawnTimer - 1
		if PST.specialNodes.SC_causeConvRespawnTimer == 0 then
			PST_causeConvBossSpawn()
		end
	else
		if PST.specialNodes.SC_causeConvBossEnt and not PST.specialNodes.SC_causeConvBossEnt:Exists() and PST.specialNodes.SC_causeConvRespawnTimer == 0 then
			PST.specialNodes.SC_causeConvRespawnTimer = 300
		end
	end

	-- Ancient starcursed jewel: Glowing Glass Piece
	if PST.specialNodes.SC_glowingGlassProc then
		local foundNPC = false
		for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not EntityRef(tmpNPC).IsFriendly
			and tmpNPC.Type ~= EntityType.ENTITY_GIDEON then
				foundNPC = true
				local levelStageBonus = (level:GetStage() - 1) * 2
				if not PST:isFirstOrigStage() and level:GetStage() == LevelStage.STAGE1_1 then
					levelStageBonus = levelStageBonus + 1
				end
				tmpNPC.MaxHitPoints = (tmpNPC.MaxHitPoints + 5 + levelStageBonus) * (1.05 + levelStageBonus / 100)
				tmpNPC.HitPoints = tmpNPC.MaxHitPoints
			end
		end
		if foundNPC then
			SFXManager():Play(SoundEffect.SOUND_GLASS_BREAK, 0.9, 2, false, 0.7 + math.random(5) * 0.1)
			PST:addModifiers({ SC_glowingGlassProcs = 1 }, true)

			local tmpColor = Color(0.8, 0.8, 1, 1)
			local tmpProcs = PST:getTreeSnapshotMod("SC_glowingGlassProcs", 0)
			if tmpProcs <= 3 then
				if tmpProcs == 3 then
					tmpColor = Color(0.7, 1, 1, 1)
				end
				PST:createFloatTextFX("Glass Piece: " .. tostring(tmpProcs) .. "/3", Vector.Zero, tmpColor, 0.12, 100, true)
			end
		end
		PST.specialNodes.SC_glowingGlassProc = false
	end

	-- Eldritch Mapping node
    if PST:getTreeSnapshotMod("eldritchMapping", false) and room:GetFrameCount() % 20 == 0 then
		if (level:GetCurses() & LevelCurse.CURSE_OF_THE_LOST) > 0 then
			level:RemoveCurses(LevelCurse.CURSE_OF_THE_LOST)
			PST:createFloatTextFX("Eldritch Mapping", Vector.Zero, Color(0.2, 0.1, 0.21, 1), 0.12, 90, true)
			SFXManager():Play(SoundEffect.SOUND_DEATH_CARD)
			PST:addModifiers({ eldritchMappingDebuffs = 1 }, true)
			if PST:getTreeSnapshotMod("eldritchMappingDebuffs") <= 2 then
				PST:addModifiers({ allstatsPerc = -6 }, true)
			end
		end
    end

	-- Fickle Fortune node (Cain's tree)
	if PST:getTreeSnapshotMod("fickleFortune", false) then
		-- +7% luck while holding a trinket
		local hasTrinket = player:GetTrinket(0) ~= 0 or player:GetTrinket(1) ~= 0
		if not PST:getTreeSnapshotMod("fickleFortuneActive", false) and hasTrinket then
			PST:addModifiers({ luckPerc = 7, fickleFortuneActive = true }, true)
		elseif PST:getTreeSnapshotMod("fickleFortuneActive", false) and not hasTrinket then
			PST:addModifiers({ luckPerc = -7, fickleFortuneActive = false }, true)
		end
	end

	-- Dark Heart node (Judas' tree)
	if PST:getTreeSnapshotMod("darkHeart", false) then
		-- -6% all stats while you have no black hearts. Book of Belial removes this reduction for the current room
		if not PST:getTreeSnapshotMod("darkHeartActive", false) and not PST:getTreeSnapshotMod("darkHeartBelial", false) and player:GetBlackHearts() == 0 then
			PST:addModifiers({ allstatsPerc = -6, darkHeartActive = true }, true)
		elseif PST:getTreeSnapshotMod("darkHeartActive", false) and (player:GetBlackHearts() > 0 or PST:getTreeSnapshotMod("darkHeartBelial", false)) then
			PST:addModifiers({ allstatsPerc = 6, darkHeartActive = false }, true)
		end
	end

	-- Inner Demon node (Judas' tree)
	if PST:getTreeSnapshotMod("innerDemon", false) then
		-- -35% damage as Dark Judas and start with 1 black heart instead
		if not PST:getTreeSnapshotMod("innerDemonActive") and player:GetPlayerType() == PlayerType.PLAYER_BLACKJUDAS then
			PST:addModifiers({ damagePerc = -35, innerDemonActive = true }, true)
			player:AddSoulHearts(-2)
		end
	end

	-- Heart updates
	PST:onHeartUpdate()

	-- Samson temp mods
	local tmpTime = PST:getTreeSnapshotMod("samsonTempTime", 0)
	if tmpTime ~= 0 then
		-- Mod: +damage or +speed for 2.5 seconds after killing an enemy, or hitting a boss 8 times
		if os.clock() - tmpTime > 2.5 and PST:getTreeSnapshotMod("samsonTempActive", false) then
			PST:addModifiers({
                damagePerc = -PST:getTreeSnapshotMod("samsonTempDamage", 0),
                speedPerc = -PST:getTreeSnapshotMod("samsonTempSpeed", 0),
                samsonTempActive = false,
				samsonTempTime = { value = 0, set = true}
            }, true)
		end
	end

	-- King's Curse node (Lazarus' tree)
	if PST:getTreeSnapshotMod("kingCurse", false) then
		if not PST:getTreeSnapshotMod("kingCurseActive", false) and player:GetPlayerType() ~= PlayerType.PLAYER_LAZARUS2 then
			PST:addModifiers({ allstatsPerc = -10, luck = -1, kingCurseActive = true }, true)
		elseif PST:getTreeSnapshotMod("kingCurseActive", false) and player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2 then
			PST:addModifiers({ allstatsPerc = 10, luck = 1, kingCurseActive = false }, true)
		end
	end

	-- Mod: +all stats while luck is positive
	local tmpStats = PST:getTreeSnapshotMod("luckyAllStats", 0)
	if tmpStats > 0 then
		if player.Luck > 0 and not PST:getTreeSnapshotMod("luckyAllStatsActive", false) then
			PST:addModifiers({ allstats = tmpStats, luckyAllStatsActive = true }, true)
		elseif player.Luck <= 0 and PST:getTreeSnapshotMod("luckyAllStatsActive", false) then
			PST:addModifiers({ allstats = -tmpStats, luckyAllStatsActive = false }, true)
		end
	end

	-- Holy mantle broken
	if player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) == nil and updateTrackers.holyMantleTracker then
		updateTrackers.holyMantleTracker = false

		-- Sacred Aegis node (The Lost's tree)
		if PST:getTreeSnapshotMod("sacredAegis", false) then
			-- Regenerate holy mantle after 7 seconds in this room
			PST.specialNodes.sacredAegis.hitTime = room:GetFrameCount()

			if PST.specialNodes.sacredAegis.hitsTaken < 2 then
				PST:addModifiers({ allstatsPerc = -7 }, true)
				PST.specialNodes.sacredAegis.hitsTaken = PST.specialNodes.sacredAegis.hitsTaken + 1
			end
		end

		-- Mod: all stats while not having holy mantle
		tmpStats = PST:getTreeSnapshotMod("noHolyMantleAllStats", 0)
		if tmpStats ~= 0 and not PST:getTreeSnapshotMod("noHolyMantleAllStatsActive", false) then
			PST:addModifiers({ allstats = tmpStats, noHolyMantleAllStatsActive = true }, true)
		end
	elseif player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) ~= nil and not updateTrackers.holyMantleTracker then
		updateTrackers.holyMantleTracker = true

		tmpStats = PST:getTreeSnapshotMod("noHolyMantleAllStats", 0)
		if tmpStats ~= 0 and PST:getTreeSnapshotMod("noHolyMantleAllStatsActive", false) then
			PST:addModifiers({ allstats = -tmpStats, noHolyMantleAllStatsActive = false }, true)
		end
	end

	-- Sacred Aegis node (The Lost's tree)
	if PST:getTreeSnapshotMod("sacredAegis", false) and room:GetFrameCount() - PST.specialNodes.sacredAegis.hitTime >= 210 and
	PST.specialNodes.sacredAegis.hitTime ~= 0 and not PST.specialNodes.sacredAegis.proc then
		-- Regenerate holy mantle
		player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
		sfx:Play(SoundEffect.SOUND_BEEP)
		Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, player.Position, Vector.Zero, nil, 0, Random() + 1)
		PST.specialNodes.sacredAegis.proc = true
	end

	-- Familiar quantity update
	local tmpTotal = PST:getTreeSnapshotMod("totalFamiliars", 0)
	if tmpTotal ~= updateTrackers.familiarsTracker then
		player:AddCacheFlags(PST.allstatsCache, true)
		updateTrackers.familiarsTracker = tmpTotal
	end

	-- Gulp! node (Keeper's tree)
	if PST:getTreeSnapshotMod("gulp", false) then
		-- +1.5 luck while holding swallowed penny
		local hasTrinket = player:GetTrinket(0) == TrinketType.TRINKET_SWALLOWED_PENNY or player:GetTrinket(1) == TrinketType.TRINKET_SWALLOWED_PENNY
		if hasTrinket and not PST:getTreeSnapshotMod("gulpActive", false) then
			PST:addModifiers({ luck = 1.5, gulpActive = true }, true)
		elseif not hasTrinket and PST:getTreeSnapshotMod("gulpActive", false) then
			PST:addModifiers({ luck = -1.5, gulpActive = false }, true)
		end
	end

	-- Null node (Apollyon's tree)
	if PST:getTreeSnapshotMod("null", false) then
		-- Set whether an active item has been absorbed
		if not PST:getTreeSnapshotMod("nullActiveAbsorbed", false) and #player:GetVoidedCollectiblesList() > 0 then
			PST:addModifiers({ nullActiveAbsorbed = true }, true)
		end

		-- -10% all stats while not holding void
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and not PST:getTreeSnapshotMod("nullDebuff", false) then
			PST:addModifiers({ allstatsPerc = -10, nullDebuff = true }, true)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and PST:getTreeSnapshotMod("nullDebuff", false) then
			PST:addModifiers({ allstatsPerc = 10, nullDebuff = false }, true)
		end
	end

	-- Inner Flare node (The Forgotten's tree)
	if PST:getTreeSnapshotMod("innerFlare", false) then
		-- Slow room enemies when switching to The Soul
		if not PST:getTreeSnapshotMod("innerFlareProc", false) and updateTrackers.playerTypeTracker == PlayerType.PLAYER_THEFORGOTTEN and
		player:GetPlayerType() == PlayerType.PLAYER_THESOUL then
			for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
				if tmpEntity:IsActiveEnemy() and tmpEntity:IsVulnerableEnemy() then
					tmpEntity:AddSlowing(EntityRef(player), math.floor(PST:getTreeSnapshotMod("innerFlareSlowDuration", 2) * 30), 0.7, Color(0.7, 0.7, 1, 1, 0, 0))
				end
			end
			PST:addModifiers({ innerFlareProc = true }, true)
		end
		updateTrackers.playerTypeTracker = player:GetPlayerType()
	end

	-- Fate Pendulum node (Bethany's tree)
	if PST:getTreeSnapshotMod("fatePendulum", false) then
		-- -50% all stats while not holding Metronome
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_METRONOME) and not PST:getTreeSnapshotMod("fatePendulumDebuffActive", false) then
			PST:addModifiers({ allstatsPerc = -50, fatePendulumDebuffActive = true }, true)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_METRONOME) and PST:getTreeSnapshotMod("fatePendulumDebuffActive", false) then
			PST:addModifiers({ allstatsPerc = 50, fatePendulumDebuffActive = false }, true)
		end
	end

	-- Player twin checks
	local tmpTwin = player:GetOtherTwin()
	if tmpTwin then
		-- Heart Link node (Jacob & Esau's tree)
		if PST:getTreeSnapshotMod("heartLink", false) then
			if (player:GetHearts() - tmpTwin:GetHearts()) ~= updateTrackers.jacobHeartDiffTracker then
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_RANGE, true)
				tmpTwin:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_RANGE, true)
				updateTrackers.jacobHeartDiffTracker = player:GetHearts() - tmpTwin:GetHearts()
			end
		end

		-- Statue Pilgrimage node (Jacob & Esau's tree)
		if PST:getTreeSnapshotMod("statuePilgrimage", false) then
			---@diagnostic disable-next-line: undefined-field
			tmpTimer = tmpTwin:GetGnawedLeafTimer()
			if tmpTimer >= 60 and not PST.specialNodes.esauIsStatue then
				PST.specialNodes.esauIsStatue = true
			elseif tmpTimer < 60 and PST.specialNodes.esauIsStatue then
				PST.specialNodes.esauIsStatue = false
			end

			local tmpDist = PST:distBetweenPoints(player.Position, tmpTwin.Position)
			if PST.specialNodes.esauIsStatue and tmpDist < tmpTwin.TearRange / 3 and not PST.specialNodes.jacobNearEsauBuff then
				PST:addModifiers({ allstatsPerc = 12 }, true)
				PST.specialNodes.jacobNearEsauBuff = true
			elseif (not PST.specialNodes.esauIsStatue or tmpDist > tmpTwin.TearRange / 3) and PST.specialNodes.jacobNearEsauBuff then
				PST:addModifiers({ allstatsPerc = -12 }, true)
				PST.specialNodes.jacobNearEsauBuff = false
			end
		end

		-- Mod: +luck per 1/2 heart of any type with the brother with lower total health
		local tmpBonus = PST:getTreeSnapshotMod("jacobHeartLuck", 0)
		if tmpBonus ~= 0 then
			local tmpHP = player:GetHearts() + player:GetSoulHearts() + player:GetBoneHearts() + player:GetRottenHearts() / 2
			local twinHP = tmpTwin:GetHearts() + tmpTwin:GetSoulHearts() + tmpTwin:GetBoneHearts() + tmpTwin:GetRottenHearts() / 2
			if twinHP < tmpHP then
				tmpHP = twinHP
			end
			if tmpHP ~= PST.specialNodes.jacobHeartLuckVal then
				PST.specialNodes.jacobHeartLuckVal = tmpHP
				player:AddCacheFlags(CacheFlag.CACHE_LUCK, true)
				tmpTwin:AddCacheFlags(CacheFlag.CACHE_LUCK, true)
			end
		end
	end

	-- Luck changes
	if player.Luck ~= updateTrackers.luckTracker then
		-- Mod: +% all stats when luck changes
		tmpStats = PST:getTreeSnapshotMod("mightOfFortune", 0)
		if tmpStats ~= 0 then
			player:AddCacheFlags(PST.allstatsCache, true)
		end
		updateTrackers.luckTracker = player.Luck
	end

	-- Coin changes
	if player:GetNumCoins() ~= updateTrackers.coinTracker then
		-- Lost coins
		if player:GetNumCoins() < updateTrackers.coinTracker then
			-- Starcursed mod: when losing or spending coins, X% chance to additionally lose Y coins
			tmpMod = PST:SC_getSnapshotMod("loseCoinsOnSpend", {0, 0})
			if tmpMod[1] > 0 and tmpMod[2] > 0 and 100 * math.random() < tmpMod[1] then
				player:AddCoins(-tmpMod[2])
			end
		end
		updateTrackers.coinTracker = player:GetNumCoins()
	end

	-- Level curse changes
	local tmpCurses = level:GetCurses()
	if tmpCurses ~= updateTrackers.lvlCurseTracker then
		-- Mod: all stats while a level curse is present
		tmpMod = PST:getTreeSnapshotMod("curseAllstats", 0)
		if tmpMod ~= 0 then
			if tmpCurses ~= 0 and not PST:getTreeSnapshotMod("curseAllstatsActive", false) then
				PST:addModifiers({ allstatsPerc = tmpMod, curseAllstatsActive = true }, true)
			elseif tmpCurses == 0 and PST:getTreeSnapshotMod("curseAllstatsActive", false) then
				PST:addModifiers({ allstatsPerc = -tmpMod, curseAllstatsActive = false }, true)
			end
		end
		updateTrackers.lvlCurseTracker = tmpCurses
	end

	-- Pocket item changes
	local pocketItemSum = player:GetCard(0) + player:GetCard(1)
	if pocketItemSum ~= updateTrackers.pocketTracker then
		-- Vacuophobia node (T. Isaac's tree)
		if PST:getTreeSnapshotMod("vacuophobia", false) then
			PST:updateCacheDelayed()
		end
		updateTrackers.pocketTracker = pocketItemSum
	end

	-- Spider Mod node
	if PST:getTreeSnapshotMod("spiderMod", false) and not player:HasCollectible(CollectibleType.COLLECTIBLE_SPIDER_MOD) then
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_SPIDER_MOD)
	end

	-- Overwhelming Voice node (Siren's tree)
	if PST.specialNodes.overwhelmingVoiceProc then
		local dmgMult = 1
		if PST:SC_getSnapshotMod("unusuallySmallStarstone", false) then
			dmgMult = 0.5
		end
		-- Convert friendly enemies back to enemies & deal damage
		for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC then
				if EntityRef(tmpNPC).IsFriendly and (not PST.specialNodes.SC_causeConvBossEnt or
				(PST.specialNodes.SC_causeConvBossEnt and tmpNPC.InitSeed ~= PST.specialNodes.SC_causeConvBossEnt.InitSeed)) then
					tmpNPC:ClearEntityFlags(EntityFlag.FLAG_FRIENDLY)
					if PST:getTreeSnapshotMod("overwhelmingVoiceBuff", 0) < 20 then
						PST:addModifiers({ damagePerc = 5, overwhelmingVoiceBuff = 5 }, true)
					end
				end
				if EntityRef(tmpNPC).IsCharmed then
					tmpNPC:TakeDamage((6 + level:GetStage() - 1) * dmgMult, 0, EntityRef(player), 0)
				end
			end
		end
		PST.specialNodes.overwhelmingVoiceProc = false
	end

	-- Mod: innate items absorbed by Black Rune
	tmpMod = PST:getTreeSnapshotMod("blackRuneInnateItems", {})
	if #tmpMod > 0 then
		for _, tmpItem in ipairs(tmpMod) do
			if not player:HasCollectible(tmpItem) then
				player:AddInnateCollectible(tmpItem)
			end
		end
	end

	-- Dextral Runemaster: Berkano innate Hive Mind
	if PST:getTreeSnapshotMod("berkanoHivemind", false) and room:GetFrameCount() > 1 and not player:HasCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND) then
		player:AddInnateCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND)
	end
	-- Dextral Runemaster: Algiz buff
	if PST:getTreeSnapshotMod("algizBuffProc", false) and room:GetFrameCount() % 30 == 0 then
		tmpMod = PST:getTreeSnapshotMod("algizBuffTimer", 0)
		if tmpMod > 0 then
			PST:addModifiers({ algizBuffTimer = -1 }, true)
		else
			PST:addModifiers({ damagePerc = -7, tearsPerc = -7, algizBuffProc = false }, true)
		end
	end

	-- Lingering Malice, creep damage against flying enemies
	if #PST.specialNodes.lingMaliceCreepList > 0 and room:GetFrameCount() % 15 == 0 then
		for i = #PST.specialNodes.lingMaliceCreepList, 1, -1 do
			local tmpCreep = PST.specialNodes.lingMaliceCreepList[i]
			if tmpCreep.Timeout > 0 then
				local tmpEnemies = Isaac.FindInRadius(tmpCreep.Position, tmpCreep.Size)
				for _, tmpEntity in ipairs(tmpEnemies) do
					local tmpNPC = tmpEntity:ToNPC()
					if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and tmpNPC:IsFlying() then
						local tmpDamage = (player.Damage / 2) * (1 + PST:getTreeSnapshotMod("creepDamage", false) / 100)
						tmpNPC:TakeDamage(tmpDamage, 0, EntityRef(player), 0)
					end
				end
			else
				table.remove(PST.specialNodes.lingMaliceCreepList, i)
			end
		end
	end

	-- Mod: +% damage/tears when picking up temporary hearts
	if PST.specialNodes.temporaryHeartBuffTimer > 0 then
		PST.specialNodes.temporaryHeartBuffTimer = PST.specialNodes.temporaryHeartBuffTimer - 1
		if PST.specialNodes.temporaryHeartBuffTimer == 0 then
			PST.specialNodes.temporaryHeartDmgStacks = 0
			PST.specialNodes.temporaryHeartTearStacks = 0
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY, true)
		end
	end

	-- Troll bomb disarm debuff timer
	if PST.specialNodes.trollBombDisarmDebuffTimer > 0 then
		PST.specialNodes.trollBombDisarmDebuffTimer = PST.specialNodes.trollBombDisarmDebuffTimer - 1
	end

	-- Mod: +% damage for 2 seconds after destroying poop
	if PST.specialNodes.poopDestroyBuffTimer > 0 then
		PST.specialNodes.poopDestroyBuffTimer = PST.specialNodes.poopDestroyBuffTimer - 1
		if PST.specialNodes.poopDestroyBuffTimer == 0 then
			PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
		end
	end

	-- Bloodwrath node (T. Eve's tree)
	if PST.specialNodes.bloodwrathFlipTimer > 0 then
		PST.specialNodes.bloodwrathFlipTimer = PST.specialNodes.bloodwrathFlipTimer - 1
		if PST.specialNodes.bloodwrathFlipTimer == 0 then
			PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
		end
	end

	-- Cosmic Realignment node
	local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.treeMods.cosmicRCache)
	if PST:cosmicRCharPicked(PlayerType.PLAYER_LILITH) then
		-- Lilith, -8% all stats if you don't currently have a baby familiar
		local hasBabyFamiliar = false
		for _, familiarType in ipairs(PST.babyFamiliarItems) do
			if player:HasCollectible(familiarType) then
				hasBabyFamiliar = true
				break
			end
		end
		if not cosmicRCache.lilithActive and not hasBabyFamiliar then
			PST:addModifiers({ allstatsPerc = -8 }, true)
			cosmicRCache.lilithActive = true
		elseif cosmicRCache.lilithActive and hasBabyFamiliar then
			PST:addModifiers({ allstatsPerc = 8 }, true)
			cosmicRCache.lilithActive = false
		end
	elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN) then
		-- The Forgotten, Keeper debuff: -4% all stats per active blue fly, up to -40%
		if player:GetPlayerType() == PlayerType.PLAYER_KEEPER or
		player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
			local debuffVal = math.max(-40, math.min(cosmicRCache.forgottenKeeperDebuff, player:GetNumBlueFlies() * -4))
			if cosmicRCache.forgottenKeeperDebuff ~= debuffVal then
				cosmicRCache.forgottenKeeperDebuff = debuffVal
				player:AddCacheFlags(PST.allstatsCache, true)
			end
		end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_ISAAC_B) then
        -- Tainted Isaac, -4% all stats per item obtained after the 8th one, up to -40%
		local tmpItemCount = math.max(0, player:GetCollectibleCount() - 8)
		if tmpItemCount ~= cosmicRCache.TIsaacItems then
        	cosmicRCache.TIsaacItems = tmpItemCount
			player:AddCacheFlags(PST.allstatsCache, true)
		end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_CAIN_B) then
		-- Tainted Cain, -2 luck if not holding Bag of Crafting
		if not cosmicRCache.TCainActive and not player:HasCollectible(CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING) then
			PST:addModifiers({ luck = -2 }, true)
			cosmicRCache.TCainActive = true
		elseif cosmicRCache.TCainActive and player:HasCollectible(CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING) then
			PST:addModifiers({ luck = 2 }, true)
			cosmicRCache.TCainActive = false
		end
	elseif PST:cosmicRCharPicked(PlayerType.PLAYER_JACOB_B) then
		-- Tainted Jacob, spawn Dark Esau if he's not around
		if room:GetAliveEnemiesCount() > 0 and not PST.specialNodes.TJacobEsauSpawned then
			local spawned = false
			for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
				if tmpEntity.Type == EntityType.ENTITY_DARK_ESAU then
					spawned = true
					break
				end
			end
			if not spawned then
				Game():Spawn(EntityType.ENTITY_DARK_ESAU, 0, room:GetCenterPos(), Vector.Zero, nil, 0, Random() + 1)
				PST.specialNodes.TJacobEsauSpawned = true
			end
		end
	end

	-- Bag of Crafting effects
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING) then
		-- Bag of Crafting pickup changes
		local craftBagChecksum = 0
		for _, tmpBagPickup in ipairs(player:GetBagOfCraftingContent()) do
			craftBagChecksum = craftBagChecksum + tmpBagPickup
		end
		if updateTrackers.craftBagPickups ~= craftBagChecksum then
			if craftBagChecksum > 0 then
				local newPickup = 0
				if not PST:getTreeSnapshotMod("craftingBagFull", false) then
					for i=0,6 do
						if player:GetBagOfCraftingSlot(i) ~= 0 and player:GetBagOfCraftingSlot(i + 1) == 0 then
							newPickup = player:GetBagOfCraftingSlot(i)
							break
						end
					end
				end
				if newPickup == 0 then
					newPickup = player:GetBagOfCraftingSlot(7)
				end
				-- New bag pickup
				if newPickup ~= 0 then
					-- Opportunist node (T. Cain's tree)
					if PST:getTreeSnapshotMod("opportunist", false) then
						if newPickup == BagOfCraftingPickup.BOC_RED_HEART and 100 * math.random() < 30 then
							player:AddHearts(1)
						elseif newPickup == BagOfCraftingPickup.BOC_SOUL_HEART and 100 * math.random() < 15 then
							player:AddSoulHearts(1)
						elseif newPickup == BagOfCraftingPickup.BOC_BLACK_HEART and 100 * math.random() < 15 then
							player:AddBlackHearts(1)
						elseif (newPickup == BagOfCraftingPickup.BOC_PENNY or newPickup == BagOfCraftingPickup.BOC_GOLD_PENNY or newPickup == BagOfCraftingPickup.BOC_LUCKY_PENNY)
						and 100 * math.random() < 15 then
							player:AddCoins(1)
						elseif newPickup == BagOfCraftingPickup.BOC_NICKEL and 100 * math.random() < 15 then
							player:AddCoins(5)
						elseif newPickup == BagOfCraftingPickup.BOC_DIME and 100 * math.random() < 15 then
							player:AddCoins(10)
						elseif newPickup == BagOfCraftingPickup.BOC_KEY and 100 * math.random() < 15 then
							player:AddKeys(1)
						elseif newPickup == BagOfCraftingPickup.BOC_GOLD_KEY and 100 * math.random() < 15 then
							player:AddGoldenKey()
						elseif newPickup == BagOfCraftingPickup.BOC_BOMB and 100 * math.random() < 15 then
							player:AddBombs(1)
						elseif newPickup == BagOfCraftingPickup.BOC_GOLD_BOMB and 100 * math.random() < 15 then
							player:AddGoldenBomb()
						elseif newPickup == BagOfCraftingPickup.BOC_GIGA_BOMB and 100 * math.random() < 15 then
							player:AddGigaBombs(1)
						elseif (newPickup == BagOfCraftingPickup.BOC_MINI_BATTERY or newPickup == BagOfCraftingPickup.BOC_BATTERY or newPickup == BagOfCraftingPickup.BOC_MEGA_BATTERY)
						and 100 * math.random() < 15 then
							for _, slot in pairs(ActiveSlot) do
								player:AddActiveCharge(2, slot, true, false, false)
							end
						elseif newPickup == BagOfCraftingPickup.BOC_RUNE then
							player:UseCard(Card.RUNE_SHARD, UseFlag.USE_NOANIM)
						elseif newPickup == BagOfCraftingPickup.BOC_CARD then
							PST:addModifiers({ luckPerc = 0.5 }, true)
						end
					end
				end
			end

			-- Magic Bag node (T. Cain's tree)
			if PST:getTreeSnapshotMod("magicBag", false) or PST:getTreeSnapshotMod("grandIngredientCoins", false) or
			PST:getTreeSnapshotMod("grandIngredientKeys", false) or PST:getTreeSnapshotMod("grandIngredientBombs", false) then
				PST:updateCacheDelayed()
			else
				-- Bag pickup stat boost mods
				if PST:getTreeSnapshotMod("bagBombDamage", 0) > 0 then
					PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
				end
				if PST:getTreeSnapshotMod("bagKeyTears", 0) > 0 then
					PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
				end
				if PST:getTreeSnapshotMod("bagCoinRangeLuck", 0) > 0 then
					PST:updateCacheDelayed(CacheFlag.CACHE_RANGE | CacheFlag.CACHE_LUCK)
				end
				if PST:getTreeSnapshotMod("bagHeartSpeed", 0) > 0 then
					PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
				end
			end
			updateTrackers.craftBagPickups = craftBagChecksum
			PST:save()
		end

		-- Set bag full status to detect crafting
		local bagStatus = player:GetBagOfCraftingSlot(7) ~= 0
		if bagStatus ~= PST:getTreeSnapshotMod("craftingBagFull", false) then
			-- Crafted item
			if PST:getTreeSnapshotMod("craftingBagFull", false) and #PST.specialNodes.craftBagSnapshot > 0 then
				-- Magic Bag node (T. Cain's tree)
				local spawnExtraPickups = 0
				if PST:getTreeSnapshotMod("magicBag", false) then
					spawnExtraPickups = 1
				end
				-- Mod: chance to spawn one of the consumed pickups when crafting an item
				if 100 * math.random() < PST:getTreeSnapshotMod("craftPickupRecovery", 0) then
					spawnExtraPickups = spawnExtraPickups + 1
				end
				if spawnExtraPickups > 0 then
					for _=1,spawnExtraPickups do
						local craftBagPickup = PST.specialNodes.craftBagSnapshot[math.random(8)]
						if craftBagPickup and PST.craftBagPickups[craftBagPickup] then
							local tmpNewPickup = PST.craftBagPickups[craftBagPickup]
							Game():Spawn(EntityType.ENTITY_PICKUP, tmpNewPickup[1], player.Position, RandomVector() * 3, nil, tmpNewPickup[2], Random() + 1)
						end
					end
				end

				-- Grand Ingredient nodes (T. Cain's tree)
				if PST:grandIngredientNodes(true) <= 2 then
					-- Grand Ingredient: Coins node (T. Cain's tree)
					if PST:getTreeSnapshotMod("grandIngredientCoins", false) then
						if PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_NICKEL then
							player:AddCoins(5)
						elseif PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_DIME then
							player:AddCoins(10)
						end
					end

					-- Grand Ingredient: Bombs node (T. Cain's tree)
					if PST:getTreeSnapshotMod("grandIngredientBombs", false) then
						if PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_GOLD_BOMB then
							PST:addModifiers({ damagePerc = 10 }, true)
						end
					end

					-- Grand Ingredient: Keys node (T. Cain's tree)
					if PST:getTreeSnapshotMod("grandIngredientKeys", false) then
						if PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_GOLD_KEY then
							player:AddKeys(4)
							player:UseActiveItem(CollectibleType.COLLECTIBLE_DADS_KEY, UseFlag.USE_NOANIM)
						elseif PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_CHARGED_KEY then
							for _, slot in ipairs(ActiveSlot) do
								player:AddActiveCharge(1, slot, true, false, false)
							end
						end
					end

					-- Grand Ingredient: Hearts node (T. Cain's tree)
					if PST:getTreeSnapshotMod("grandIngredientHearts", false) then
						if PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_RED_HEART then
							player:AddHearts(2)
						elseif PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_SOUL_HEART then
							player:AddSoulHearts(2)
						elseif PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_BLACK_HEART then
							player:AddBlackHearts(2)
						elseif PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_ETERNAL_HEART then
							player:SetFullHearts()
						elseif PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_GOLD_HEART then
							player:AddCoins(7)
						elseif PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_BONE_HEART then
							player:AddBoneHearts(1)
						elseif PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_ROTTEN_HEART then
							local tmpMax = 1 + math.random(3)
							for _=1,tmpMax do
								Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_SPIDER, player.Position, Vector.Zero, nil, 0, Random() + 1)
							end
							tmpMax = 1 + math.random(3)
							for _=1,tmpMax do
								Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, player.Position, Vector.Zero, nil, 0, Random() + 1)
							end
						end
					end
				end

				-- Mod: +luck when crafting an item
				tmpMod = PST:getTreeSnapshotMod("itemCraftingLuck", 0)
				if tmpMod > 0 then
					PST:addModifiers({ luck = tmpMod }, true)
				end

				-- Cosmic Realignment node - Tainted Cain
				if PST:cosmicRCharPicked(PlayerType.PLAYER_CAIN_B) then
					if PST:getTreeSnapshotMod("craftingBagFull", false) then
						cosmicRCache.TCainUses = cosmicRCache.TCainUses + 1
						PST:save()
					end
				end
			end
			PST:addModifiers({ craftingBagFull = bagStatus }, true)
		end
	end

	-- Stealth Tactics node (T. Judas' tree)
	if PST:getTreeSnapshotMod("stealthTactics", false) then
		local tmpDarkArts = player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_DARK_ARTS)
		if tmpDarkArts ~= hasDarkArtsEffect then
			player:AddCacheFlags(CacheFlag.CACHE_SPEED, true)
			hasDarkArtsEffect = tmpDarkArts
		end
	end

	-- Mod: dark pulse when landing with How to Jump
	if PST.specialNodes.howToJumpPulseTimer > 0 then
		PST.specialNodes.howToJumpPulseTimer = PST.specialNodes.howToJumpPulseTimer - 1
		if PST.specialNodes.howToJumpPulseTimer == 0 then
			local pulseEffect = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, player.Position, Vector.Zero, nil, 0, Random() + 1)
			pulseEffect:GetSprite().Scale = Vector(2, 2)
			pulseEffect.Color = Color(0.38, 0.1, 0.5, 1)
			SFXManager():Play(SoundEffect.SOUND_EXPLOSION_WEAK, 1, 2, false, 1.3)

			for _, tmpEntity in ipairs(Isaac.FindInRadius(player.Position, 80)) do
				local tmpNPC = tmpEntity:ToNPC()
				if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() then
					tmpNPC:TakeDamage(player.Damage * 1.5, 0, EntityRef(tmpNPC), 0)
				end
			end
		end
	end

	-- Mod: +% tears when using Dark Arts for 3 seconds
	if PST.specialNodes.darkArtsTearsTimer > 0 then
		PST.specialNodes.darkArtsTearsTimer = PST.specialNodes.darkArtsTearsTimer - 1
		if PST.specialNodes.darkArtsTearsTimer == 0 then
			player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
		end
	end

	-- Berserk update
	local isBerserk = PST:isBerserk()
	if updateTrackers.isBerserk ~= nil and updateTrackers.isBerserk ~= isBerserk then
		local berserkEffect = player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK)
		if berserkEffect then
			local berserkMaxCharge = PST:getBerserkMaxCharge()
			if berserkMaxCharge > 150 then
				berserkEffect.Item.MaxCooldown = berserkMaxCharge
			end

			if PST:getTreeSnapshotMod("absoluteRage", false) then
				PST:addModifiers({ absoluteRageCharge = { value = PST:getBerserkMaxCharge(), set = true } }, true)
			elseif berserkEffect then
				berserkEffect.Cooldown = PST:getBerserkMaxCharge()
			end

			-- Mod: % character size while berserk
			tmpMod = PST:getTreeSnapshotMod("berserkSize", 0)
			if tmpMod ~= 0 then
				player:AddCacheFlags(CacheFlag.CACHE_SIZE, true)
			end
		end

		PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY)
		updateTrackers.isBerserk = isBerserk
	end

	-- Violent Marauder node (T. Samson's tree)
	if PST:getTreeSnapshotMod("violentMarauder", false) then
		local tmpSlot = player:GetActiveItemSlot(CollectibleType.COLLECTIBLE_SUPLEX)
		if tmpSlot ~= -1 and not PST:isBerserk() then
			player:SetActiveCharge(0, tmpSlot)
		end
	end

	-- Absolute Rage node (T. Samson's tree)
    if PST:getTreeSnapshotMod("absoluteRage", false) then
		local berserkEffect = player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK)
		if berserkEffect then
			player.SamsonBerserkCharge = 0
			local rageCharge = PST:getTreeSnapshotMod("absoluteRageCharge", 0)
			if rageCharge > 0 then
				berserkEffect.Cooldown = rageCharge
			else
				player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK)
			end
		elseif room:GetFrameCount() % 30 == 0 then
			player.SamsonBerserkCharge = math.min(100000, player.SamsonBerserkCharge + 5000)
			if player.SamsonBerserkCharge >= 100000 then
				player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK)
				SFXManager():Play(SoundEffect.SOUND_BERSERK_START)
			end
			PST:updateCacheDelayed(CacheFlag.CACHE_COLOR)
		end
	end
	if PST.specialNodes.berserkHitCooldown > 0 then
		PST.specialNodes.berserkHitCooldown = PST.specialNodes.berserkHitCooldown - 1
	end

	-- Gilded Regrowth node (T. Azazel's tree)
	if PST:getTreeSnapshotMod("gildedRegrowth", false) then
		if not player:IsFlying() and not PST:getTreeSnapshotMod("gildedRegrowthDebuff", false) then
			PST:addModifiers({ speed = -0.2, gildedRegrowthDebuff = true }, true)
		elseif player:IsFlying() and PST:getTreeSnapshotMod("gildedRegrowthDebuff", false) then
			PST:addModifiers({ speed = 0.2, gildedRegrowthDebuff = false }, true)
		end
	end

	-- Hemoptysis fired countdown
	if PST.specialNodes.hemoptysisFired > 0 then
		PST.specialNodes.hemoptysisFired = PST.specialNodes.hemoptysisFired - 1
	end

	-- Hemoptysis speed buff timer
	if PST.specialNodes.hemoptysisSpeedTimer > 0 then
		PST.specialNodes.hemoptysisSpeedTimer = PST.specialNodes.hemoptysisSpeedTimer - 1
		if PST.specialNodes.hemoptysisSpeedTimer == 0 then
			PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
		end
	end

	-- Mod: +% damage while you have brimstone
	tmpMod = PST:getTreeSnapshotMod("brimstoneDmg", 0)
	if tmpMod > 0 then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) and not PST:getTreeSnapshotMod("brimstoneDmgApplied", false) then
			PST:addModifiers({ damagePerc = tmpMod, brimstoneDmgApplied = true }, true)
		elseif not player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) and PST:getTreeSnapshotMod("brimstoneDmgApplied", false) then
			PST:addModifiers({ damagePerc = -tmpMod, brimstoneDmgApplied = false }, true)
		end
	end

	-- Room clear update check
	PST:onRoomClear(level, room)

	-- Delayed cache update
	if PST.delayedCacheUpdate > 0 and Game():GetFrameCount() > PST.delayedCacheUpdate + 1 then
		PST.delayedCacheUpdate = 0
		player:AddCacheFlags(PST.delayedCacheFlags, true)
		PST.delayedCacheFlags = 0
	end
end