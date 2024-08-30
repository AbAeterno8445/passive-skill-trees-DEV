-- On entity damage
function PST:onDamage(target, damage, flag, source)
    local player = target:ToPlayer()
    local room = PST:getRoom()
    local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.treeMods.cosmicRCache)

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

        -- Sacrifice room
        if room:GetType() == RoomType.ROOM_SACRIFICE and (flag & DamageFlag.DAMAGE_SPIKES) ~= 0 then
            -- Mod: chance to spawn a red heart when using a sacrifice room, up to 4 times
            if 100 * math.random() < PST:getTreeSnapshotMod("sacrificeRoomHearts", 0) then
                if PST:getTreeSnapshotMod("sacrificeRoomHeartsSpawned", 0) < 4 then
                    Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, room:GetCenterPos(), RandomVector() * 3, nil, HeartSubType.HEART_FULL, Random() + 1)
                    PST:addModifiers({ sacrificeRoomHeartsSpawned = 1 }, true)
                end
            end
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
                player:AddCacheFlags(PST.allstatsCache, true)
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
            player:AddCacheFlags(PST.allstatsCache, true)
        end

        -- Mod: chance to nullify hit that wakes dead bird
        if not PST.specialNodes.deadBirdActive and 100 * math.random() < PST:getTreeSnapshotMod("deadBirdNullify", 0) then
            return { Damage = 0 }
        end

        -- Mod: chance to negate killing hit if opposing brother has more than 1 remaining red heart
        local tmpTwin = player:GetOtherTwin()
        if tmpTwin then
            if 100 * math.random() < PST:getTreeSnapshotMod("brotherHitNegation", 0) and tmpTwin:GetHearts() > 2 and damage >= tmpHP then
                SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE, 0.7)
                tmpTwin:AddHearts(2 - tmpTwin:GetHearts())
                return { Damage = 0 }
            end
        end

        -- Mod: when a charmed enemy hits you, return damage
        local tmpTreeMod = PST:getTreeSnapshotMod("charmedRetaliation", 0)
        if tmpTreeMod > 0 then
            if source and source.Entity then
                if source.Entity:IsVulnerableEnemy() and source.IsCharmed then
                    source.Entity:TakeDamage(tmpTreeMod, 0, EntityRef(player), 0)
                elseif source.Entity.Parent and source.Entity.Parent:IsVulnerableEnemy() and EntityRef(source.Entity.Parent).IsCharmed then
                    source.Entity.Parent:TakeDamage(tmpTreeMod, 0, EntityRef(player), 0)
                end
            end
        end

        -- Mod: chance to negate a killing hit from charmed enemies. This can only happen once per room
        tmpTreeMod = PST:getTreeSnapshotMod("charmedHitNegation", 0)
        if tmpTreeMod > 0 and 100 * math.random() < tmpTreeMod and not PST:getTreeSnapshotMod("charmedHitNegationProc", false) and damage >= tmpHP then
            if source and source.Entity then
                if source.IsCharmed or (source.Entity.Parent and EntityRef(source.Entity.Parent).IsCharmed) then
                    SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE, 0.7)
                    PST:addModifiers({ charmedHitNegationProc = true }, true)
                    return { Damage = 0 }
                end
            end
        end

        -- Ancient starcursed jewel: Martian Ultimatum
        if PST:SC_getSnapshotMod("martianUltimatum", false) and PST:getTreeSnapshotMod("SC_martianDebuff", 0) < 0.5 then
            PST:addModifiers({ speed = -0.1, SC_martianDebuff = 0.1 }, true)
        end

        -- Ancient starcursed jewel: Crimson Warpstone
        if PST:SC_getSnapshotMod("crimsonWarpstone", false) then
            tmpMod = PST:getTreeSnapshotMod("SC_crimsonWarpKeyDrop", 0)
            if tmpMod > 0 then
                PST:addModifiers({ SC_crimsonWarpKeyDrop = -15 }, true)
            end
        end

        -- Starcursed modifiers
        if source and source.Entity then
            local tmpDmg = 0
            local tmpSource = source.Entity:ToNPC()
            if not tmpSource and source.Entity.Parent then
                tmpSource = source.Entity.Parent:ToNPC()
            end
            if tmpSource then
                -- Ancient starcursed jewel: Sanguinis
                if PST:SC_getSnapshotMod("sanguinis", false) then
                    local tmpChance = 40
                    if PST:getLevel():IsAscent() then
                        tmpChance = 20
                    end
                    if not PST:getTreeSnapshotMod("SC_sanguinisProc", false) and 100 * math.random() < tmpChance then
                        player:AddBrokenHearts(1)
                        SFXManager():Play(SoundEffect.SOUND_DEATH_CARD, 0.9)
                        PST:createFloatTextFX("-- Sanguinis --", Vector.Zero, Color(0.85, 0.1, 0.1, 1), 0.12, 100, true)
                        PST:addModifiers({ SC_sanguinisProc = true }, true)
                    end
                    if room:GetType() == RoomType.ROOM_BOSS and not PST:getTreeSnapshotMod("SC_sanguinisTookDmg", false) then
                        PST:addModifiers({ SC_sanguinisTookDmg = true }, true)
                    end
                end

                -- Chance for monsters to also remove 1/2 soul/black heart when hitting
                local tmpMod = PST:SC_getSnapshotMod("mobExtraHitDmg", 0)
                if 100 * math.random() < tmpMod then
                    player:AddSoulHearts(-1)
                end

                -- Chance for monsters to slow you on hit for 2 seconds
                tmpMod = PST:SC_getSnapshotMod("mobSlowOnHit", 0)
                if 100 * math.random() < tmpMod then
                    player:AddSlowing(EntityRef(tmpSource), 60, 0.9, Color(0.8, 0.8, 1, 1))
                end

                -- Chance for monsters to reduce your damage by 20% on hit for 3 seconds
                tmpMod = PST:SC_getSnapshotMod("mobReduceDmgOnHit", 0)
                if 100 * math.random() < tmpMod then
                    if PST.specialNodes.mobHitReduceDmg == 0 then
                        PST:addModifiers({ damagePerc = -20 }, true)
                    end
                    PST.specialNodes.mobHitReduceDmg = 90
                end

                -- When hit by a monster, the next X hits in the room will deal an additional 1/2 heart damage
                tmpMod = PST:SC_getSnapshotMod("roomMobExtraDmgOnHit", 0)
                if tmpMod > 0 then
                    if PST.specialNodes.mobHitRoomExtraDmg.hits > 0 then
                        tmpDmg = tmpDmg + 1
                        PST.specialNodes.mobHitRoomExtraDmg.hits = PST.specialNodes.mobHitRoomExtraDmg.hits - 1
                    elseif not PST.specialNodes.mobHitRoomExtraDmg.proc then
                        PST.specialNodes.mobHitRoomExtraDmg.hits = tmpMod
                        PST.specialNodes.mobHitRoomExtraDmg.proc = true
                    end
                end

                -- Chance for normal monsters to deal an extra 1/2 heart damage
                tmpMod = PST:SC_getSnapshotMod("mobExtraHitDmg", 0)
                if not tmpSource:IsBoss() and not tmpSource:IsChampion() and 100 * math.random() < tmpMod then
                    return { Damage = damage + 1 + tmpDmg }
                end

                -- Chance for champion monsters to deal an extra 1/2 heart damage
                tmpMod = PST:SC_getSnapshotMod("champExtraHitDmg", 0)
                if tmpSource:IsChampion() and 100 * math.random() < tmpMod then
                    return { Damage = damage + 1 + tmpDmg }
                end

                -- Chance for boss monsters to deal an extra 1/2 heart damage
                tmpMod = PST:SC_getSnapshotMod("bossExtraHitDmg", 0)
                if tmpSource:IsBoss() and 100 * math.random() < tmpMod then
                    return { Damage = damage + 1 + tmpDmg }
                end

                if tmpDmg > 0 then
                    return { Damage = damage + tmpDmg }
                end
            end
        end
    elseif target and target.Type ~= EntityType.ENTITY_GIDEON then
        local tmpPlayer = PST:getPlayer()
        local dmgMult = 1

        -- Starcursed modifiers
        if target:IsActiveEnemy(false) then
            -- Damage reduction
            local tmpMod = PST:SC_getSnapshotMod("mobDmgReduction", 0)
            dmgMult = dmgMult - tmpMod / 100

            -- Damage reduction from explosions
            tmpMod = PST:SC_getSnapshotMod("mobExplosionDR", 0)
            if (flag & DamageFlag.DAMAGE_EXPLOSION) ~= 0 and tmpMod ~= 0 then
                dmgMult = dmgMult - tmpMod / 100
            end

            -- Damage blocking
            local blockedDamage = false
            local partialBlock = false
            tmpMod = PST:SC_getSnapshotMod("mobBlock", 0)
            if 100 * math.random() < tmpMod then
                partialBlock = true
            end

            -- First hits blocked
            tmpMod = PST:SC_getSnapshotMod("mobFirstBlock", 0)
            if tmpMod > 0 and target.InitSeed then
                if not PST.specialNodes.mobFirstHitsBlocked[target.InitSeed] then
                    PST.specialNodes.mobFirstHitsBlocked[target.InitSeed] = 0
                end
                if PST.specialNodes.mobFirstHitsBlocked[target.InitSeed] < tmpMod then
                    PST.specialNodes.mobFirstHitsBlocked[target.InitSeed] = PST.specialNodes.mobFirstHitsBlocked[target.InitSeed] + 1
                    partialBlock = true
                end
            end

            -- One-shot protection: if the first and only hit this mob ever receives would've killed it, prevent damage and set its health to 10%
            tmpMod = PST:SC_getSnapshotMod("mobOneShotProt", nil)
            if tmpMod ~= nil then
                if target.InitSeed and not PST.specialNodes.oneShotProtectedMobs[target.InitSeed] then
                    PST.specialNodes.oneShotProtectedMobs[target.InitSeed] = true
                    if target.HitPoints <= damage * dmgMult then
                        target.HitPoints = target.MaxHitPoints * 0.1
                        blockedDamage = true
                    end
                end
            end

            -- Ancient starcursed jewel: Circadian destructor - explosion immunity
            if PST.specialNodes.SC_circadianExplImmune > 0 and (flag & DamageFlag.DAMAGE_EXPLOSION) ~= 0 then
                blockedDamage = true
            end

            -- Ancient starcursed jewel: Gaze Averter
            if PST:SC_getSnapshotMod("gazeAverter", false) then
                local dir = tmpPlayer:GetHeadDirection()
                if dir == Direction.LEFT and target.Position.X < tmpPlayer.Position.X or
                dir == Direction.RIGHT and target.Position.X > tmpPlayer.Position.X or
                dir == Direction.UP and target.Position.Y < tmpPlayer.Position.Y or
                dir == Direction.DOWN and target.Position.Y > tmpPlayer.Position.Y then
                    dmgMult = dmgMult - 0.75
                end
            end

            if blockedDamage or PST.specialNodes.mobPeriodicShield then
                SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE, 0.2, 2, false, 1.3)
                return { Damage = 0 }
            elseif partialBlock then
                SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE, 0.2, 2, false, 1.4)
                return { Damage = damage * dmgMult * 0.35 }
            end
        end

        if target:IsBoss() then
            -- Mod: chance for Book of Belial to gain a charge when hitting a boss
            local tmpBookSlot = tmpPlayer:GetActiveItemSlot(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL)
            if tmpBookSlot ~= -1 then
                if PST:getTreeSnapshotMod("belialChargesGained", 0) < 12 and 100 * math.random() < PST:getTreeSnapshotMod("belialBossHitCharge", 0) then
                    PST:addModifiers({ belialChargesGained = 1 }, true)
                    tmpPlayer:AddActiveCharge(1, 0, true, false, false)
                end
            end
        else
            -- Check if a familiar got hit
            local tmpFamiliar = target:ToFamiliar()
            if tmpFamiliar then
                if tmpFamiliar.Variant == FamiliarVariant.WISP then
                    -- Will-o-the-Wisp node (Bethany's tree)
                    if PST:getTreeSnapshotMod("willOTheWisp", false) then
                        dmgMult = dmgMult - 0.6
                        if tmpFamiliar.HitPoints <= damage * dmgMult and PST:getTreeSnapshotMod("willOTheWispDmgBuff", 0) < 2.5 then
                            PST:addModifiers({ damage = 0.5, willOTheWispDmgBuff = 0.5 }, true)
                        end
                    end

                    -- Soul Trickle node (Bethany's tree)
                    if PST:getTreeSnapshotMod("soulTrickle", false) and PST:getTreeSnapshotMod("soulTrickleWispDrops", 0) < 2 and
                    100 * math.random() < 5 then
                        Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, tmpFamiliar.Position, Vector.Zero, nil, HeartSubType.HEART_HALF_SOUL, Random() + 1)
                        PST:addModifiers({ soulTrickleWispDrops = 1 }, true)
                    end

                    -- Mod: +luck when a wisp is destroyed, up to +2
                    local tmpBonus = PST:getTreeSnapshotMod("wispDestroyedLuck", 0)
                    local tmpTotal = PST:getTreeSnapshotMod("wispDestroyedLuckTotal", 0)
                    if tmpBonus ~= 0 and tmpTotal < 2 and tmpFamiliar.HitPoints <= damage * dmgMult then
                        local tmpAdd = math.min(tmpBonus, 2 - tmpTotal)
                        PST:addModifiers({ luck = tmpAdd, wispDestroyedLuckTotal = tmpAdd }, true)
                    end
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
            if tmpFamiliar and target:IsActiveEnemy(false) and target:IsVulnerableEnemy() and target.Type ~= EntityType.ENTITY_BLOOD_PUPPY then
                -- Carrion Avian node (Eve's tree)
                if PST:getTreeSnapshotMod("carrionAvian", false) then
                    if tmpFamiliar.Variant == FamiliarVariant.DEAD_BIRD then
                        -- +0.15 damage when dead bird kills an enemy, up to +3. Permanent +0.6 if boss
                        if target.HitPoints <= damage * dmgMult then
                            if not target:IsBoss() then
                                if PST:getTreeSnapshotMod("carrionAvianTempBonus", 0) < 3 then
                                    PST:addModifiers({ damage = 0.15, carrionAvianTempBonus = 0.15 }, true)
                                end
                            elseif PST:getTreeSnapshotMod("carrionAvianBossProc", 0) < 2 then
                                PST:addModifiers({ damage = 0.6, carrionAvianBossProc = 1 }, true)
                            end
                        end

                        local birdInheritDmg = PST:getTreeSnapshotMod("deadBirdInheritDamage", 0)
                        if birdInheritDmg > 0 then
                            dmgMult = dmgMult + birdInheritDmg / 100
                        end
                    end
                end

                -- Mod: chance for enemies killed by familiars to drop an additional 1/2 soul heart
                local tmpMod = PST:getTreeSnapshotMod("familiarKillSoulHeart", 0)
                if tmpMod > 0 and target.SpawnerType == 0 and target.HitPoints <= damage * dmgMult and 100 * math.random() < tmpMod then
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
                            if (target.HitPoints - damage * dmgMult) / target.MaxHitPoints <= 0.1 then
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

                        -- Coordination node (Jacob & Esau's tree)
                        if PST:getTreeSnapshotMod("coordination", false) and srcPlayer:GetOtherTwin() then
                            local tmpTwin = srcPlayer:GetOtherTwin()
                            -- Landing 5 hits as Jacob grants +10% tears to Esau, 5 hits as Esau grants +10% damage to Jacob
                            if srcPlayer:GetPlayerType() == PlayerType.PLAYER_JACOB then
                                PST.specialNodes.coordinationHits.jacob = PST.specialNodes.coordinationHits.jacob + 1
                                if PST.specialNodes.coordinationHits.jacob == 5 then
                                    Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, tmpTwin.Position, Vector.Zero, nil, 0, Random() + 1)
                                    tmpTwin:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
                                end
                            elseif srcPlayer:GetPlayerType() == PlayerType.PLAYER_ESAU then
                                PST.specialNodes.coordinationHits.esau = PST.specialNodes.coordinationHits.esau + 1
                                if PST.specialNodes.coordinationHits.esau == 5 then
                                    Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, tmpTwin.Position, Vector.Zero, nil, 0, Random() + 1)
                                    tmpTwin:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
                                end
                            end
                        end

                        -- Mod: chance for enemies killed by Jacob to drop 1/2 red heart, once per room
                        if 100 * math.random() < PST:getTreeSnapshotMod("jacobHeartOnKill", 0) and not PST:getTreeSnapshotMod("jacobHeartOnKillProc", false) and
                        target.HitPoints <= damage * dmgMult and srcPlayer:GetPlayerType() == PlayerType.PLAYER_JACOB then
                            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, target.Position, Vector.Zero, nil, HeartSubType.HEART_HALF, Random() + 1)
                            PST:addModifiers({ jacobHeartOnKillProc = true }, true)
                        end

                        -- Mod: chance for enemies killed by Esau to drop 1/2 soul heart, once per room
                        if 100 * math.random() < PST:getTreeSnapshotMod("esauSoulOnKill", 0) and not PST:getTreeSnapshotMod("esauSoulOnKillProc", false) and
                        target.HitPoints <= damage * dmgMult and srcPlayer:GetPlayerType() == PlayerType.PLAYER_ESAU then
                            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, target.Position, Vector.Zero, nil, HeartSubType.HEART_HALF_SOUL, Random() + 1)
                            PST:addModifiers({ esauSoulOnKillProc = true }, true)
                        end

                        -- Dark Songstress node (Siren's tree)
                        if PST:getTreeSnapshotMod("darkSongstress", false) and not EntityRef(target).IsCharmed and not PST:getTreeSnapshotMod("darkSongstressActive", false) then
                            -- Deal -8% damage to non-charmed enemies
                            dmgMult = dmgMult - 0.08
                        end

                        -- Song of Celerity node (Siren's tree) [Harmonic modifier]
                        if PST:getTreeSnapshotMod("songOfCelerity", false) and PST:songNodesAllocated(true) <= 2 and EntityRef(target).IsCharmed and
                        PST:getTreeSnapshotMod("songOfCelerityBuff", 0) < 15 then
                            PST:addModifiers({ tearsPerc = 1, songOfCelerityBuff = 1 }, true)
                        end
                    end
                end
            end
        end

        -- Cosmic Realignment node
        if PST:cosmicRCharPicked(PlayerType.PLAYER_AZAZEL_B) then
            -- Tainted Azazel, -40% damage dealt to enemies far away from you, based on your range stat
            local dist = PST:distBetweenPoints(tmpPlayer.Position, target.Position)
            if dist > tmpPlayer.TearRange * 0.4 then
                dmgMult = dmgMult - 0.4
            end
        elseif PST:cosmicRCharPicked(PlayerType.PLAYER_BETHANY_B) then
            -- Tainted Bethany, -4% all stats when an item wisp dies, up to -20%
            local tmpWisp = target:ToFamiliar()
            if tmpWisp and tmpWisp.Variant == FamiliarVariant.ITEM_WISP then
                if target.HitPoints <= damage * dmgMult then
                    if cosmicRCache.TBethanyDeadWisps < 5 then
                        cosmicRCache.TBethanyDeadWisps = cosmicRCache.TBethanyDeadWisps + 1
                        PST:addModifiers({ allstatsPerc = -4 }, true)
                    end
                else
                    dmgMult = dmgMult - 0.7
                end
            end
        end

        return { Damage = damage * math.max(0.01, dmgMult) }
    end
end

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
    elseif entity:IsActiveEnemy(true) and entity.Type ~= EntityType.ENTITY_BLOOD_PUPPY and not EntityRef(entity).IsFriendly then
        -- Enemy death
        local room = PST:getRoom()

        local addXP = false
        if not (entity:IsBoss() and entity.Parent) or entity.Type == EntityType.ENTITY_LARRYJR then
            if entity.SpawnerType ~= 0 then
                if PST.modData.spawnKills < 12 then
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
            if not PST:getTreeSnapshotMod("SC_nullstoneProc", false) and not PST:getTreeSnapshotMod("SC_nullstoneClear", false) and
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
            if PST:getTreeSnapshotMod("daemonArmy", false) then
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