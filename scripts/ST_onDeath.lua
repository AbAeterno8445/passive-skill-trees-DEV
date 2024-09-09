local clotHeartTypes = {
    HeartSubType.HEART_HALF,
    HeartSubType.HEART_HALF_SOUL,
    HeartSubType.HEART_BLACK,
    HeartSubType.HEART_ETERNAL,
    HeartSubType.HEART_GOLDEN,
    HeartSubType.HEART_BONE,
    HeartSubType.HEART_ROTTEN
}

-- On entity death
---@param entity Entity
function PST:onDeath(entity)
    local player = entity:ToPlayer()
    local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.treeMods.cosmicRCache)
    -- Player death
    if player ~= nil then
        if player:GetPlayerType() == PlayerType.PLAYER_LAZARUS then
            cosmicRCache.lazarusHasDied = true
            PST:save()
        end

        -- Soulful Awakening node (Lazarus' tree)
        if PST:getTreeSnapshotMod("soulfulAwakening", false) then
            local tmpPos = Isaac.GetFreeNearPosition(player.Position, 40)
            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, tmpPos, Vector.Zero, nil, HeartSubType.HEART_SOUL, Random() + 1)
            PST:addModifiers({ luck = -0.5 }, true)
        end
    elseif entity:IsActiveEnemy(true) and entity.Type ~= EntityType.ENTITY_BLOOD_PUPPY and not EntityRef(entity).IsFriendly and
    PST:getRoom():GetFrameCount() > 1 then
        -- Enemy death
        local room = PST:getRoom()

        local addXP = false
        if not (entity:IsBoss() and entity.Parent) or entity.Type == EntityType.ENTITY_LARRYJR then
            if entity.SpawnerType ~= 0 then
                local bonusKills = 0
                if PST:SC_getSnapshotMod("unusuallySmallStarstone", false) then
                    bonusKills = 30
                end
                if PST.modData.spawnKills < 12 + bonusKills then
                    PST.modData.spawnKills = PST.modData.spawnKills + 1
                    addXP = true
                end
            else
                addXP = true
            end
        end

        if addXP and not PST:getTreeSnapshotMod("d7Proc", false) then
            local mult = 1
            -- Reduce xp for certain bosses
            if entity.Type == EntityType.ENTITY_PEEP then
                mult = 0.33
            end

            if entity:IsBoss() then
                mult = mult + PST:getTreeSnapshotMod("xpgainBoss", 0) / 100
                local roomType = room:GetType()
                if not roomType == RoomType.ROOM_MINIBOSS and not roomType == RoomType.ROOM_BOSS then
                    mult = mult - 0.6
                end
            else
                mult = mult + PST:getTreeSnapshotMod("xpgainNormalMob", 0) / 100
            end
            PST:addTempXP(math.max(1, math.floor(mult * entity.MaxHitPoints / 2)), true)
        end

        -- Chance for champions to drop a random starcursed jewel
        local tmpNPC = entity:ToNPC()
        local levelStage = PST:getLevel():GetStage()
        if tmpNPC and tmpNPC:IsChampion() and 100 * math.random() < PST.SCDropRates.championKill(levelStage).regular then
            PST:SC_dropRandomJewelAt(entity.Position, PST.SCDropRates.championKill(levelStage).ancient)
        end
        -- Starcursed mod: spawn X static hovering tears for Y seconds on death
        local tmpMod = PST:SC_getSnapshotMod("hoveringTearsOnDeath", {0, 0})
        if tmpMod[1] > 0 and tmpMod[2] > 0 then
            local proc = true
            local isFrozen = entity:HasEntityFlags(EntityFlag.FLAG_ICE_FROZEN)
            if isFrozen then
                proc = PST:distBetweenPoints(entity.Position, PST:getPlayer().Position) > 60
            end
            if proc then
                for _=1,tmpMod[1] do
                    local newTear = Game():Spawn(
                        EntityType.ENTITY_PROJECTILE,
                        ProjectileVariant.PROJECTILE_TEAR,
                        entity.Position + Vector(-6 + 12 * math.random(), -6 + 12 * math.random()),
                        Vector.Zero,
                        entity,
                        TearVariant.BLOOD,
                        Random() + 1
                    )
                    newTear.Color = Color(1, 0.1, 0.1, 1)
                    newTear:SetPauseTime(math.max(10, 30 * tmpMod[2] - 30))
                    table.insert(PST.specialNodes.SC_hoveringTears, newTear)
                end
            end
        end
        -- Starcursed mod: X chance to release Y tears on death
        tmpMod = PST:SC_getSnapshotMod("tearExplosionOnDeath", {0, 0})
        if tmpMod[1] > 0 and tmpMod[2] > 0 and 100 * math.random() < tmpMod[1] then
            local newTear = Game():Spawn(
                EntityType.ENTITY_TEAR,
                TearVariant.BALLOON,
                entity.Position,
                Vector.Zero,
                entity,
                0,
                Random() + 1
            );
            SFXManager():Play(SoundEffect.SOUND_HEARTOUT, 0.9)
            newTear:ToTear():AddTearFlags(TearFlags.TEAR_PIERCING | TearFlags.TEAR_GROW)
            newTear:ToTear().FallingSpeed = -25
            newTear:ToTear().FallingAcceleration = 0.75
            table.insert(PST.specialNodes.SC_exploderTears, newTear.InitSeed)
        end
        -- Ancient starcursed jewel: Soul Watcher
        if PST:SC_getSnapshotMod("soulWatcher", false) then
            for i, tmpSoulEater in ipairs(PST.specialNodes.SC_soulEaterMobs) do
                if not EntityRef(tmpSoulEater.mob).IsFriendly then
                    if tmpSoulEater.mob.InitSeed == entity.InitSeed then
                        PST.specialNodes.SC_soulEaterMobs[i] = nil
                    elseif tmpSoulEater.souls < 20 then
                        local dist = PST:distBetweenPoints(tmpSoulEater.mob.Position, entity.Position)
                        if dist <= 140 then
                            tmpSoulEater.souls = tmpSoulEater.souls + 1
                            Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, tmpSoulEater.mob.Position, Vector.Zero, nil, 1, Random() + 1)
                            SFXManager():Play(SoundEffect.SOUND_VAMP_GULP, 0.3)

                            local HPBoost = 4 + tmpSoulEater.mob.MaxHitPoints * 0.04
                            tmpSoulEater.mob.MaxHitPoints = tmpSoulEater.mob.MaxHitPoints + HPBoost
                            tmpSoulEater.mob.HitPoints = math.min(tmpSoulEater.mob.MaxHitPoints, tmpSoulEater.mob.HitPoints + HPBoost)
                            if not tmpSoulEater.mob:IsBoss() or (tmpSoulEater.mob:IsBoss() and tmpSoulEater.souls < 6) then
                                tmpSoulEater.mob.Scale = tmpSoulEater.mob.Scale + 0.02
                            end
                            tmpSoulEater.mob:SetSpeedMultiplier(tmpSoulEater.mob:GetSpeedMultiplier() + tmpSoulEater.souls * 0.02)
                        end
                    end
                end
            end
        end
        -- Ancient starcursed jewel: Glace
        if PST:SC_getSnapshotMod("glace", false) then
            if entity:HasEntityFlags(EntityFlag.FLAG_ICE_FROZEN) and PST:getTreeSnapshotMod("SC_glaceDebuff", 0) > 0 then
                PST:addModifiers({ speedPerc = 0.5, tearsPerc = 0.5, SC_glaceDebuff = -0.5 }, true)
            end
        end
        -- Ancient starcursed jewel: Nullstone
        if PST:SC_getSnapshotMod("nullstone", false) then
            -- Add enemy from non-boss room to nullstone list
            if tmpNPC and not PST:getTreeSnapshotMod("SC_nullstoneProc", false) and not PST:getTreeSnapshotMod("SC_nullstoneClear", false) and
            not entity:IsBoss() and room:GetType() ~= RoomType.ROOM_BOSS and
            ((not entity.Parent and entity.MaxHitPoints >= PST:getTreeSnapshotMod("SC_nullstoneHPThreshold", 0)) or room:GetAliveEnemiesCount() == 1) then
                local nullstoneEnemyList = PST:getTreeSnapshotMod("SC_nullstoneEnemies", nil)
                if nullstoneEnemyList then
                    table.insert(nullstoneEnemyList, {
                        type = entity.Type,
                        variant = entity.Variant,
                        subtype = entity.SubType,
                        champion = tmpNPC:GetChampionColorIdx()
                    })
                    PST:addModifiers({ SC_nullstoneProc = true }, true)
                    SFXManager():Play(SoundEffect.SOUND_DEATH_CARD, 0.7, 2, false, 1.08)

                    PST.specialNodes.SC_nullstonePoofFX.x = entity.Position.X
                    PST.specialNodes.SC_nullstonePoofFX.y = entity.Position.Y
                    PST.specialNodes.SC_nullstonePoofFX.sprite:Play("Poof", true)
                    PST.specialNodes.SC_nullstonePoofFX.stoneSprite.Color = Color(1, 1, 1, 1)
                end
            -- Spawn next enemy in sequence if killing nullified enemy in boss room
            elseif not PST:getTreeSnapshotMod("SC_nullstoneClear", false) and room:GetType() == RoomType.ROOM_BOSS
            and room:GetAliveBossesCount() > 0 then
                local nullstoneList = PST:getTreeSnapshotMod("SC_nullstoneEnemies", nil)
                local currentSpawn = PST.specialNodes.SC_nullstoneCurrentSpawn
                if currentSpawn and currentSpawn.InitSeed == entity.InitSeed and nullstoneList and
                nullstoneList[PST.specialNodes.SC_nullstoneSpawned] ~= nil then
                    local spawnEntry = nullstoneList[PST.specialNodes.SC_nullstoneSpawned]
                    local tmpPos = Isaac.GetFreeNearPosition(entity.Position, 8)
                    local newSpawn = Game():Spawn(spawnEntry.type, spawnEntry.variant, tmpPos, Vector.Zero, nil, spawnEntry.subtype, Random() + 1)
                    if spawnEntry.champion >= 0 then
                        newSpawn:ToNPC():MakeChampion(newSpawn.InitSeed, spawnEntry.champion, true)
                    end
                    newSpawn.Color = Color(0.1, 0.1, 0.1, 1, 0.1, 0.1, 0.1)
                    PST.specialNodes.SC_nullstoneCurrentSpawn = newSpawn
                    PST.specialNodes.SC_nullstoneSpawned = PST.specialNodes.SC_nullstoneSpawned + 1

                    PST.specialNodes.SC_nullstonePoofFX.x = entity.Position.X
                    PST.specialNodes.SC_nullstonePoofFX.y = entity.Position.Y
                    PST.specialNodes.SC_nullstonePoofFX.stoneSprite.Color = Color(1, 1, 1, 1)
                end
            end
        end
        -- Ancient starcursed jewel: Cause Converter
        local tmpAncient = PST:SC_getSocketedAncient("Cause Converter")
        if tmpAncient and tmpAncient.status == "seeking" and entity:IsBoss() and not PST:arrHasValue(PST.causeConverterBossBlacklist, entity.Type) and
        (tmpAncient.converted ~= entity.Type or tmpAncient.converted == entity.Type and tmpAncient.convertedVariant ~= entity.Variant) then
            tmpAncient.converted = entity.Type
            tmpAncient.convertedVariant = entity.Variant
            SFXManager():Play(SoundEffect.SOUND_LIGHTBOLT, 0.9)
            PST:createFloatTextFX("Boss converted!", entity.Position, Color(0.7, 0.85, 1, 1), 0.12, 120, false)
        end
        -- Ancient starcursed jewel: Mightstone
        if PST:SC_getSnapshotMod("mightstone", false) and tmpNPC and tmpNPC:IsChampion() then
            local foundMobs = false
            for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
                otherNPC = tmpEntity:ToNPC()
                if otherNPC and not EntityRef(otherNPC).IsFriendly and otherNPC.InitSeed ~= entity.InitSeed and otherNPC:IsChampion() and
                PST:getTreeSnapshotMod("SC_mightstoneProcs", 0) < 5 then
                    local tmpPoof = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, otherNPC.Position, Vector.Zero, nil, 0, Random() + 1)
                    tmpPoof:GetSprite().Scale = Vector(1.4, 1.4)

                    local HPBoost = otherNPC.MaxHitPoints * 0.1
                    otherNPC.MaxHitPoints = otherNPC.MaxHitPoints + HPBoost
                    otherNPC.HitPoints = otherNPC.HitPoints + HPBoost * 3

                    if not otherNPC:IsBoss() then
                        otherNPC.Scale = otherNPC.Scale + 0.05
                    end
                    otherNPC:SetSpeedMultiplier(otherNPC:GetSpeedMultiplier() + (PST:getTreeSnapshotMod("SC_mightstoneProcs", 0) + 1) * 0.05)
                    foundMobs = true
                end
            end
            if foundMobs then
                SFXManager():Play(SoundEffect.SOUND_VAMP_GULP, 0.6, 2, false, 0.7)
            end
            PST:addModifiers({ SC_mightstoneProcs = 1 }, true)
        end

        -- Samson temp mods
        if PST:getTreeSnapshotMod("samsonTempDamage", 0) > 0 or PST:getTreeSnapshotMod("samsonTempSpeed", 0) > 0 then
            if not PST:getTreeSnapshotMod("samsonTempActive", false) then
                PST:addModifiers({
                    damagePerc = PST:getTreeSnapshotMod("samsonTempDamage", 0),
                    speedPerc = PST:getTreeSnapshotMod("samsonTempSpeed", 0),
                    samsonTempActive = true,
                    samsonTempTime = { value = os.clock(), set = true }
                }, true)
            else
                PST:addModifiers({ samsonTempTime = { value = os.clock(), set = true } }, true)
            end
        end

        -- Mom death procs
        if entity.Type == EntityType.ENTITY_MOM and not PST.specialNodes.momDeathProc then
            PST.specialNodes.momDeathProc = true

            -- Mod: chance for Mom to drop Plan C when defeated
            if 100 * math.random() < PST:getTreeSnapshotMod("momPlanC", 0) then
                local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_PLAN_C, Random() + 1)
            end

            -- Daemon Army node (Lilith's tree)
            if PST:getTreeSnapshotMod("daemonArmy", false) and not PST:getTreeSnapshotMod("runGotHit", false) then
                -- Mom drops an additional Incubus
                local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_INCUBUS, Random() + 1)
            end

            -- Harbinger Locusts node (Apollyon's tree)
			if PST:getTreeSnapshotMod("harbingerLocusts", false) then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				local tmpLocust = PST.locustTrinkets[math.random(#PST.locustTrinkets)]
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpPos, Vector.Zero, nil, tmpLocust, Random() + 1)
			end

            -- Mod: chance for mom to additionally drop Birthright
            if 100 * math.random() < PST:getTreeSnapshotMod("jacobBirthright", 0) then
                local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_BIRTHRIGHT, Random() + 1)
                PST:addModifiers({ jacobBirthrightProc = true }, true)
            end
        -- Mom's Heart death procs
        elseif entity.Type == EntityType.ENTITY_MOMS_HEART and not PST.specialNodes.momHeartDeathProc then
            PST.specialNodes.momDeathProc = true

            -- Mod: chance for Mom's Heart to additionally drop Birthright (if Mom didn't previously drop it)
            if not PST:getTreeSnapshotMod("jacobBirthrightProc", false) and 100 * math.random() < PST:getTreeSnapshotMod("jacobBirthright", 0) / 2 then
                local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_BIRTHRIGHT, Random() + 1)
                PST:addModifiers({ jacobBirthrightProc = true }, true)
            end
        -- Greed death procs
        elseif entity.Type == EntityType.ENTITY_GREED then
            -- Mod: chance for Greed to drop an additional nickel
            if 100 * math.random() < PST:getTreeSnapshotMod("greedNickelDrop", 0) then
                local tmpPos = Isaac.GetFreeNearPosition(entity.Position, 40)
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, tmpPos, Vector.Zero, nil, CoinSubType.COIN_NICKEL, Random() + 1)
            end

            -- Mod: chance for Greed to drop an additional dime
            if 100 * math.random() < PST:getTreeSnapshotMod("greedDimeDrop", 0) then
                local tmpPos = Isaac.GetFreeNearPosition(entity.Position, 40)
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, tmpPos, Vector.Zero, nil, CoinSubType.COIN_DIME, Random() + 1)
            end
        end

        -- Harbinger Locusts node (Apollyon's tree)
        if PST:getTreeSnapshotMod("harbingerLocusts", false) then
            -- +1% chance to replace dropped trinkets with a random locust when defeating a boss, up to 10%
            if entity:IsBoss() and entity.Parent == nil and PST:getTreeSnapshotMod("harbingerLocustsReplace", 2) < 10 then
                PST:addModifiers({ harbingerLocustsReplace = 1 }, true)
            end
        end

        -- Killed charmed enemy
        if EntityRef(entity).IsCharmed then
            local tmpPlayer = PST:getPlayer()

            -- Dark Songstress node
            if PST:getTreeSnapshotMod("darkSongstress", false) and not PST:getTreeSnapshotMod("darkSongstressActive", false) then
                local tmpSlot = tmpPlayer:GetActiveItemSlot(Isaac.GetItemIdByName("Siren Song"))
				if tmpSlot ~= -1 and 100 * math.random() < 8 then
                    tmpPlayer:AddActiveCharge(1, tmpSlot, true, false, false)
				end
            end

            -- Song of Darkness node (Siren's tree) [Harmonic modifier]
            if PST:getTreeSnapshotMod("songOfDarkness", false) and PST:getTreeSnapshotMod("songOfDarknessChance", 2) < 6 and PST:songNodesAllocated(true) <= 2 then
                PST:addModifiers({ songOfDarknessChance = 0.4 }, true)
            end

            local luckBonus = 0
            -- Song of Fortune node (Siren's tree) [Harmonic modifier]
            if PST:getTreeSnapshotMod("songOfFortune", false) and PST:songNodesAllocated(true) <= 2 then
                if tmpPlayer.Luck < 4 and 100 * math.random() < 50 then
                    luckBonus = luckBonus + 0.01
                elseif tmpPlayer.Luck > 4 and 100 * math.random() < 25 then
                    luckBonus = -1
                end
            end

            -- Mod: chance for charmed enemies to grant an additional 0.01 luck on kill
            if 100 * math.random() < PST:getTreeSnapshotMod("luckOnCharmedKill", 0) then
                luckBonus = luckBonus + 0.01
            end

            -- Mod: chance for charmed enemies to explode in a cloud of pheromones on death, dealing 4 damage and charming nearby enemies
            if 100 * math.random() < PST:getTreeSnapshotMod("charmExplosions", 0) then
                Game():CharmFart(entity.Position, 80, tmpPlayer)
                for _, tmpEntity in ipairs(Isaac.FindInRadius(entity.Position, 80, EntityPartition.ENEMY)) do
                    if tmpEntity:IsVulnerableEnemy() then
                        tmpEntity:TakeDamage(4, 0, EntityRef(tmpPlayer), 0)
                    end
                end
            end

            if luckBonus > 0 then
                PST:addModifiers({ luck = luckBonus }, true)
            end
        end

        -- Ascetic Soul node (T. Blue Baby's tree)
        if PST:getTreeSnapshotMod("asceticSoul", false) and PST:getTreeSnapshotMod("asceticSoulDrops", 0) < 5 and PST:getPlayer():GetPoopMana() >= 8 and
        100 * math.random() < 7 then
            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, entity.Position, Vector.Zero, nil, HeartSubType.HEART_HALF_SOUL, Random() + 1)
            PST:addModifiers({ asceticSoulDrops = 1 }, true)
        end

        -- Mystic Vampirism node (T. Eve's tree)
        if PST:getTreeSnapshotMod("mysticVampirism", false) then
            PST:addModifiers({ mysticVampirismKills = 1 }, true)
            if PST:getTreeSnapshotMod("mysticVampirismKills", 0) >= 13 then
                if PST:getTreeSnapshotMod("mysticVampirismProcs", 0) < 8 and 100 * math.random() < 20 then
                    local clotList = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 0)
                    if #clotList > 0 then
                        local tmpClot = clotList[math.random(#clotList)]
                        local newClot = 1
                        if math.random() < 0.4 then
                            newClot = 1 + math.random(5)
                        end
                        local newClotEnt = Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, tmpClot.Position, Vector.Zero, player, newClot, Random() + 1)
                        newClotEnt:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
                        tmpClot:Remove()
                        PST:addModifiers({ mysticVampirismProcs = 1 }, true)
                    end
                end
                PST:addModifiers({ mysticVampirismKills = { value = 0, set = true } }, true)
            end
        end

        -- Mod: chance to spawn a black clot while T. Eve's whore of babylon effect is active
        tmpMod = PST:getTreeSnapshotMod("blackClotBabylon", 0)
        if tmpMod > 0 then
            local hasBabylon = false
            local plEffects = PST:getPlayer():GetEffects():GetEffectsList()
            if plEffects.Size > 0 then
                for i=0,plEffects.Size-1 do
                    local tmpEffect = plEffects:Get(i).Item
                    if tmpEffect.ID == 110 then
                        hasBabylon = true
                        break
                    end
                end
            end
            if hasBabylon and 100 * math.random() < tmpMod then
                local existingClots = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 2)
                if #existingClots < 3 then
                    local newClot = Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, PST:getPlayer().Position, Vector.Zero, PST:getPlayer(), 2, Random() + 1)
                    newClot:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
                end
            end
        end

        -- Cosmic Realignment node
        if PST:cosmicRCharPicked(PlayerType.PLAYER_SAMSON_B) then
            local tmpPlayer = PST:getPlayer()
            -- Tainted Samson, +2% all stats when killing a monster, up to 10%
            if cosmicRCache.TSamsonBuffer < 10 then
                cosmicRCache.TSamsonBuffer = cosmicRCache.TSamsonBuffer + 2
                PST:save()
                tmpPlayer:AddCacheFlags(PST.allstatsCache, true)
            end
        elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN_B) then
            -- Tainted Forgotten, bosses drop an additional soul heart
            if entity:IsBoss() then
                local isBone = 100 * math.random() < 50
                Game():Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_HEART,
                    entity.Position,
                    Vector.Zero,
                    nil,
                    isBone and HeartSubType.HEART_BONE or HeartSubType.HEART_SOUL,
                    Random() + 1
                )
            end
        end
    else
        -- Familiar death
        local tmpFamiliar = entity:ToFamiliar()
        if tmpFamiliar then
            -- Blood clot death
            if tmpFamiliar.Variant == FamiliarVariant.BLOOD_BABY then
                -- Mod: chance for blood clots to drop their respective heart type on death, which vanishes after 2.5 seconds
                local tmpMod = PST:getTreeSnapshotMod("clotHeartDrop", 0)
                local clotType = tmpFamiliar.SubType + 1
                if tmpMod > 0 and clotHeartTypes[clotType] ~= nil and 100 * math.random() < tmpMod then
                    local tmpHeart = Game():Spawn(
                        EntityType.ENTITY_PICKUP,
                        PickupVariant.PICKUP_HEART,
                        tmpFamiliar.Position,
                        RandomVector() * 3,
                        nil,
                        clotHeartTypes[clotType],
                        Random() + 1
                    ):ToPickup()
                    tmpHeart.Timeout = 90
                end

                -- Mod: chance to gain luck when a blood clot is destroyed
                tmpMod = PST:getTreeSnapshotMod("clotDestroyedLuck", 0)
                if tmpMod > 0 and 100 * math.random() < tmpMod then
                    PST:addModifiers({ luck = 0.03 }, true)
                end
            end
        end
    end
end