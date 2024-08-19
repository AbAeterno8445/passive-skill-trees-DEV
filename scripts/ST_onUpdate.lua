local sfx = SFXManager()

local blackHeartTracker = 0
local soulHeartTracker = 0
local boneHeartTracker = 0
local playerTypeTracker = 0
local jacobHeartDiffTracker = 0
local luckTracker = 0
local familiarsTracker = 0
local coinTracker = 0
local holyMantleTracker = false
local lvlCurseTracker = -1

-- On update
local clearRoomProc = false
function PST:onUpdate()
	local room = Game():GetRoom()
	local player = Isaac.GetPlayer()

	-- First heart-related functions update
	if not PST.modData.firstHeartUpdate then
		PST:onAddHearts(player, 0, 0)
		PST.modData.firstHeartUpdate = true
	end

	-- First update when entering floor
	if PST.floorFirstUpdate then
		PST.floorFirstUpdate = false
		blackHeartTracker = 0
		soulHeartTracker = 0
		boneHeartTracker = 0
		jacobHeartDiffTracker = 0
		luckTracker = 0
		familiarsTracker = 0
		PST.specialNodes.jacobHeartLuckVal = 0
		lvlCurseTracker = -1

		local level = Game():GetLevel()
		-- Mod: chance to reveal the arcade room's location if it is present
		if 100 * math.random() < PST:getTreeSnapshotMod("arcadeReveal", 0) then
			local arcadeIdx = level:QueryRoomTypeIndex(RoomType.ROOM_ARCADE, false, RNG())
			local arcadeRoom = level:GetRoomByIdx(arcadeIdx)
			if arcadeRoom then
				arcadeRoom.DisplayFlags = 1 << 2
				level:UpdateVisibility()
			end
		end

		-- Mod: chance to reveal the shop room's location if it is present
		if 100 * math.random() < PST:getTreeSnapshotMod("shopReveal", 0) then
			local shopIdx = level:QueryRoomTypeIndex(RoomType.ROOM_SHOP, false, RNG())
			local shopRoom = level:GetRoomByIdx(shopIdx)
			if shopRoom then
				shopRoom.DisplayFlags = 1 << 2
				level:UpdateVisibility()
			end
		end

		-- Demonic Souvenirs node (Azazel's tree)
		if PST:getTreeSnapshotMod("demonicSouvenirs", false) then
			-- Spawn The Empress card every other floor, and spawn a random unlocked evil trinket on the second floor you enter
			if not PST:getTreeSnapshotMod("demonicSouvenirsProc", false) then
				local tmpPos = Isaac.GetFreeNearPosition(Game():GetRoom():GetCenterPos(), 40)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.CARD_EMPRESS, Random() + 1)
				PST:addModifiers({ demonicSouvenirsProc = true }, true)
			else
				PST:addModifiers({ demonicSouvenirsProc = false }, true)
			end
		end

		-- Gulp! node (Keeper's tree)
		if PST:getTreeSnapshotMod("gulp") and level:GetStage() % 2 ~= 0 then
			local tmpPos = Isaac.GetFreeNearPosition(Game():GetRoom():GetCenterPos(), 40)
       		Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpPos, Vector.Zero, nil, TrinketType.TRINKET_SWALLOWED_PENNY, Random() + 1)
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

			-- Mod: chance to reveal map
			if PST:getTreeSnapshotMod("mapRevealed", false) then
				level:ShowMap()
				PST:createFloatTextFX("Map revealed!", Vector.Zero, Color(1, 1, 1, 1), 0.12, 70, true)
			end

			-- Mod: chance to spawn a Blood Donation Machine at the start of a floor
			if 100 * math.random() < PST:getTreeSnapshotMod("bloodMachineSpawn", 0) then
				local tmpPos = room:GetCenterPos()
				tmpPos.Y = tmpPos.Y - 40
				Game():Spawn(EntityType.ENTITY_SLOT, SlotVariant.BLOOD_DONATION_MACHINE, tmpPos, Vector.Zero, nil, 0, Random() + 1)
				Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpPos, Vector.Zero, nil, 0, 0)
				SFXManager():Play(SoundEffect.SOUND_SUMMONSOUND, 0.7)
			end

			-- Mod: chance to spawn a random trinket at the start of a floor
			if 100 * math.random() < PST:getTreeSnapshotMod("trinketSpawn", 0) then
				local tmpPos = Isaac.GetFreeNearPosition(Game():GetRoom():GetCenterPos(), 40)
       			Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpPos, Vector.Zero, nil, Game():GetItemPool():GetTrinket(), Random() + 1)
			end

			-- Demonic Souvenirs node (Azazel's tree)
			if PST:getTreeSnapshotMod("demonicSouvenirs", false) and not PST:getTreeSnapshotMod("demonicSouvenirsTrinket", false) then
				-- Spawn random evil trinket on the second floor you enter
				local tmpPos = Isaac.GetFreeNearPosition(Game():GetRoom():GetCenterPos(), 40)
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
			if 100 * math.random() < PST:getTreeSnapshotMod("edenBlessingSpawn", 0) and not PST:getTreeSnapshotMod("edenBlessingSpawned", false) then
				local tmpPos = Isaac.GetFreeNearPosition(Game():GetRoom():GetCenterPos(), 40)
				Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpPos, Vector.Zero, nil, 0, 0)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_EDENS_BLESSING, Random() + 1)
				PST:addModifiers({ edenBlessingSpawned = true }, true)
			end

			-- Harbinger Locusts node (Apollyon's tree)
			if PST:getTreeSnapshotMod("harbingerLocusts", false) and not PST:isFirstOrigStage() and not PST:getTreeSnapshotMod("harbingerLocustsFloorProc", false) then
				local tmpPos = Isaac.GetFreeNearPosition(Game():GetRoom():GetCenterPos(), 40)
				local tmpLocust = PST.locustTrinkets[math.random(#PST.locustTrinkets)]
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpPos, Vector.Zero, nil, tmpLocust, Random() + 1)
				PST:addModifiers({ harbingerLocustsFloorProc = true }, true)
			end
		end
	end

	-- First update per room
	if room:GetFrameCount() == 1 then
		-- Update familiars
		local tmpFamiliars = PST:getRoomFamiliars()
		if tmpFamiliars ~= PST:getTreeSnapshotMod("totalFamiliars", 0) then
			PST:addModifiers({ totalFamiliars = { value = tmpFamiliars, set = true } }, true)
		end
	end

	-- Starcursed mod: monster status cleanse every X seconds
	local tmpMod = PST:SC_getSnapshotMod("statusCleanse", 0)
	if tmpMod > 0 and room:GetFrameCount() % (tmpMod * 30) == 0 then
		for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC and tmpNPC:IsActiveEnemy(false) then
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
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and not tmpNPC:IsBoss() and not tmpNPC:HasFullHealth() then
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
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsBoss() and not tmpNPC:HasFullHealth() then
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
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and not tmpNPC:IsChampion() then
				for _, tmpChamp in ipairs(tmpChamps) do
					local dist = math.sqrt((tmpNPC.Position.X - tmpChamp.Position.X)^2 + (tmpNPC.Position.Y - tmpChamp.Position.Y)^2)
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
				if tmpSoulEater.mob:IsBoss() and not tmpSoulEater.mob.Type == EntityType.ENTITY_GIDEON then
					Game():Spawn(EntityType.ENTITY_ATTACKFLY, 0, tmpSoulEater.mob.Position, Vector.Zero, nil, 0, Random() + 1)
					break
				end
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
		-- -15% damage as Dark Judas and start with 1 black heart instead
		if not PST:getTreeSnapshotMod("innerDemonActive") and player:GetPlayerType() == PlayerType.PLAYER_BLACKJUDAS then
			PST:addModifiers({ damagePerc = -15, innerDemonActive = true }, true)
			player:AddSoulHearts(-2)
		end
	end

	-- Black heart quantity updates
	if player:GetBlackHearts() ~= blackHeartTracker then
		-- Mod: +luck whenever you lose black hearts
		local lostBlackHeartsLuck = PST:getTreeSnapshotMod("lostBlackHeartsLuck", 0)
		if lostBlackHeartsLuck > 0 and player:GetBlackHearts() < blackHeartTracker then
			PST:addModifiers({ luck = lostBlackHeartsLuck }, true)
		end

		-- Song of Darkness node (Siren's tree) [Harmonic modifier]
		if PST:getTreeSnapshotMod("songOfDarkness", false) and PST:songNodesAllocated(true) <= 2 then
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
		end
	end
	blackHeartTracker = player:GetBlackHearts()

	-- Slipping Essence node (Blue Baby's tree)
	if PST:getTreeSnapshotMod("slippingEssence", false) then
		local slippingEssenceLost = PST:getTreeSnapshotMod("slippingEssenceLost", 0)
		if player:GetSoulHearts() < soulHeartTracker and 100 * math.random() < 100 / (2 ^ slippingEssenceLost) then
			PST:addModifiers({ slippingEssenceLost = 1, luck = -0.1 }, true)
			Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, player.Position, Vector.Zero, nil, HeartSubType.HEART_SOUL, Random() + 1)
		end
	end
	soulHeartTracker = player:GetSoulHearts()

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
			PST:addModifiers({ allstatsPerc = -5, kingCurseActive = true }, true)
		elseif PST:getTreeSnapshotMod("kingCurseActive", false) and player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2 then
			PST:addModifiers({ allstatsPerc = 5, kingCurseActive = false }, true)
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
	if player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) == nil and holyMantleTracker then
		holyMantleTracker = false

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
	elseif player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) ~= nil and not holyMantleTracker then
		holyMantleTracker = true

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
	if tmpTotal ~= familiarsTracker then
		player:AddCacheFlags(PST.allstatsCache, true)
	end
	familiarsTracker = tmpTotal

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

	-- Soulful node (The Forgotten's tree)
	if PST:getTreeSnapshotMod("soulful", false) then
		if player:GetBoneHearts() < boneHeartTracker and player:GetPlayerType() ~= PlayerType.PLAYER_THESOUL then
			for _=1, boneHeartTracker - player:GetBoneHearts() do
				local tmpPos = Isaac.GetFreeNearPosition(player.Position, 40)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, tmpPos, Vector.Zero, nil, HeartSubType.HEART_SOUL, Random() + 1)
				PST:addModifiers({ luck = -0.25 }, true)
			end
		end
	end
	boneHeartTracker = player:GetBoneHearts()

	-- Inner Flare node (The Forgotten's tree)
	if PST:getTreeSnapshotMod("innerFlare", false) then
		-- Slow room enemies when switching to The Soul
		if not PST:getTreeSnapshotMod("innerFlareProc", false) and playerTypeTracker == PlayerType.PLAYER_THEFORGOTTEN and
		player:GetPlayerType() == PlayerType.PLAYER_THESOUL then
			for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
				if tmpEntity:IsActiveEnemy() and tmpEntity:IsVulnerableEnemy() then
					tmpEntity:AddSlowing(EntityRef(player), math.floor(PST:getTreeSnapshotMod("innerFlareSlowDuration", 2) * 30), 0.7, Color(0.7, 0.7, 1, 1, 0, 0))
				end
			end
			PST:addModifiers({ innerFlareProc = true }, true)
		end
	end
	playerTypeTracker = player:GetPlayerType()

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
			if (player:GetHearts() - tmpTwin:GetHearts()) ~= jacobHeartDiffTracker then
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_RANGE, true)
				tmpTwin:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_RANGE, true)
				jacobHeartDiffTracker = player:GetHearts() - tmpTwin:GetHearts()
			end
		end

		-- Statue Pilgrimage node (Jacob & Esau's tree)
		if PST:getTreeSnapshotMod("statuePilgrimage", false) then
			---@diagnostic disable-next-line: undefined-field
			local tmpTimer = tmpTwin:GetGnawedLeafTimer()
			if tmpTimer >= 60 and not PST.specialNodes.esauIsStatue then
				PST.specialNodes.esauIsStatue = true
			elseif tmpTimer < 60 and PST.specialNodes.esauIsStatue then
				PST.specialNodes.esauIsStatue = false
			end

			local tmpDist = math.sqrt((player.Position.X - tmpTwin.Position.X)^2 + (player.Position.Y - tmpTwin.Position.Y)^2)
			if PST.specialNodes.esauIsStatue and tmpDist < tmpTwin.TearRange / 3 and not PST.specialNodes.jacobNearEsauBuff then
				PST:addModifiers({ allstatsPerc = 7 }, true)
				PST.specialNodes.jacobNearEsauBuff = true
			elseif (not PST.specialNodes.esauIsStatue or tmpDist > tmpTwin.TearRange / 3) and PST.specialNodes.jacobNearEsauBuff then
				PST:addModifiers({ allstatsPerc = -7 }, true)
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
	if player.Luck ~= luckTracker then
		-- Mod: +% all stats when luck changes
		tmpStats = PST:getTreeSnapshotMod("mightOfFortune", 0)
		if tmpStats ~= 0 then
			player:AddCacheFlags(PST.allstatsCache, true)
		end
	end
	luckTracker = player.Luck

	-- Coin changes
	if player:GetNumCoins() ~= coinTracker then
		-- Lost coins
		if player:GetNumCoins() < coinTracker then
			-- Starcursed mod: when losing or spending coins, X% chance to additionally lose Y coins
			tmpMod = PST:SC_getSnapshotMod("loseCoinsOnSpend", {0, 0})
			if tmpMod[1] > 0 and tmpMod[2] > 0 and 100 * math.random() < tmpMod[1] then
				player:AddCoins(-tmpMod[2])
			end
		end
	end
	coinTracker = player:GetNumCoins()

	-- Level curse changes
	local tmpCurses = Game():GetLevel():GetCurses()
	if tmpCurses ~= lvlCurseTracker then
		-- Mod: all stats while a level curse is present
		tmpMod = PST:getTreeSnapshotMod("curseAllstats", 0)
		if tmpMod ~= 0 then
			if tmpCurses ~= 0 and not PST:getTreeSnapshotMod("curseAllstatsActive", false) then
				PST:addModifiers({ allstatsPerc = tmpMod, curseAllstatsActive = true }, true)
			elseif tmpCurses == 0 and PST:getTreeSnapshotMod("curseAllstatsActive", false) then
				PST:addModifiers({ allstatsPerc = -tmpMod, curseAllstatsActive = false }, true)
			end
		end
	end
	lvlCurseTracker = tmpCurses

	-- Cosmic Realignment node
	local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
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

		local level = Game():GetLevel()
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

				-- Starcursed jewel drop
				if 100 * math.random() < PST.SCDropRates.challenge(level:GetStage()).regular then
					local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
					PST:SC_dropRandomJewelAt(tmpPos, PST.SCDropRates.challenge(level:GetStage()).ancient)
					jewelDrop = true
				end

				-- Ancient starcursed jewel: Challenger's Starpiece
				if PST:SC_getSnapshotMod("challengerStarpiece", false) and not PST:getTreeSnapshotMod("SC_challClear", false) then
					local tmpVariant = 0
					if level:GetStage() >= 7 then
						tmpVariant = 1
					end
					Game():Spawn(
						PST.deadlySinBosses[math.random(#PST.deadlySinBosses)],
						tmpVariant, room:GetCenterPos(), Vector.Zero, nil, 0, Random() + 1
					)
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
		-- Boss rush
		elseif room:GetType() == RoomType.ROOM_BOSSRUSH then
			-- Boss rush clear
			if Ambush.GetCurrentWave() >= Ambush.GetMaxBossrushWaves() then
				-- Starcursed jewel drop
				if 100 * math.random() < PST.SCDropRates.bossrush().regular then
					local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
					PST:SC_dropRandomJewelAt(tmpPos, PST.SCDropRates.bossrush().ancient)
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
					local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
					Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.CARD_REVERSE_WHEEL_OF_FORTUNE, Random() + 1)
				end

				-- Starcursed jewel drop
				if 100 * math.random() < PST.SCDropRates.boss(level:GetStage()).regular then
					local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
					PST:SC_dropRandomJewelAt(tmpPos, PST.SCDropRates.boss(level:GetStage()).ancient)
				end
			end

			-- Starcursed jewel drop
			if not jewelDrop and not PST:isFirstOrigStage() then
				tmpMod = PST:getTreeSnapshotMod("SC_jewelDropOnClear", 0)
				if 100 * math.random() < tmpMod then
					local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
					PST:SC_dropRandomJewelAt(tmpPos, 1)
					PST:addModifiers({ SC_jewelDropOnClear = { value = 0, set = true } }, true)
					jewelDrop = true
				elseif 100 * math.random() < 25 and tmpMod < 20 then
					PST:addModifiers({ SC_jewelDropOnClear = 1 }, true)
				end
			end

			-- Starcursed mod: chance to spawn an additional troll bomb at the center of the room on clear
			local tmpChance = PST:getTreeSnapshotMod("trollBombOnClear", 0)
			if 100 * math.random() < tmpChance then
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

			-- Mod: chance to heal 1/2 red heart when clearing a room
			tmpChance = PST:getTreeSnapshotMod("healOnClear", 0)
			if isBossRoom then
				tmpChance = tmpChance * 2
			end
			if 100 * math.random() < tmpChance then
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
			if 100 * math.random() < tmpChance then
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
				PST:addModifiers({ luck = tmpLuck }, true)
			end

			-- Mod: +luck if you clear the boss room within 1 minute
			tmpLuck = PST:getTreeSnapshotMod("bossQuickKillLuck", 0)
			if isBossRoom and tmpLuck > 0 and room:GetFrameCount() <= 1800 then
				PST:addModifiers({ luck = tmpLuck }, true)
			end

			-- Mod: +luck if you clear the boss room without getting hit more than 3 times
			tmpLuck = PST:getTreeSnapshotMod("bossFlawlessLuck", 0)
			if isBossRoom and tmpLuck > 0 and PST.specialNodes.bossRoomHitsFrom <= 3 then
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
			if 100 * math.random() < PST:getTreeSnapshotMod("lazarusClearHearts", 0) then
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
					local tmpPos = Isaac.GetFreeNearPosition(Game():GetRoom():GetCenterPos(), 40)
					Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.CARD_STARS, Random() + 1)
				end
			end

			-- Mod: chance to spawn a soul heart on room clear
			if 100 * math.random() < PST:getTreeSnapshotMod("soulHeartOnClear", 0) then
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
			if 100 * math.random() < PST:getTreeSnapshotMod("soulChargeOnClear", 0) then
				player:AddSoulCharge(1)
			end

			-- Song of Darkness node (Siren's tree)
			if PST:getTreeSnapshotMod("songOfDarkness", false) and 100 * math.random() < PST:getTreeSnapshotMod("songOfDarknessChance", 2) then
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
		elseif PST:cosmicRCharPicked(PlayerType.PLAYER_SAMSON_B) then
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
		player:AddCacheFlags(PST.allstatsCache, true)
	end
end