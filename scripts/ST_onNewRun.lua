function PST:onNewRun(isContinued)
    if isContinued then
        PST.player = Isaac.GetPlayer()
        PST.gameInit = true
        PST:onNewRoom()
        return
    end

    local player = Isaac.GetPlayer()
    local playerTwin = player:GetOtherTwin()
    local itemPool = Game():GetItemPool()

    PST:resetMods()
    local treeActive = not PST.modData.treeDisabled and ((not PST.config.treeOnChallenges and Isaac.GetChallenge() == 0) or PST.config.treeOnChallenges)
    if treeActive then
        local globalTrees = {"global", "starTree"}
        -- Get snapshot of tree modifiers
        for _, tmpTree in ipairs(globalTrees) do
            for nodeID, node in pairs(PST.trees[tmpTree]) do
                if PST:isNodeAllocated(tmpTree, nodeID) then
                    PST:addModifiers(node.modifiers)
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

        -- Cosmic Realignment
        PST:addModifiers({ cosmicRealignment = PST.modData.cosmicRealignment })

        -- Effects that re-enable when killing Mom's Heart
        if PST.modData.momHeartProc["isaacBlessing"] or PST.modData.momHeartProc["isaacBlessing"] == nil then
            -- Isaac's Blessing, % all stats
            if PST.treeMods.isaacBlessing > 0 then
                PST:addModifiers({ allstatsPerc = PST.treeMods.isaacBlessing })
                PST.modData.momHeartProc["isaacBlessing"] = false
            end
        end
    end

    PST.floorFirstUpdate = true

    if treeActive then
        PST.modData.treeModSnapshot = PST:copyTable(PST.treeMods)
    else
        PST.modData.treeModSnapshot = {}
    end

    -- Remove defaults
    for k, v in pairs(PST.modData.treeModSnapshot) do
        if (PST.defaultTreeMods[k] ~= nil and PST.defaultTreeMods[k] == v) or (PST.defaultTreeMods[k] == nil and v == nil) then
            PST.modData.treeModSnapshot[k] = nil
        end
    end
    if PST.debugOptions.printModsOnStart then
        for k, v in pairs(PST.modData.treeModSnapshot) do
            print("Applied mod:", k, v)
        end
    end

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

        -- Item pool removals
        tmpMod = PST:SC_getSnapshotMod("itemPoolRemoval", {0, 0})
        if tmpMod[1] > 0 and tmpMod[2] > 0 then
            local pickedItems = 0
            local failsafe = 0
            while pickedItems < tmpMod[1] and failsafe < 2000 do
                local tmpItem = itemPool:GetCollectible(math.random(ItemPoolType.NUM_ITEMPOOLS) - 1)
                if Isaac.GetItemConfig():GetCollectible(tmpItem).Quality == tmpMod[2] then
                    itemPool:RemoveCollectible(tmpItem)
                    pickedItems = pickedItems + 1
                end
                failsafe = failsafe + 1
            end
        end

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
        -- Ancient starcursed jewel: Glace
        if PST:SC_getSnapshotMod("glace", false) then
            player:AddCollectible(CollectibleType.COLLECTIBLE_URANUS)
            player:AddSmeltedTrinket(TrinketType.TRINKET_ICE_CUBE)
            local tmpReduction = -50
            if tmpSCMods["tearsPerc"] then tmpSCMods["tearsPerc"] = tmpSCMods["tearsPerc"] + tmpReduction
            else tmpSCMods["tearsPerc"] = tmpReduction end
            if tmpSCMods["speedPerc"] then tmpSCMods["speedPerc"] = tmpSCMods["speedPerc"] + tmpReduction
            else tmpSCMods["speedPerc"] = tmpReduction end
            tmpSCMods["SC_glaceDebuff"] = -tmpReduction
        end
        -- Ancient starcursed jewel: Martian Ultimatum
        if PST:SC_getSnapshotMod("martianUltimatum", false) then
            player:AddInnateCollectible(CollectibleType.COLLECTIBLE_MARS)
            if playerTwin then
                playerTwin:AddInnateCollectible(CollectibleType.COLLECTIBLE_MARS)
            end
        end
        -- Ancient starcursed jewel: Sanguinis
        if PST:SC_getSnapshotMod("sanguinis", false) then
            player:AddBrokenHearts(1)
        end
        -- Ancient starcursed jewel: Saturnian Luminite
        if PST:SC_getSnapshotMod("saturnianLuminite", false) then
            itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_GENESIS)
            player:AddCollectible(CollectibleType.COLLECTIBLE_SATURNUS)
            player:AddCollectible(CollectibleType.COLLECTIBLE_SPEAR_OF_DESTINY)
            player:SetCanShoot(false)
        end
        -- Ancient starcursed jewel: Cursed Auric Shard
        if PST:SC_getSnapshotMod("cursedAuricShard", false) then
            itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_CARD_READING)
            player:AddInnateCollectible(CollectibleType.COLLECTIBLE_CARD_READING)
        end
        -- Ancient starcursed jewel: Unusually Small Starstone
        if PST:SC_getSnapshotMod("unusuallySmallStarstone", false) then
            itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_PLUTO)
            player:AddInnateCollectible(CollectibleType.COLLECTIBLE_PLUTO)
            if playerTwin then
                playerTwin:AddInnateCollectible(CollectibleType.COLLECTIBLE_PLUTO)
            end
            PST:addModifiers({ tears = -0.7, damagePerc = -30 }, true)
        end
        -- Ancient starcursed jewel: Primordial Kaleidoscope
        if PST:SC_getSnapshotMod("primordialKaleidoscope", false) then
            itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE)
            itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_FRUIT_CAKE)
            player:AddInnateCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE)
            player:AddInnateCollectible(CollectibleType.COLLECTIBLE_FRUIT_CAKE)
            if playerTwin then
                playerTwin:AddInnateCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE)
                playerTwin:AddInnateCollectible(CollectibleType.COLLECTIBLE_FRUIT_CAKE)
            end
            player:AddSmeltedTrinket(TrinketType.TRINKET_RAINBOW_WORM)
            PST:addModifiers({ luck = -3 }, true)
        end
        -- Ancient starcursed jewel: Teprucord Tenican Eljwe
        if PST:SC_getSnapshotMod("teprucordTenicanEljwe", false) then
            player:AddCollectible(CollectibleType.COLLECTIBLE_MISSING_NO)
            player:AddCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
        end
        -- Ancient starcursed jewel: Cause Converter
        local tmpAncient = PST:SC_getSocketedAncient("Cause Converter")
        if tmpAncient and tmpAncient.converted then
            if tmpAncient.status == "seeking" then tmpAncient.status = "converted" end
            PST:addModifiers({
                tearsPerc = -80,
                SC_causeConvBoss = tmpAncient.converted,
                SC_causeConvBossVariant = tmpAncient.convertedVariant or 0
            }, true)
        end
        -- Ancient starcursed jewel: Tellurian Splinter
        if PST:SC_getSnapshotMod("tellurianSplinter", false) then
            itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_TERRA)
            player:AddCollectible(CollectibleType.COLLECTIBLE_TERRA)
            PST:addModifiers({ damage = -1.5, speedPerc = -50 }, true)
        end
        -- Ancient starcursed jewel: Mightstone
        if PST:SC_getSnapshotMod("mightstone", false) then
            itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_CHAMPION_BELT)
            player:AddCollectible(CollectibleType.COLLECTIBLE_CHAMPION_BELT)
        end
        -- Ancient starcursed jewel: Crystallized Anamnesis
        if PST:SC_getSnapshotMod("crystallizedAnamnesis", false) then
            itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_PURITY)
            itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_CHAOS)
            player:AddCollectible(CollectibleType.COLLECTIBLE_PURITY)
            if not player:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS) then
                player:AddInnateCollectible(CollectibleType.COLLECTIBLE_CHAOS)
            end
        end
        -- Ancient starcursed jewel: Glittering Starstone
        if PST:SC_getSnapshotMod("glitteringStarstone", false) then
            itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_SOY_MILK)
            itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER)
            player:AddCollectible(CollectibleType.COLLECTIBLE_SOY_MILK)
            player:AddCollectible(CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER)
        PST:addModifiers({ damagePerc = -50 }, true)
        end

        if next(tmpSCMods) ~= nil then
            PST:addModifiers(tmpSCMods, true)
        end
    end

    -- Astral Expeditions
    if treeActive and PST.modData.expedEnabled and PST:expedMeetsRequirements(PST.modData.expedSelDepth) then
        local expData = PST.expeditionsData[PST.modData.expedSelDepth]
        if expData and expData.selectedNode then
            PST.modData.treeModSnapshot.isExpedRun = true
            PST.modData.treeModSnapshot.expedDepth = PST.modData.expedSelDepth

            -- Astral weapon drop tiers (starts at 1, +1 every 10 depths until tier 5 max)
            PST.modData.treeModSnapshot.astralWepTierDrops = math.min(5, 1 + math.floor(PST.modData.expedSelDepth / 10))

            -- Set objective
            local origNode = expData.nodes[expData.selectedNode.col][expData.selectedNode.row]
            if origNode then
                PST.modData.treeModSnapshot.expedSelNodeCol = expData.selectedNode.col
                PST.modData.treeModSnapshot.expedSelNodeRow = expData.selectedNode.row
                PST.modData.treeModSnapshot.expedSelNodeObjName = origNode.objective.name
            end

            -- Expedition items
            for _, tmpItem in ipairs(expData.items) do
                player:AddCollectible(tmpItem)
            end

            -- Expedition implicits
            local tmpImplicits = {}
            for impName, impVal in pairs(expData.implicits) do
                if PST:strStartsWith(impName, "expedImp_") then
                    tmpImplicits[impName] = impVal
                end
            end
            if next(tmpImplicits) ~= nil then
                PST:addModifiers(tmpImplicits, true)
            end

            -- Expedition boons
            for _, boonID in ipairs(expData.boons) do
                local isUpgraded = PST:arrHasValue(expData.upgradedBoons, boonID)
                local boonData = PST.expeditionBoons[boonID]
                if boonData then
                    local tgtMods = boonData.mods
                    if isUpgraded and boonData.upgradedMods then tgtMods = boonData.upgradedMods end
                    PST:addModifiers(tgtMods, true)
                end
            end

            -- Expedition curses
            for _, curseID in ipairs(expData.curses) do
                local curseData = PST.expeditionCurses[curseID]
                if curseData and curseData.modsFunc then
                    PST:addModifiers(curseData.modsFunc(PST.modData.expedSelDepth), true)
                end
            end

            -- Boon: + starting bombs
            local tmpMod = PST:getTreeSnapshotMod("boonVolatilityBombs", 0)
            if tmpMod > 0 then
                player:AddBombs(tmpMod)
            end

            -- Boon: unexpected gift, decide how many treasure rooms for gift to show up
            if PST:getTreeSnapshotMod("boonUnexGift", 0) > 0 then
                PST:addModifiers({ boonUnexGiftsRooms = math.random(6) }, true)
            end

            -- Expedition curse: heartbroken
            tmpMod = PST:getTreeSnapshotMod("curseHeartbroken", 0)
            -- Expedition implicit: additional broken hearts
            tmpMod = PST:getTreeSnapshotMod("expedImp_heartbreak", 0)
            if tmpMod > 0 then
                player:AddBrokenHearts(tmpMod)
            end

            -- Expedition implicit: heartbreak can no longer show up
            if PST:getTreeSnapshotMod("expedImp_heartbreak", 0) > 0 then
                itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_HEARTBREAK)
            end

            -- Expedition implicit: remove quality 4 items
            tmpMod = PST:getTreeSnapshotMod("expedImp_quality4Remove", 0)
            if tmpMod > 0 then
                local pickedItems = 0
                local failsafe = 0
                while pickedItems < tmpMod and failsafe < 2000 do
                    local tmpItem = itemPool:GetCollectible(math.random(ItemPoolType.NUM_ITEMPOOLS) - 1)
                    if Isaac.GetItemConfig():GetCollectible(tmpItem).Quality == 4 then
                        itemPool:RemoveCollectible(tmpItem)
                        pickedItems = pickedItems + 1
                    end
                    failsafe = failsafe + 1
                end
            end
        end
    end

    -- Apply Sidereal tree nodes
    if treeActive and PST:isRunSidereal() then
        -- Get snapshot of tree modifiers
        for nodeID, node in pairs(PST.trees["sidereal"]) do
            if PST:isNodeAllocated("sidereal", nodeID) then
                PST:addModifiers(node.modifiers)
            end
        end

        -- Astral Forge - equipped weapon mods
        if PST:isNodeNameAllocated("sidereal", "Astral Forge") then
            local eqWeapon = PST:getEquippedAstralWep()
            if eqWeapon then
                local wepTypeData = PST.astralWepData[eqWeapon.type]

                -- Weapon implicit mod
                if eqWeapon.implicitMod then
                    local tmpModName = PST.astralWepPrefix .. wepTypeData.implicitMod.name
                    PST.modData.treeModSnapshot[tmpModName] = eqWeapon.implicitMod
                end

                -- Weapon modifiers
                if eqWeapon.mods then
                    for _, tmpMod in ipairs(eqWeapon.mods) do
                        local tmpModName = PST.astralWepPrefix .. tmpMod.name
                        PST.modData.treeModSnapshot[tmpModName] = tmpMod.rolls or true

                        -- Ancient mod rolls
                        local tmpModData = PST.astralWepMods[tmpMod.name]
                        if tmpModData.ancient then
                            local ancRolls = {}
                            for i, tmpMinRoll in ipairs(tmpModData.minRolls) do
                                local newRoll = tmpMinRoll
                                if eqWeapon.ancientUpg then
                                    newRoll = newRoll + tmpModData.upgIncrements[i] * eqWeapon.ancientUpg
                                end
                                table.insert(ancRolls, newRoll)
                            end
                            PST.modData.treeModSnapshot[tmpModName] = ancRolls
                        end
                    end
                end

                -- Astral weapon mod: greataxe implicit
                tmpMod = PST:getSnapAstralWepMod("greataxeImp")
                if tmpMod then
                    PST:addModifiers({ tearsPerc = tmpMod[3] }, true)
                end

                -- Astral weapon mod: shortbow implicit
                tmpMod = PST:getSnapAstralWepMod("shortbowImp")
                if tmpMod then
                    PST:addModifiers({ shotSpeed = tmpMod[1] }, true)
                end

                -- Astral weapon mod: bow implicit
                tmpMod = PST:getSnapAstralWepMod("bowImp")
                if tmpMod then
                    PST:addModifiers({ shotSpeed = tmpMod[1] }, true)
                end

                -- Astral weapon mod: crossbow implicit
                tmpMod = PST:getSnapAstralWepMod("crossbowImp")
                if tmpMod then
                    PST:addModifiers({ tears = tmpMod[1], shotSpeed = tmpMod[2] }, true)
                end

                -- Astral weapon mod: + base damage
                tmpMod = PST:getSnapAstralWepMod("baseDmg")
                if tmpMod then
                    PST:addModifiers({ damage = tmpMod[1] }, true)
                end

                -- Astral weapon mod: + base damage (removed for X secs when you get hit)
                tmpMod = PST:getSnapAstralWepMod("baseDmg2")
                if tmpMod then
                    PST:addModifiers({ damage = tmpMod[1] }, true)
                end

                -- Ancient weapon mod: Grey Wind
                tmpMod = PST:getSnapAstralWepMod("greyWind")
                if tmpMod then
                    PST:addModifiers({ damage = -0.6 }, true)
                end

                -- Ancient weapon mod: Executioner
                tmpMod = PST:getSnapAstralWepMod("executioner")
                if tmpMod then
                    PST:addModifiers({ damagePerc = tmpMod[1] }, true)
                end

                -- Ancient weapon mod: Nimble Twins
                tmpMod = PST:getSnapAstralWepMod("nimbleTwins")
                if tmpMod then
                    PST:addModifiers({ tearsPerc = tmpMod[1] }, true)
                end

                -- Ancient weapon mod: Lost Coral Trident
                tmpMod = PST:getSnapAstralWepMod("lostCoralTrident")
                if tmpMod then
                    player:AddInnateCollectible(CollectibleType.COLLECTIBLE_NEPTUNUS)
                    PST:addModifiers({ damagePerc = -tmpMod[1] }, true)
                end

                -- Ancient weapon mod: Oceanic Might
                if PST:getSnapAstralWepMod("oceanicMight") then
                    player:AddInnateCollectible(CollectibleType.COLLECTIBLE_AQUARIUS)
                end

                -- Ancient weapon mod: Mobripper
                tmpMod = PST:getSnapAstralWepMod("mobripper")
                if tmpMod then
                    PST:addModifiers({ damagePerc = -tmpMod[2] }, true)
                end

                -- Ancient weapon mod: Berserker's Wrath
                tmpMod = PST:getSnapAstralWepMod("berserkerWrath")
                if tmpMod then
                    PST:addModifiers({ berserkDuration = tmpMod[1] }, true)
                end

                -- Ancient weapon mod: Storm's Advance
                if PST:getSnapAstralWepMod("stormAdvance") then
                    player:AddInnateCollectible(CollectibleType.COLLECTIBLE_120_VOLT)
                end

                -- Ancient weapon mod: Quill Rain
                if PST:getSnapAstralWepMod("quillRain") then
                    player:AddInnateCollectible(CollectibleType.COLLECTIBLE_SOY_MILK)
                end

                -- Ancient weapon mod: Gilded Seeker
                tmpMod = PST:getSnapAstralWepMod("gildedSeeker")
                if tmpMod then
                    player:AddInnateCollectible(CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER)
                end

                -- Ancient weapon mod: Glowing Moonblade
                tmpMod = PST:getSnapAstralWepMod("glowingMoonblade")
                if tmpMod then
                    player:AddInnateCollectible(CollectibleType.COLLECTIBLE_LUNA)
                    PST:addModifiers({ damagePerc = -tmpMod[1], tearsPerc = -tmpMod[1] }, true)
                end

                -- Ancient weapon mod: Glowing Sunblade
                tmpMod = PST:getSnapAstralWepMod("glowingSunblade")
                if tmpMod then
                    player:AddInnateCollectible(CollectibleType.COLLECTIBLE_SOL)
                    PST:addModifiers({ damagePerc = -tmpMod[1], tearsPerc = -tmpMod[1] }, true)
                end
            end
        end

        -- Timeless Bazaar
        local charData = PST:getCurrentCharData()
        if PST:isNodeNameAllocated("sidereal", "Timeless Bazaar") and charData then
            -- Add purchased items
            if charData.bazaarPurchased then
                for _, tmpItem in ipairs(charData.bazaarPurchased) do
                    itemPool:RemoveCollectible(tmpItem)
                    player:AddCollectible(tmpItem)
                end
                charData.bazaarPurchased = {}
            end
        end
    end

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
    end

    -- Soulful Awakening node (Lazarus' tree)
    if PST:getTreeSnapshotMod("soulfulAwakening", false) then
        PST:addModifiers({ luck = 2 }, true)
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

    -- Spider Mod node
    if PST:getTreeSnapshotMod("spiderMod", false) then
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_SPIDER_MOD)
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_SPIDER_MOD)
    end

    -- Mod: -% all stats while you haven't used a soul stone matching your current character
    local tmpMod = PST:getTreeSnapshotMod("soulStoneUnusedAllstats", 0)
    if tmpMod ~= 0 then
        PST:addModifiers({ allstatsPerc = tmpMod }, true)
    end

    -- Vacuophobia node (T. Isaac's tree)
    if PST:getTreeSnapshotMod("vacuophobia", false) then
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
        player:AddCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
        PST:addModifiers({ allstatsPerc = -12 }, true)
        PST:updateCacheDelayed()
    end

    -- Fractured Die node (T. Isaac's tree)
    if PST:getTreeSnapshotMod("fracturedRemains", false) then
        player:AddCard(Card.CARD_DICE_SHARD)
    end

    -- Bloodful node (T. Magdalene's tree)
    if PST:getTreeSnapshotMod("bloodful", false) then
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_BLOOD_OATH)
        player:AddCollectible(CollectibleType.COLLECTIBLE_BLOOD_OATH)
        PST:addModifiers({ allstatsPerc = -5 }, true)
    end

    -- Lingering Malice node (T. Magdalene's tree)
    if PST:getTreeSnapshotMod("lingeringMalice", false) then
        player:AddSmeltedTrinket(TrinketType.TRINKET_LOST_CORK)
    end

    -- Stealth Tactics node (T. Judas' tree)
    if PST:getTreeSnapshotMod("stealthTactics", false) then
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_9_VOLT)
        player:AddCollectible(CollectibleType.COLLECTIBLE_9_VOLT)
    end

    -- Sloth's Legacy node (T. Blue Baby's tree)
    if PST:getTreeSnapshotMod("slothLegacy", false) then
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD)
        player:AddCollectible(CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD, 2)
    end

    -- Bloodwrath node (T. Eve's tree)
    if PST:getTreeSnapshotMod("bloodwrath", false) then
        player:AddMaxHearts(2)
        player:SetFullHearts()
    end

    -- Congealed Buddy node (T. Eve's tree)
    if PST:getTreeSnapshotMod("congealedBuddy", false) then
        player:AddSmeltedTrinket(TrinketType.TRINKET_LIL_CLOT)
    end

    -- Mystic Vampirism node (T. Eve's tree)
    if PST:getTreeSnapshotMod("mysticVampirism", false) then
        player:AddCollectible(CollectibleType.COLLECTIBLE_CHARM_VAMPIRE)
    end

    -- Balanced Approach node (T. Samson's tree)
    if PST:getTreeSnapshotMod("balancedApproach", false) then
        player:AddCollectible(CollectibleType.COLLECTIBLE_LIBRA)
    end

    -- Violent Marauder node (T. Samson's tree)
    if PST:getTreeSnapshotMod("violentMarauder", false) then
        player:AddCollectible(CollectibleType.COLLECTIBLE_SUPLEX)
    end

    -- Absolute Rage node (T. Samson's tree)
    if PST:getTreeSnapshotMod("absoluteRage", false) then
        player:AddCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK, true)
        if not PST:getTreeSnapshotMod("tempered", false) then
            PST:addModifiers({ berserkTears = -30 }, true)
        end
    end

    -- Gilded Regrowth node (T. Azazel's tree)
    if PST:getTreeSnapshotMod("gildedRegrowth", false) then
        ---@diagnostic disable-next-line: param-type-mismatch
        player:AddSmeltedTrinket(TrinketType.TRINKET_BAT_WING | TrinketType.TRINKET_GOLDEN_FLAG)
    end

    -- Brimsoul node (T. Azazel's tree)
    if PST:getTreeSnapshotMod("brimsoul", false) then
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE)
    end

    -- Spiritus node (T. Lazarus' tree)
    if PST:getTreeSnapshotMod("spiritus", false) then
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
    end

    -- Serendipitous Soul node (T. Eden's tree)
    if PST:getTreeSnapshotMod("serendipitousSoul", false) then
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
        player:AddCollectible(CollectibleType.COLLECTIBLE_EDENS_SOUL)
    end

    -- Crucific node (T. Eden's tree)
    if PST:getTreeSnapshotMod("blessedCrucifix", false) then
        player:AddSmeltedTrinket(TrinketType.TRINKET_WOODEN_CROSS)
    end

    -- Chaos Take The World node (T. Eden's tree)
    if PST:getTreeSnapshotMod("chaosTakeTheWorld", false) then
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_CHAOS)
    end

    -- Glass Specter node (T. Lost's tree)
    if PST:getTreeSnapshotMod("glassSpecter", false) then
        for i=0,1 do
            tmpCard = player:GetCard(i)
            if tmpCard == Card.CARD_HOLY then
                player:RemovePocketItem(0)
            end
        end
    end

    -- Spin-down node (T. Lost's tree)
    if PST:getTreeSnapshotMod("spindown", false) then
        player:AddCollectible(CollectibleType.COLLECTIBLE_SPINDOWN_DICE)
    end

    -- Mighty Gestation (T. Lilith's tree)
    if PST:getTreeSnapshotMod("mightyGestation", false) then
        player:AddSmeltedTrinket(TrinketType.TRINKET_BABY_BENDER)
    end

    -- Chimeric Amalgam (T. Lilith's tree)
    if PST:getTreeSnapshotMod("chimericAmalgam", false) then
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
    end

    -- Strange Coupon node (T. Keeper's tree)
    if PST:getTreeSnapshotMod("strangeCoupon", false) then
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_COUPON)
        player:AddCollectible(CollectibleType.COLLECTIBLE_COUPON)
    end

    -- Voodoo Trick node (T. Keeper's tree)
    if PST:getTreeSnapshotMod("voodooTrick", false) then
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_VOODOO_HEAD)
    end

    -- Mod: % chance for fired tears to be coin tears from Head of the Keeper. Above 40% total chance, Head of the Keeper no longer shows up
    if PST:getTreeSnapshotMod("coinTearsChance", 0) > 40 then
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER)
    end

    -- Electrified Swarm node (T. Apollyon's tree)
    if PST:getTreeSnapshotMod("electrifiedSwarm", false) then
        player:AddSmeltedTrinket(TrinketType.TRINKET_EXTENSION_CORD)
    end

    -- Recall! node (T. Forgotten's tree)
    if PST:getTreeSnapshotMod("forgRecall", false) then
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
        player:AddCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
    end

    -- Magnetized Shell node (T. Forgotten's tree)
    if PST:getTreeSnapshotMod("magnetizedShell", false) then
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_STRANGE_ATTRACTOR)
        player:AddCollectible(CollectibleType.COLLECTIBLE_STRANGE_ATTRACTOR)
    end

    -- Otherside Seeker node (T. Bethany's tree)
    if PST:getTreeSnapshotMod("othersideSeeker", false) then
        for _=1,3 do
            player:AddSmeltedTrinket(TrinketType.TRINKET_CRYSTAL_KEY)
        end
    end

    -- Reaper Wraiths node (T. Jacob's tree)
    if PST:getTreeSnapshotMod("reaperWraiths", false) then
        player:AddCollectible(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
    end

    -- Song Of The Few node (T. Siren's tree)
    if PST:getTreeSnapshotMod("songOfTheFew", false) then
        player:AddSmeltedTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY)
    end

    -- Mod: +seconds to the boss rush door timer
    tmpMod = PST:getTreeSnapshotMod("bossRushTimer", 0)
    -- Beast-hunter's Rush node
    if PST:getTreeSnapshotMod("beasthunterRush", false) then
        tmpMod = tmpMod * 3
    end
    if tmpMod > 0 then
        Game().BossRushParTime = Game().BossRushParTime + math.ceil(tmpMod * 30)
    end

    -- Mod: +seconds to the hush door timer
    tmpMod = PST:getTreeSnapshotMod("hushTimer", 0)
    if tmpMod > 0 then
        Game().BlueWombParTime = Game().BlueWombParTime + math.ceil(tmpMod * 30)
    end

    -- Mod: +- boss rush waves
    tmpMod = PST:getTreeSnapshotMod("bossRushWaves", 0)
    if tmpMod ~= 0 then
        Ambush.SetMaxBossrushWaves(15 + tmpMod)
    end

    -- Update familiars
    local tmpFamiliars = PST:getRoomFamiliars()
    if tmpFamiliars > 0 then
        PST:addModifiers({ totalFamiliars = { value = tmpFamiliars, set = true } }, true)
    end

    local remove1UPItems = false

    -- Expedition curse: mortality
    if PST:getTreeSnapshotMod("curseMortality", false) then
        remove1UPItems = true
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
        remove1UPItems = true
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
        local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.treeMods.cosmicRCache)
        cosmicRCache.TLazarusBank1.red = player:GetHearts()
        cosmicRCache.TLazarusBank1.max = player:GetMaxHearts()
        cosmicRCache.TLazarusBank1.soul = player:GetSoulHearts()
        cosmicRCache.TLazarusBank1.black = player:GetBlackHearts()
        cosmicRCache.TLazarusBank1.bone = player:GetBoneHearts()
        cosmicRCache.TLazarusBank1.rotten = player:GetRottenHearts()
        cosmicRCache.TLazarusBank1.broken = player:GetBrokenHearts()
        cosmicRCache.TLazarusBank1.eternal = player:GetEternalHearts()
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

    -- Extra life items pool removal
    if remove1UPItems then
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_1UP)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_DEAD_CAT)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_INNER_CHILD)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_GUPPYS_COLLAR)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_ANKH)
        itemPool:RemoveTrinket(TrinketType.TRINKET_BROKEN_ANKH)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
        itemPool:RemoveTrinket(TrinketType.TRINKET_MISSING_POSTER)
    end

    PST:closeTreeMenu(true)
    PST.player = player
    PST.gameInit = true

    PST:updateCacheDelayed()

    -- Initial level & room funcs
    PST:onNewLevel()
    PST:onNewRoom()

    PST:save()

    -- Create backup if available
    if PST_BackupSave then
        PST_BackupSave(PST.saveSlot, PST.config.maxBackups, PST.modData.level)
        print("PST: Created backup for slot", PST.saveSlot)
    end
end