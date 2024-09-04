local sfx = SFXManager()

local inDeathCertificate = false

-- On update
local clearRoomProc = false
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

		-- First update - After first floor
		if not PST:isFirstOrigStage() then
			-- Ancient starcursed jewel: Challenger Starpiece
			if PST:SC_getSnapshotMod("challengerStarpiece", false) then
				local tmpRoomIdx = level:QueryRoomTypeIndex(RoomType.ROOM_CHALLENGE, false, RNG())
				local challRoom = level:GetRoomByIdx(tmpRoomIdx)
				if challRoom and challRoom.Data.Type == RoomType.ROOM_CHALLENGE then
					PST:addModifiers({ SC_levelHasChall = true }, true)
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
		if PST:SC_getSnapshotMod("saturnianLuminite") then
			player:SetCanShoot(false)
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
				not tmpNPC.Parent and not tmpNPC.Child then
					---@diagnostic disable-next-line: undefined-field
					tmpNPC:TrySplit(0, EntityRef(player))
				end
			end
		end

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

	-- Starcursed mod: monster status cleanse every X seconds
	local tmpMod = PST:SC_getSnapshotMod("statusCleanse", 0)
	if tmpMod > 0 and room:GetFrameCount() % (tmpMod * 30) == 0 then
		for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and not EntityRef(tmpNPC).IsFriendly and not tmpNPC:HasEntityFlags(EntityFlag.FLAG_ICE_FROZEN) then
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
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and not tmpNPC:IsBoss() and not tmpNPC:HasFullHealth() and not tmpNPC.Type == EntityType.ENTITY_GIDEON then
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
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsBoss() and not tmpNPC:HasFullHealth() and not tmpNPC.Type == EntityType.ENTITY_GIDEON then
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
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and not tmpNPC:IsChampion() and not tmpNPC.Type == EntityType.ENTITY_GIDEON then
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
	if PST:SC_getSnapshotMod("martianUltimatum", false) and room:GetFrameCount() > 1 then
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
	end

	-- Ancient starcursed jewel: Primordial Kaleidoscope
	if PST:SC_getSnapshotMod("primordialKaleidoscope", false) then
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE)
		end
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_FRUIT_CAKE) then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_FRUIT_CAKE)
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

	-- Cosmic Realignment node
	local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.treeMods.cosmicRCache)
	local isKeeper = player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B
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

		-- Set bag full status to detect crafting
		cosmicRCache.TCainBag = player:GetBagOfCraftingSlot(7) ~= 0
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

	-- On room clear
	if room:GetAliveEnemiesCount() == 0 and (not clearRoomProc or PST.modData.xpObtained > 0) then
		PST.modData.spawnKills = 0

		local jewelDrop = false
		-- Challenge rooms
		if room:GetType() == RoomType.ROOM_CHALLENGE then
			-- Final round clear
			if Ambush.GetCurrentWave() >= Ambush.GetMaxChallengeWaves() or (level:HasBossChallenge() and Ambush.GetCurrentWave() == 2) then
				-- Challenge room XP reward
				local challengeXP = PST:getTreeSnapshotMod("challengeXP", 0)
				local bossChallengeXP = PST:getTreeSnapshotMod("bossChallengeXP", false)
				if challengeXP > 0 and (not level:HasBossChallenge() or (level:HasBossChallenge() and bossChallengeXP)) then
					PST:addTempXP(challengeXP, true)
				end

				if not PST:getTreeSnapshotMod("SC_challClear", false) then
					-- Starcursed jewel drop
					if 100 * math.random() < PST.SCDropRates.challenge(level:GetStage()).regular then
						local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20)
						PST:SC_dropRandomJewelAt(tmpPos, PST.SCDropRates.challenge(level:GetStage()).ancient)
						jewelDrop = true
					end

					-- Ancient starcursed jewel: Challenger's Starpiece
					if PST:SC_getSnapshotMod("challengerStarpiece", false) then
						local tmpVariant = 0
						if level:GetStage() >= 7 then
							tmpVariant = 1
						end
						Game():Spawn(
							PST.deadlySinBosses[math.random(#PST.deadlySinBosses)],
							tmpVariant, room:GetCenterPos(), Vector.Zero, nil, 0, Random() + 1
						)
					end
					PST:addModifiers({ SC_challClear = true }, true)
				end
			end
		-- Boss rooms
		elseif room:GetType() == RoomType.ROOM_BOSS then
			-- Thievery node Greed proc (Cain's tree)
			-- Mod: chance for Greed to spawn after defeating the first floor's boss
			if not PST.specialNodes.bossGreedSpawned and (PST:getTreeSnapshotMod("thieveryGreedProc", false) or
			(level:GetStage() == LevelStage.STAGE1_1 and 100 * math.random() < PST:getTreeSnapshotMod("firstBossGreed", 0))) then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpPos, Vector.Zero, nil, 0, 0)
				Game():Spawn(EntityType.ENTITY_GREED, 0, tmpPos, Vector.Zero, nil, 0, Random() + 1)
				SFXManager():Play(SoundEffect.SOUND_SUMMONSOUND)
				PST.specialNodes.bossGreedSpawned = true
			end

			-- Ancient starcursed jewel: Nullstone
			if PST:SC_getSnapshotMod("nullstone", false) then
				PST:addModifiers({ SC_nullstoneClear = true }, true)
			end
		-- Boss rush
		elseif room:GetType() == RoomType.ROOM_BOSSRUSH then
			-- Boss rush clear
			if Ambush.GetCurrentWave() == Ambush.GetMaxBossrushWaves() then
				-- Starcursed jewel drop
				if not PST:getTreeSnapshotMod("SC_bossrushJewel", false) and 100 * math.random() < PST.SCDropRates.bossrush().regular then
					local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20)
					PST:SC_dropRandomJewelAt(tmpPos, PST.SCDropRates.bossrush().ancient)
					PST:addModifiers({ SC_bossrushJewel = true }, true)
					jewelDrop = true
				end
			end
		end

		-- Once-per-clear effects
		if not PST:getTreeSnapshotMod("roomClearProc", false) and PST.modData.xpObtained > 0 then
			PST:addModifiers({ roomClearProc = true }, true)
			local isBossRoom = room:GetType() == RoomType.ROOM_BOSS

			-- Boss room
			if isBossRoom then
				-- Respec chance
				local respecChance = PST:getTreeSnapshotMod("respecChance", 15)
				if not PST:getTreeSnapshotMod("relearning", false) then
					local tmpRespecs = 0
					while (respecChance > 0) do
						if 100 * math.random() < respecChance then
							tmpRespecs = tmpRespecs + 1
						end
						respecChance = respecChance - 100
					end
					if tmpRespecs > 0 then
						PST:createFloatTextFX("+" .. tmpRespecs .. " Respec(s)", Vector.Zero, Color(1, 1, 1, 1), 0.12, 90, true)
						sfx:Play(SoundEffect.SOUND_THUMBSUP)
						PST.modData.respecPoints = PST.modData.respecPoints + tmpRespecs
					end
				else
					-- Relearning node, count as completed floor
					PST:addModifiers({ relearningFloors = 1 }, true)
				end

				-- Ancient starcursed jewel: Luminescent Die
				if PST:SC_getSnapshotMod("luminescentDie", false) then
					local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20)
					Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.CARD_REVERSE_WHEEL_OF_FORTUNE, Random() + 1)
				end

				-- Ancient starcursed jewel: Sanguinis
				if PST:SC_getSnapshotMod("sanguinis", false) and not PST:getTreeSnapshotMod("SC_sanguinisTookDmg", false) then
					PST:createFloatTextFX("-- Sanguinis --", Vector.Zero, Color(0.1, 0.85, 0.1, 1), 0.12, 100, true)
					player:AddBrokenHearts(-1)
				end

				-- Ancient starcursed jewel: Twisted Emperor's Heirloom
				if PST:SC_getSnapshotMod("twistedEmperorHeirloom", false) then
					if PST:getTreeSnapshotMod("SC_empHeirloomRoomID", -1) == level:GetCurrentRoomDesc().SafeGridIndex then
						PST:addModifiers({ SC_empHeirloomProc = true }, true)
					end
				end

				-- Starcursed jewel drop
				if 100 * math.random() < PST.SCDropRates.boss(level:GetStage()).regular then
					local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20)
					PST:SC_dropRandomJewelAt(tmpPos, PST.SCDropRates.boss(level:GetStage()).ancient)
				end

				-- Boss room + took no damage
				if not PST:getTreeMod("roomGotHitByMob", false) then
					-- Mod: +luck when clearing boss room without taking damage
					tmpMod = PST:getTreeSnapshotMod("flawlessBossLuck", 0)
					if tmpMod > 0 then
						PST:addModifiers({ luck = tmpMod }, true)
					end
				end
			end

			-- Starcursed jewel drop
			if not jewelDrop and not PST:isFirstOrigStage() then
				tmpMod = PST:getTreeSnapshotMod("SC_jewelDropOnClear", 0)
				if 100 * math.random() < tmpMod then
					local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20)
					PST:SC_dropRandomJewelAt(tmpPos, 1)
					PST:addModifiers({ SC_jewelDropOnClear = { value = 0, set = true } }, true)
					jewelDrop = true
				elseif 100 * math.random() < 25 and tmpMod < 20 then
					PST:addModifiers({ SC_jewelDropOnClear = 0.5 }, true)
				end
			end

			-- Starcursed mod: chance to spawn an additional troll bomb at the center of the room on clear
			local tmpChance = PST:getTreeSnapshotMod("trollBombOnClear", 0)
			if tmpChance > 0 and 100 * math.random() < tmpChance then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 20)
				Game():Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_TROLL, tmpPos, Vector.Zero, nil, BombSubType.BOMB_TROLL, Random() + 1)
			end

			-- Ancient starcursed jewel: Umbra
			if PST:SC_getSnapshotMod("umbra", false) then
				if not PST:getTreeSnapshotMod("SC_umbraNightLightSpawn", false) and 100 * math.random() < 16 then
					local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
					Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_NIGHT_LIGHT, Random() + 1)
					PST:addModifiers({ SC_umbraNightLightSpawn = true }, true)
				end
			end

			-- Ancient starcursed jewel: Crimson Warpstone
			if PST:SC_getSnapshotMod("crimsonWarpstone", false) then
				tmpChance = PST:getTreeSnapshotMod("SC_crimsonWarpKeyDrop", 0)
				if tmpChance > 0 and 100 * math.random() < tmpChance then
					local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
					Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.CARD_CRACKED_KEY, Random() + 1)
				end
			end

			-- Ancient starcursed jewel: Cursed Auric Shard
			if PST:SC_getSnapshotMod("cursedAuricShard", false) then
				local roomType = room:GetType()
				if roomType == RoomType.ROOM_BOSS then
					PST:addModifiers({ SC_cursedAuricSpeedProc = true }, true)
				elseif 100 * math.random() < 90 then
					if roomType ~= RoomType.ROOM_BOSS and roomType ~= RoomType.ROOM_BOSSRUSH and roomType ~= RoomType.ROOM_ANGEL and roomType ~= RoomType.ROOM_DEVIL and
					roomType ~= RoomType.ROOM_CURSE and roomType ~= RoomType.ROOM_CHALLENGE then
						PST:addModifiers({ SC_cursedAuricTimer = { value = Game():GetFrameCount(), set = true } }, true)
					end
				end
			end

			-- Mod: chance to heal 1/2 red heart when clearing a room
			tmpChance = PST:getTreeSnapshotMod("healOnClear", 0)
			if isBossRoom then
				tmpChance = tmpChance * 2
			end
			if tmpChance > 0 and 100 * math.random() < tmpChance then
				player:AddHearts(1)
				if isBossRoom then
					player:AddHearts(1)
				end
			end

			-- Mod: chance to spawn an additional nickel when clearing a room
			tmpChance = PST:getTreeSnapshotMod("nickelOnClear", 0)
			if isBossRoom then
				tmpChance = tmpChance * 2
			end
			if tmpChance > 0 and 100 * math.random() < tmpChance then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, tmpPos, Vector.Zero, nil, CoinSubType.COIN_NICKEL, Random() + 1)
			end

			-- Heartless node (Eve's tree)
			if PST:getTreeSnapshotMod("heartless", false) then
				-- +0.5% all stats on room clear, up to 10%
				tmpTotal = PST:getTreeSnapshotMod("heartlessTotal", 0)
				if tmpTotal < 10 then
					local tmpAdd = math.min(0.5, 10 - tmpTotal)
					if tmpAdd > 0 then
						PST:addModifiers({ allstatsPerc = tmpAdd, heartlessTotal = tmpAdd }, true)
					end
				end
			end

			-- Mod: +luck when clearing a room below full red hearts
			local tmpLuck = PST:getTreeSnapshotMod("luckOnClearBelowFull", 0)
			if tmpLuck > 0 and player:GetHearts() < player:GetEffectiveMaxHearts() then
				PST:addModifiers({ luck = tmpLuck, luckOnClearBelowFullBuff = tmpLuck }, true)
			end

			-- Mod: +luck if you clear the boss room within 40 seconds
			tmpLuck = PST:getTreeSnapshotMod("bossQuickKillLuck", 0)
			if isBossRoom and tmpLuck > 0 and room:GetFrameCount() <= 1200 then
				PST:addModifiers({ luck = tmpLuck }, true)
			end

			-- Mod: +luck if you clear the boss room without getting hit more than 2 times
			tmpLuck = PST:getTreeSnapshotMod("bossFlawlessLuck", 0)
			if isBossRoom and tmpLuck > 0 and PST.specialNodes.bossRoomHitsFrom <= 2 then
				PST:addModifiers({ luck = tmpLuck }, true)
			end

			-- A True Ending? node (Lazarus' tree)
			if isBossRoom and PST:getTreeSnapshotMod("aTrueEnding", false) and
			(level:GetStage() == LevelStage.STAGE1_1 or level:GetStage() == LevelStage.STAGE3_2 or level:GetStage() == LevelStage.STAGE4_2) then
				-- Drop Suicide King card when defeating first boss, mom, or mom's heart
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.CARD_SUICIDE_KING, Random() + 1)
			end

			-- Mod: chance to spawn 1/2 red heard as Lazarus, or 1/2 soul heart as Lazarus Risen
			tmpMod = PST:getTreeSnapshotMod("lazarusClearHearts", 0)
			if tmpMod > 0 and 100 * math.random() < tmpMod then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				if player:GetPlayerType() == PlayerType.PLAYER_LAZARUS then
					Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, tmpPos, Vector.Zero, nil, HeartSubType.HEART_HALF, Random() + 1)
				elseif player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2 then
					Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, tmpPos, Vector.Zero, nil, HeartSubType.HEART_HALF_SOUL, Random() + 1)
				end
			end

			-- Starblessed node (Eden's tree)
			if PST:getTreeSnapshotMod("starblessed", false) then
				if isBossRoom and level:GetStage() == LevelStage.STAGE1_1 then
					local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
					Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.CARD_STARS, Random() + 1)
				end
			end

			-- Mod: chance to spawn a soulheart on room clear
			tmpMod = PST:getTreeSnapshotMod("soulHeartOnClear", 0)
			if tmpMod > 0 and 100 * math.random() < tmpMod then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, tmpPos, Vector.Zero, nil, HeartSubType.HEART_SOUL, Random() + 1)
			end

			-- Null node (Apollyon's tree)
			-- Mod: chance to gain an additional active item charge when clearing a room
			if (PST:getTreeSnapshotMod("null", false) and PST:getTreeSnapshotMod("nullActiveAbsorbed", false) and 100 * math.random() < 50)
			or (100 * math.random() < PST:getTreeSnapshotMod("chargeOnClear", 0)) then
				if player:GetBatteryCharge(0) == 0 then
					player:AddActiveCharge(1, 0, true, false, false)
				end
			end

			-- Mod: chance to gain a soul charge when clearing a room
			tmpMod = PST:getTreeSnapshotMod("soulChargeOnClear", 0)
			if tmpMod > 0 and 100 * math.random() < tmpMod then
				player:AddSoulCharge(1)
			end

			-- Song of Darkness node (Siren's tree)
			tmpMod = PST:getTreeSnapshotMod("songOfDarknessChance", 2)
			if PST:getTreeSnapshotMod("songOfDarkness", false) and tmpMod > 0 and 100 * math.random() < tmpMod then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, tmpPos, Vector.Zero, nil, HeartSubType.HEART_BLACK, Random() + 1)
			end

			-- Song of Awe node (Siren's tree) [Harmonic modifier]
			if PST:getTreeSnapshotMod("songOfAwe", false) then
				local tmpSlot = player:GetActiveItemSlot(Isaac.GetItemIdByName("Siren Song"))
				if tmpSlot ~= -1 and player:GetActiveCharge(tmpSlot) < player:GetActiveMaxCharge(tmpSlot) then
					SFXManager():Play(SoundEffect.SOUND_BEEP, 0.7)
					player:AddActiveCharge(1, tmpSlot, true, false, false)
				end
			end

			-- Mod: +% coalescing soul trigger chance when clearing a room without taking damage
			tmpMod = PST:getTreeSnapshotMod("coalSoulRoomClearChance", 0)
			if tmpMod > 0 and not PST:getTreeSnapshotMod("roomGotHitByMob", false) then
				PST:addModifiers({ coalescingSoulChance = tmpMod }, true)
			end

			-- Fractured Die node (T. Isaac's tree)
			if PST:getTreeSnapshotMod("fracturedRemains", false) and not PST:getTreeSnapshotMod("roomGotHitByMob", false) then
				-- Dice shard drop
				tmpChance = 3
				if room:GetType() == RoomType.ROOM_BOSS then
					tmpChance = 75
				end
				if 100 * math.random() < tmpChance then
					local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20)
					Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.CARD_DICE_SHARD, Random() + 1)
				end
				-- Rune shard drop
				if room:GetType() ~= RoomType.ROOM_BOSS then
					tmpChance = 7
					if 100 * math.random() < tmpChance then
						local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20)
						Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.RUNE_SHARD, Random() + 1)
					end
				else
					for _=1,2 do
						local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20)
						Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.RUNE_SHARD, Random() + 1)
					end
				end
			end

			-- Mod: +luck when clearing a boss room without taking damage
			tmpMod = PST:getTreeSnapshotMod("bossFlawlessLuck", 0)
			if tmpMod > 0 and room:GetType() == RoomType.ROOM_BOSS and not PST:getTreeSnapshotMod("roomGotHitByMob", false) then
				PST:addModifiers({ luck = tmpMod }, true)
			end

			-- Test of Temperance node (T. Magdalene's tree)
			if PST.specialNodes.testOfTemperanceCD > 0 then
				PST.specialNodes.testOfTemperanceCD = PST.specialNodes.testOfTemperanceCD - 1
			end

			-- Cosmic Realignment node
			if PST:cosmicRCharPicked(PlayerType.PLAYER_SAMSON_B) then
				-- Tainted Samson, take up to 1 heart damage if final buff was negative, then reset
				local totalHP = player:GetHearts() + player:GetSoulHearts() + player:GetRottenHearts() + player:GetBrokenHearts() + player:GetBoneHearts()
				if cosmicRCache.TSamsonBuffer < 0 and totalHP - 1 > 0 then
					player:TakeDamage(math.min(2, totalHP - 1), 0, EntityRef(player), 0)
				end
				cosmicRCache.TSamsonBuffer = 0
				player:AddCacheFlags(PST.allstatsCache, true)
			elseif PST:cosmicRCharPicked(PlayerType.PLAYER_LAZARUS_B) then
				-- Tainted Lazarus, switch health banks
				if not isKeeper and PST.modData.xpObtained > 0 then
					local newBank = nil
					if cosmicRCache.TLazarusBank1.active then
						newBank = cosmicRCache.TLazarusBank2
						cosmicRCache.TLazarusBank1.active = false
					else
						newBank = cosmicRCache.TLazarusBank1
						cosmicRCache.TLazarusBank1.active = true
					end
					player:AddMaxHearts(-player:GetMaxHearts() + newBank.max)
					player:AddSoulHearts(-player:GetSoulHearts() + newBank.soul)
					---@diagnostic disable-next-line: undefined-field
					player:SetBlackHeart(newBank.black)
					player:AddRottenHearts(-player:GetRottenHearts() + newBank.rotten)
					player:AddBoneHearts(-player:GetBoneHearts() + newBank.bone)
					player:AddBrokenHearts(-player:GetBrokenHearts() + newBank.broken)
					player:AddHearts(-player:GetHearts() + newBank.red)
					player:AddEternalHearts(-player:GetEternalHearts() + newBank.eternal)
				end
			end
		end

		-- Starcursed modifier: static hovering tears when killing mobs (unfreeze)
		if #PST.specialNodes.SC_hoveringTears > 0 then
			for _, tmpTear in ipairs(PST.specialNodes.SC_hoveringTears) do
				if tmpTear then
					tmpTear:SetPauseTime(0)
				end
			end
		end

		-- Cosmic Realignment node
		if PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN) then
			-- The Forgotten, reset Keeper debuff
			if isKeeper then
				local debuffVal = math.max(-40, math.min(0, player:GetNumBlueFlies() * -4))
				if cosmicRCache.forgottenKeeperDebuff ~= debuffVal then
					cosmicRCache.forgottenKeeperDebuff = debuffVal
					player:AddCacheFlags(PST.allstatsCache, true)
				end
			end
		end

		-- Convert temp xp to normal xp
		if PST.modData.xpObtained > 0 then
			PST:addXP(PST.modData.xpObtained, false)
			PST.modData.xpObtained = 0
		end

		-- Save data
		PST:save()
		clearRoomProc = true
	elseif room:GetAliveEnemiesCount() > 0 then
		clearRoomProc = false
	end

	-- Delayed cache update
	if PST.delayedCacheUpdate > 0 and Game():GetFrameCount() > PST.delayedCacheUpdate + 1 then
		PST.delayedCacheUpdate = 0
		player:AddCacheFlags(PST.delayedCacheFlags, true)
		PST.delayedCacheFlags = 0
	end
end