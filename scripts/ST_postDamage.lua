-- Post entity damage
---@param target Entity
---@param damage number
---@param flag DamageFlag
---@param source EntityRef
function PST:postDamage(target, damage, flag, source)
    if target and target.Type ~= EntityType.ENTITY_GIDEON then
        local isKillingHit = target.HitPoints <= damage

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
        end

        if source and source.Entity then
            -- Check if a familiar hit/killed enemy
            tmpFamiliar = source.Entity:ToFamiliar()
            if tmpFamiliar == nil and source.Entity.SpawnerEntity ~= nil then
                -- For tears shot by familiars
                tmpFamiliar = source.Entity.SpawnerEntity:ToFamiliar()
            end
            if tmpFamiliar and target:IsActiveEnemy(false) and target:IsVulnerableEnemy() and target.Type ~= EntityType.ENTITY_BLOOD_PUPPY then
                -- Dead bird
                if tmpFamiliar.Variant == FamiliarVariant.DEAD_BIRD then
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
                end

                -- Mod: chance for enemies killed by familiars to drop an additional 1/2 soul heart
                local tmpMod = PST:getTreeSnapshotMod("familiarKillSoulHeart", 0)
                if tmpMod > 0 and target.SpawnerType == 0 and isKillingHit and 100 * math.random() < tmpMod then
                    Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, target.Position, Vector.Zero, nil, HeartSubType.HEART_HALF_SOUL, Random() + 1)
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
            else
                -- Player hit to enemy (direct/through tears)
                local srcPlayer = source.Entity:ToPlayer()
                if srcPlayer == nil then
                    if source.Entity.Parent then
                        srcPlayer = source.Entity.Parent:ToPlayer()
                    end
                    if srcPlayer == nil and source.Entity.SpawnerEntity then
                        srcPlayer = source.Entity.SpawnerEntity:ToPlayer()
                    end
                end
                if srcPlayer and target:IsVulnerableEnemy() then
                    -- Player effect hit
                    if source.Entity.Variant == EntityType.ENTITY_EFFECT then
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
                            if tmpMod > 0 and target.HitPoints <= isKillingHit then
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
        end
    end
end