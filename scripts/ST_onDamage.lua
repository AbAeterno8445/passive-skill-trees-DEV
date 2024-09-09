-- On entity damage
---@param target Entity
---@param damage number
---@param flag DamageFlag
---@param source EntityRef
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

        -- Reduce troll bomb disarm chance if you have curse of the tower
        if player:HasCollectible(CollectibleType.COLLECTIBLE_CURSE_OF_THE_TOWER) then
            PST.specialNodes.trollBombDisarmDebuffTimer = 45
        end

        -- Test of Temperance node (T. Magdalene's tree)
        if PST:getTreeSnapshotMod("testOfTemperance", false) and room:GetType() == RoomType.ROOM_BOSS and player:GetHearts() > 4 then
            return { Damage = damage + 1 }
        end

        -- Annihilation node (T. Judas' tree)
        if PST:getTreeSnapshotMod("annihilation", false) and PST:GetBlackHeartCount(player) >= 3 and source.Entity and source.Entity:IsBoss() and
        100 * math.random() < 25 then
            return { Damage = damage + 1 }
        end

        -- Treasured Waste node (T. Blue Baby's tree)
        if PST:getTreeSnapshotMod("treasuredWaste", false) then
            local tmpSlot = player:GetActiveItemSlot(CollectibleType.COLLECTIBLE_HOLD)
            if tmpSlot ~= -1 then
                local heldPoop = player:GetActiveItemDesc(tmpSlot).VarData
                if heldPoop == PoopSpellType.SPELL_STONE and 100 * math.random() < 8 then
                    SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE, 0.7, 2, false, 1.2)
                    return { Damage = 0 }
                elseif heldPoop == PoopSpellType.SPELL_FART and 100 * math.random() < 40 then
                    player:UseActiveItem(CollectibleType.COLLECTIBLE_BUTTER_BEAN, UseFlag.USE_NOANIM)
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
                    SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE, 0.75)
                    PST:addModifiers({ charmedHitNegationProc = true }, true)
                    return { Damage = 0 }
                end
            end
        end

        -- Mod: chance for troll bombs to deal no damage to you
        tmpTreeMod = PST:getTreeSnapshotMod("trollBombProtection", 0)
        if tmpTreeMod > 0 and source.Entity and source.Entity.Type == EntityType.ENTITY_BOMB and
        (source.Entity.Variant == BombVariant.BOMB_TROLL or source.Entity.Variant == BombVariant.BOMB_SUPERTROLL) and 100 * math.random() < tmpTreeMod then
            SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE, 0.75)
            return { Damage = 0 }
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

        -- Monster hits specifically
        if source and source.Entity then
            local tmpDmg = 0
            local tmpSource = source.Entity:ToNPC()
            if not tmpSource and source.Entity.Parent then
                tmpSource = source.Entity.Parent:ToNPC()
            end
            if tmpSource then
                -- Set hit by mob in room flag
                if not PST:getTreeSnapshotMod("roomGotHitByMob", false) then
                    PST:addModifiers({ roomGotHitByMob = true }, true)
                end

                -- Set run-wide hit flag
                if not PST:getTreeSnapshotMod("runGotHit", false) then
                    PST:addModifiers({ runGotHit = true }, true)
                end

                -- Avid Shopper node (Keeper's tree)
                if PST:getTreeSnapshotMod("avidShopper", false) then
                    player:AddCoins(-math.random(3))
                end

                -- Mod: -% coalescing soul trigger chance when hit by a monster
                tmpTreeMod = PST:getTreeSnapshotMod("coalSoulHitChance", 0)
                if tmpTreeMod > 0 and PST:getTreeSnapshotMod("coalescingSoulChance", 0) > 0 then
                    PST:addModifiers({ coalescingSoulChance = tmpTreeMod }, true)
                end

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

                -- Mod: chance to reset Dark Arts' cooldown when hit by a monster
                tmpMod = PST:getTreeSnapshotMod("darkArtsCDReset", 0)
                if tmpMod > 0 and 100 * math.random() < tmpMod then
                    local tmpSlot = player:GetActiveItemSlot(CollectibleType.COLLECTIBLE_DARK_ARTS)
                    if tmpSlot ~= -1 then
                        player:AddActiveCharge(1, tmpSlot, true, false, false)
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
        local dmgExtra = 0

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
            if tmpMod > 0 and 100 * math.random() < tmpMod then
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
                -- Wisps
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
                -- Blood clots (Sumptorium)
                elseif tmpFamiliar.Variant == FamiliarVariant.BLOOD_BABY then
                    -- Mod: release a pulse that deals damage to nearby enemies when a clot gets hit
                    if PST:getTreeSnapshotMod("clotHitPulse", false) then
                        local pulseEffect = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, tmpFamiliar.Position, Vector.Zero, nil, 0, Random() + 1)
                        pulseEffect:GetSprite().Scale = Vector(1.5, 1.5)
                        pulseEffect.Color = Color(1, 0.25, 0.25, 1)
                        SFXManager():Play(SoundEffect.SOUND_EXPLOSION_WEAK, 0.8, 2, false, 1.4)

                        for _, tmpEntity in ipairs(Isaac.FindInRadius(tmpFamiliar.Position, 70)) do
                            local tmpNPC = tmpEntity:ToNPC()
                            if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() then
                                local dmgBonus = PST:getPlayer().Damage * PST:getTreeSnapshotMod("clotPulseDmgInherit", 0) / 100
                                tmpNPC:TakeDamage(3 + dmgBonus, 0, EntityRef(tmpNPC), 0)
                            end
                        end
                    end

                    -- Resilient Blood node (T. Eve's tree)
                    if PST:getTreeSnapshotMod("resilientBlood", false) then
                        if 100 * math.random() < 25 then
                            return { Damage = 0 }
                        end
                        dmgMult = dmgMult - 0.5
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

                -- Blood Clot hit
                if tmpFamiliar.Variant == FamiliarVariant.BLOOD_BABY then
                    -- Lil Clot
                    if tmpFamiliar.SubType == 7 then
                        -- Congealed Buddy node (T. Eve's tree)
                        if PST:getTreeSnapshotMod("congealedBuddy", false) then
                            dmgMult = dmgMult + 0.2
                        end

                        -- Mod: +% lil clot damage
                        tmpMod = PST:getTreeSnapshotMod("lilClotDmg", 0)
                        if tmpMod ~= 0 then
                            dmgMult = dmgMult + tmpMod / 100
                        end
                    else
                        -- Mod: +% damage dealt by clots
                        tmpMod = PST:getTreeSnapshotMod("clotDmg", 0)
                        if tmpMod ~= 0 then
                            dmgMult = dmgMult + tmpMod / 100
                        end

                        -- Red heart clots
                        if tmpFamiliar.SubType == 0 then
                            -- Mod: +% damage dealt by red clots per 1/2 remaining red heart
                            tmpMod = PST:getTreeSnapshotMod("redClotHeartDmg", 0)
                            if tmpMod > 0 and PST:getPlayer():GetHearts() > 0 then
                                dmgMult = dmgMult + (tmpMod * PST:getPlayer():GetHearts()) / 100
                            end
                        -- Soul heart clots
                        elseif tmpFamiliar.SubType == 1 then
                            -- Mod: +% damage dealt by soul clots per 1/2 remaining soul heart
                            tmpMod = PST:getTreeSnapshotMod("soulClotHeartDmg", 0)
                            if tmpMod > 0 and PST:getPlayer():GetSoulHearts() > 0 then
                                dmgMult = dmgMult + (tmpMod * PST:getPlayer():GetSoulHearts()) / 100
                            end
                        end
                    end
                end
            elseif PST.specialNodes.SC_causeConvBossEnt and PST.specialNodes.SC_causeConvBossEnt:Exists() then
                -- Cause converter boss check
                local tmpNPC = source.Entity:ToNPC()
                if tmpNPC == nil and source.Entity.SpawnerEntity ~= nil then
                    tmpNPC = source.Entity.SpawnerEntity:ToNPC()
                end
                if tmpNPC == nil and source.Entity.Parent ~= nil then
                    tmpNPC = source.Entity.Parent:ToNPC()
                end
                if tmpNPC and tmpNPC.InitSeed == PST.specialNodes.SC_causeConvBossEnt.InitSeed then
                    dmgExtra = dmgExtra + PST:getPlayer().Damage * ((10 * PST:getLevel():GetStage()) / 100)
                end
            -- Bomb hits enemy
            elseif source.Type == EntityType.ENTITY_BOMB then
                -- Troll bomb hit
                if source.Variant == BombVariant.BOMB_TROLL or source.Variant == BombVariant.BOMB_SUPERTROLL then
                    -- Anarchy node (T. Judas' tree)
                    if PST:getTreeSnapshotMod("anarchy", false) then
                        dmgMult = dmgMult - 0.75
                    end

                    -- Mod: +luck if troll bomb kills enemy
                    local tmpMod = PST:getTreeSnapshotMod("trollBombKillLuck", 0)
                    if tmpMod > 0 and target.HitPoints <= damage * dmgMult + dmgExtra then
                        PST:addModifiers({ luck = tmpMod }, true)
                    end
                end

                -- Anarchy node (T. Judas' tree)
                if PST:getTreeSnapshotMod("anarchy", false) and target.HitPoints <= damage * dmgMult + dmgExtra then
                    local srcPlayer = PST:getPlayer()
                    local tmpSlot = srcPlayer:GetActiveItemSlot(CollectibleType.COLLECTIBLE_DARK_ARTS)
                    if tmpSlot ~= -1 then
                        srcPlayer:SetActiveCharge(srcPlayer:GetActiveCharge(tmpSlot) + 15, tmpSlot)
                    end
                end
            -- Bob's Head hit
            elseif source.Type == EntityType.ENTITY_TEAR and source.Variant == TearVariant.BOBS_HEAD then
                -- Sloth's Legacy node (T. Blue Baby's tree)
                if PST:getTreeSnapshotMod("slothLegacy", false) then
                    if target:IsBoss() and not PST:getTreeSnapshotMod("slothLegacyProc") then
                        for _=1,3 do
                            local tmpMaggot = Game():Spawn(EntityType.ENTITY_CHARGER, 0, Isaac.GetFreeNearPosition(PST:getPlayer().Position, 20), Vector.Zero, PST:getPlayer(), 0, Random() + 1)
                            tmpMaggot:ToNPC():AddCharmed(EntityRef(PST:getPlayer()), -1)
                        end
                        PST:addModifiers({ slothLegacyProc = true }, true)
                    end
                    dmgMult = dmgMult - 0.6
                end

                -- Mod: chance for Bob's Head to spawn a blue fly when hitting an enemy
                local tmpMod = PST:getTreeSnapshotMod("bobHeadFlySpawn", 0)
                if tmpMod > 0 and PST:getTreeSnapshotMod("bobHeadFliesSpawned", 0) < 8 and 100 * math.random() < tmpMod then
                    Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, source.Entity.Position, Vector.Zero, player, 0, Random() + 1)
                    PST:addModifiers({ bobHeadFliesSpawned = 1 }, true)
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
                if srcPlayer then
                    if target:IsVulnerableEnemy() then
                        local isDarkArts = false
                        -- Player effect hit
                        if source.Entity.Type == EntityType.ENTITY_EFFECT then
                            -- Dark Arts
                            if source.Entity.Variant == EffectVariant.DARK_SNARE then
                                isDarkArts = true

                                -- Mod: dark arts damage %
                                local tmpMod = PST:getTreeSnapshotMod("darkArtsDmg", 0)
                                if tmpMod ~= 0 then
                                    dmgMult = dmgMult + tmpMod / 100
                                end

                                -- Dark Expertise node (T. Judas' tree)
                                if PST:getTreeSnapshotMod("darkExpertise", false) then
                                    local tmpSlot = srcPlayer:GetActiveItemSlot(CollectibleType.COLLECTIBLE_DARK_ARTS)
                                    if tmpSlot ~= -1 then
                                        if not target:IsBoss() then
                                            srcPlayer:SetActiveCharge(srcPlayer:GetActiveCharge(tmpSlot) + 15, tmpSlot)
                                        elseif not PST.specialNodes.darkArtsBossHitProc then
                                            srcPlayer:SetActiveCharge(srcPlayer:GetActiveCharge(tmpSlot) + 60, tmpSlot)
                                            PST.specialNodes.darkArtsBossHitProc = true
                                        end
                                    end
                                end

                                -- Bounty For The Lightless node (T. Judas' tree)
                                if PST:getTreeSnapshotMod("lightlessBounty", false) and target.HitPoints <= damage * dmgMult + dmgExtra then
                                    if PST:GetBlackHeartCount(srcPlayer) < 8 and 100 * math.random() < 15 then
                                        srcPlayer:AddBlackHearts(1)
                                    end

                                    local tmpLuck = PST:getTreeSnapshotMod("lightlessBountyLuck", 0)
                                    if tmpLuck < 1 then
                                        local tmpAdd = math.min(0.03, 1 - tmpLuck)
                                        PST:addModifiers({ luck = tmpAdd, lightlessBountyLuck = tmpAdd }, true)
                                    end
                                end

                                -- Annihilation node (T. Judas' tree)
                                if PST:getTreeSnapshotMod("annihilation", false) and target:IsBoss() and PST.specialNodes.annihilationProcs < 2 and
                                not PST:arrHasValue(PST.specialNodes.annihilationHitList, target.InitSeed) then
                                    if target.MaxHitPoints * 0.1 > 40 then
                                        target:TakeDamage(target.MaxHitPoints * 0.1, 0, EntityRef(target), 0)
                                    else
                                        target:TakeDamage(40, 0, EntityRef(target), 0)
                                    end
                                    PST.specialNodes.annihilationProcs = PST.specialNodes.annihilationProcs + 1
                                    table.insert(PST.specialNodes.annihilationHitList, target.InitSeed)
                                end

                                -- Anarchy node (T. Judas' tree)
                                if PST:getTreeSnapshotMod("anarchy", false) and PST.specialNodes.anarchyBombProcs < 3 and 100 * math.random() < 25 then
                                    Game():Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_TROLL, target.Position, Vector.Zero, nil, 0, Random() + 1)
                                    PST.specialNodes.anarchyBombProcs = PST.specialNodes.anarchyBombProcs + 1
                                end

                                -- Mod: +% random stat every 12 Dark Arts kills
                                tmpMod = PST:getTreeSnapshotMod("darkArtsKillStat", 0)
                                if tmpMod > 0 and target.HitPoints <= damage * dmgMult + dmgExtra then
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
                        -- Direct non-tear player hit to enemy (e.g. melee hits)
                        elseif source.Entity.Type == EntityType.ENTITY_PLAYER then
                            -- Mod: Bag of Crafting's melee attack gains % of your damage
                            local tmpMod = PST:getTreeSnapshotMod("craftBagMeleeDmgInherit", 0)
                            if tmpMod > 0 and srcPlayer:HasCollectible(CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING) then
                                dmgExtra = dmgExtra + srcPlayer.Damage * (tmpMod / 100)
                            end

                            -- Ransacking node (T. Cain's tree)
                            if PST:getTreeSnapshotMod("ransacking", false) and target.HitPoints <= damage * dmgMult + dmgExtra then
                                if PST:getTreeSnapshotMod("ransackingRoomPickups", 0) < 5 and 100 * math.random() < 10 then
                                    local tmpNewPickup = PST:getTCainRandPickup()
                                    Game():Spawn(EntityType.ENTITY_PICKUP, tmpNewPickup[1], target.Position, Vector.Zero, nil, tmpNewPickup[2], Random() + 1)
                                    PST:addModifiers({ ransackingRoomPickups = 1 }, true)
                                end
                                PST:addModifiers({ luck = 0.02 }, true)
                            end
                        end

                        -- Mod: % damage from sources that aren't Dark Arts
                        if not isDarkArts then
                            local tmpMod = PST:getTreeSnapshotMod("nonDarkArtsDmg", 0)
                            if tmpMod ~= 0 then
                                dmgMult = dmgMult + tmpMod / 100
                            end
                        end

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
                            if (target.HitPoints - damage * dmgMult + dmgExtra) / target.MaxHitPoints <= 0.1 then
                                if 100 * math.random() < PST:getTreeSnapshotMod("bossCulling", 0) then
                                    dmgMult = dmgMult + 9
                                end
                            end

                            -- Test of Temperance node (T. Magdalene's tree)
                            if PST:getTreeSnapshotMod("testOfTemperance", false) and PST.specialNodes.testOfTemperanceCD == 0 and 100 * math.random() < 5 then
                                local tmpHeart = Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, target.Position, RandomVector() * 3, nil, HeartSubType.HEART_HALF, Random() + 1)
                                tmpHeart:ToPickup().Timeout = 60 + math.floor(PST:getTreeSnapshotMod("temporaryHeartTime", 0) * 30)
                                PST.specialNodes.testOfTemperanceCD = 15
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
                        target.HitPoints <= damage * dmgMult + dmgExtra and srcPlayer:GetPlayerType() == PlayerType.PLAYER_JACOB then
                            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, target.Position, Vector.Zero, nil, HeartSubType.HEART_HALF, Random() + 1)
                            PST:addModifiers({ jacobHeartOnKillProc = true }, true)
                        end

                        -- Mod: chance for enemies killed by Esau to drop 1/2 soul heart, once per room
                        if 100 * math.random() < PST:getTreeSnapshotMod("esauSoulOnKill", 0) and not PST:getTreeSnapshotMod("esauSoulOnKillProc", false) and
                        target.HitPoints <= damage * dmgMult + dmgExtra and srcPlayer:GetPlayerType() == PlayerType.PLAYER_ESAU then
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

                        -- Creep damage
                        if source.Type == EntityType.ENTITY_EFFECT and PST:arrHasValue(PST.playerDamagingCreep, source.Variant) then
                            -- Mod: creep damage %
                            local tmpMod = PST:getTreeSnapshotMod("creepDamage", 0)
                            if tmpMod > 0 then
                                dmgMult = dmgMult + tmpMod / 100
                            end
                        end

                        -- Treasured Waste node (T. Blue Baby's tree)
                        if PST:getTreeSnapshotMod("treasuredWaste", false) then
                            local tmpSlot = srcPlayer:GetActiveItemSlot(CollectibleType.COLLECTIBLE_HOLD)
                            if tmpSlot ~= -1 then
                                local heldPoop = srcPlayer:GetActiveItemDesc(tmpSlot).VarData
                                if heldPoop == PoopSpellType.SPELL_BURNING and 100 * math.random() < 5 then
                                    target:AddBurn(EntityRef(srcPlayer), 90, srcPlayer.Damage / 2)
                                elseif heldPoop == PoopSpellType.SPELL_STINKY and 100 * math.random() < 5 then
                                    target:AddPoison(EntityRef(srcPlayer), 90, srcPlayer.Damage / 2)
                                elseif heldPoop == PoopSpellType.SPELL_BLACK and 100 * math.random() < 5 then
                                    target:AddConfusion(EntityRef(srcPlayer), 90, false)
                                end
                            end
                        end

                        -- Congealed Buddy node (T. Eve's tree)
                        if PST:getTreeSnapshotMod("congealedBuddy", false) then
                            dmgMult = dmgMult - 0.3
                        end

                        -- Ancient starcursed jewel: Primordial Kaleidoscope
                        if PST:SC_getSnapshotMod("primordialKaleidoscope", false) then
                            if not target:HasEntityFlags(EntityFlag.FLAG_BAITED | EntityFlag.FLAG_BLEED_OUT | EntityFlag.FLAG_BURN | EntityFlag.FLAG_CHARM | EntityFlag.FLAG_CONFUSION | EntityFlag.FLAG_FEAR | EntityFlag.FLAG_POISON | EntityFlag.FLAG_SLOW | EntityFlag.FLAG_SHRINK | EntityFlag.FLAG_FREEZE) then
                                dmgMult = dmgMult - 0.5
                                if target:IsBoss() and target:GetBossStatusEffectCooldown() > 0 then
                                    target:SetBossStatusEffectCooldown(math.max(0, target:GetBossStatusEffectCooldown() - 15))
                                end
                            end
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
                if target.HitPoints <= damage * dmgMult + dmgExtra then
                    if cosmicRCache.TBethanyDeadWisps < 5 then
                        cosmicRCache.TBethanyDeadWisps = cosmicRCache.TBethanyDeadWisps + 1
                        PST:addModifiers({ allstatsPerc = -4 }, true)
                    end
                else
                    dmgMult = dmgMult - 0.7
                end
            end
        end

        return { Damage = damage * math.max(0.01, dmgMult) + dmgExtra }
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