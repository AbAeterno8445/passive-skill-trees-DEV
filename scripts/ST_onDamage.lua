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

        -- Hasted node (Samson's tree)
        if PST:getTreeSnapshotMod("hasted", false) and PST:getTreeSnapshotMod("hastedHits", 0) < 5 then
            PST:addModifiers({ tearsPerc = -1.5, shotSpeedPerc = -1.5, hastedHits = 1 }, true)
        end

        -- Rage Buildup node (Samson's tree)
        if PST:getTreeSnapshotMod("rageBuildup", false) then
            local tmpTotal = PST:getTreeSnapshotMod("rageBuildupTotal", 0)
            PST:addModifiers({ damage = -tmpTotal, rageBuildupTotal = { value = 0, set = true } }, true)
        end

        -- Mod: +% speed when hit, up to 15%
        local tmpBonus = PST:getTreeSnapshotMod("speedWhenHit", 0)
        local tmpTotal = PST:getTreeSnapshotMod("speedWhenHitTotal", 0)
        if tmpBonus > 0 and tmpTotal < 15 then
            local tmpAdd = math.min(tmpBonus, 15 - tmpTotal)
            if tmpAdd > 0 then
                PST:addModifiers({ speedPerc = tmpAdd, speedWhenHitTotal = tmpAdd }, true)
            end
        end

        -- Mod: +luck if you clear the boss room without getting hit more than 3 times (register hit)
        if room:GetType() == RoomType.ROOM_BOSS then
            PST.specialNodes.bossRoomHitsFrom = PST.specialNodes.bossRoomHitsFrom + 1
        end

        -- Mod: chance to negate incoming hit if it would've killed you
        local tmpHP = player:GetHearts() + player:GetSoulHearts() + player:GetBoneHearts() + player:GetRottenHearts() / 2
        if 100 * math.random() < PST:getTreeSnapshotMod("killingHitNegation", 0) and damage >= tmpHP then
            SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE)
            return { Damage = 0 }
        end

        -- Gulp! node (Keeper's tree)
        if PST:getTreeSnapshotMod("gulp", false) then
            local hasTrinket = player:GetTrinket(0) == TrinketType.TRINKET_SWALLOWED_PENNY or player:GetTrinket(1) == TrinketType.TRINKET_SWALLOWED_PENNY
            if hasTrinket and 100 * math.random() < 30 then
                SFXManager():Play(SoundEffect.SOUND_GULP)
                player:TryRemoveTrinket(TrinketType.TRINKET_SWALLOWED_PENNY)
                player:AddCoins(math.random(4))
            end
        end

        -- Mod: chance to negate a hit that would've killed you if you have more than 0 coins. Negating a hit removes all your coins and fully discharges your active item
        if player:GetNumCoins() > 0 and 100 * math.random() < PST:getTreeSnapshotMod("coinShield", 0) and damage >= tmpHP then
            SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE, 0.7)
            SFXManager():Play(SoundEffect.SOUND_BATTERYDISCHARGE)
            player:AddCoins(-999)
            player:SetActiveCharge(0)
            return { Damage = 0 }
        end

        -- Avid Shopper node (Keeper's tree)
        if PST:getTreeSnapshotMod("avidShopper", false) then
            player:AddCoins(-math.random(3))
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
        local dmgMult = 1

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

        if source and source.Entity then
            -- Check if a familiar hit/killed enemy
            local tmpFamiliar = source.Entity:ToFamiliar()
            if tmpFamiliar == nil and source.Entity.SpawnerEntity ~= nil then
                -- For tears shot by familiars
                tmpFamiliar = source.Entity.SpawnerEntity:ToFamiliar()
            end
            if tmpFamiliar then
                -- Carrion Avian node (Eve's tree)
                if PST:getTreeSnapshotMod("carrionAvian", false) then
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
                            dmgMult = dmgMult + birdInheritDmg / 100
                        end
                    end
                end

                -- Mod: chance for enemies killed by familiars to drop an additional 1/2 soul heart
                if target.SpawnerType == 0 and target.HitPoints <= damage and 100 * math.random() < PST:getTreeSnapshotMod("familiarKillSoulHeart", 0) then
                    Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, target.Position, Vector.Zero, nil, HeartSubType.HEART_HALF_SOUL, Random() + 1)
                end

                if tmpFamiliar.Variant == FamiliarVariant.BLUE_FLY then
                    -- Mod: +damage when a blue fly dies, up to +1.2. Resets every floor
                    local tmpBonus = PST:getTreeSnapshotMod("blueFlyDeathDamage", 0)
                    local tmpTotal = PST:getTreeSnapshotMod("blueFlyDeathDamageTotal", 0)
                    if tmpBonus > 0 and tmpTotal < 1.2 then
                        local tmpAdd = math.min(tmpBonus, 1.2 - tmpTotal)
                        PST:addModifiers({ damage = tmpAdd, blueFlyDeathDamageTotal = tmpAdd }, true)
                    end
                end
            else
                -- Direct player hit to enemy
                local srcPlayer = source.Entity:ToPlayer()
                if srcPlayer == nil then
                    if source.Entity.Parent then
                        srcPlayer = source.Entity.Parent:ToPlayer()
                    end
                    if srcPlayer == nil and source.Entity.SpawnerEntity then
                        srcPlayer = source.Entity.SpawnerEntity:ToPlayer()
                    end
                end
                if srcPlayer then
                    if target:IsVulnerableEnemy() then
                        -- Rage Buildup node (Samson's tree)
                        if PST:getTreeSnapshotMod("rageBuildup", false) and PST:getTreeSnapshotMod("rageBuildupTotal", 0) < 3 then
                            PST:addModifiers({ damage = 0.02, rageBuildupTotal = 0.02 }, true)
                        end

                        -- Player hits boss
                        if target:IsBoss() then
                            PST.specialNodes.bossHits = PST.specialNodes.bossHits + 1

                            -- Samson temp mods
                            if PST:getTreeSnapshotMod("samsonTempDamage", 0) > 0 or PST:getTreeSnapshotMod("samsonTempSpeed", 0) > 0 then
                                -- Mod: +damage or +speed for 2 seconds when hitting a boss 8 times
                                if PST.specialNodes.bossHits > 0 and PST.specialNodes.bossHits % 8 == 0 then
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
                            end

                            -- Mod: chance to deal 10x damage to boss below 10% HP
                            if (target.HitPoints - damage) / target.MaxHitPoints <= 0.1 then
                                if 100 * math.random() < PST:getTreeSnapshotMod("bossCulling", 0) then
                                    dmgMult = dmgMult + 9
                                end
                            end
                        end

                        -- Spirit Ebb and Flow node (The Forgotten's tree)
                        if PST:getTreeSnapshotMod("spiritEbb", false) then
                            if srcPlayer:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
                                PST.specialNodes.spiritEbbHits.forgotten = PST.specialNodes.spiritEbbHits.forgotten + 1
                                if PST.specialNodes.spiritEbbHits.forgotten == 6 then
                                    Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, srcPlayer.Position, Vector.Zero, nil, 0, Random() + 1)
                                    srcPlayer:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED, true)
                                end
                            elseif srcPlayer:GetPlayerType() == PlayerType.PLAYER_THESOUL then
                                PST.specialNodes.spiritEbbHits.soul = PST.specialNodes.spiritEbbHits.soul + 1
                                if PST.specialNodes.spiritEbbHits.soul == 6 then
                                    Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, srcPlayer.Position, Vector.Zero, nil, 0, Random() + 1)
                                    srcPlayer:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY, true)
                                end
                            end
                        end

                        -- Inner Flare node (The Forgotten's tree)
                        if PST:getTreeSnapshotMod("innerFlare", false) then
                            if target:GetSlowingCountdown() > 0 and srcPlayer:GetPlayerType() == PlayerType.PLAYER_THESOUL then
                                dmgMult = dmgMult + 0.15
                            end
                        end

                        -- Mod: increased tear damage when melee hitting as The Forgotten
                        local tmpBonus = PST:getTreeSnapshotMod("forgottenMeleeTearBuff", 0)
                        if tmpBonus > 0 and srcPlayer:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
                            if PST.specialNodes.forgottenMeleeTearBuff < 20 then
                                local tmpAdd = math.min(tmpBonus, 20 - PST.specialNodes.forgottenMeleeTearBuff)
                                PST.specialNodes.forgottenMeleeTearBuff = PST.specialNodes.forgottenMeleeTearBuff + tmpAdd
                            end
                        elseif source.Entity.Type == EntityType.ENTITY_TEAR and PST.specialNodes.forgottenMeleeTearBuff ~= 0 then
                            dmgMult = dmgMult + PST.specialNodes.forgottenMeleeTearBuff / 100
                        end
                    end
                end
            end
        end

        -- Cosmic Realignment node
        if PST:cosmicRCharPicked(PlayerType.PLAYER_AZAZEL_B) then
            -- Tainted Azazel, -40% damage dealt to enemies far away from you, based on your range stat
            local dist = math.sqrt((tmpPlayer.Position.X - target.Position.X) ^ 2 + (tmpPlayer.Position.Y - target.Position.Y) ^ 2)
            if dist > tmpPlayer.TearRange * 0.4 then
                dmgMult = dmgMult - 0.4
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
                    dmgMult = dmgMult - 0.7
                end
            end
        end

        return { Damage = damage * math.max(0, dmgMult) }
    end
end

function PST:onDeath(entity)
    local player = entity:ToPlayer()
    local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
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
                local tmpPos = Isaac.GetFreeNearPosition(Game():GetRoom():GetCenterPos(), 40)
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_PLAN_C, Random() + 1)
            end

            -- Daemon Army node (Lilith's tree)
            if PST:getTreeSnapshotMod("daemonArmy", false) then
                -- Mom drops an additional Incubus
                local tmpPos = Isaac.GetFreeNearPosition(Game():GetRoom():GetCenterPos(), 40)
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_INCUBUS, Random() + 1)
            end

            -- Harbinger Locusts node (Apollyon's tree)
			if PST:getTreeSnapshotMod("harbingerLocusts", false) then
				local tmpPos = Isaac.GetFreeNearPosition(Game():GetRoom():GetCenterPos(), 40)
				local tmpLocust = PST.locustTrinkets[math.random(#PST.locustTrinkets)]
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpPos, Vector.Zero, nil, tmpLocust, Random() + 1)
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