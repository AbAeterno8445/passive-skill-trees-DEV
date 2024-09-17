function PST:onNewLevel()
    if not PST.gameInit then return end

    local tmpMod
    local player = PST:getPlayer()
    local level = Game():GetLevel()
    PST.level = level

    PST.specialNodes.mobHitReduceDmg = 0
    PST.specialNodes.momDeathProc = false
    PST.specialNodes.itemRemovalProtected = {}
    PST.specialNodes.temporaryHeartBuffTimer = 0
    PST.specialNodes.temporaryHeartDmgStacks = 0
    PST.specialNodes.temporaryHeartTearStacks = 0
    PST.specialNodes.craftBagSnapshot = {}
	PST:resetFloatingTexts()
    PST.floorFirstUpdate = true
    PST:addModifiers({
        staticEntitiesCache = { value = {}, set = true },
        shopSavingCache = { value = {}, set = true }
    }, true)

    -- Equipped ancient starcursed jewels - 'unhalve' xp from first floor
    if not PST:isFirstOrigStage() and not PST:getTreeSnapshotMod("SC_firstFloorXPHalvedProc", false) then
        for i=1,2 do
            local ancientJewel = PST:SC_getSocketedJewel(PSTStarcursedType.ANCIENT, tostring(i))
            if ancientJewel and ancientJewel.rewards then
                tmpMod = ancientJewel.rewards.xpgain
                if tmpMod and tmpMod ~= 0 and ancientJewel.rewards.halveXPFirstFloor then
                    PST:addModifiers({
                        xpgain = tmpMod / 2,
                        SC_firstFloorXPHalvedProc = true
                    }, true)
                end
            end
        end
    end

    -- Ancient starcursed jewel: Challenger's Starpiece (reset stairway proc)
    if PST:getTreeSnapshotMod("SC_challStairwayProc", false) then
        PST:addModifiers({ SC_challStairwayProc = false }, true)
    end

    -- Ancient starcursed jewel: Umbra (reset)
    if PST:SC_getSnapshotMod("umbra", false) then
        tmpMod = PST:getTreeSnapshotMod("SC_umbraStatsDown", 0)
        if tmpMod > 0 then
            PST:addModifiers({
                allstatsPerc = tmpMod,
                SC_umbraStatsDown = { value = 0, set = true },
                SC_umbraNightLightSpawn = false
            }, true)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_NIGHT_LIGHT) then
            player:RemoveCollectible(CollectibleType.COLLECTIBLE_NIGHT_LIGHT)
        end
    end

    -- Ancient starcursed jewel: Opalescent Purity
    if PST:getTreeSnapshotMod("SC_opalescentProc", false) then
        PST:addModifiers({ SC_opalescentProc = false }, true)
    end

    -- Ancient starcursed jewel: Iridescent Purity
    if PST:SC_getSnapshotMod("iridescentPurity", false) then
        local iridescentItems = PST:getTreeSnapshotMod("SC_iridescentItems", nil)
        if iridescentItems and #iridescentItems > 0 then
            for i, itemType in ipairs(iridescentItems) do
                if 100 * math.random() < 15 * i then
                    player:RemoveCollectible(itemType)
                end
            end
            PST.modData.treeModSnapshot.SC_iridescentItems = {}
        end
    end

    -- Ancient starcursed jewel: Nullstone
    local tmpTreeMod = PST:getTreeSnapshotMod("SC_nullstoneEnemies", nil)
    if tmpTreeMod and #tmpTreeMod > 0 then
        PST:addModifiers({ SC_nullstoneEnemies = { value = {}, set = true } }, true)
    end
    if PST:getTreeSnapshotMod("SC_nullstoneClear", false) then
        PST:addModifiers({ SC_nullstoneClear = false }, true)
    end

    -- Ancient starcursed jewel: Sanguinis
    if PST:getTreeSnapshotMod("SC_sanguinisProc", false) then
        PST:addModifiers({ SC_sanguinisProc = false }, true)
    end
    if PST:getTreeSnapshotMod("SC_sanguinisTookDmg", false) then
        PST:addModifiers({ SC_sanguinisTookDmg = false }, true)
    end

    -- Ancient starcursed jewel: Twisted Emperor's Heirloom
    if PST:SC_getSnapshotMod("twistedEmperorHeirloom", false) then
        if PST:getTreeSnapshotMod("SC_empHeirloomActive", false) and not PST:getTreeSnapshotMod("SC_empHeirloomProc", false) then
            tmpMod = PST:getTreeSnapshotMod("SC_empHeirloomDebuff", 0)
            if tmpMod < 48 then
                PST:addModifiers({ allstatsPerc = -12, SC_empHeirloomDebuff = 12 }, true)
            end
        end
        PST:addModifiers({
            SC_empHeirloomProc = false,
            SC_empHeirloomRoomID = { value = -1, set = true },
            SC_empHeirloomUsedCard = false
        }, true)
    end

    -- Ancient starcursed jewel: Cursed Auric Shard
    if PST:getTreeSnapshotMod("SC_cursedAuricSpeedProc", false) then
        PST:addModifiers({ SC_cursedAuricSpeedProc = false }, true)
        player:AddCacheFlags(CacheFlag.CACHE_SPEED, true)
    end

    -- Ancient starcursed jewel: Tellurian Splinter
    tmpMod = PST:getTreeSnapshotMod("SC_tellurianBuff", 0)
    if tmpMod > 0 then
        PST:addModifiers({ speedPerc = -tmpMod / 2, SC_tellurianBuff = -tmpMod / 2 }, true)
    end

    -- Ancient starcursed jewel: Astral Insignia
    if PST:SC_getSnapshotMod("astralInsignia", false) then
        PST:addModifiers({ SC_astralInsigniaLevel = 1 }, true)
    end

    -- Challenge room clear proc
    if PST:getTreeSnapshotMod("SC_challClear", false) then
        PST:addModifiers({ SC_challClear = false }, true)
    end

    -- Boss rush clear proc
    if PST:getTreeSnapshotMod("SC_bossrushJewel", false) then
        PST:addModifiers({ SC_bossrushJewel = false }, true)
    end

    -- Eldritch mapping reset
    tmpMod = PST:getTreeSnapshotMod("eldritchMappingDebuffs", 0)
    if tmpMod > 0 then
        PST:addModifiers({
            allstatsPerc = 6 * math.min(2, tmpMod),
            eldritchMappingDebuffs = { value = 0, set = true }
        }, true)
    end

    -- Impromptu Gambler node (Cain's tree)
	if PST:getTreeSnapshotMod("impromptuGambler", false) then
		PST:addModifiers({ impromptuGamblerProc = false }, true)
    end
    if PST:getTreeSnapshotMod("impromptuGamblerItemRemoved", false) then
        PST:addModifiers({ impromptuGamblerItemRemoved = false }, true)
    end

    -- Sacrifice Darkness node (Judas' tree)
    if PST:getTreeSnapshotMod("sacrificeDarkness", false) then
        PST:addModifiers({ blackHeartSacrifices = { value = 0, set = true } }, true)
    end

    -- Mod: beggar luck
    local tmpBonusTotal = PST:getTreeSnapshotMod("beggarLuckTotal", 0)
    if tmpBonusTotal > 0 then
        PST:addModifiers({ beggarLuckTotal = { value = 0, set = true } }, true)
    end

    -- Mod: +% tears and range when picking up a soul heart (reset)
    tmpBonusTotal = PST:getTreeSnapshotMod("soulHeartTearsRangeTotal", 0)
    if tmpBonusTotal > 0 then
        PST:addModifiers({
            tearsPerc = -tmpBonusTotal,
            rangePerc = -tmpBonusTotal,
            soulHeartTearsRangeTotal = { value = 0, set = true }
        }, true)
    end

    -- Carrion Avian node (Eve's tree)
    if PST:getTreeSnapshotMod("carrionAvian", false) then
        PST:addModifiers({
            damage = -PST:getTreeSnapshotMod("carrionAvianTempBonus", 0),
            carrionAvianTempBonus = { value = 0, set = true }
        }, true)
    end

    -- Hasted node (Samson's tree)
    if PST:getTreeSnapshotMod("hasted", false) then
        local tmpHits = PST:getTreeSnapshotMod("hastedHits", 0)
        PST:addModifiers({
            tearsPerc = tmpHits * 1.5,
            shotSpeedPerc = tmpHits * 1.5,
            hastedHits = { value = 0, set = true }
        }, true)
    end

    -- Mod: +damage / +luck on card use, resets every floor
    local tmpTotal = PST:getTreeSnapshotMod("cardFloorDamageTotal", 0)
    if tmpTotal > 0 then
        PST:addModifiers({
            damage = -tmpTotal,
            cardFloorDamageTotal = { value = 0, set = true }
        }, true)
    end
    tmpTotal = PST:getTreeSnapshotMod("cardFloorTearsTotal", 0)
    if tmpTotal > 0 then
        PST:addModifiers({
            tears = -tmpTotal,
            cardFloorTearsTotal = { value = 0, set = true }
        }, true)
    end

    -- King's Curse node (Lazarus' tree)
    if PST:getTreeSnapshotMod("kingCurse", false) then
        if not player:HasCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE) then
            player:AddCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE)
        else
            player:RemoveCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE)
        end
    end

    -- Sporadic Growth node (Eden's tree)
    if PST:getTreeSnapshotMod("sporadicGrowth", false) and not PST:isFirstOrigStage() then
        for _=1,2 do
            local tmpStat = PST:getRandomStat()
            PST:addModifiers({ [tmpStat .. "Perc"] = 1 }, true)
        end
    end

    -- Mod: +damage when a blue fly dies, up to +2. Resets every floor
    tmpTotal = PST:getTreeSnapshotMod("blueFlyDeathDamageTotal", 0)
    if tmpTotal > 0 then
        PST:addModifiers({
            damage = -tmpTotal,
            blueFlyDeathDamageTotal = { value = 0, set = true }
        }, true)
    end

    -- Null node (Apollyon's tree)
    if PST:getTreeSnapshotMod("null", false) then
        if not PST:getTreeSnapshotMod("nullActiveAbsorbed", false) and PST:getTreeSnapshotMod("nullAppliedBonus", 0) < 3 then
            PST:addModifiers({ allstatsPerc = 5, nullAppliedBonus = 1 }, true)
        end
    end

    -- Mod: +% all stats per wisp orbiting you when entering a floor, up to 15%
    local tmpBonus = PST:getTreeSnapshotMod("wispFloorBuff", 0)
    if tmpBonus ~= 0 then
        tmpTotal = 0
        for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
            if tmpEntity.Type == EntityType.ENTITY_FAMILIAR and tmpEntity.Variant == FamiliarVariant.WISP then
                tmpTotal = tmpTotal + tmpBonus
            end
        end
        local treeTotal = PST:getTreeSnapshotMod("wispFloorBuffTotal", 0)
        if tmpTotal ~= 0 and treeTotal < 15 then
            local tmpAdd = math.min(tmpTotal, 15 - treeTotal)
            PST:addModifiers({ allstatsPerc = tmpAdd, wispFloorBuffTotal = tmpAdd }, true)
        end
    end

    -- Floor stat buffs reset
    tmpBonus = PST:getTreeSnapshotMod("floorLuckPerc", 0)
    if tmpBonus ~= 0 then
        PST:addModifiers({ luckPerc = -tmpBonus, floorLuckPerc = { value = 0, set = true } }, true)
    end
    tmpBonus = PST:getTreeSnapshotMod("floorLuck", 0)
    if tmpBonus ~= 0 then
        PST:addModifiers({ luck = -tmpBonus, floorLuck = { value = 0, set = true } }, true)
    end

    -- Card against humanity proc reset
    if PST:getTreeSnapshotMod("cardAgainstHumanityProc", false) then
        PST:addModifiers({ cardAgainstHumanityProc = false }, true)
    end

    -- Mod: chance to unlock boss challenge room regardless of hearts
    if 100 * math.random() < PST:getTreeSnapshotMod("bossChallengeUnlock", 0) then
        PST:addModifiers({ bossChallengeUnlockProc = true }, true)
    elseif PST:getTreeSnapshotMod("bossChallengeUnlockProc", false) then
        PST:addModifiers({ bossChallengeUnlockProc = false }, true)
    end

    -- Mod: chance to convert all curse room spiked doors to regular ones
    if 100 * math.random() < PST:getTreeSnapshotMod("curseRoomSpikesOut", 0) then
        PST:addModifiers({ curseRoomSpikesOutProc = true }, true)
    elseif PST:getTreeSnapshotMod("curseRoomSpikesOut", 0) then
        PST:addModifiers({ curseRoomSpikesOutProc = false }, true)
    end

    -- Mod: chance to convert keys to golden keys, once per floor (reset)
    if PST:getTreeSnapshotMod("goldenKeyConvertProc", false) then
        PST:addModifiers({ goldenKeyConvertProc = false }, true)
    end

    -- Mod: chance to spawn a red heart when using a sacrifice room, up to 4 times (reset)
    tmpMod = PST:getTreeSnapshotMod("sacrificeRoomHeartsSpawned", 0)
    if tmpMod > 0 then
        PST:addModifiers({ sacrificeRoomHeartsSpawned = { value = 0, set = true } }, true)
    end

    -- Mod: chance to reveal map
    if 100 * math.random() < PST:getTreeSnapshotMod("mapChance", 0) + PST:getTreeSnapshotMod("ansuzMapreveal", 0) then
        PST:addModifiers({ mapRevealed = true }, true)
    elseif PST:getTreeSnapshotMod("mapRevealed", false) then
        PST:addModifiers({ mapRevealed = false }, true)
    end

    -- Mod: chance to reroll active items into random passive items (reset)
    if PST:getTreeSnapshotMod("activeItemRerolled", 0) > 0 then
        PST:addModifiers({ activeItemRerolled = { value = 0, set = true } }, true)
    end

    -- Mod: +% speed when using a rune shard (reset)
    tmpMod = PST:getTreeSnapshotMod("runicSpeedBuff", 0)
    if tmpMod > 0 then
        PST:addModifiers({ speedPerc = -tmpMod, runicSpeedBuff = { value = 0, set = true } }, true)
    end

    -- Consuming Void node (T. Isaac's tree)
    if PST:getTreeSnapshotMod("consumingVoidSpawned", false) then
        PST:addModifiers({ consumingVoidSpawned = false }, true)
    end

    -- Sinistral Runemaster: Ehwaz proc
    if PST:getTreeSnapshotMod("ehwazAllstatsProc", false) then
        PST:addModifiers({ allstatsPerc = 3 }, true)
    end
    -- Sinistral Runemaster: Dagaz buff
    tmpMod = PST:getTreeSnapshotMod("dagazBuff", 0)
    if tmpMod > 0 then
        PST:addModifiers({ allstatsPerc = -tmpMod, dagazBuff = { value = 0, set = true } }, true)
    end

    -- Dextral Runemaster: Ansuz map reveal chance
    tmpMod = PST:getTreeSnapshotMod("ansuzMapreveal", 0)
    if tmpMod > 0 then
        PST:addModifiers({ ansuzMapreveal = { value = 0, set = true } }, true)
    end
    -- Dextral Runemaster: Berkano innate Hive Mind
    if PST:getTreeSnapshotMod("berkanoHivemind", false) then
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND, -1)
        PST:addModifiers({ berkanoHivemind = false }, true)
    end

    -- Mod: +luck if temporary heart has 1.8 seconds or more remaining (halve on new floor)
    tmpMod = PST:getTreeSnapshotMod("temporaryHeartLuckBuff", 0)
    if tmpMod > 0 then
        PST:addModifiers({ luck = -tmpMod / 2, temporaryHeartLuckBuff = -tmpMod / 2 }, true)
    end

    -- Bounty For The Lightless node (T. Judas' tree)
    if PST:getTreeSnapshotMod("lightlessBountyLuck", 0) > 0 then
        PST:addModifiers({ lightlessBountyLuck = { value = 0, set = true } }, true)
    end

    -- Mod: +% random stat every X kills with Dark Arts (reset)
    local tmpBuffTable = PST:getTreeSnapshotMod("darkArtsKillStatBuffs", nil)
    if tmpBuffTable then
        local tmpMods = {}
        for tmpStat, tmpStatVal in pairs(tmpBuffTable) do
            tmpMods[tmpStat] = -tmpStatVal
        end
        PST:addModifiers(tmpMods, true)
        PST.modData.treeModSnapshot.darkArtsKillStatBuffs = {}
    end

    -- Alacritous Purpose node (T. Blue Baby's tree)
    tmpMod = PST:getTreeSnapshotMod("alacritousTearBuff", 0)
    if tmpMod > 0 then
        PST:addModifiers({ tears = -tmpMod, alacritousTearBuff = { value = 0, set = true } }, true)
    end
    tmpMod = PST:getTreeSnapshotMod("alacritousLuckBuff", 0)
    if tmpMod > 0 then
        PST:addModifiers({ luck = -tmpMod, alacritousLuckBuff = { value = 0, set = true } }, true)
    end

    -- Ascetic Soul node (T. Blue Baby's tree)
    if PST:getTreeSnapshotMod("asceticSoulDrops", 0) > 0 then
        PST:addModifiers({ asceticSoulDrops = { value = 0, set = true } }, true)
    end

    -- Sloth's Legacy node (T. Blue Baby's tree)
    if PST:getTreeSnapshotMod("slothLegacyProc", false) then
        PST:addModifiers({ slothLegacyProc = false }, true)
    end

    -- Mod: +% luck when destroying rainbow poop (halve)
    tmpMod = PST:getTreeSnapshotMod("rainbowPoopLuckBuff", 0)
    if tmpMod > 0 then
        PST:addModifiers({ luckPerc = -tmpMod / 2, rainbowPoopLuckBuff = -tmpMod / 2 }, true)
    end

    -- Mod: chance to gain +luck when picking up red hearts, up to +1 per floor (reset)
    if PST:getTreeSnapshotMod("redHeartLuckBuff", 0) > 0 then
        PST:addModifiers({ redHeartLuckBuff = { value = 0, set = true } }, true)
    end

    -- Mod: % chance to gain +0.01 tears for the current floor when killing cursed enemies, up to +1 (reset)
    tmpMod = PST:getTreeSnapshotMod("cursedKillTearsBuff", 0)
    if tmpMod > 0 then
        PST:addModifiers({ tears = -tmpMod, cursedKillTearsBuff = { value = 0, set = true } }, true)
    end

    -- Mod: % chance for devil deals to be free while you don't have flight (reset cache)
    tmpMod = PST:getTreeSnapshotMod("flightlessDevilDeal", 0)
    if tmpMod > 0 then
        PST.modData.treeModSnapshot.flightlessDevilCache = {}
    end

    -- Spiritus node (T. Lazarus' tree)
    if PST:getTreeSnapshotMod("spiritus", false) and not PST:isFirstOrigStage() then
        if not PST:getTreeSnapshotMod("floorGotHit", false) and not player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
            player:AddCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
        elseif PST:getTreeSnapshotMod("floorGotHit") and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
            player:RemoveCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
        end
    end

    -- Mod: chance to gain 1 Ephemeral Bond when entering a floor
    tmpMod = PST:getTreeSnapshotMod("ephBondFloor", 0)
    if tmpMod > 0 and 100 * math.random() < tmpMod then
        PST:addModifiers({ ephemeralBond = 1, gainedTempEphBond = 1 }, true)
    end

    -- Mod: +% to a random stat every X kills with the current form (T. Lazarus - reset)
    tmpMod = PST:getTreeSnapshotMod("lazFormKillStat", 0)
    if tmpMod > 0 then
        PST:addModifiers({ lazFormStatCache = { value = {}, set = true }, lazFormDeadStatCache = { value = {}, set = true } }, true)
        PST:updateCacheDelayed()
    end

    -- Mod: +% to a random stat when using an active item while you have a holy mantle/wooden cross shield (reset)
    tmpMod = PST:getTreeSnapshotMod("shieldActiveStat", 0)
    if tmpMod > 0 then
        local tmpMods = {}
        local tmpStatCache = PST:getTreeSnapshotMod("shieldActiveStatList", {})
        for tmpStat, tmpStatVal in pairs(tmpStatCache) do
            tmpMods[tmpStat] = -tmpStatVal
        end
        tmpMods["shieldActiveStatList"] = { value = {}, set = true }
        PST:addModifiers(tmpMods, true)
    end

    -- Mod: % chance when rerolling items to turn a resulting item into a new +1 quality item (reset)
    if PST:getTreeSnapshotMod("higherQualityRerollProcs", 0) > 0 then
        PST:addModifiers({ higherQualityRerollProcs = { value = 0, set = true } }, true)
    end

    -- Deferred Aegis node (T. Lost's tree)
    if PST:getTreeSnapshotMod("deferredAegisCardUses", 0) > 0 then
        PST:addModifiers({ deferredAegisCardUses = { value = 0, set = true } }, true)
    end

    -- Mod: +speed for the next floor when clearing the boss room without having/receiving shields at any point in the fight
    if PST:getTreeSnapshotMod("shieldlessBossDone", false) then
        if not PST:getTreeSnapshotMod("shieldlessBossSpeedApplied", false) then
            PST:addModifiers({ speed = PST:getTreeSnapshotMod("shieldlessBossSpeed", 0), shieldlessBossSpeedApplied = true }, true)
        end
        PST:addModifiers({ shieldlessBossDone = false }, true)
    elseif PST:getTreeSnapshotMod("shieldlessBossSpeedApplied", false) then
        PST:addModifiers({ speed = -PST:getTreeSnapshotMod("shieldlessBossSpeed", 0), shieldlessBossSpeedApplied = false }, true)
    end

    -- Mod: % chance for champions to drop a Holy card on kill, once every 2 floors
    if PST:getTreeSnapshotMod("champHolyCardDropFloors", 0) > 0 then
        PST:addModifiers({ champHolyCardDropFloors = -1 }, true)
    end

    -- Mod: +luck for the current floor when using a Holy Card (reset)
    tmpMod = PST:getTreeSnapshotMod("holyCardLuckBuff", 0)
    if tmpMod > 0 then
        PST:addModifiers({ luck = -tmpMod, holyCardLuckBuff = { value = 0, set = true } }, true)
    end

    -- Chimeric Amalgam node (T. Lilith's tree)
    if PST:getTreeSnapshotMod("chimericAmalgam", false) then
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
            local tmpDmgBuff = PST:getTreeSnapshotMod("chimericAmalgamDmgBonus", 0)
            if tmpDmgBuff < 50 then
                local tmpAdd = math.min(8, 50 - tmpDmgBuff)
                PST:addModifiers({ damagePerc = tmpAdd, chimericAmalgamDmgBonus = tmpAdd }, true)
            end
        end
    end

    -- Mod: % chance to gain +luck when killing enemies within 1.5 tiles of you (halve)
    tmpMod = PST:getTreeSnapshotMod("nearbyKillLuckBuff", 0)
    if tmpMod > 0 then
        PST:addModifiers({ luck = -tmpMod / 2, nearbyKillLuckBuff = -tmpMod / 2 }, true)
    end

    -- Cosmic Realignment node
    local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.treeMods.cosmicRCache)
    if PST:cosmicRCharPicked(PlayerType.PLAYER_BLUEBABY) then
        -- Blue baby, reset non-soul heart pickups
        cosmicRCache.blueBabyHearts = 0
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_EDEN) then
        -- Eden, -0.1 to random stat when entering a floor (from 2 onwards)
        if not PST:isFirstOrigStage() then
            local randomStat = PST:getRandomStat()
            PST:addModifiers({ [randomStat] = -0.1 }, true)
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_KEEPER) then
        -- Keeper, tally collected coins in previous floor and halve coin count if < 5
        if cosmicRCache.keeperFloorCoins < 5 then
            player:AddCoins(math.floor(player:GetNumCoins() / 2) * -1)
        end
        cosmicRCache.keeperFloorCoins = 0
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN) then
        -- The Forgotten, convert a red/bone heart into a full soul heart (prioritizes bone hearts)
        local boneHearts = player:GetBoneHearts()
        if boneHearts > 0 then
            player:AddBoneHearts(-1)
            player:AddSoulHearts(2)
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST_B) then
        -- Tainted Lost, reset Keeper coins tracker
        cosmicRCache.TLostKeeperCoins = 0
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_KEEPER_B) then
        -- Tainted Keeper, if < 15 coins, lose a heart container, otherwise halve coin count
        if not PST:isFirstOrigStage() then
            if player:GetNumCoins() < 15 then
                if player:GetMaxHearts() > 2 then
                    player:AddMaxHearts(-2)
                elseif player:GetSoulHearts() > 2 then
                    player:AddSoulHearts(-2)
                end
            else
                player:AddCoins(-math.ceil(player:GetNumCoins() / 2))
            end
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_APOLLYON_B) then
        -- Tainted Apollyon, despawn a locust
        for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
            if tmpEntity.Type == EntityType.ENTITY_FAMILIAR and tmpEntity.Variant == FamiliarVariant.ABYSS_LOCUST then
                tmpEntity:Remove()
                cosmicRCache.TApollyonLocusts = math.max(0, cosmicRCache.TApollyonLocusts - 1)
                player:AddCacheFlags(PST.allstatsCache, true)
                break
            end
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_BETHANY_B) then
        -- Tainted Bethany, heal wisps
        for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
            if tmpEntity.Type == EntityType.ENTITY_FAMILIAR and tmpEntity.Variant == FamiliarVariant.ITEM_WISP then
                tmpEntity:AddHealth(tmpEntity.MaxHitPoints)
            end
        end
    end

    -- Floor player got-hit proc
    if PST:getTreeSnapshotMod("floorGotHit", false) then
        PST:addModifiers({ floorGotHit = false }, true)
    end

    PST:save()
