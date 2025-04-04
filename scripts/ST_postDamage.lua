-- Post entity damage
---@param target Entity
---@param damage number
---@param flag DamageFlag
---@param source EntityRef
function PST:postDamage(target, damage, flag, source)
    local targetPlayer = target:ToPlayer()

    -- Check if player got hit
    if targetPlayer then
        -- Expedition boon: chance for invulnerability frames to be 2x as long
        tmpMod = PST:getTreeSnapshotMod("boonIntangibility", 0)
        if tmpMod > 0 and 100 * math.random() < tmpMod then
            targetPlayer:SetMinDamageCooldown(math.ceil(targetPlayer:GetDamageCooldown() * 2.5))
        end
    elseif target and target.Type ~= EntityType.ENTITY_GIDEON then
        local isKillingHit = target:HasMortalDamage()

        -- Starcursed modifiers
        if target:IsActiveEnemy(false) then
            -- One-shot protection: if the first and only hit this mob ever receives would've killed it, prevent damage and set its health to 10%
            tmpMod = PST:SC_getSnapshotMod("mobOneShotProt", nil)
            if tmpMod ~= nil then
                if target.InitSeed and not PST.specialNodes.oneShotProtectedMobs[target.InitSeed] then
                    PST.specialNodes.oneShotProtectedMobs[target.InitSeed] = true
                    if isKillingHit then
                        target.HitPoints = target.MaxHitPoints * 0.1
                        blockedDamage = true
                    end
                end
            end
        end

        -- Check if a familiar got hit
        local tmpFamiliar = target:ToFamiliar()
        if tmpFamiliar then
            -- Wisp
            if target.Variant == FamiliarVariant.WISP then
                -- Will-o-the-Wisp node (Bethany's tree)
                if PST:getTreeSnapshotMod("willOTheWisp", false) then
                    if isKillingHit and PST:getTreeSnapshotMod("willOTheWispDmgBuff", 0) < 2.5 then
                        PST:addModifiers({ damage = 0.5, willOTheWispDmgBuff = 0.5 }, true)
                    end
                end

                -- Mod: +luck when a wisp is destroyed, up to +2
                local tmpBonus = PST:getTreeSnapshotMod("wispDestroyedLuck", 0)
                local tmpTotal = PST:getTreeSnapshotMod("wispDestroyedLuckTotal", 0)
                if tmpBonus ~= 0 and tmpTotal < 2 and isKillingHit then
                    local tmpAdd = math.min(tmpBonus, 2 - tmpTotal)
                    PST:addModifiers({ luck = tmpAdd, wispDestroyedLuckTotal = tmpAdd }, true)
                end
            -- Item wisps
            elseif target.Variant == FamiliarVariant.ITEM_WISP then
                -- Inherited Chaos node (T. Bethany's tree)
                if PST:getTreeSnapshotMod("inheritedChaos", false) and isKillingHit and target.SubType == CollectibleType.COLLECTIBLE_CHAOS and
                PST:getTreeSnapshotMod("inheritedChaosDebuff", 0) < 12 then
                    PST:addModifiers({ allstatsPerc = -3, inheritedChaosDebuff = 3 }, true)
                end

                local tmpMod = PST:getTreeSnapshotMod("destroyedWispItem", 0)
                if tmpMod > 0 and isKillingHit and 100 * math.random() < tmpMod then
                    local tmpItemList = PST:getTreeSnapshotMod("destroyedWispItemList", nil)
                    if tmpItemList then
                        PST:getPlayer():AddCollectible(tmpFamiliar.SubType, 0, false)
                        table.insert(tmpItemList, tmpFamiliar.SubType)
                        PST:createFloatTextFX("Gained wisp item!", Vector.Zero, PST:RGBColor(198, 112, 251), 0.13, 90, true)
                    end
                end
            end
        end

        if source and source.Entity and target.Type ~= EntityType.ENTITY_FIREPLACE then
            local srcPlayer = source.Entity:ToPlayer()

            -- Check if a familiar hit/killed enemy
            tmpFamiliar = source.Entity:ToFamiliar()
            if tmpFamiliar == nil and source.Entity.SpawnerEntity ~= nil then
                -- For tears shot by familiars
                tmpFamiliar = source.Entity.SpawnerEntity:ToFamiliar()
            end
            if tmpFamiliar and target:IsActiveEnemy(false) and target:IsVulnerableEnemy() and target.Type ~= EntityType.ENTITY_BLOOD_PUPPY then
                -- Dead bird
                if tmpFamiliar.Variant == FamiliarVariant.DEAD_BIRD or tmpFamiliar.Variant == FamiliarVariant.EVES_BIRD_FOOT then
                    -- Carrion Avian node (Eve's tree)
                    if PST:getTreeSnapshotMod("carrionAvian", false) and isKillingHit then
                        -- +0.15 damage when dead bird kills an enemy, up to +3. Permanent +0.6 if boss
                        if not target:IsBoss() then
                            if PST:getTreeSnapshotMod("carrionAvianTempBonus", 0) < 3 then
                                PST:addModifiers({ damage = 0.15, carrionAvianTempBonus = 0.15 }, true)
                            end
                        elseif PST:getTreeSnapshotMod("carrionAvianBossProc", 0) < 2 then
                            PST:addModifiers({ damage = 0.6, carrionAvianBossProc = 1 }, true)
                        end
                    end

                    -- Phantomcrows node (Eve's tree)
                    if PST:getTreeSnapshotMod("phantomcrows", false) and not PST:getTreeSnapshotMod("phantomcrowsProc", false) and 100 * math.random() < 0.5 then
                        Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.EVES_BIRD_FOOT, 0, source.Position, RandomVector() * 4, PST:getPlayer())
                        PST:addModifiers({ phantomcrowsProc = true }, true)
                    end
                -- Locusts / locust trinkets
                elseif tmpFamiliar.Variant == FamiliarVariant.ABYSS_LOCUST or (tmpFamiliar.Variant == FamiliarVariant.BLUE_FLY and tmpFamiliar.SubType >= 1 and tmpFamiliar.SubType <= 5) then
                    if isKillingHit then
                        -- Carrion Locusts node (T. Apollyon's tree)
                        if PST:getTreeSnapshotMod("carrionLocusts", false) then
                            local statsCache = PST:getTreeSnapshotMod("carrionLocustStats", nil)
                            if statsCache then
                                local randStat = PST:getRandomStat() .. "Perc"
                                if not statsCache[randStat] then
                                    statsCache[randStat] = 0
                                end
                                if statsCache[randStat] < 12 then
                                    statsCache[randStat] = statsCache[randStat] + 1
                                    PST:addModifiers({ [randStat] = 1 }, true)
                                end

                                PST:addModifiers({ carrionLocustKills = 1 }, true)
                                if PST:getTreeSnapshotMod("carrionLocustKills", 0) == 20 then
                                    local newLocust = PST.locustTrinketsNonGold[math.random(#PST.locustTrinketsNonGold)]
                                    local failsafe = 0
                                    while PST:getPlayer():HasTrinket(newLocust) and failsafe < 100 do
                                        newLocust = PST.locustTrinketsNonGold[math.random(#PST.locustTrinketsNonGold)]
                                        failsafe = failsafe + 1
                                    end
                                    if failsafe < 100 then
                                        PST:getPlayer():AddSmeltedTrinket(newLocust)
                                    end
                                    PST:addModifiers({ carrionLocustKills = { value = 0, set = true } }, true)
                                end
                            end
                        end

                        -- Mod: % chance for enemies killed by locusts to drop an additional coin/key/bomb, up to twice per room
                        local tmpMod = PST:getTreeSnapshotMod("locustKillPickup", 0)
                        if tmpMod > 0 and PST:getTreeSnapshotMod("locustKillPickupProcs", 0) < 2 and 100 * math.random() < tmpMod then
                            local tmpPickups = {
                                {PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY},
                                {PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL},
                                {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL}
                            }
                            local newPickup = tmpPickups[math.random(#tmpPickups)]
                            Game():Spawn(EntityType.ENTITY_PICKUP, newPickup[1], target.Position, Vector.Zero, nil, newPickup[2], Random() + 1)
                            PST:addModifiers({ locustKillPickupProcs = 1 }, true)
                        end

                        -- Mod: +% tears for 2 seconds when a locust kills an enemy
                        if PST:getTreeSnapshotMod("locustKillTears", 0) > 0 then
                            if PST.specialNodes.locustKillTearsTimer == 0 then
                                PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
                            end
                            PST.specialNodes.locustKillTearsTimer = 60
                        end

                        -- Mod: % chance to gain +0.04 luck when a locust kills an enemy
                        tmpMod = PST:getTreeSnapshotMod("locustKillLuck", 0)
                        if tmpMod > 0 and 100 * math.random() < tmpMod then
                            PST:addModifiers({ luck = 0.04, locustKillLuckBuff = 0.04 }, true)
                        end
                    end
                -- Item wisps
                elseif tmpFamiliar.Variant == FamiliarVariant.ITEM_WISP then
                    if isKillingHit then
                        -- Resilient Flickers node (T. Bethany's tree)
                        if PST:getTreeSnapshotMod("resilientFlickers", false) and tmpFamiliar.HitPoints < tmpFamiliar.MaxHitPoints then
                            tmpFamiliar.HitPoints = tmpFamiliar.MaxHitPoints
                        end

                        -- Mod: % chance for enemies killed by wisps or their tears to drop a 1/2 soul heart if you have less than 3 soul hearts
                        local tmpMod = PST:getTreeSnapshotMod("wispKillSoul", 0)
                        if tmpMod > 0 and PST:getPlayer():GetSoulHearts() < 6 and PST:getTreeSnapshotMod("wispKillSoulDrops", 0) < 4 and 100 * math.random() < tmpMod then
                            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, target.Position, Vector.Zero, nil, HeartSubType.HEART_HALF_SOUL, Random() + 1)
                            PST:addModifiers({ wispKillSoulDrops = 1 }, true)
                        end
                    end
                end

                -- Mod: chance for enemies killed by familiars to drop an additional 1/2 soul heart
                local tmpMod = PST:getTreeSnapshotMod("familiarKillSoulHeart", 0)
                if tmpMod > 0 and target.SpawnerType == 0 and isKillingHit and 100 * math.random() < tmpMod then
                    Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, target.Position, Vector.Zero, nil, HeartSubType.HEART_HALF_SOUL, Random() + 1)
                end

                -- Astral weapon mod: +% damage dealt for X seconds after a familiar kills an enemy
                tmpMod = PST:getSnapAstralWepMod("famKillDmg")
                if tmpMod then
                    PST.specialNodes.astralwep_famKillTimer = math.ceil(tmpMod[2] * 30)
                end

                -- Sidereal Artifact objective/condition: kill monsters with familiar damage
                if isKillingHit then
                    PST:sideArtiObjProgress("allianceSeptentrion", 1)
                    if PST:getTreeSnapshotMod("allianceSeptentrion", false) then
                        PST:sideArtiAddEnergy(PST.sideArtiData.allianceSeptentrion.energy)
                    end

                    -- Sidereal Artifact objective: kill boss monsters with familiar damage
                    if target:IsBoss() then
                        PST:sideArtiObjProgress("virtuousMeridion", 1)
                    end
                end
            -- Bomb hits enemy
            elseif source.Type == EntityType.ENTITY_BOMB then
                -- Troll bomb hit
                if source.Variant == BombVariant.BOMB_TROLL or source.Variant == BombVariant.BOMB_SUPERTROLL then
                    -- Mod: +luck if troll bomb kills enemy
                    local tmpMod = PST:getTreeSnapshotMod("trollBombKillLuck", 0)
                    if tmpMod > 0 and isKillingHit then
                        PST:addModifiers({ luck = tmpMod }, true)
                    end
                end

                -- Anarchy node (T. Judas' tree)
                if PST:getTreeSnapshotMod("anarchy", false) and isKillingHit then
                    local srcPlayer = PST:getPlayer()
                    local tmpSlot = srcPlayer:GetActiveItemSlot(CollectibleType.COLLECTIBLE_DARK_ARTS)
                    if tmpSlot ~= -1 then
                        srcPlayer:SetActiveCharge(srcPlayer:GetActiveCharge(tmpSlot) + 15, tmpSlot)
                    end
                end
            -- Dark Esau hit
            elseif source.Type == EntityType.ENTITY_DARK_ESAU then
                if isKillingHit then
                    -- Mod: % chance to gain +luck when Dark Esau kills an enemy
                    local tmpMod = PST:getTreeSnapshotMod("darkEsauKillLuck", 0)
                    if tmpMod > 0 and 100 * math.random() < tmpMod then
                        PST:addModifiers({ luck = 0.04, darkEsauKillLuckBuff = 0.04 }, true)
                    end
                end
            else
                -- Player hit to enemy (direct/through tears)
                if srcPlayer == nil then
                    if source.Entity.Parent then
                        srcPlayer = source.Entity.Parent:ToPlayer()
                    end
                    if srcPlayer == nil and source.Entity.SpawnerEntity then
                        srcPlayer = source.Entity.SpawnerEntity:ToPlayer()
                    end
                end
                if srcPlayer and target:IsVulnerableEnemy() then
                    -- Player tear hit
                    if source.Entity.Type == EntityType.ENTITY_TEAR then
                        -- T. Forgotten bone tears
                        if source.Entity.Variant == TearVariant.BONE and source.Entity.SpawnerEntity:ToPlayer():GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B and
                        isKillingHit then
                            -- Mod: % chance to gain +0.04 luck when T. Forgotten's bone tears kill an enemy
                            local tmpMod = PST:getTreeSnapshotMod("forgBoneTearKillLuck", 0)
                            if tmpMod > 0 and 100 * math.random() < tmpMod then
                                PST:addModifiers({ luck = 0.03, forgBoneTearLuckBuff = 0.03 }, true)
                            end
                        end

                        -- Sidereal Artifact objective: kill monsters with tears
                        if isKillingHit then
                            PST:sideArtiObjProgress("flowingMeridion", 1)
                        end
                    -- Player effect hit
                    elseif source.Entity.Type == EntityType.ENTITY_EFFECT then
                        -- Dark Arts
                        if source.Entity.Variant == EffectVariant.DARK_SNARE then
                            -- Bounty For The Lightless node (T. Judas' tree)
                            if PST:getTreeSnapshotMod("lightlessBounty", false) and isKillingHit then
                                if PST:GetBlackHeartCount(srcPlayer) < 8 and 100 * math.random() < 15 then
                                    srcPlayer:AddBlackHearts(1)
                                end

                                local tmpLuck = PST:getTreeSnapshotMod("lightlessBountyLuck", 0)
                                if tmpLuck < 1 then
                                    local tmpAdd = math.min(0.03, 1 - tmpLuck)
                                    PST:addModifiers({ luck = tmpAdd, lightlessBountyLuck = tmpAdd }, true)
                                end
                            end

                            -- Mod: +% random stat every 12 Dark Arts kills
                            tmpMod = PST:getTreeSnapshotMod("darkArtsKillStat", 0)
                            if tmpMod > 0 and isKillingHit then
                                PST:addModifiers({ darkArtsKills = 1 }, true)
                                if PST:getTreeSnapshotMod("darkArtsKills", 0) >= 10 then
                                    local randStat = PST:getRandomStat()
                                    PST:addModifiers({
                                        [randStat .. "Perc"] = tmpMod,
                                        darkArtsKills = { value = 0, set = true }
                                    }, true)
                                    local buffTable = PST:getTreeSnapshotMod("darkArtsKillStatBuffs", PST.treeMods.darkArtsKillStatBuffs)
                                    if not buffTable[randStat .. "Perc"] then
                                        buffTable[randStat .. "Perc"] = tmpMod
                                    else
                                        buffTable[randStat .. "Perc"] = buffTable[randStat .. "Perc"] + tmpMod
                                    end
                                end
                            end
                        end
                    -- Laser hit
                    elseif (flag & DamageFlag.DAMAGE_LASER) > 0 then
                        if isKillingHit then
                            -- Sidereal Artifact objective: kill enemies with lasers
                            PST:sideArtiObjProgress("brimMeridion", 1)
                        end
                    -- Direct non-tear player hit to enemy (e.g. melee hits)
                    elseif source.Entity.Type == EntityType.ENTITY_PLAYER and flag == 0 then
                        -- Ransacking node (T. Cain's tree)
                        if PST:getTreeSnapshotMod("ransacking", false) and isKillingHit then
                            if PST:getTreeSnapshotMod("ransackingRoomPickups", 0) < 5 and 100 * math.random() < 10 then
                                local tmpNewPickup = PST:getTCainRandPickup()
                                Game():Spawn(EntityType.ENTITY_PICKUP, tmpNewPickup[1], target.Position, Vector.Zero, nil, tmpNewPickup[2], Random() + 1)
                                PST:addModifiers({ ransackingRoomPickups = 1 }, true)
                            end
                            PST:addModifiers({ luck = 0.02 }, true)
                        end

                        -- Hemoptysis kill
                        if PST.specialNodes.hemoptysisFired > 0 and isKillingHit then
                            -- Mod: % chance to gain 0.03 luck when killing enemies with Hemoptysis
                            tmpMod = PST:getTreeSnapshotMod("hemoptysisKillLuck", 0)
                            if tmpMod > 0 and 100 * math.random() < tmpMod then
                                PST:addModifiers({ luck = 0.03 }, true)
                            end
                        end
                    end

                    -- Mod: chance for enemies killed by Jacob to drop 1/2 red heart, once per room
                    if 100 * math.random() < PST:getTreeSnapshotMod("jacobHeartOnKill", 0) and not PST:getTreeSnapshotMod("jacobHeartOnKillProc", false) and
                    isKillingHit and srcPlayer:GetPlayerType() == PlayerType.PLAYER_JACOB then
                        Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, target.Position, Vector.Zero, nil, HeartSubType.HEART_HALF, Random() + 1)
                        PST:addModifiers({ jacobHeartOnKillProc = true }, true)
                    end

                    -- Mod: chance for enemies killed by Esau to drop 1/2 soul heart, once per room
                    if 100 * math.random() < PST:getTreeSnapshotMod("esauSoulOnKill", 0) and not PST:getTreeSnapshotMod("esauSoulOnKillProc", false) and
                    isKillingHit and srcPlayer:GetPlayerType() == PlayerType.PLAYER_ESAU then
                        Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, target.Position, Vector.Zero, nil, HeartSubType.HEART_HALF_SOUL, Random() + 1)
                        PST:addModifiers({ esauSoulOnKillProc = true }, true)
                    end

                    -- Mod: +% to a random stat every X kills with the current form (T. Lazarus)
                    tmpMod = PST:getTreeSnapshotMod("lazFormKillStat", 0)
                    if tmpMod > 0 and PST:getTreeSnapshotMod("lazFormKillStatProcs", 0) < 8 and isKillingHit then
                        if srcPlayer:GetPlayerType() == PlayerType.PLAYER_LAZARUS2_B then
                            PST:addModifiers({ lazFormDeadKills = 1 }, true)
                            if PST:getTreeSnapshotMod("lazFormDeadKills", 0) >= 8 then
                                local randStat = PST:getRandomStat({"shotSpeed"})
                                local tmpStatCache = PST:getTreeSnapshotMod("lazFormDeadStatCache", {})
                                if not tmpStatCache[randStat .. "Perc"] then tmpStatCache[randStat .. "Perc"] = 0 end
                                tmpStatCache[randStat .. "Perc"] = tmpStatCache[randStat .. "Perc"] + tmpMod
                                PST:addModifiers({ lazFormKillStatProcs = 1, lazFormDeadKills = { value = 0, set = true } }, true)
                                PST:updateCacheDelayed()
                            end
                        else
                            PST:addModifiers({ lazFormKills = 1 }, true)
                            if PST:getTreeSnapshotMod("lazFormKills", 0) >= 8 then
                                local randStat = PST:getRandomStat({"shotSpeed"})
                                local tmpStatCache = PST:getTreeSnapshotMod("lazFormStatCache", {})
                                if not tmpStatCache[randStat .. "Perc"] then tmpStatCache[randStat .. "Perc"] = 0 end
                                tmpStatCache[randStat .. "Perc"] = tmpStatCache[randStat .. "Perc"] + tmpMod
                                PST:addModifiers({ lazFormKillStatProcs = 1, lazFormKills = { value = 0, set = true } }, true)
                                PST:updateCacheDelayed()
                            end
                        end
                    end

                    -- Mod: % chance to gain a smelted Cricket Leg when you kill an enemy
                    tmpMod = PST:getTreeSnapshotMod("killCricketLeg", 0)
                    if tmpMod > 0 and not srcPlayer:HasTrinket(TrinketType.TRINKET_CRICKET_LEG) and 100 * math.random() < tmpMod then
                        srcPlayer:AddSmeltedTrinket(TrinketType.TRINKET_CRICKET_LEG)
                        PST:addModifiers({ killCricketLegProc = true }, true)
                    end

                    -- Magnetized Shell node (T. Forgotten's tree)
                    if PST:getTreeSnapshotMod("magnetizedShell", false) and PST:getTreeSnapshotMod("magnetizedShellBuff", 0) < 20 then
                        if target.Position:Distance(srcPlayer.Position) <= 100 then
                            PST:addModifiers({ speedPerc = 2, magnetizedShellBuff = 2 }, true)
                        end
                    end

                    -- Enemies chained by Anima Sola
                    if PST:arrHasValue(PST.specialNodes.animaChainedMobs, target.InitSeed) then
                        -- Wrathful Chains node (T. Jacob's tree)
                        if PST:getTreeSnapshotMod("wrathfulChains", false) then
                            local nearbyEnemies = Isaac.FindInRadius(target.Position, 100, EntityPartition.ENEMY)
                            if #nearbyEnemies > 0 then
                                for _, tmpEnemy in ipairs(nearbyEnemies) do
                                    if tmpEnemy:IsActiveEnemy(false) and tmpEnemy:IsVulnerableEnemy() and tmpEnemy.Type ~= EntityType.ENTITY_DARK_ESAU and
                                    tmpEnemy.InitSeed ~= target.InitSeed and not PST:arrHasValue(PST.specialNodes.animaChainedMobs, tmpEnemy.InitSeed) then
                                        tmpEnemy:TakeDamage(damage * 0.4, 0, EntityRef(srcPlayer), 0)
                                    end
                                end
                            end
                        end

                        if isKillingHit then
                            -- Mod: +% tears for the current floor when killing an enemy chained by Anima Sola (reset)
                            tmpMod = PST:getTreeSnapshotMod("animaSolaKillTears", 0)
                            if tmpMod > 0 then
                                local tmpTotal = PST:getTreeSnapshotMod("animaSolaKillTearsBuff", 0)
                                if tmpTotal < 15 then
                                    local tmpAdd = math.min(tmpMod, 15 - tmpTotal)
                                    PST:addModifiers({ tearsPerc = tmpAdd, animaSolaKillTearsBuff = tmpAdd }, true)
                                end
                            end
                        end
                    end

                    local tmpNPC = target:ToNPC()
                    if tmpNPC then
                        -- Boss hit
                        if tmpNPC:IsBoss() then
                            -- Sidereal Artifact condition: Hit a boss 3 times
                            if PST:getTreeSnapshotMod("beastseekerSeptentrion", false) then
                                PST.specialNodes.arti_beastseekerHits = PST.specialNodes.arti_beastseekerHits + 1
                                if PST.specialNodes.arti_beastseekerHits >= 3 then
                                    PST.specialNodes.arti_beastseekerHits = 0
                                    PST:sideArtiAddEnergy(PST.sideArtiData.beastseekerSeptentrion.energy)
                                end
                            end

                            -- Sidereal Artifact condition: Hit a boss 8 times
                            if PST:getTreeSnapshotMod("giantseekerSeptentrion", false) then
                                PST.specialNodes.arti_giantseekerHits = PST.specialNodes.arti_giantseekerHits + 1
                                if PST.specialNodes.arti_giantseekerHits >= 8 then
                                    PST.specialNodes.arti_giantseekerHits = 0
                                    PST:sideArtiAddEnergy(PST.sideArtiData.giantseekerSeptentrion.energy)
                                end
                            end

                            -- Sidereal Artifact condition: Hit a boss affected by any status effect
                            if PST:getTreeSnapshotMod("rotseekerSeptentrion", false) and PST:entityHasAnyStatus(tmpNPC) then
                                PST:sideArtiAddEnergy(PST.sideArtiData.rotseekerSeptentrion.energy)
                            end
                        end
                    end

                    -- Sidereal Artifact condition: Hit a final boss
                    if PST:getTreeSnapshotMod("titanseekerSeptentrion") and PST:entityIsFinalBoss(target) then
                        PST:sideArtiAddEnergy(PST.sideArtiData.titanseekerSeptentrion.energy)
                    end

                    -- Sidereal Artifact: Executioner Meridion
                    if PST.specialNodes.arti_executionerBuffTimer > 0 and (target.HitPoints / target.MaxHitPoints) <= 0.15 then
                        local function PST_tmpDmgTick()
                            return function()
                                target:TakeDamage(target.MaxHitPoints, 0, EntityRef(srcPlayer), 0)
                            end
                        end
                        PST:createAnimFXAt("gfx/1000.176_cleaver slash.anm2", "Slash", target.Position - Vector(0, 12), {
                            [3] = PST_tmpDmgTick()
                        })
                    end

                    -- Ancient weapon mod: Sacred Scourge
                    local tmpMod = PST:getSnapAstralWepMod("sacredScourge")
                    if tmpMod and PST:isMobUndead(target) and isKillingHit then
                        PST.specialNodes.ancwep_sacScourgeBuff = tmpMod[1] * 30
                    end

                    -- Mod: hitting enemies affected by slow or paralysis extends the status by X seconds, up to 4 times per enemy
                    tmpMod = PST:getTreeSnapshotMod("slowParaExtension", 0)
                    if tmpMod > 0 then
                        local tgData = PST:getEntData(target)
                        if not tgData.PST_slowParaExtension then
                            tgData.PST_slowParaExtension = 0
                        end
                        if tgData.PST_slowParaExtension < 4 then
                            tgData.PST_slowParaExtension = tgData.PST_slowParaExtension + 1
                            if target:GetSlowingCountdown() > 0 then
                                target:SetSlowingCountdown(target:GetSlowingCountdown() + math.ceil(tmpMod * 30))
                            end
                            if target:GetFreezeCountdown() > 0 then
                                target:SetFreezeCountdown(target:GetFreezeCountdown() + math.ceil(tmpMod * 30))
                            end
                        end
                    end
                end
            end

            -- Hit by Gello's damaging pulse (Coordinated Demons node - T. Lilith's tree)
            if PST.specialNodes.gelloPulseDmgFlag then
                if target:IsActiveEnemy(false) then
                    -- Mod: % chance for enemies killed with Gello's damaging pulse to drop a black heart
                    local tmpMod = PST:getTreeSnapshotMod("pulseKillBlackHeart", 0)
                    if tmpMod > 0 and isKillingHit and PST:GetBlackHeartCount(PST:getPlayer()) < 4 and
                    not PST:getTreeSnapshotMod("pulseKillBlackHeartProc", false) and 100 * math.random() < tmpMod then
                        Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, target.Position, RandomVector() * 3, nil, HeartSubType.HEART_BLACK, Random() + 1)
                        PST:addModifiers({ pulseKillBlackHeartProc = true }, true)
                    end
                end
                PST.specialNodes.gelloPulseDmgFlag = false
            end

            -- Player/Familiar hit
            if srcPlayer or tmpFamiliar then
                -- Boon: chance on hit to execute enemies affected by any status effect, halve boss status effect CD
                if not isKillingHit and target:IsActiveEnemy(false) then
                    if target:GetBossStatusEffectCooldown() > 0 then
                        target:SetBossStatusEffectCooldown(math.floor(target:GetBossStatusEffectCooldown() / 2))
                    end
                    if PST:entityHasAnyStatus(target) then
                        local tmpMod = PST:getTreeSnapshotMod("boonMercyChance", 0)
                        local hpPerc = target.HitPoints / target.MaxHitPoints
                        if tmpMod > 0 and hpPerc <= PST:getTreeSnapshotMod("boonMercyHP", 0) / 100 and 100 * math.random() < tmpMod then
                            SFXManager():Play(SoundEffect.SOUND_KNIFE_PULL, 0.8)
                            target:TakeDamage(target.MaxHitPoints, 0, EntityRef(srcPlayer or tmpFamiliar), 0)
                        end
                    end
                end

                -- Ancient weapon mod: Grey Wind
                tmpMod = PST:getSnapAstralWepMod("greyWind")
                if tmpMod and PST.specialNodes.ancwep_greyWindCD == 0 and 100 * math.random() < tmpMod[1] then
                    local nearbyEnem = Isaac.FindInRadius(target.Position, 100, EntityPartition.ENEMY)
                    if #nearbyEnem > 0 then
                        for _, tmpEnemy in ipairs(nearbyEnem) do
                            if tmpEnemy:IsActiveEnemy(false) and tmpEnemy:IsVulnerableEnemy() and not EntityRef(tmpEnemy).IsFriendly then
                                local function PST_tmpDmgTick(dmg)
                                    return function()
                                        local tmpDamage = dmg
                                        if #nearbyEnem <= 3 then
                                            tmpDamage = tmpDamage * 1.5
                                            tmpEnemy:AddBleeding(EntityRef(srcPlayer or tmpFamiliar), 90)
                                        end
                                        tmpEnemy:TakeDamage(tmpDamage, 0, EntityRef(srcPlayer or tmpFamiliar), 0)
                                    end
                                end
                                PST:createAnimFXAt("gfx/1000.176_cleaver slash.anm2", "Slash", tmpEnemy.Position - Vector(0, 12), {
                                    [3] = PST_tmpDmgTick(damage * (tmpMod[2] / 100))
                                })
                            end
                        end
                        SFXManager():Play(SoundEffect.SOUND_KNIFE_PULL, 0.7, 5)
                        if #nearbyEnem > 3 then
                            PST.specialNodes.ancwep_greyWindCD = 60
                        else
                            PST.specialNodes.ancwep_greyWindCD = 150
                        end
                    end
                end

                -- Ancient weapon mod: Executioner
                tmpMod = PST:getSnapAstralWepMod("executioner")
                if tmpMod and not isKillingHit then
                    local targetHP = (target.HitPoints - damage) / target.MaxHitPoints
                    if targetHP <= tmpMod[3] / 100 and 100 * math.random() < tmpMod[2] then
                        target:TakeDamage(target.MaxHitPoints, 0, EntityRef(srcPlayer or tmpFamiliar), 0)
                        SFXManager():Play(SoundEffect.SOUND_KNIFE_PULL, 0.8, 2, false, 0.8)
                    end
                end

                -- Ancient weapon mod: Sword of Song
                tmpMod = PST:getSnapAstralWepMod("swordOfSong")
                if tmpMod then
                    -- Charming pulse
                    if PST.specialNodes.ancwep_swordOfSongCD == 0 and 100 * math.random() < tmpMod[1] then
                        local pulseSprite = PST:createAnimFXAt("gfx/1000.164_siren ring.anm2", "Idle", target.Position)
                        pulseSprite.Color = Color(1, 1, 1, 1, 0, 0, 0.5)
                        pulseSprite.PlaybackSpeed = 1.5
                        pulseSprite.Scale = Vector(0.8, 0.8)
                        SFXManager():Play(SoundEffect.SOUND_ANGEL_BEAM, 0.5, 2, false, 1.5 + 0.2 * math.random())

                        local nearbyEnem = Isaac.FindInRadius(target.Position, 120, EntityPartition.ENEMY)
                        for _, tmpEnemy in ipairs(nearbyEnem) do
                            if tmpEnemy:IsActiveEnemy(false) and tmpEnemy:IsVulnerableEnemy() and not EntityRef(tmpEnemy).IsFriendly then
                                tmpEnemy:AddCharmed(EntityRef(srcPlayer or tmpFamiliar), 120)
                            end
                        end
                        PST.specialNodes.ancwep_swordOfSongCD = 5
                    end
                    -- Damage buff + Isaac Tears proc
                    if (target:GetEntityFlags() & EntityFlag.FLAG_CHARM) > 0 and PST:getTreeSnapshotMod("ancwep_swordOfSongBuff", 0) < tmpMod[2] then
                        PST:addModifiers({ ancwep_swordOfSongBuff = 1, damagePerc = 1 }, true)
                        local tmpBuff = PST:getTreeSnapshotMod("ancwep_swordOfSongBuff", 0)
                        if tmpBuff >= tmpMod[2] then
                            local tmpPlayer = srcPlayer or PST:getPlayer()
                            tmpPlayer:UseActiveItem(CollectibleType.COLLECTIBLE_ISAACS_TEARS, UseFlag.USE_NOANIM)
                            PST:addModifiers({ damagePerc = -tmpBuff, ancwep_swordOfSongBuff = { value = 0, set = true } }, true)
                        end
                    end
                end

                -- Ancient weapon mod: Maxwell's Thermic Engine
                tmpMod = PST:getSnapAstralWepMod("maxwellEngine")
                if tmpMod then
                    if PST.specialNodes.ancwep_maxwellBuff < tmpMod[1] then
                        PST.specialNodes.ancwep_maxwellBuff = math.min(tmpMod[1], PST.specialNodes.ancwep_maxwellBuff + 0.5)
                        if PST.specialNodes.ancwep_maxwellBuff >= tmpMod[1] then
                            local tmpSprite = Sprite("gfx/ui/skilltrees/nodes/astral_weapons.anm2", true)
                            tmpSprite:SetFrame("Ancients", 34)
                            PST:createFloatIconFX(tmpSprite, Vector.Zero, 0.3, 80, true)
                            SFXManager():Play(SoundEffect.SOUND_FIREDEATH_HISS, 0.6, 2, false, 1.3)
                        end
                        PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
                    else
                        if 100 * math.random() < tmpMod[2] then
                            if math.random() < 0.5 and target:GetSlowingCountdown() == 0 then
                                target:AddBurn(EntityRef(srcPlayer or tmpFamiliar), 90, damage)
                            elseif target:GetBurnCountdown() == 0 then
                                target:AddSlowing(EntityRef(srcPlayer or tmpFamiliar), 90, 0.8, Color(0.65, 0.65, 0.9, 1))
                            end
                        end
                        if isKillingHit and 100 * math.random() < 15 then
                            if target:GetSlowingCountdown() > 0 then
                                target:AddIce(EntityRef(srcPlayer or tmpFamiliar), 90)
                            elseif target:GetBurnCountdown() > 0 then
                                Isaac.Explode(target.Position, PST:getPlayer(), 30)
                            end
                        end
                    end
                    PST.specialNodes.ancwep_maxwellBuffTimer = 90
                end

                -- Ancient weapon mod: Nimble Twins
                tmpMod = PST:getSnapAstralWepMod("nimbleTwins")
                if tmpMod and source.Entity and PST.specialNodes.ancwep_nimbleTwinsCD == 0 then
                    local tearSrcPlayer = PST:getPlayer()
                    -- Slow red tear
                    local tmpVel = (target.Position - tearSrcPlayer.Position):Normalized() * 7
                    local redTear = Game():Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, tearSrcPlayer.Position, tmpVel, source.Entity, 0, Random() + 1)
					redTear:ToTear().Height = tearSrcPlayer.TearHeight
					redTear:ToTear().FallingSpeed = -tearSrcPlayer.TearFallingSpeed * 2
                    redTear.CollisionDamage = tearSrcPlayer.Damage * (tmpMod[2] / 100)
                    redTear.Color = PST:RGBColor(225, 85, 85)
                    PST:getEntData(redTear).PST_nimbleTwinsRed = true

                    -- Fast blue tear
                    tmpVel = (target.Position - tearSrcPlayer.Position):Normalized() * 15
                    local blueTear = Game():Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, tearSrcPlayer.Position, tmpVel, source.Entity, 0, Random() + 1)
					blueTear:ToTear().Height = tearSrcPlayer.TearHeight
					blueTear:ToTear().FallingSpeed = -tearSrcPlayer.TearFallingSpeed * 2
                    blueTear.CollisionDamage = tearSrcPlayer.Damage * (tmpMod[2] / 100)
                    blueTear.Color = PST:RGBColor(85, 85, 255)
                    PST:getEntData(blueTear).PST_nimbleTwinsBlue = true

                    PST.specialNodes.ancwep_nimbleTwinsCD = 24
                end

                -- Ancient weapon mod: Gravitas
                tmpMod = PST:getSnapAstralWepMod("gravitas")
                if tmpMod and PST.specialNodes.ancwep_gravitasCD == 0 then
                    local tearSrcPlayer = PST:getPlayer()
                    local dist = tearSrcPlayer.Position:Distance(target.Position)
                    if dist > PST:getTilesDist(2) and 100 * math.random() < tmpMod[1] then
                        for i=1,3 do
                            local tmpVel = (target.Position - tearSrcPlayer.Position):Normalized() * (6 + i * 2)
                            local tmpTear = Game():Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, tearSrcPlayer.Position, tmpVel, source.Entity, 0, Random() + 1)
                            tmpTear:ToTear():AddTearFlags(TearFlags.TEAR_HOMING)
                            tmpTear:ToTear().Height = tearSrcPlayer.TearHeight
                            tmpTear:ToTear().FallingSpeed = -tearSrcPlayer.TearFallingSpeed * 2
                            tmpTear.CollisionDamage = tearSrcPlayer.Damage * (tmpMod[2] / 100)
                            tmpTear.Color = PST:RGBColor(165, 45, 220)
                            PST:getEntData(tmpTear).PST_gravitasTear = true
                        end
                        PST.specialNodes.ancwep_gravitasCD = 15
                    end
                end

                -- Ancient weapon mod: Boreal Frostspear
                tmpMod = PST:getSnapAstralWepMod("borealSpear")
                if tmpMod then
                    local tgData = PST:getEntData(target)
                    if target:GetSlowingCountdown() > 0 and PST:getPlayer().Position:Distance(target.Position) >= PST:getTilesDist(tmpMod[2]) then
                        if not tgData.PST_borealSpearHits then tgData.PST_borealSpearHits = 0 end
                        tgData.PST_borealSpearHits = tgData.PST_borealSpearHits + 1
                    end
                    if 100 * math.random() < tmpMod[1] then
                        target:AddSlowing(EntityRef(PST:getPlayer()), 90, 0.8, Color(0.6, 0.6, 0.9, 1))
                    end
                    if tgData.PST_borealSpearHits and 100 * math.random() < tgData.PST_borealSpearHits then
                        target:AddIce(EntityRef(PST:getPlayer()), 90)
                    end
                end

                -- Ancient weapon mod: Viper Stinger
                tmpMod = PST:getSnapAstralWepMod("viperStinger")
                if tmpMod then
                    local tmpChance = tmpMod[1]
                    local isPoisoned = (target:GetEntityFlags() & EntityFlag.FLAG_POISON) > 0
                    if isPoisoned then tmpChance = tmpChance * 2 end
                    if 100 * math.random() < tmpChance then
                        local tmpDur = 60
                        if isPoisoned then tmpDur = tmpDur * 2 end
                        target:AddFreeze(EntityRef(PST:getPlayer()), tmpDur)
                    end
                end

                -- Ancient weapon mod: Verdant Green
                tmpMod = PST:getSnapAstralWepMod("verdantGreen")
                if tmpMod and PST.specialNodes.ancwep_verdantCD == 0 and (flag & DamageFlag.DAMAGE_POISON_BURN) == 0 then
                    local tmpChance = tmpMod[1] + math.min(5, 30 / PST:getPlayer().MaxFireDelay)
                    if 100 * math.random() < tmpChance then
                        local function PST_verdantGreenTick(pos, modRolls)
                            return function()
                                local nearbyEnem = Isaac.FindInRadius(pos, 100, EntityPartition.ENEMY)
                                for _, tmpEnemy in ipairs(nearbyEnem) do
                                    if tmpEnemy:IsActiveEnemy(false) and tmpEnemy:IsVulnerableEnemy() and not EntityRef(tmpEnemy).IsFriendly then
                                        local dmg = PST:getPlayer().Damage * (modRolls[2] / 100)
                                        if (tmpEnemy:GetEntityFlags() & EntityFlag.FLAG_POISON) == 0 then
                                            tmpEnemy:AddPoison(EntityRef(PST:getPlayer()), 120, dmg)
                                        else
                                            tmpEnemy:TakeDamage(dmg, DamageFlag.DAMAGE_POISON_BURN, EntityRef(PST:getPlayer()), 0)
                                        end
                                    end
                                end
                            end
                        end
                        local function PST_verdantLastTick(pos)
                            return function()
                                PST:createAnimFXAt("gfx/1000.106_fartring.anm2", "Dissappear", pos)
                            end
                        end
                        -- Poison/damage ticks for poison cloud
                        local cloudTickFuncs = {}
                        for i=5,30,5 do
                            cloudTickFuncs[i] = PST_verdantGreenTick(target.Position, tmpMod)
                        end
                        -- Disappear anim
                        cloudTickFuncs[34] = PST_verdantLastTick(target.Position)
                        PST:createAnimFXAt("gfx/1000.106_fartring.anm2", "Appear", target.Position, cloudTickFuncs)
                        SFXManager():Play(SoundEffect.SOUND_DEATH_CARD, 0.8, 2, false, 1.4 + 0.2 * math.random())
                        PST.specialNodes.ancwep_verdantCD = 8
                    end
                end

                -- Ancient weapon mod: Oceanic Might
                tmpMod = PST:getSnapAstralWepMod("oceanicMight")
                local tmpChance = 10
                if target:IsFlying() then
                    tmpChance = 40
                end
                if tmpMod and (flag & DamageFlag.DAMAGE_EXPLOSION) == 0 and PST.specialNodes.ancwep_oceanicMightCD == 0 and
                100 * math.random() < tmpChance then
                    local nearbyEffects = Isaac.FindInRadius(target.Position, 60 + target.Size * 2)
                    local creepNearby = false
                    for _, tmpEffect in ipairs(nearbyEffects) do
                        if tmpEffect.Type == EntityType.ENTITY_EFFECT and PST:arrHasValue(PST.playerDamagingCreep, tmpEffect.Variant) then
                            creepNearby = true
                            break
                        end
                    end
                    if creepNearby then
                        PST:createAnimFXAt("gfx/1000.001b_water explosion.anm2", "Explosion", target.Position)
                        SFXManager():Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION, 0.8)
                        local nearbyEnem = Isaac.FindInRadius(target.Position, 80, EntityPartition.ENEMY)
                        for _, tmpEnemy in ipairs(nearbyEnem) do
                            if tmpEnemy:IsActiveEnemy(false) and tmpEnemy:IsVulnerableEnemy() and not EntityRef(tmpEnemy).IsFriendly then
                                tmpEnemy:TakeDamage(25, DamageFlag.DAMAGE_EXPLOSION, EntityRef(PST:getPlayer()), 0)
                            end
                        end
                        PST.specialNodes.ancwep_oceanicMightCD = 75
                    end
                end

                -- Ancient weapon mod: Tale Ender
                tmpMod = PST:getSnapAstralWepMod("taleEnder")
                if tmpMod then
                    if not PST.specialNodes.ancwep_taleEnderProc and not target:IsBoss() then
                        tmpChance = tmpMod[2] / (2 ^ PST:getTreeSnapshotMod("ancwep_taleEnderProcs", 0))
                        if 100 * math.random() < tmpChance then
                            PST:addModifiers({ ancwep_taleEnderProcs = 1 }, true)
                            PST:createAnimFXAt("gfx/1000.176_cleaver slash.anm2", "Slash", target.Position - Vector(0, 4), {
                                [3] = function()
                                    if target then
                                        target:TakeDamage(target.MaxHitPoints, 0, EntityRef(PST:getPlayer()), 0)
                                    end
                                end
                            })
                            SFXManager():Play(SoundEffect.SOUND_SIREN_SING_STAB, 0.8)
                        end
                        PST.specialNodes.ancwep_taleEnderProc = true
                    end
                end

                -- Ancient weapon mod: Starsteel Broadaxe
                tmpMod = PST:getSnapAstralWepMod("starsteelBroadaxe")
                if tmpMod then
                    if target:GetBleedingCountdown() > 0 then
                        PST.specialNodes.ancwep_starsteelAxeBuff = math.min(tmpMod[1], PST.specialNodes.ancwep_starsteelAxeBuff + 2)
                        PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
                    end
                    if target:IsBoss() then
                        local tmpCD = target:GetBossStatusEffectCooldown()
                        if tmpCD > 0 then target:SetBossStatusEffectCooldown(tmpCD - 15) end
                    end
                end

                -- Ancient weapon mod: Frozen Terror
                tmpMod = PST:getSnapAstralWepMod("frozenTerror")
                if tmpMod then
                    -- Slash nearby slowed enemies
                    local dist = PST:getPlayer().Position:Distance(target.Position)
                    if target:GetSlowingCountdown() > 0 and dist <= PST:getTilesDist(tmpMod[2]) and PST.specialNodes.ancwep_frozenTerrorCD == 0 then
                        local function PST_tmpDmgTick(dmg)
                            return function()
                                local nearbyEnemies = Isaac.FindInRadius(target.Position, 100, EntityPartition.ENEMY)
                                for _, tmpEnemy in ipairs(nearbyEnemies) do
                                    if tmpEnemy:IsActiveEnemy(false) and tmpEnemy:IsVulnerableEnemy() and not EntityRef(tmpEnemy).IsFriendly then
                                        tmpEnemy:TakeDamage(dmg, 0, EntityRef(srcPlayer), 0)
                                        if tmpEnemy:GetSlowingCountdown() > 0 then
                                            tmpEnemy:AddIce(EntityRef(PST:getPlayer()), 60)
                                        end
                                    end
                                end
                            end
                        end
                        PST:createAnimFXAt("gfx/effect_wepslash.anm2", "Spin", PST:getPlayer().Position, {
                            [3] = PST_tmpDmgTick(damage * (tmpMod[3] / 100))
                        })
                        SFXManager():Play(SoundEffect.SOUND_SWORD_SPIN, 0.7, 2, false, 0.75 + 0.2 * math.random())
                        PST.specialNodes.ancwep_frozenTerrorCD = 45
                    end
                    -- Slow bleeding enemies
                    if target:GetBleedingCountdown() > 0 and 100 * math.random() < tmpMod[1] then
                        target:AddSlowing(EntityRef(PST:getPlayer()), 90, 0.8, Color(0.6, 0.6, 0.9, 1))
                    end
                end

                -- Ancient weapon mod: Storm's Advance
                tmpMod = PST:getSnapAstralWepMod("stormAdvance")
                if tmpMod and PST.specialNodes.ancwep_stormAdvanceCD == 0 then
                    PST.specialNodes.ancwep_stormAdvanceHits = PST.specialNodes.ancwep_stormAdvanceHits + 1
                    if PST.specialNodes.ancwep_stormAdvanceHits >= tmpMod[1] then
                        for i=-2,2 do
                            local tmpVel = (target.Position - PST:getPlayer().Position):Normalized():Rotated(24 * i) * 10
                            local tmpTear = Game():Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, PST:getPlayer().Position, tmpVel, PST:getPlayer(), 0, Random() + 1)
                            tmpTear:ToTear():AddTearFlags(TearFlags.TEAR_JACOBS)
                            tmpTear:ToTear().Height = PST:getPlayer().TearHeight
                            tmpTear:ToTear().FallingSpeed = -PST:getPlayer().TearFallingSpeed * 2
                            tmpTear.CollisionDamage = PST:getPlayer().Damage * (tmpMod[2] / 100)
                            tmpTear.Color = PST:RGBColor(50, 180, 220)
                        end
                        PST.specialNodes.ancwep_stormAdvanceHits = 0
                        PST.specialNodes.ancwep_stormAdvanceCD = 60
                    end
                end

                -- Ancient weapon mod: Twisted Oakstring
                tmpMod = PST:getSnapAstralWepMod("twistedOakstring")
                if tmpMod and PST:getPlayer().Position:Distance(target.Position) > PST:getTilesDist(tmpMod[1]) and
                PST.specialNodes.ancwep_oakstringCD == 0 then
                    local tmpVel = (target.Position - PST:getPlayer().Position):Normalized() * 10
                    local tmpTear = Game():Spawn(EntityType.ENTITY_TEAR, TearVariant.DARK_MATTER, target.Position + tmpVel * 1.75, tmpVel, source.Entity, 0, Random() + 1)
                    tmpTear:ToTear():AddTearFlags(TearFlags.TEAR_HOMING | TearFlags.TEAR_FEAR | TearFlags.TEAR_SPECTRAL)
                    tmpTear:ToTear().Height = PST:getPlayer().TearHeight
                    tmpTear:ToTear().FallingSpeed = 0.5
                    tmpTear.CollisionDamage = PST:getPlayer().Damage * (tmpMod[2] / 100)
                    tmpTear.Color = PST:RGBColor(180, 50, 220)
                    PST.specialNodes.ancwep_oakstringCD = 15
                end

                -- Ancient weapon mod: Volatile Arbalest
                tmpMod = PST:getSnapAstralWepMod("volatileArbalest")
                if tmpMod and PST:getPlayer().Position:Distance(target.Position) > PST:getTilesDist(2.5) and (flag & DamageFlag.DAMAGE_EXPLOSION) == 0 and
                PST.specialNodes.ancwep_volatileArbalestCD == 0 and 100 * math.random() < tmpMod[1] then
                    local tmpExplosionSpr = PST:createAnimFXAt("gfx/1000.001_bomb explosion.anm2", "Explosion", target.Position)
                    tmpExplosionSpr.Scale = Vector(0.6, 0.6)
                    SFXManager():Play(SoundEffect.SOUND_EXPLOSION_WEAK, 1, 2, false, 1 + 0.25 * math.random())

                    local nearbyEnem = Isaac.FindInRadius(target.Position, 80, EntityPartition.ENEMY)
                    local tmpDmg = PST:getPlayer().Damage * (tmpMod[2] / 100)
                    for _, tmpEnemy in ipairs(nearbyEnem) do
                        if tmpEnemy:IsActiveEnemy(false) and tmpEnemy:IsVulnerableEnemy() and not EntityRef(tmpEnemy).IsFriendly then
                            tmpEnemy:TakeDamage(tmpDmg, DamageFlag.DAMAGE_EXPLOSION, EntityRef(PST:getPlayer()), 0)
                        end
                    end
                    PST.specialNodes.ancwep_volatileArbalestCD = 30
                end

                -- Ancient weapon mod: Circuit Splitter
                tmpMod = PST:getSnapAstralWepMod("circuitSplitter")
                if tmpMod and (flag & DamageFlag.DAMAGE_EXPLOSION) == 0 and target:GetBleedingCountdown() > 0 and #PST.specialNodes.ancwep_circuitEnems < 3 then
                    local isInList = false
                    for _, tmpEnemy in ipairs(PST.specialNodes.ancwep_circuitEnems) do
                        if tmpEnemy.enemy.InitSeed == target.InitSeed or (source.Entity and tmpEnemy.laser.InitSeed == source.Entity.InitSeed) then
                            isInList = true
                            break
                        end
                    end
                    if not isInList then
                        local newLaser = EntityLaser.ShootAngle(LaserVariant.THIN_RED, target.Position, 0, math.ceil(tmpMod[2] * 30), Vector.Zero, PST:getPlayer())
                        newLaser.SubType = LaserSubType.LASER_SUBTYPE_RING_PROJECTILE
                        newLaser.Radius = 50
                        newLaser.CollisionDamage = math.min(5, PST:getPlayer().Damage * (tmpMod[1] / 100))
                        table.insert(PST.specialNodes.ancwep_circuitEnems, {
                            laser = newLaser,
                            timer = math.ceil(tmpMod[2] * 30),
                            enemy = target
                        })
                    end
                end

                -- Ancient weapon mod: Firestarter
                tmpMod = PST:getSnapAstralWepMod("firestarter")
                if tmpMod and target:GetBurnCountdown() > 0 and isKillingHit and 100 * math.random() < 35 then
                    local tmpPlayer = srcPlayer or PST:getPlayer()
                    Isaac.Explode(target.Position, PST:getPlayer(), math.min(50, tmpPlayer.Damage * (tmpMod[2] / 100)))
                end

                -- Deep-Space Distortion mod: Final boss damage immunity on HP thresholds
                if PST:getTreeSnapshotMod("dsdMod_finalDmgImm", false) and not isKillingHit and PST:entityIsFinalBoss(target) then
                    local hpThreshold = 1 - 0.25 * (1 + PST:getTreeSnapshotMod("dsdMod_finalImmProcs", 0))
                    if hpThreshold > 0 and (target.HitPoints / target.MaxHitPoints) <= hpThreshold then
                        PST.specialNodes.dsdMod_finalImmTimer = 150
                        PST:addModifiers({ dsdMod_finalImmProcs = 1 }, true)
                    end
                end
            end

            local srcEntData = PST:getEntData(source.Entity)

            -- Ancient weapon mod: Nimble Twins (special tear hits)
            tmpMod = PST:getSnapAstralWepMod("nimbleTwins")
            if tmpMod then
                if srcEntData.PST_nimbleTwinsRed then
                    PST.specialNodes.ancwep_nimbleRedBuff = math.min(tmpMod[3], PST.specialNodes.ancwep_nimbleRedBuff + 3)
                    if PST.specialNodes.ancwep_nimbleRedTimer == 0 then
                        PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
                    end
                    PST.specialNodes.ancwep_nimbleRedTimer = 60
                elseif srcEntData.PST_nimbleTwinsBlue then
                    PST.specialNodes.ancwep_nimbleBlueBuff = math.min(tmpMod[3], PST.specialNodes.ancwep_nimbleBlueBuff + 3)
                    if PST.specialNodes.ancwep_nimbleBlueTimer == 0 then
                        PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
                    end
                    PST.specialNodes.ancwep_nimbleBlueTimer = 60
                end
            end

            -- Astral weapon mod: Whips
            tmpMod = PST:getSnapAstralWepMod("whipImp")
            if tmpMod then
                if srcEntData.PST_whipTear then
                    if math.random() <= 0.5 then
                        -- Speed buff
                        if PST.specialNodes.astralwep_whipSpeedBuff < tmpMod[2] then
                            PST.specialNodes.astralwep_whipSpeedBuff = math.min(tmpMod[2], PST.specialNodes.astralwep_whipSpeedBuff + tmpMod[1])
                            PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
                        end
                        PST.specialNodes.astralwep_whipSpeedTimer = tmpMod[3] * 30
                    else
                        -- Tears buff
                        if PST.specialNodes.astralwep_whipTearBuff < tmpMod[2] then
                            PST.specialNodes.astralwep_whipTearBuff = math.min(tmpMod[2], PST.specialNodes.astralwep_whipTearBuff + tmpMod[1])
                            PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
                        end
                        PST.specialNodes.astralwep_whipTearTimer = tmpMod[3] * 30
                    end
                end
            end

            -- Ancient weapon mod: Gravitas (tear hit)
            if srcEntData.PST_gravitasTear and not PST:getPlayer():HasCollectible(CollectibleType.COLLECTIBLE_SPOON_BENDER) and
            100 * math.random() < 3 then
                PST:getPlayer():AddCollectible(CollectibleType.COLLECTIBLE_SPOON_BENDER)
                PST:addModifiers({ ancwep_gravitasSpoon = true }, true)
            end

            -- Cosmic Realignment node
            if PST:cosmicRCharPicked(PlayerType.PLAYER_BETHANY_B) then
                local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.treeMods.cosmicRCache)

                -- Tainted Bethany, -4% all stats when an item wisp dies, up to -20%
                local tmpWisp = target:ToFamiliar()
                if tmpWisp and tmpWisp.Variant == FamiliarVariant.ITEM_WISP then
                    if isKillingHit then
                        if cosmicRCache.TBethanyDeadWisps < 5 then
                            cosmicRCache.TBethanyDeadWisps = cosmicRCache.TBethanyDeadWisps + 1
                            PST:addModifiers({ allstatsPerc = -4 }, true)
                        end
                    else
                        dmgMult = dmgMult - 0.7
                    end
                end
            end

            -- Deep-Space Distortion mod: Warning for sudden-death
            local tgData = PST:getEntData(target)
            if PST:getTreeSnapshotMod("dsdMod_finalLastStand", false) and PST:entityIsFinalBoss(target) and not isKillingHit and (target.HitPoints / target.MaxHitPoints) <= 0.12 and
            not tgData.PST_dsdLastStandWarn then
                PST:createFloatTextFX("!!SUDDEN DEATH!!", Vector.Zero, Color(1, 0.1, 0.1, 1), 0.1, 180, true)
                SFXManager():Play(SoundEffect.SOUND_SATAN_ROOM_APPEAR, 1, 2, false, 0.8)
                tgData.PST_dsdLastStandWarn = true
            end
        end

        -- Generic checks
        if target:IsActiveEnemy(false) and target:IsVulnerableEnemy() then
            -- Generic explosion hits enemy
            if (flag & DamageFlag.DAMAGE_EXPLOSION) > 0 then
                -- Enemy dies to explosion
                if isKillingHit then
                    -- Expedition objective: kill enemies with explosions
				    PST:expedAddProgInRun("explosions", 1)
                end
            end
        end
    end
end