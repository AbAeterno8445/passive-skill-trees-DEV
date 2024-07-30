-- On entity damage
function PST:onDamage(target, damage, flag, source)
    local player = target:ToPlayer()
    local room = Game():GetRoom()
    local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)

    -- Player gets hit
    if player then
        -- Fickle Fortune node (Cain's tree)
        if PST:getTreeSnapshotMod("fickleFortune", false) and 100 * math.random() < 7 then
            if 100 * math.random() < 7 then
                PST.specialNodes.fickleFortuneVanish = true
            end
            player:DropTrinket(player.Position, true)
        end

        -- Cosmic Realignment node
	    if PST:cosmicRCharPicked(PlayerType.PLAYER_SAMSON) then
            -- Samson, -0.15 damage when hit, up to -0.9
            if room:GetAliveEnemiesCount() > 0 and cosmicRCache.samsonDmg < 0.9 then
                cosmicRCache.samsonDmg = cosmicRCache.samsonDmg + 0.15
                PST:addModifiers({ damage = -0.15 }, true)
            end
        elseif PST:cosmicRCharPicked(PlayerType.PLAYER_SAMSON_B) then
            -- Tainted Samson, -5% all stats when hit, up to -20%
            if room:GetAliveEnemiesCount() > 0 and cosmicRCache.TSamsonBuffer > -20 then
                cosmicRCache.TSamsonBuffer = cosmicRCache.TSamsonBuffer - 5
                PST:save()
                player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
            end
        elseif PST:cosmicRCharPicked(PlayerType.PLAYER_EDEN_B) then
            -- Tainted Eden, shuffle stat reduction
            for stat, _ in pairs(cosmicRCache.TEdenDebuff) do
                cosmicRCache.TEdenDebuff[stat] = 0
            end
            for _=1,6 do
                local tmpStat = PST:getRandomStat()
                cosmicRCache.TEdenDebuff[tmpStat] = cosmicRCache.TEdenDebuff[tmpStat] - 0.1
            end
            local tmpStat = PST:getRandomStat()
            cosmicRCache.TEdenDebuff[tmpStat .. "Perc"] = math.floor(-25 * math.random())
            player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
        end

        -- Mod: chance to nullify hit that wakes dead bird
        if not PST.specialNodes.deadBirdActive and 100 * math.random() < PST:getTreeSnapshotMod("deadBirdNullify", 0) then
            return { Damage = 0 }
        end
    else
        local tmpPlayer = Isaac.GetPlayer()

        if target:IsBoss() then
            -- Mod: chance for Book of Belial to gain a charge when hitting a boss
            if tmpPlayer:GetActiveCharge(0) < tmpPlayer:GetActiveMaxCharge(0) and tmpPlayer:GetActiveItem(0) == CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL then
                if PST:getTreeSnapshotMod("belialChargesGained", 0) < 12 and 100 * math.random() < PST:getTreeSnapshotMod("belialBossHitCharge", 0) then
                    PST:addModifiers({ belialChargesGained = 1 }, true)
                    tmpPlayer:SetActiveCharge(tmpPlayer:GetActiveCharge(0) + 1, 0)
                    SFXManager():Play(SoundEffect.SOUND_BEEP)
                end
            end
        end

        -- Carrion Avian node (Eve's tree)
        local tmpFamiliar = source.Entity:ToFamiliar()
        if PST:getTreeSnapshotMod("carrionAvian", false) and tmpFamiliar then
            if tmpFamiliar.Variant == FamiliarVariant.DEAD_BIRD then
                -- +0.15 damage when dead bird kills an enemy, up to +3. Permanent +0.6 if boss
                if target.HitPoints <= damage then
                    if not target:IsBoss() then
                        if PST:getTreeSnapshotMod("carrionAvianTempBonus", 0) < 3 then
                            PST:addModifiers({ damage = 0.15, carrionAvianTempBonus = 0.15 }, true)
                        end
                    else
                        PST:addModifiers({ damage = 0.6 }, true)
                    end
                end

                local birdInheritDmg = PST:getTreeSnapshotMod("deadBirdInheritDamage", 0)
                if birdInheritDmg > 0 then
                    return { Damage = damage * (1 + birdInheritDmg / 100) }
                end
            end
        end

        -- Cosmic Realignment node
        if PST:cosmicRCharPicked(PlayerType.PLAYER_AZAZEL_B) then
            -- Tainted Azazel, -40% damage dealt to enemies far away from you, based on your range stat
            local dist = math.sqrt((tmpPlayer.Position.X - target.Position.X) ^ 2 + (tmpPlayer.Position.Y - target.Position.Y) ^ 2)
            if dist > tmpPlayer.TearRange * 0.4 then
                return { Damage = damage * 0.6 }
            end
        elseif PST:cosmicRCharPicked(PlayerType.PLAYER_BETHANY_B) then
            -- Tainted Bethany, -4% all stats when an item wisp dies, up to -20%
            local tmpWisp = target:ToFamiliar()
            if tmpWisp and tmpWisp.Variant == FamiliarVariant.ITEM_WISP then
                if target.HitPoints <= damage then
                    if cosmicRCache.TBethanyDeadWisps < 5 then
                        cosmicRCache.TBethanyDeadWisps = cosmicRCache.TBethanyDeadWisps + 1
                        PST:addModifiers({ allstatsPerc = -4 }, true)
                    end
                else
                    return { Damage = damage * 0.3 }
                end
            end
        end
    end
end

function PST:onDeath(entity)
    local player = entity:ToPlayer()
    local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
    if player ~= nil then
        -- Player death
        if player:GetPlayerType() == PlayerType.PLAYER_LAZARUS then
            cosmicRCache.lazarusHasDied = true
            PST:save()
        end
    elseif entity:IsActiveEnemy(true) then
        -- Enemy death
        local addXP = false
        if entity.SpawnerType ~= 0 then
            if PST.modData.spawnKills < 10 then
                PST.modData.spawnKills = PST.modData.spawnKills + 1
                addXP = true
            end
        else
            addXP = true
        end

        if addXP then
            local mult = 1
            if entity:IsBoss() then
                mult = mult + PST:getTreeSnapshotMod("xpgainBoss", 0) / 100
            else
                mult = mult + PST:getTreeSnapshotMod("xpgainNormalMob", 0) / 100
            end
            PST:addTempXP(math.max(1, math.floor(mult * entity.MaxHitPoints / 2)), true)
        end

        -- Cosmic Realignment node
        if PST:cosmicRCharPicked(PlayerType.PLAYER_SAMSON_B) then
            local tmpPlayer = Isaac.GetPlayer()
            -- Tainted Samson, +2% all stats when killing a monster, up to 10%
            if cosmicRCache.TSamsonBuffer < 10 then
                cosmicRCache.TSamsonBuffer = cosmicRCache.TSamsonBuffer + 2
                PST:save()
                tmpPlayer:AddCacheFlags(CacheFlag.CACHE_ALL, true)
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
    end
end

function PST:onPlayerCollision(player, collider, low)
    -- Cosmic Realignment node
    if PST:cosmicRCharPicked(PlayerType.PLAYER_JACOB_B) then
        -- Tainted Jacob, take 1 1/2 hearts of damage when colliding with Dark Esau
        if collider.Type == EntityType.ENTITY_DARK_ESAU then
            player:TakeDamage(3, 0, EntityRef(collider), 0)
        end
    end
end