end

local curseIDs = {
    LevelCurse.CURSE_OF_BLIND,
    LevelCurse.CURSE_OF_DARKNESS,
    LevelCurse.CURSE_OF_LABYRINTH,
    LevelCurse.CURSE_OF_MAZE,
    LevelCurse.CURSE_OF_THE_LOST,
    LevelCurse.CURSE_OF_THE_UNKNOWN
}
function PST:onCurseEval(curses)
    if not PST.gameInit then return curses end

    local causeCurse = PST:getTreeSnapshotMod("causeCurse", false)
    local curseChance = 0

    -- Mod: chance to negate curses when entering a floor
    local tmpMod = PST:getTreeSnapshotMod("naturalCurseCleanse", 0)
    if curses ~= 0 and tmpMod > 0 and 100 * math.random() < tmpMod then
        curses = 0
        PST:addModifiers({ naturalCurseCleanseProc = true }, true)
    elseif PST:getTreeSnapshotMod("naturalCurseCleanseProc", false) then
        PST:addModifiers({ naturalCurseCleanseProc = false }, true)
    end

    -- Starcursed mod: additional chance to receive a random curse when entering a floor
    curseChance = curseChance + PST:SC_getSnapshotMod("floorCurse", 0)

    -- Eldritch mapping curse chance
    tmpMod = PST:getTreeSnapshotMod("eldritchMappingDebuffs", 0)
    if tmpMod > 0 then
        curseChance = curseChance + 15 * tmpMod
    end

    if 100 * math.random() < curseChance then
        causeCurse = true
    end

    -- Ancient starcursed jewel: Umbra
    if PST:SC_getSnapshotMod("umbra", false) then
        curses = curses | LevelCurse.CURSE_OF_DARKNESS
    end

    -- Cosmic Realignment node
    if PST:cosmicRCharPicked(PlayerType.PLAYER_CAIN_B) then
        -- Tainted Cain, roll for curse of the blind
        local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.treeMods.cosmicRCache)
        if 100 * math.random() < 100 - cosmicRCache.TCainUses * 10 then
            curses = curses | LevelCurse.CURSE_OF_BLIND
        end
    end

    if causeCurse then
        PST:addModifiers({ causeCurse = false }, true)
        if curses == LevelCurse.CURSE_NONE then
            local level = Game():GetLevel()
            local newCurse = LevelCurse.CURSE_NONE
            while newCurse == LevelCurse.CURSE_NONE do
                newCurse = curseIDs[math.random(#curseIDs)]
                if newCurse == LevelCurse.CURSE_OF_LABYRINTH and not level:CanStageHaveCurseOfLabyrinth(level:GetStage()) then
                    newCurse = LevelCurse.CURSE_NONE
                end
            end
            curses = curses | newCurse
        end
    end

    -- Apollyon's Blessing node (Apollyon's tree)
    if PST:getTreeSnapshotMod("apollyonBlessing", false) then
        -- Curse of blind immunity
        curses = curses &~ LevelCurse.CURSE_OF_BLIND
    end

    return curses
end