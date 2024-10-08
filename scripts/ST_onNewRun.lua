function PST:onNewRun(isContinued)
    if isContinued then
        PST.gameInit = true
        return
    end

    local player = Isaac.GetPlayer()
    local itemPool = Game():GetItemPool()

    -- Mods that are mutable before beginning a run should be set here
    local keptMods = {
        ["Cosmic Realignment"] = { cosmicRealignment = PST.modData.treeMods.cosmicRealignment }
    }

    PST:resetMods()
    local treeActive = not PST.modData.treeDisabled and ((not PST.config.treeOnChallenges and Isaac.GetChallenge() == 0) or PST.config.treeOnChallenges)
    if treeActive then
        local globalTrees = {"global", "starTree"}
        -- Get snapshot of tree modifiers
        for _, tmpTree in ipairs(globalTrees) do
            for nodeID, node in pairs(PST.trees[tmpTree]) do
                if PST:isNodeAllocated(tmpTree, nodeID) then
                    local kept = false
                    for keptName, keptVal in pairs(keptMods) do
                        if node.name == keptName then
                            PST:addModifiers(keptVal)
                            kept = true
                            break
                        end
                    end
                    if not kept then
                        PST:addModifiers(node.modifiers)
                    end
                end
            end
        end
        local currentChar = PST.charNames[1 + PST.selectedMenuChar]
        if currentChar == nil then
            currentChar = PST.charNames[1 + player:GetPlayerType()]
        end
        if currentChar ~= nil then
            if PST.trees[currentChar] ~= nil then
                for nodeID, node in pairs(PST.trees[currentChar]) do
                    if PST:isNodeAllocated(currentChar, nodeID) then
                        PST:addModifiers(node.modifiers)
                    end
                end
            end
        end

        -- Effects that re-enable when killing Mom's Heart
        if PST.modData.momHeartProc["isaacBlessing"] or PST.modData.momHeartProc["isaacBlessing"] == nil then
            -- Isaac's Blessing, % all stats
            if PST.modData.treeMods.isaacBlessing > 0 then
                PST:addModifiers({ allstatsPerc = PST.modData.treeMods.isaacBlessing })
                PST.modData.momHeartProc["isaacBlessing"] = false
            end
        end
    end

    PST.floorFirstUpdate = true

    PST.modData.treeModSnapshot = PST.modData.treeMods

    -- Starcursed jewel mods
    if treeActive then
        local starcursedMods = PST:SC_getTotalJewelMods()
        if next(starcursedMods.totalMods) ~= nil then
            PST.modData.treeModSnapshot.starcursedMods = starcursedMods.totalMods
        end
        PST.modData.treeModSnapshot.starmight = starcursedMods.totalStarmight

        if starcursedMods.totalStarmight > 0 then
            PST:addModifiers(PST:SC_getStarmightImplicits(starcursedMods.totalStarmight), true)
        end

        local tmpSCMods = {}
        -- Less speed
        local tmpMod = PST:SC_getSnapshotMod("lessSpeed", 0)
        if tmpMod ~= 0 then tmpSCMods["speed"] = -tmpMod end
        -- Less damage
        tmpMod = PST:SC_getSnapshotMod("lessDamage", 0)
        if tmpMod ~= 0 then tmpSCMods["damage"] = -tmpMod end
        -- Less luck
        tmpMod = PST:SC_getSnapshotMod("lessLuck", 0)
        if tmpMod ~= 0 then tmpSCMods["luck"] = -tmpMod end

        -- Equipped ancient starcursed jewels
        for i=1,2 do
            local ancientJewel = PST:SC_getSocketedJewel(PSTStarcursedType.ANCIENT, tostring(i))
            if ancientJewel and ancientJewel.rewards then
                tmpMod = ancientJewel.rewards.xpgain
                if tmpMod and tmpMod ~= 0 then
                    local tmpMult = 1
                    if ancientJewel.rewards.halveXPFirstFloor then
                        tmpMult = 0.5
                    end
                    tmpSCMods["xpgain"] = tmpMod * tmpMult
                end
            end
        end
        -- Ancient starcursed jewel: Umbra
        if PST:SC_getSnapshotMod("umbra", false) then
            itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE)
            Game():GetLevel():AddCurse(LevelCurse.CURSE_OF_DARKNESS, false)
        end
        -- Ancient starcursed jewel: Gaze Averter
        if PST:SC_getSnapshotMod("gazeAverter", false) then
            player:AddCollectible(CollectibleType.COLLECTIBLE_TINY_PLANET)
            player:AddCollectible(CollectibleType.COLLECTIBLE_MY_REFLECTION)
            if tmpSCMods["damage"] then tmpSCMods["damage"] = tmpSCMods["damage"] - 2
            else tmpSCMods["damage"] = -2 end
            if tmpSCMods["range"] then tmpSCMods["range"] = tmpSCMods["range"] - 10
            else tmpSCMods["range"] = -10 end
        end

        if next(tmpSCMods) ~= nil then
            PST:addModifiers(tmpSCMods, true)
        end
    end

    player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
    PST:save()

    -- Reset specialNodes that might be left over
    PST.specialNodes.SC_circadianSpawnTime = 0
    PST.specialNodes.SC_circadianSpawnProc = false
    PST.specialNodes.SC_circadianExplImmune = 0

    local isKeeper = player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B

    -- Intermittent Conceptions node (Isaac's tree)
    if PST:getTreeSnapshotMod("intermittentConceptions", false) then
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
        player:AddCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
    end

    -- Dark Heart node (Judas' tree)
    if PST:getTreeSnapshotMod("darkHeart", false) then
        player:AddBlackHearts(2)
    end

    -- Inner Demon node (Judas' tree)
    if PST:getTreeSnapshotMod("innerDemon", false) then
        player:AddCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
    end

    -- Brown Blessing node (Blue Baby's tree)
    if PST:getTreeSnapshotMod("brownBlessing", false) then
        player:AddTrinket(TrinketType.TRINKET_PETRIFIED_POOP)
    end

    -- Hasted node (Samson's tree)
    if PST:getTreeSnapshotMod("hasted", false) then
        PST:addModifiers({ tearsPerc = 10, shotSpeedPerc = 10 }, true)
    end

    -- Hearty node (Samson's tree)
    if PST:getTreeSnapshotMod("hearty", false) then
        player:AddMaxHearts(2)
        player:SetFullHearts()
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end

    -- Soulful Awakening node (Lazarus' tree)
    if PST:getTreeSnapshotMod("soulfulAwakening", false) then
        PST:addModifiers({ luck = 2 }, true)
    end
    
    -- King's Curse node (Lazarus' tree)
    if PST:getTreeSnapshotMod("kingCurse", false) then
        player:AddCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE)
    end

    -- Sporadic Growth node (Eden's tree)
    if PST:getTreeSnapshotMod("sporadicGrowth", false) then
        for _=1,6 do
            local tmpStat = PST:getRandomStat()
            PST:addModifiers({ [tmpStat .. "Perc"] = 1 }, true)
        end
    end

    -- Starblessed node (Eden's tree)
    if PST:getTreeSnapshotMod("starblessed", false) then
        local tmpItem = itemPool:GetCollectible(ItemPoolType.POOL_TREASURE)
        player:AddCollectible(tmpItem)
    end

    -- Mod: chance to start with an additional coin/key/bomb
    local tmpChance = PST:getTreeSnapshotMod("startCoinKeyBomb", 0)
    if tmpChance > 0 then
        while tmpChance > 0 do
            if 100 * math.random() < tmpChance then
                local randAddFunc = { player.AddCoins, player.AddKeys, player.AddBombs }
                randAddFunc[math.random(#randAddFunc)](player, 1)
            end
            tmpChance = tmpChance - 100
        end
    end

    -- Heavy Friends node (Lilith's tree)
    if PST:getTreeSnapshotMod("heavyFriends", false) then
        player:AddCollectible(CollectibleType.COLLECTIBLE_BFFS)
    end

    -- Daemon Army node (Lilith's tree)
    if PST:getTreeSnapshotMod("daemonArmy", false) then
        player:AddCollectible(CollectibleType.COLLECTIBLE_INCUBUS)
        for _, tmpItem in ipairs(PST.babyFamiliarItems) do
            if tmpItem ~= CollectibleType.COLLECTIBLE_INCUBUS then
                itemPool:RemoveCollectible(tmpItem)
            end
        end
    end

    -- Avid Shopper node (Keeper's tree)
    if PST:getTreeSnapshotMod("avidShopper", false) then
        player:AddCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE)
        player:AddCoins(5)
    end

    -- Fate Pendulum node (Bethany's tree)
    if PST:getTreeSnapshotMod("fatePendulum", false) then
        player:AddCollectible(CollectibleType.COLLECTIBLE_METRONOME)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_METRONOME)
        player:FullCharge(0)
    end

    -- Statue Pilgrimage node (Jacob & Esau's tree)
    if PST:getTreeSnapshotMod("statuePilgrimage", false) and player:GetOtherTwin() then
        player:GetOtherTwin():AddCollectible(CollectibleType.COLLECTIBLE_GNAWED_LEAF)
    end

    -- Song of Celerity node (Siren's tree) [Harmonic modifier]
    if PST:getTreeSnapshotMod("songOfCelerity", false) and PST:songNodesAllocated(true) <= 2 then
        PST:addModifiers({ speedPerc = 7 }, true)
    end

    -- Update familiars
    local tmpFamiliars = PST:getRoomFamiliars()
    if tmpFamiliars > 0 then
        PST:addModifiers({ totalFamiliars = { value = tmpFamiliars, set = true } }, true)
    end

    -- Cosmic Realignment node
    if PST:cosmicRCharPicked(PlayerType.PLAYER_ISAAC) then
        -- Isaac, -0.1 all stats
        PST:addModifiers({ allstats = -0.1 }, true)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_CAIN) then
        -- Cain, -0.5 luck
        PST:addModifiers({ luck = -0.5 }, true)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_JUDAS) then
        -- Judas, -10% damage
        PST:addModifiers({ damagePerc = -10 }, true)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_AZAZEL) then
        -- Azazel, -20% range
        PST:addModifiers({ rangePerc = -20 }, true)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_LAZARUS) then
        -- Lazarus, remove items that give extra lives
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_1UP)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_DEAD_CAT)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_INNER_CHILD)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_GUPPYS_COLLAR)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_ANKH)
        itemPool:RemoveTrinket(TrinketType.TRINKET_BROKEN_ANKH)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
        itemPool:RemoveTrinket(TrinketType.TRINKET_MISSING_POSTER)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST) then
        -- The Lost, if Holy Mantle is unlocked, start with Wafer
        if Isaac.GetPersistentGameData():Unlocked(Achievement.LOST_HOLDS_HOLY_MANTLE) then
            player:AddCollectible(CollectibleType.COLLECTIBLE_WAFER)
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_LILITH) then
        -- Lilith, remove incubus
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_INCUBUS)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN) then
        -- The Forgotten, convert starting hearts to bone hearts (not on Keepers)
        if not isKeeper then
            local totalHP = player:GetMaxHearts() + player:GetSoulHearts() + player:GetRottenHearts()
            player:AddMaxHearts(-player:GetMaxHearts())
            player:AddSoulHearts(-player:GetSoulHearts())
            player:AddRottenHearts(-player:GetRottenHearts())
            player:AddBoneHearts(math.floor(totalHP / 2))
            player:SetFullHearts()
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_JACOB) then
        -- Jacob & Esau, apply -50% xp gain
        PST:addModifiers({ xpgain = -50 }, true)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_CAIN_B) then
        -- Tainted Cain, begin with Bag of Crafting if unlocked
        if Isaac.GetPersistentGameData():Unlocked(Achievement.BAG_OF_CRAFTING) then
            player:AddCollectible(CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING)
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_JUDAS_B) then
        -- Tainted Judas, set starting health to 2 black hearts
        if not isKeeper then
            player:AddMaxHearts(-player:GetMaxHearts())
            player:AddSoulHearts(-player:GetSoulHearts())
            player:AddRottenHearts(-player:GetRottenHearts())
            player:AddBoneHearts(-player:GetBoneHearts())
            player:AddBlackHearts(4)
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_BLUEBABY_B) then
        -- Tainted ???, convert starting hearts to soul hearts
        if not isKeeper then
            local totalHP = player:GetMaxHearts() + player:GetSoulHearts() + player:GetRottenHearts() + player:GetBoneHearts() * 2
            player:AddMaxHearts(-player:GetMaxHearts())
            player:AddSoulHearts(-player:GetSoulHearts())
            player:AddRottenHearts(-player:GetRottenHearts())
            player:AddSoulHearts(totalHP)
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_EVE_B) then
        -- Tainted Eve, -33% fire rate
        PST:addModifiers({ tearsPerc = -33 }, true)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_LAZARUS_B) then
        -- Tainted Lazarus, setup first health bank
        local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
        cosmicRCache.TLazarusBank1.red = player:GetHearts()
        cosmicRCache.TLazarusBank1.max = player:GetMaxHearts()
        cosmicRCache.TLazarusBank1.soul = player:GetSoulHearts()
        cosmicRCache.TLazarusBank1.black = player:GetBlackHearts()
        cosmicRCache.TLazarusBank1.bone = player:GetBoneHearts()
        cosmicRCache.TLazarusBank1.rotten = player:GetRottenHearts()
        cosmicRCache.TLazarusBank1.broken = player:GetBrokenHearts()
        cosmicRCache.TLazarusBank1.eternal = player:GetEternalHearts()
        PST:save()
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST_B) then
        -- Tainted Lost, remove Wafer and Holy Mantle
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_WAFER)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_LILITH_B) then
        -- Tainted Lilith, -1 tears, range and shot speed
        PST:addModifiers({ tears = -1, range = -1, shotSpeed = -1 }, true)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_KEEPER_B) then
        -- Tainted Keeper, start with Restock
        player:AddCollectible(CollectibleType.COLLECTIBLE_RESTOCK)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN_B) then
        -- Tainted Forgotten, convert a starting red/soul heart to a bone heart
        if not isKeeper then
            if player:GetMaxHearts() > 2 then
                player:AddMaxHearts(-2)
                player:AddBoneHearts(1)
            elseif player:GetSoulHearts() > 2 then
                player:AddSoulHearts(-2)
                player:AddBoneHearts(1)
            end
            player:SetFullHearts()
        end
    end

    PST:closeTreeMenu(true)
    PST.gameInit = true
end