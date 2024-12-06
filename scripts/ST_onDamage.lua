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
        -- Boon: block the first X hits you receive every floor
        if PST:getTreeSnapshotMod("boonAegisSpent", 0) > 0 then
            local tmpSprite = Sprite("gfx/ui/skilltrees/nodes/expedition_boons.anm2", true)
            tmpSprite:SetFrame("Boons", 9)
            PST:createFloatIconFX(tmpSprite, Vector.Zero, 0.3, 70, true)

            SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE, 0.6, 2, false, 1.2)
            PST:addModifiers({ boonAegisSpent = -1 }, true)
            return { Damage = 0 }
        end

        -- Fickle Fortune node (Cain's tree) - also Expedition curse: flimsy gadgets
        local tmpChance = 0
        if PST:getTreeSnapshotMod("fickleFortune", false) then
            tmpChance = 7
        end
        tmpChance = tmpChance + PST:getTreeSnapshotMod("curseFlimGadgDrop", 0)

        if tmpChance > 0 and 100 * math.random() < tmpChance then
            local vanishChance = 0
            if PST:getTreeSnapshotMod("fickleFortune", false) then
                vanishChance = 7
            end
            vanishChance = vanishChance + PST:getTreeSnapshotMod("curseFlimGadgVanish", 0)

            if vanishChance > 0 and 100 * math.random() < vanishChance then
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

        -- Entanglement node (T. Lazarus' tree)
        if PST:getTreeSnapshotMod("entanglement", false) and not PST:getTreeSnapshotMod("entanglementProc", false) and damage >= tmpHP then
            local otherForm = PST:getTLazOtherForm()
            if otherForm then
                PST:addModifiers({ entanglementProc = true }, true)
                SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE)
                SFXManager():Play(SoundEffect.SOUND_ANGEL_BEAM, 0.9, 2, false, 0.85)

                otherForm:AddMaxHearts(-otherForm:GetMaxHearts())
                otherForm:AddRottenHearts(-otherForm:GetRottenHearts())
                otherForm:AddBoneHearts(-otherForm:GetBoneHearts())
                otherForm:AddSoulHearts(-otherForm:GetSoulHearts() + damage + 1)
                local tmpSlot = player:GetActiveItemSlot(CollectibleType.COLLECTIBLE_FLIP)
                if tmpSlot ~= -1 then
                    player:AddActiveCharge(-12, tmpSlot, false, false, false)
                end
                player:UseActiveItem(CollectibleType.COLLECTIBLE_FLIP, UseFlag.USE_NOANIM)
                PST:createFloatTextFX("Entanglement!", Vector.Zero, Color(0.6, 0.9, 1, 1), 0.12, 100, true)
                return { Damage = 0 }
            end
        end

        -- Blessed Crucifix node (T. Eden's tree)
        if PST:getTreeSnapshotMod("blessedCrucifix", false) and damage >= tmpHP then
            if player:HasTrinket(TrinketType.TRINKET_WOODEN_CROSS) then
                SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE)
                PST:createFloatTextFX("Blessed Crucifix", Vector.Zero, Color(), 0.12, 100, true)
                if not player:TryRemoveTrinket(TrinketType.TRINKET_WOODEN_CROSS) then
                    player:TryRemoveSmeltedTrinket(TrinketType.TRINKET_WOODEN_CROSS)
                end
                return { Damage = 0 }
            end
        end

        -- Death's Trial nodes (T. Lost's tree)
        local tmpMod = PST:getTreeSnapshotMod("deathTrial", 0)
        if tmpMod > 0 and player:GetPlayerType() == PlayerType.PLAYER_THELOST_B and damage >= tmpHP and not PST:getTreeSnapshotMod("deathTrialProc", false) and
        100 * math.random() < tmpMod then
            player:UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW, UseFlag.USE_NOANIM)
            for i=1,0,-1 do
                if player:GetCard(i) == Card.CARD_HOLY then player:RemovePocketItem(i) end
            end
            PST:removePlayerShields()
            PST:addModifiers({ deathTrialProc = true, deathTrialActive = true, holyCardStacks = { value = 0, set = true } }, true)
            return { Damage = 0 }
        end

        -- Mod: % chance to lose smelted Polished Bone when hit
        tmpMod = PST:getTreeSnapshotMod("flawlessClearPBone", 0)
        if tmpMod > 0 and PST:getTreeSnapshotMod("flawlessPBoneProc", false) and 100 * math.random() < tmpMod then
            player:TryRemoveSmeltedTrinket(TrinketType.TRINKET_POLISHED_BONE)
            PST:addModifiers({ flawlessPBoneProc = false }, true)
        end

        -- Grand Consonance node (T. Siren's tree)
        if PST:getTreeSnapshotMod("grandConsonance", false) then
            local consonanceCache = PST:getTreeSnapshotMod("grandConsonanceCache", nil)
            if consonanceCache then
                -- Dry Baby: 25% chance to block incoming hits, up to thrice per room. 25% chance on block to trigger necronomicon
                -- Additional dry babies increase max blocks per room by 2
                local dryBabies = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_DRY_BABY)
                if dryBabies > 0 then
                    if consonanceCache.dryBabyProcs == nil then consonanceCache.dryBabyProcs = 0 end
                    local maxProcs = 3 + (dryBabies - 1) * 2
                    if consonanceCache.dryBabyProcs < maxProcs and 100 * math.random() < 25 then
                        local tmpSprite = Sprite("gfx/003.265_drybaby.anm2", true)
                        tmpSprite:SetFrame("Hit", 16)
                        PST:createFloatIconFX(tmpSprite, Vector.Zero, 0.13, 100, true)
                        SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE, 0.35)
                        consonanceCache.dryBabyProcs = consonanceCache.dryBabyProcs + 1

                        if 100 * math.random() < 25 then
                            player:UseActiveItem(CollectibleType.COLLECTIBLE_NECRONOMICON)
                        end
                        return { Damage = 0 }
                    end
                end

                -- BBF: 50% chance when hit to trigger an explosion at your position, once per room. +1 max explosion per room per additional BBF
                local BBFs = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BBF)
                if BBFs > 0 then
                    if consonanceCache.BBFProcs == nil then consonanceCache.BBFProcs = 0 end
                    if consonanceCache.BBFProcs < BBFs and 100 * math.random() < 50 then
                        Isaac.Explode(player.Position, player, 100)
                        consonanceCache.BBFProcs = consonanceCache.BBFProcs + 1
                    end
                end
            end

            -- Depression: chance to retaliate with a crack the sky beam when hit
            local depressionCount = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_DEPRESSION)
            if depressionCount > 0 and 100 * math.random() < math.min(15, 5 * depressionCount) then
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, source.Entity.Position, Vector.Zero, nil)
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

        -- Monster hits specifically
        if source and source.Entity then
            local tmpDmg = 0
            local tmpSource = source.Entity:ToNPC()
            if not tmpSource and source.Entity.Parent then
                tmpSource = source.Entity.Parent:ToNPC()
            end
            if not tmpSource and source.Entity.SpawnerEntity then
                tmpSource = source.Entity.SpawnerEntity:ToNPC()
            end
            if tmpSource and tmpSource.Type ~= EntityType.ENTITY_FIREPLACE then
                -- Ancient weapon mod: Quicksilver
                if PST.specialNodes.ancwep_quicksilverParrying > 0 then
                    SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE, 0.5, 2, false, 1.3)
                    player:SetColor(Color(1, 1, 1, 1, 0.4, 0.4, 0.8), 12, 1, true, false)
                    player:SetMinDamageCooldown(12)

                    if PST.specialNodes.ancwep_quicksilverBuff == 0 then
                        PST:updateCacheDelayed(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY)
                    end
                    PST.specialNodes.ancwep_quicksilverBuff = 90

                    PST:addModifiers({ ancwep_quicksilverProc = true }, true)
                    PST.specialNodes.ancwep_quicksilverParrying = 0
                    return false
                end

                -- Set hit by mob in room flag
                if not PST:getTreeSnapshotMod("roomGotHitByMob", false) then
                    PST:addModifiers({ roomGotHitByMob = true }, true)
                end
                PST:addModifiers({ roomHitsReceived = 1, floorHitsReceived = 1 }, true)

                -- Set floor-wide hit flag
                if not PST:getTreeSnapshotMod("floorGotHit", false) then
                    PST:addModifiers({ floorGotHit = true }, true)
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
                    tmpChance = 40
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
                tmpMod = PST:SC_getSnapshotMod("mobExtraHitDmg", 0)
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

                -- Great Overlap node (T. Lazarus' tree)
                if PST:getTreeSnapshotMod("greatOverlap", false) and 100 * math.random() < 50 then
                    local tmpSlot = player:GetActiveItemSlot(CollectibleType.COLLECTIBLE_FLIP)
                    if tmpSlot ~= -1 then
                        player:AddActiveCharge(-1, tmpSlot, false, false, false)
                    end
                end

                -- Chaos Take The World node (T. Eden's tree)
                if PST:getTreeSnapshotMod("chaosTakeTheWorld", false) and not PST:getTreeSnapshotMod("chaosTakeTheWorldProc", false) then
                    PST:addModifiers({ chaosTakeTheWorldProc = true }, true)
                    player:UseActiveItem(CollectibleType.COLLECTIBLE_D10, UseFlag.USE_NOANIM)
                end

                -- Mod: % chance not to reroll items when hit by monsters (T. Eden)
                tmpMod = PST:getTreeSnapshotMod("rerollAvoidance", 0)
                if tmpMod > 0 and damage < tmpHP and 100 * math.random() < tmpMod then
                    player:AddCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
                    player:TakeDamage(damage, flag, EntityRef(nil), 0)
                    player:RemoveCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
                    PST:createFloatTextFX("Items Protected", Vector.Zero, Color(), 0.13, 70, true)
                    return { Damage = 0 }
                end

                -- Mod: % chance to trigger a random active item effect from the Devil item pool when hit, once per room
                tmpMod = PST:getTreeSnapshotMod("devilActiveOnHit", 0)
                if tmpMod > 0 and not PST:getTreeSnapshotMod("devilActiveOnHitProc", false) and 100 * math.random() < tmpMod then
                    PST.specialNodes.activeOnHitProc.pool = ItemPoolType.POOL_DEVIL
                    PST.specialNodes.activeOnHitProc.procMod = "devilActiveOnHitProc"
                    PST.specialNodes.activeOnHitProc.proc = true
                end
                -- Mod: % chance to trigger a random active item effect from the Angel item pool when hit, once per room
                tmpMod = PST:getTreeSnapshotMod("angelActiveOnHit", 0)
                if tmpMod > 0 and not PST:getTreeSnapshotMod("angelActiveOnHitProc", false) and 100 * math.random() < tmpMod then
                    PST.specialNodes.activeOnHitProc.pool = ItemPoolType.POOL_ANGEL
                    PST.specialNodes.activeOnHitProc.procMod = "angelActiveOnHitProc"
                    PST.specialNodes.activeOnHitProc.proc = true
                end

                -- Mod: % chance to gain a passive treasure room item when hit, for the current room, excluding hp up items
                tmpMod = PST:getTreeSnapshotMod("treasureItemOnHit", 0)
                if tmpMod > 0 and PST:getTreeSnapshotMod("treasureItemOnHitItem", 0) == 0 and 100 * math.random() < tmpMod then
                    PST.specialNodes.treasureItemOnHitProc = true
                end

                -- Mod: % chance to gain a passive treasure room item when hit, for the current room, excluding hp up items
                tmpMod = PST:getTreeSnapshotMod("higherQualityReroll", 0)
                if tmpMod > 0 and PST:getTreeSnapshotMod("higherQualityRerollProcs", 0) < 5 and 100 * math.random() < tmpMod then
                    PST:addModifiers({ higherQualityRerollProcs = 1 }, true)
                    PST.specialNodes.higherQualityRerollProc = true
                end

                -- Blessed Pennies node (T. Keeper's tree)
                if PST:getTreeSnapshotMod("blessedPennies", false) then
                    for i=1,0,-1 do
                        local tmpTrinket = player:GetTrinket(i)
                        if PST:arrHasValue(PST.pennyTrinkets, tmpTrinket) then
                            player:TryRemoveTrinket(tmpTrinket)
                        end
                    end
                end

                -- Voodoo Trick node (T. Keeper's tree)
                if PST:getTreeSnapshotMod("voodooTrick", false) then
                    PST:addModifiers({ voodooTrickHits = 1 }, true)
                end

                -- Astral weapon mod: + base damage, removed for X secs when you get hit
                tmpMod = PST:getSnapAstralWepMod("baseDmg2")
                if tmpMod then
                    if PST.specialNodes.astralwep_baseDmg2Disable == 0 then
                        PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
                    end
                    PST.specialNodes.astralwep_baseDmg2Disable = math.ceil(tmpMod[2] * 30)
                end

                -- Astral weapon mod: enemies take % more damage for X seconds after you get hit
                tmpMod = PST:getSnapAstralWepMod("onHitEnemyDmgTaken")
                if tmpMod then
                    PST.specialNodes.astralwep_onHitEnemyDmgTimer = math.ceil(tmpMod[2] * 30)
                end

                -- Ancient weapon mod: Mighty Purifier
                tmpMod = PST:getSnapAstralWepMod("mightyPurifier")
                if tmpMod then
                    if PST:isMobUndead(tmpSource) and 100 * math.random() < tmpMod[2] then
                        SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE, 0.9, 2, false, 1.2)
                        return { Damage = 0 }
                    end
                end

                -- Ancient starcursed jewel: Phantasm Prism
                if PST:SC_getSnapshotMod("phantasmPrism", false) and PST:getTreeSnapshotMod("SC_phantasmChance", 0) < 50 and
                PST:isMobUndead(tmpSource) then
                    PST:addModifiers({ SC_phantasmChance = 4 }, true)
                end

                -- Ancient weapon mod: Firestarter
                tmpMod = PST:getSnapAstralWepMod("firestarter")
                if tmpMod and source.Entity:GetBurnCountdown() > 0 then
                    if PST.specialNodes.ancwep_firestarterBuffTimer == 0 then
                        PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
                    end
                    PST.specialNodes.ancwep_firestarterBuffTimer = 90
                end

                -- Beast-hunter's Rush node
                if PST:getTreeSnapshotMod("beasthunterRush", false) then
                    Game().BossRushParTime = Game().BossRushParTime + 90
                end

                -- Ancient starcursed jewel: Mistlestone
                if PST:SC_getSnapshotMod("mistlestone", false) then
                    PST:addModifiers({ devilChance = -5 }, true)
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
        local srcPlayer
        if source and source.Entity then
            if source.Type == EntityType.ENTITY_PLAYER then
                srcPlayer = source.Entity:ToPlayer()
            elseif source.Entity.SpawnerEntity and source.Entity.SpawnerEntity == EntityType.ENTITY_PLAYER then
                srcPlayer = source.Entity.SpawnerEntity:ToPlayer()
            elseif source.Entity.Parent and source.Entity.Parent == EntityType.ENTITY_PLAYER then
                srcPlayer = source.Entity.Parent:ToPlayer()
            end
        end
        if not srcPlayer then srcPlayer = PST:getPlayer() end

        local dmgMult = 1
        local dmgExtra = 0

        -- Valid enemy
        if target:IsVulnerableEnemy() and target:IsActiveEnemy(false) and not EntityRef(target).IsFriendly then
            -- Starcursed mod: Damage reduction
            local tmpMod = PST:SC_getSnapshotMod("mobDmgReduction", 0)
            dmgMult = dmgMult - tmpMod / 100

            -- Starcursed mod: Damage reduction from explosions
            tmpMod = PST:SC_getSnapshotMod("mobExplosionDR", 0)
            if (flag & DamageFlag.DAMAGE_EXPLOSION) ~= 0 and tmpMod ~= 0 then
                dmgMult = dmgMult - tmpMod / 100
            end

            -- Starcursed mod: Damage blocking
            local blockedDamage = false
            local partialBlock = false
            tmpMod = PST:SC_getSnapshotMod("mobBlock", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                partialBlock = true
            end

            -- Starcursed mod: First hits blocked
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

            -- Ancient starcursed jewel: Circadian destructor - explosion immunity
            if PST.specialNodes.SC_circadianExplImmune > 0 and (flag & DamageFlag.DAMAGE_EXPLOSION) ~= 0 then
                blockedDamage = true
            end

            -- Ancient starcursed jewel: Gaze Averter
            if PST:SC_getSnapshotMod("gazeAverter", false) then
                local dir = srcPlayer:GetHeadDirection()
                if dir == Direction.LEFT and target.Position.X < srcPlayer.Position.X or
                dir == Direction.RIGHT and target.Position.X > srcPlayer.Position.X or
                dir == Direction.UP and target.Position.Y < srcPlayer.Position.Y or
                dir == Direction.DOWN and target.Position.Y > srcPlayer.Position.Y then
                    dmgMult = dmgMult - 0.75
                end
            end

            -- Close Keeper node (T. Apollyon's tree)
            if PST:getTreeSnapshotMod("closeKeeper", false) then
                local dmgAdd = 0
                for _, tmpLocust in ipairs(PST.specialNodes.activeLocusts) do
                    if target.Position:Distance(tmpLocust.Position) < 50 then
                        if dmgAdd < 10 then
                            dmgMult = dmgMult + 0.02
                            dmgAdd = dmgAdd + 1
                        else break end
                    end
                end
            end

            -- Harmonized Specters node (T. Forgotten's tree)
            if PST:getTreeSnapshotMod("harmonizedSpecters", false) then
                local tmpTwin = srcPlayer:GetOtherTwin()
                if tmpTwin then
                    local tmpFulfilled = false
                    local inGround = 1 - math.max(math.abs(srcPlayer.Velocity.X), math.abs(srcPlayer.Velocity.Y)) > 0.9
                    if target.Position:Distance(tmpTwin.Position) <= 110 then
                        dmgMult = dmgMult + 0.12
                        tmpFulfilled = true
                    end
                    if srcPlayer.Position:Distance(tmpTwin.Position) > 10 and inGround then
                        dmgMult = dmgMult + 0.12
                        tmpFulfilled = true
                    end
                    if not tmpFulfilled then
                        dmgMult = dmgMult - 0.2
                    end
                end
            end

            -- Mod: +% damage taken by paralyzed enemies
            tmpMod = PST:getTreeSnapshotMod("paraEnemyDmg", 0)
            if tmpMod > 0 and target:GetFreezeCountdown() > 0 then
                dmgMult = dmgMult + tmpMod / 100
            end

            -- Enemies chained by Anima Sola
            if PST:arrHasValue(PST.specialNodes.animaChainedMobs, target.InitSeed) then
                -- Mod: +% damage taken by enemies chained by Anima Sola
                tmpMod = PST:getTreeSnapshotMod("chainedEnemyDmg", 0)
                if tmpMod > 0 then
                    dmgMult = dmgMult + tmpMod / 100
                end
            end

            -- Mod: +% damage taken by slowed enemies
            tmpMod = PST:getTreeSnapshotMod("slowEnemyDmg", 0)
            if tmpMod > 0 and target:GetSlowingCountdown() > 0 then
                dmgMult = dmgMult + tmpMod / 100
            end

            -- Feared enemies
            if target:GetFearCountdown() > 0 then
                -- Mod: +% damage taken by feared enemies
                tmpMod = PST:getTreeSnapshotMod("fearedDmg", 0)
                if tmpMod > 0 then
                    dmgMult = dmgMult + tmpMod / 100
                end

                -- Boon: +% damage taken by feared enemies
                tmpMod = PST:getTreeSnapshotMod("boonHorrorDmg", 0)
                if tmpMod > 0 then
                    dmgMult = dmgMult + tmpMod / 100
                end
            end

            -- Charmed enemies
            if target:GetCharmedCountdown() > 0 then
                -- Boon: +% damage taken by charmed enemies
                tmpMod = PST:getTreeSnapshotMod("boonHypnoDmg", 0)
                if tmpMod > 0 then
                    dmgMult = dmgMult + tmpMod / 100
                end
            end

            -- Paralyzed enemies
            if target:GetFreezeCountdown() > 0 then
                -- Boon: paralyzed enemies take 30% more damage from explosions
                if PST:getTreeSnapshotMod("boonParaChance", 0) > 0 and (flag & DamageFlag.DAMAGE_EXPLOSION) > 0 then
                    dmgMult = dmgMult + 0.3
                end
            end

            -- Explosion hits
            if (flag & DamageFlag.DAMAGE_EXPLOSION) > 0 then
                -- Boon: enemies take % more damage from explosions
                tmpMod = PST:getTreeSnapshotMod("boonVolatilityDmg", 0)
                if tmpMod > 0 then
                    dmgMult = dmgMult + tmpMod / 100
                end

                -- Expedition curse: diminished powers
                tmpMod = PST:getTreeSnapshotMod("curseDimPowerExpl", 0)
                if tmpMod > 0 then
                    dmgMult = dmgMult - tmpMod / 100
                end
            end

            -- Laser hits
            if (flag & DamageFlag.DAMAGE_LASER) > 0 then
                -- Expedition curse: diminished powers
                tmpMod = PST:getTreeSnapshotMod("curseDimPowerLaser", 0)
                if tmpMod > 0 then
                    dmgMult = dmgMult - tmpMod / 100
                end
            end

            -- Expedition curse: giants' fortification
            tmpMod = PST:getTreeSnapshotMod("curseGiantsFort", 0)
            if tmpMod > 0 and target:IsBoss() then
                if not target:GetData().PST_giantFortBlocks then
                    target:GetData().PST_giantFortBlocks = tmpMod
                elseif target:GetData().PST_giantFortBlocks > 0 then
                    partialBlock = true
                    target:GetData().PST_giantFortBlocks = target:GetData().PST_giantFortBlocks - 1
                end
            end

            -- Expedition curse: abundant might
            tmpMod = PST:getTreeSnapshotMod("curseAbundantMightDmgRed", 0)
            if tmpMod > 0 then
                local tmpNPC = target:ToNPC()
                if tmpNPC and tmpNPC:IsChampion() then
                    dmgMult = dmgMult - tmpMod / 100
                end
            end

            if blockedDamage or PST.specialNodes.mobPeriodicShield then
                SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE, 0.2, 2, false, 1.3)
                return { Damage = 0 }
            elseif partialBlock then
                SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE, 0.2, 2, false, 1.4)
                return { Damage = damage * dmgMult * 0.35 }
            end

            -- Boon: chance to slow enemy on hit
            tmpMod = PST:getTreeSnapshotMod("boonLethargyChance", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                target:AddSlowing(EntityRef(srcPlayer), math.ceil(PST:getTreeSnapshotMod("boonLethargyLen", 0) * 30), 0.8, Color(0.8, 0.8, 0.8, 1))
            end

            -- Boon: chance to fear enemy on hit
            tmpMod = PST:getTreeSnapshotMod("boonHorrorChance", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                target:AddFear(EntityRef(srcPlayer), math.ceil(PST:getTreeSnapshotMod("boonHorrorLen", 0) * 30))
            end

            -- Boon: chance to charm enemy on hit
            tmpMod = PST:getTreeSnapshotMod("boonHypnoChance", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                target:AddCharmed(EntityRef(srcPlayer), math.ceil(PST:getTreeSnapshotMod("boonHypnoLen", 0) * 30))
            end

            -- Boon: chance to paralyze enemy on hit
            tmpMod = PST:getTreeSnapshotMod("boonParaChance", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                target:AddFreeze(EntityRef(srcPlayer), math.ceil(PST:getTreeSnapshotMod("boonParaLen", 0) * 30))
            end

            -- Player/familiar hit
            if source and source.Entity and
            (source.Entity:ToPlayer() or (source.Entity.SpawnerEntity and source.Entity.SpawnerEntity:ToPlayer()) or (source.Entity.Parent and source.Entity.Parent:ToPlayer()) or
            source.Entity:ToFamiliar() or (source.Entity.SpawnerEntity and source.Entity.SpawnerEntity:ToFamiliar()) or (source.Entity.Parent and source.Entity.Parent:ToFamiliar())) then
                -- Astral weapon mod: longsword implicit
                tmpMod = PST:getSnapAstralWepMod("longswordImp")
                if tmpMod and srcPlayer.Position:Distance(target.Position) <= PST:getTilesDist(1.5) then
                    dmgMult = dmgMult + tmpMod[1] / 100
                end

                -- Astral weapon mod: estoc implicit
                tmpMod = PST:getSnapAstralWepMod("estocImp")
                if tmpMod then
                    local tmpBuff = PST:getTreeSnapshotMod("astralwep_estocImpBonus", 0)
                    if srcPlayer.Position:Distance(target.Position) <= PST:getTilesDist(2) then
                        if tmpBuff < tmpMod[2] then
                            local tmpAdd = math.min(tmpMod[1], tmpMod[2] - tmpBuff)
                            PST:addModifiers({ tearsPerc = tmpAdd, astralwep_estocImpBonus = tmpAdd }, true)
                        end
                    else
                        PST:addModifiers({ tearsPerc = -tmpBuff, astralwep_estocImpBonus = { value = 0, set = true } }, true)
                    end
                end

                -- Astral weapon mod: dagger implicit
                tmpMod = PST:getSnapAstralWepMod("daggerImp")
                if tmpMod then
                    local tmpChance = tmpMod[1]
                    if srcPlayer.Position:Distance(target.Position) <= PST:getTilesDist(1.5) then
                        tmpChance = tmpChance * 2
                    end
                    if 100 * math.random() < tmpChance then
                        dmgMult = dmgMult + tmpMod[2] / 100
                    end
                end

                -- Astral weapon mod: quickblade implicit
                tmpMod = PST:getSnapAstralWepMod("quickbladeImp")
                if tmpMod then
                    if not PST:getTreeSnapshotMod("astralwep_quickbladeImpStacks", nil) then
                        PST.modData.treeModSnapshot["astralwep_quickbladeImpStacks"] = {}
                    end
                    local stackList = PST.modData.treeModSnapshot["astralwep_quickbladeImpStacks"]
                    if #stackList < 15 then
                        local tmpDuration = tmpMod[2]
                        if srcPlayer.Position:Distance(target.Position) <= PST:getTilesDist(1.5) then
                            tmpDuration = tmpDuration * 2
                        end
                        table.insert(stackList, math.ceil(tmpDuration * 30))
                        PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
                    end
                end

                -- Astral weapon mod: spear implicit
                tmpMod = PST:getSnapAstralWepMod("spearImp")
                if tmpMod then
                    local dist = srcPlayer.Position:Distance(target.Position)
                    if dist > PST:getTilesDist(1.5) and dist <= PST:getTilesDist(2.5) then
                        dmgMult = dmgMult + tmpMod[1] / 100
                    elseif dist <= PST:getTilesDist(1.5) then
                        dmgMult = dmgMult - tmpMod[2] / 100
                    end
                end

                -- Astral weapon mod: trident implicit
                tmpMod = PST:getSnapAstralWepMod("tridentImp")
                if tmpMod then
                    local tmpBuff = PST:getTreeSnapshotMod("astralwep_tridentImpBonus", 0)
                    if srcPlayer.Position:Distance(target.Position) > PST:getTilesDist(2) then
                        if tmpBuff < tmpMod[2] then
                            local tmpAdd = math.min(tmpMod[1], tmpMod[2] - tmpBuff)
                            PST:addModifiers({ damagePerc = tmpAdd, tearsPerc = tmpAdd, astralwep_tridentImpBonus = tmpAdd }, true)
                        end
                    else
                        PST:addModifiers({ damagePerc = -tmpBuff, tearsPerc = -tmpBuff, astralwep_tridentImpBonus = { value = 0, set = true } }, true)
                    end
                end

                -- Astral weapon mod: scythe implicit
                tmpMod = PST:getSnapAstralWepMod("scytheImp")
                if tmpMod then
                    if PST.specialNodes.astralwep_scytheCD == 0 then
                        local function PST_tmpDmgTick(dmg)
                            return function()
                                local nearbyEnemies = Isaac.FindInRadius(target.Position, 120, EntityPartition.ENEMY)
                                local applyFear = false
                                for _, tmpEnemy in ipairs(nearbyEnemies) do
                                    if tmpEnemy:IsActiveEnemy(false) and tmpEnemy:IsVulnerableEnemy() and not EntityRef(tmpEnemy).IsFriendly then
                                        tmpEnemy:TakeDamage(dmg, 0, EntityRef(srcPlayer), 0)
                                        if tmpEnemy:HasMortalDamage() or tmpEnemy:IsBoss() then
                                            applyFear = true
                                        end
                                    end
                                end
                                if PST:getSnapAstralWepMod("mobripper") and applyFear then
                                    for _, tmpEnemy in ipairs(nearbyEnemies) do
                                        if tmpEnemy:IsActiveEnemy(false) and tmpEnemy:IsVulnerableEnemy() and not EntityRef(tmpEnemy).IsFriendly and
                                        (not tmpEnemy:IsBoss() or (tmpEnemy:IsBoss() and math.random() < 0.2)) then
                                            tmpEnemy:AddFear(EntityRef(srcPlayer), 90)
                                        end
                                    end
                                end
                            end
                        end
                        local scytheDmg = math.min(srcPlayer.Damage * 4, damage * (tmpMod[1] / 100))
                        local mobripper = PST:getSnapAstralWepMod("mobripper")
                        if mobripper then
                            scytheDmg = damage * (mobripper[1] / 100)
                        end
                        local slashSpr = PST:createAnimFXAt("gfx/effect_wepslash.anm2", "Spin", target.Position, {
                            [3] = PST_tmpDmgTick(scytheDmg)
                        })
                        SFXManager():Play(SoundEffect.SOUND_SWORD_SPIN, 0.7, 2, false, 0.9 + 0.2 * math.random())
                        PST.specialNodes.astralwep_scytheCD = math.ceil(tmpMod[2] * 30)
                    end
                end

                -- Astral weapon mod: axe implicit
                tmpMod = PST:getSnapAstralWepMod("axeImp")
                if tmpMod then
                    if target:GetBleedingCountdown() > 0 then
                        dmgMult = dmgMult + tmpMod[2] / 100
                    end
                    if 100 * math.random() < tmpMod[1] then
                        target:AddBleeding(EntityRef(srcPlayer), 90)
                    end
                end

                -- Astral weapon mod: greataxe implicit
                tmpMod = PST:getSnapAstralWepMod("greataxeImp")
                if tmpMod then
                    if target:GetBleedingCountdown() > 0 then
                        PST.specialNodes.astralwep_greataxeBuffTimer = 60
                        PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
                    end

                    -- Apply bleeding every X hits
                    if not target:GetData().PST_greataxeHits then
                        target:GetData().PST_greataxeHits = 0
                    end
                    target:GetData().PST_greataxeHits = target:GetData().PST_greataxeHits + 1
                    if target:GetData().PST_greataxeHits >= tmpMod[1] then
                        target:AddBleeding(EntityRef(srcPlayer), 120)
                        target:GetData().PST_greataxeHits = 0
                    end
                end

                -- Astral weapon mod: bow implicit
                tmpMod = PST:getSnapAstralWepMod("bowImp")
                if tmpMod then
                    local dist = srcPlayer.Position:Distance(target.Position)
                    local maxDist = 250
                    dmgMult = dmgMult + (tmpMod[2] * math.min(1, dist / maxDist)) / 100
                end

                -- Ancient weapon mod: Redbeak
                tmpMod = PST:getSnapAstralWepMod("redbeak")
                if tmpMod then
                    if srcPlayer:GetHearts() > 0 and srcPlayer:GetHearts() / srcPlayer:GetEffectiveMaxHearts() <= 0.5 then
                        dmgMult = dmgMult + tmpMod[1] / 100

                        if 100 * math.random() < tmpMod[2] then
                            target:AddBleeding(EntityRef(srcPlayer), 120)
                        end
                    end
                end

                -- Ancient weapon mod: The Scrambler
                tmpMod = PST:getSnapAstralWepMod("scrambler")
                if tmpMod then
                    if (target:GetEntityFlags() & EntityFlag.FLAG_CONFUSION) > 0 then
                        dmgMult = dmgMult + tmpMod[1] / 100
                        if 100 * math.random() < tmpMod[2] then
                            target:SetConfusionCountdown(0)
                        end
                    end

                    local tmpChance = 3 + PST:getTreeSnapshotMod("ancwep_scramblerChance", 0)
                    if srcPlayer.Position:Distance(target.Position) <= PST:getTilesDist(1.5) then
                        tmpChance = tmpChance * 3
                    end
                    if 100 * math.random() < tmpChance then
                        target:AddConfusion(EntityRef(srcPlayer), 120, false)
                    end
                end

                -- Ancient weapon mod: Adrift Blade
                tmpMod = PST:getSnapAstralWepMod("adriftBlade")
                if tmpMod and 100 * math.random() < tmpMod[1] then
                    local randRoll = math.random(tmpMod[2], tmpMod[3])
                    dmgMult = dmgMult + (randRoll / 100 - 1)
                end

                -- Ancient weapon mod: Beastbane
                tmpMod = PST:getSnapAstralWepMod("beastbane")
                if tmpMod and target:IsBoss() then
                    dmgMult = dmgMult + tmpMod[1] / 100
                end

                -- Ancient weapon mod: Tale Ender
                tmpMod = PST:getSnapAstralWepMod("taleEnder")
                if tmpMod and target.HitPoints >= target.MaxHitPoints * 0.99 then
                    dmgMult = dmgMult + tmpMod[1] / 100
                end

                -- Ancient weapon mod: Crimson Reaper
                tmpMod = PST:getSnapAstralWepMod("crimsonReaper")
                if tmpMod then
                    if target:GetBleedingCountdown() > 0 then
                        local targetHP = target.HitPoints / target.MaxHitPoints
                        local bleedDmgMult = math.max(0, tmpMod[2] / 100 - targetHP)
                        dmgMult = dmgMult + bleedDmgMult
                    end
                    if target.HitPoints >= target.MaxHitPoints * 0.99 then
                        local tmpDur = math.ceil(tmpMod[1] * 30)
                        if target:IsBoss() then
                            tmpDur = tmpDur * 2
                        end
                        target:AddBleeding(EntityRef(srcPlayer), tmpDur)
                    end
                end

                -- Ancient weapon mod: Quill Rain
                tmpMod = PST:getSnapAstralWepMod("quillRain")
                if tmpMod and srcPlayer.Position:Distance(target.Position) <= PST:getTilesDist(tmpMod[1]) then
                    dmgMult = dmgMult - (tmpMod[2] / 100)
                end

                -- Ancient weapon mod: Brute's Onslaught
                tmpMod = PST:getSnapAstralWepMod("bruteOnslaught")
                if tmpMod and PST.specialNodes.ancwep_bruteOnslaughtHits > 0 then
                    dmgMult = dmgMult + (tmpMod[1] / 100)
                    PST.specialNodes.ancwep_bruteOnslaughtHits = PST.specialNodes.ancwep_bruteOnslaughtHits - 1
                end

                -- Ancient weapon mod: Mighty Purifier
                tmpMod = PST:getSnapAstralWepMod("mightyPurifier")
                if tmpMod then
                    local isUndead = PST:arrHasValue(PST.undeadEnemies, target.Type)
                    if not isUndead then
                        local tmpVariant = PST.undeadEnemiesSpec[target.Type]
                        if tmpVariant then
                            if (type(tmpVariant) == "table" and PST:arrHasValue(tmpVariant, target.Variant)) or tmpVariant == target.Variant then
                                isUndead = true
                            end
                        end
                    end
                    if isUndead then
                        if not target:GetData().PST_mightyPurifierStun then
                            target:AddFreeze(EntityRef(srcPlayer), math.ceil(tmpMod[1] * 30))
                            target:GetData().PST_mightyPurifierStun = true
                        end
                        dmgMult = dmgMult + (tmpMod[3] / 100)
                    end
                end

                -- Astral weapon mod: Great Mace implicit
                tmpMod = PST:getSnapAstralWepMod("greatmaceImp")
                if tmpMod and PST.specialNodes.astralwep_greatmaceCD == 0 and (flag & DamageFlag.DAMAGE_CRUSH) == 0 then
                    local tmpDist = srcPlayer.Position:Distance(target.Position)
                    if tmpDist <= PST:getTilesDist(2.5) then
                        local colossalMaul = PST:getSnapAstralWepMod("colossalMaul")

                        -- Shockwave
                        if not colossalMaul then
                            Game():MakeShockwave(target.Position, 0.015, 0.01, 15)
                            SFXManager():Play(SoundEffect.SOUND_EXPLOSION_WEAK)
                        else
                            Game():MakeShockwave(target.Position, 0.03, 0.015, 15)
                            SFXManager():Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND, 0.85)
                        end

                        -- Paralyze nearby enemies
                        local tmpTileRange = 2.5
                        if colossalMaul then tmpTileRange = tmpTileRange * (1 + colossalMaul[3] / 100) end

                        local tmpMobs = Isaac.FindInRadius(target.Position, PST:getTilesDist(tmpTileRange), EntityPartition.ENEMY)
                        for _, tmpMob in ipairs(tmpMobs) do
                            if tmpMob:IsActiveEnemy(false) and tmpMob:IsVulnerableEnemy() and not EntityRef(tmpMob).IsFriendly then
                                local dmgMob = true
                                if tmpMob:GetFreezeCountdown() == 0 then
                                    dmgMob = false
                                    if not PST:getSnapAstralWepMod("chaoticTumult") then
                                        tmpMob:AddFreeze(EntityRef(srcPlayer), math.ceil(tmpMod[1] * 30))
                                    else
                                        local tmpStatusSrc = EntityRef(srcPlayer)
                                        local tmpStatusDur = math.ceil(tmpMod[1] * 60)
                                        -- Ancient weapon mod: Chaotic Tumult
                                        local randStatus = math.random(10)
                                        if randStatus == 1 then
                                            tmpMob:AddBurn(tmpStatusSrc, tmpStatusDur, srcPlayer.Damage)
                                        elseif randStatus == 2 then
                                            tmpMob:AddFear(tmpStatusSrc, tmpStatusDur)
                                        elseif randStatus == 3 then
                                            tmpMob:AddBaited(tmpStatusSrc, tmpStatusDur)
                                        elseif randStatus == 4 then
                                            tmpMob:AddFreeze(tmpStatusSrc, tmpStatusDur)
                                        elseif randStatus == 5 then
                                            tmpMob:AddShrink(tmpStatusSrc, tmpStatusDur)
                                        elseif randStatus == 6 then
                                            tmpMob:AddCharmed(tmpStatusSrc, tmpStatusDur)
                                        elseif randStatus == 7 then
                                            tmpMob:AddSlowing(tmpStatusSrc, tmpStatusDur, 0.8, Color(0.8, 0.8, 0.8, 1))
                                        elseif randStatus == 8 then
                                            tmpMob:AddBleeding(tmpStatusSrc, tmpStatusDur)
                                        elseif randStatus == 9 then
                                            tmpMob:AddConfusion(tmpStatusSrc, tmpStatusDur, false)
                                        elseif randStatus == 10 then
                                            tmpMob:AddPoison(tmpStatusSrc, tmpStatusDur, srcPlayer.Damage)
                                        end
                                    end
                                end
                                if dmgMob or colossalMaul then
                                    -- Damage already paralyzed enemies
                                    local tmpDmg = math.min(50, srcPlayer.Damage * (tmpMod[2] / 100))
                                    -- Ancient weapon mod: Colossal Maul
                                    if colossalMaul then tmpDmg = tmpDmg * 2 end
                                    tmpMob:TakeDamage(tmpDmg, DamageFlag.DAMAGE_CRUSH, EntityRef(srcPlayer), 0)
                                end
                            end
                        end
                        PST.specialNodes.astralwep_greatmaceCD = math.ceil(tmpMod[3] * 30)
                        if colossalMaul then
                            PST.specialNodes.astralwep_greatmaceCD = PST.specialNodes.astralwep_greatmaceCD + math.ceil(colossalMaul[1] * 30)
                            PST:updateCacheDelayed(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY)
                        end
                    end
                end

                -- Ancient weapon mod: Chaotic Tumult
                tmpMod = PST:getSnapAstralWepMod("chaoticTumult")
                if tmpMod then
                    local tmpStatusSrc = EntityRef(srcPlayer)
                    local tmpStatusDur = 90
                    if PST:entityHasAnyStatus(target) and 100 * math.random() < 15 then
                        -- Spread status to a nearby enemy
                        local nearbyEnemies = Isaac.FindInRadius(target.Position, PST:getTilesDist(tmpMod[1]), EntityPartition.ENEMY)
                        local nearbyEnem = nil
                        local dist = 9999
                        for _, tmpEnemy in ipairs(nearbyEnemies) do
                            if tmpEnemy:IsActiveEnemy(false) and tmpEnemy:IsVulnerableEnemy() and not EntityRef(tmpEnemy).IsFriendly and tmpEnemy.InitSeed ~= target.InitSeed then
                                local tmpDist = target.Position:Distance(tmpEnemy.Position)
                                if tmpDist < dist then
                                    nearbyEnem = tmpEnemy
                                    dist = tmpDist
                                end
                            end
                        end
                        if nearbyEnem then
                            if target:GetBurnCountdown() > 0 then nearbyEnem:AddBurn(tmpStatusSrc, tmpStatusDur, srcPlayer.Damage)
                            elseif target:GetFearCountdown() > 0 then nearbyEnem:AddFear(tmpStatusSrc, tmpStatusDur)
                            elseif target:GetBaitedCountdown() > 0 then nearbyEnem:AddBaited(tmpStatusSrc, tmpStatusDur)
                            elseif target:GetFreezeCountdown() > 0 then nearbyEnem:AddFreeze(tmpStatusSrc, tmpStatusDur)
                            elseif target:GetShrinkCountdown() > 0 then nearbyEnem:AddShrink(tmpStatusSrc, tmpStatusDur)
                            elseif target:GetCharmedCountdown() > 0 then nearbyEnem:AddCharmed(tmpStatusSrc, tmpStatusDur)
                            elseif target:GetSlowingCountdown() > 0 then nearbyEnem:AddSlowing(tmpStatusSrc, tmpStatusDur, 0.8, Color(0.8, 0.8, 0.8, 1))
                            elseif target:GetBleedingCountdown() > 0 then nearbyEnem:AddBleeding(tmpStatusSrc, tmpStatusDur)
                            elseif (target:GetEntityFlags() & EntityFlag.FLAG_CONFUSION) > 0 then nearbyEnem:AddConfusion(tmpStatusSrc, tmpStatusDur, false)
                            elseif (target:GetEntityFlags() & EntityFlag.FLAG_POISON) > 0 then nearbyEnem:AddPoison(tmpStatusSrc, tmpStatusDur, srcPlayer.Damage)
                            end
                        end
                    end
                end

                -- Ancient weapon mod: Firestarter
                tmpMod = PST:getSnapAstralWepMod("firestarter")
                if tmpMod then
                    local tmpChance = tmpMod[1]
                    if (flag & DamageFlag.DAMAGE_EXPLOSION) > 0 then
                        tmpChance = tmpChance * 3
                    end
                    if target:GetBurnCountdown() == 0 and 100 * math.random() < tmpChance then
                        target:AddBurn(EntityRef(srcPlayer), 150, srcPlayer.Damage)
                    end
                end

                -- Ancient weapon mod: Quicksilver
                if PST:getTreeSnapshotMod("ancwep_quicksilverProc", false) then
                    dmgMult = dmgMult + 1
                    PST:addModifiers({ ancwep_quicksilverProc = false }, true)
                end
            end

            -- Astral weapon mod: +% damage dealt to enemies affected by status effects
            tmpMod = PST:getSnapAstralWepMod("dmgStatus")
            if tmpMod and PST:entityHasAnyStatus(target) then
                dmgMult = dmgMult + tmpMod[1] / 100
            end

            -- Astral weapon mod: +% damage dealt to slowed denemies
            tmpMod = PST:getSnapAstralWepMod("dmgStatusSlow")
            if tmpMod and target:GetSlowingCountdown() > 0 then
                dmgMult = dmgMult + tmpMod[1] / 100
            end

            -- Astral weapon mod: +% damage dealt to charmed denemies
            tmpMod = PST:getSnapAstralWepMod("dmgStatusCharm")
            if tmpMod and target:GetCharmedCountdown() > 0 then
                dmgMult = dmgMult + tmpMod[1] / 100
            end

            -- Astral weapon mod: +% damage dealt to paralyzed denemies
            tmpMod = PST:getSnapAstralWepMod("dmgStatusPara")
            if tmpMod and target:GetFreezeCountdown() > 0 then
                dmgMult = dmgMult + tmpMod[1] / 100
            end

            -- Astral weapon mod: +% damage dealt to feared denemies
            tmpMod = PST:getSnapAstralWepMod("dmgStatusFear")
            if tmpMod and target:GetFearCountdown() > 0 then
                dmgMult = dmgMult + tmpMod[1] / 100
            end

            -- Astral weapon mod: +% damage dealt to bleeding denemies
            tmpMod = PST:getSnapAstralWepMod("dmgStatusBleed")
            if tmpMod and target:GetBleedingCountdown() > 0 then
                dmgMult = dmgMult + tmpMod[1] / 100
            end

            -- Astral weapon mod: +% damage dealt to poisoned denemies
            tmpMod = PST:getSnapAstralWepMod("dmgStatusPoison")
            if tmpMod and (target:GetEntityFlags() & EntityFlag.FLAG_POISON) > 0 then
                dmgMult = dmgMult + tmpMod[1] / 100
            end

            -- Astral weapon mod: +% damage dealt to burning denemies
            tmpMod = PST:getSnapAstralWepMod("dmgStatusBurn")
            if tmpMod and target:GetBurnCountdown() > 0 then
                dmgMult = dmgMult + tmpMod[1] / 100
            end

            -- Astral weapon mod: +% damage dealt after firing consecutively for 2 seconds
            tmpMod = PST:getSnapAstralWepMod("consecFireDmg")
            if tmpMod and PST.specialNodes.consecutiveFire >= 60 then
                dmgMult = dmgMult + tmpMod[1] / 100
            end

            -- Astral weapon mod: +% damage dealt after firing consecutively for 3 seconds
            tmpMod = PST:getSnapAstralWepMod("consecFireDmg2")
            if tmpMod and (PST.specialNodes.consecutiveFire >= 90 or PST.specialNodes.astralwep_consecFireBuffTimer > 0) then
                dmgMult = dmgMult + tmpMod[1] / 100
                PST.specialNodes.astralwep_consecFireBuffTimer = 30
            end

            -- Astral weapon mod: +% damage dealt to enemies beyond 2 tiles of you
            tmpMod = PST:getSnapAstralWepMod("farEnemyDmg")
            if tmpMod and srcPlayer.Position:Distance(target.Position) > PST:getTilesDist(2) then
                dmgMult = dmgMult + tmpMod[1] / 100
            end

            -- Astral weapon mod: +% damage dealt to enemies within 2 tiles of you
            tmpMod = PST:getSnapAstralWepMod("closeEnemyDmg")
            if tmpMod and srcPlayer.Position:Distance(target.Position) <= PST:getTilesDist(2) then
                dmgMult = dmgMult + tmpMod[1] / 100
            end

            -- Astral weapon mod: +% damage dealt for 5 seconds when healing red hearts, up to %
            tmpMod = PST:getSnapAstralWepMod("redHealDmg")
            if tmpMod and PST.specialNodes.astralwep_redHealTimer > 0 then
                dmgMult = dmgMult + PST.specialNodes.astralwep_redHealBuff / 100
            end

            -- Astral weapon mod: +% damage dealt for 5 seconds when gaining soul hearts, up to %
            tmpMod = PST:getSnapAstralWepMod("soulHealDmg")
            if tmpMod and PST.specialNodes.astralwep_soulHealTimer > 0 then
                dmgMult = dmgMult + PST.specialNodes.astralwep_soulHealBuff / 100
            end

            -- Astral weapon mod: +% damage dealt for 5 seconds when gaining black hearts, up to %
            tmpMod = PST:getSnapAstralWepMod("blackHealDmg")
            if tmpMod and PST.specialNodes.astralwep_blackHealTimer > 0 then
                dmgMult = dmgMult + PST.specialNodes.astralwep_blackHealBuff / 100
            end

            -- Astral weapon mod: +% damage dealt for X seconds after purchasing an item
            tmpMod = PST:getSnapAstralWepMod("purchaseDmg")
            if tmpMod and PST.specialNodes.astralwep_purchaseTimer > 0 then
                dmgMult = dmgMult + PST.specialNodes.astralwep_purchaseBuff / 100
            end

            -- Astral weapon mod: +% damage dealt for X seconds after picking up any coin
            tmpMod = PST:getSnapAstralWepMod("coinPickupDmg")
            if tmpMod and PST.specialNodes.astralwep_coinTimer > 0 then
                dmgMult = dmgMult + PST.specialNodes.astralwep_coinBuff / 100
            end

            -- Astral weapon mod: enemies take % more damage for X seconds after you get hit
            tmpMod = PST:getSnapAstralWepMod("onHitEnemyDmgTaken")
            if tmpMod and PST.specialNodes.astralwep_onHitEnemyDmgTimer > 0 then
                dmgMult = dmgMult + tmpMod[1] / 100
            end

            -- Astral weapon mod: +% damage dealt to flying if you're on ground, & vice versa
            tmpMod = PST:getSnapAstralWepMod("flyGroundDmg")
            if tmpMod and ((srcPlayer:IsFlying() and not target:IsFlying()) or (not srcPlayer:IsFlying() and target:IsFlying())) then
                dmgMult = dmgMult + tmpMod[1] / 100
            end

            -- Astral weapon mod: +% damage dealt per active familiar, up to 40%
            tmpMod = PST:getSnapAstralWepMod("activeFamDmg")
            if tmpMod then
                local activeFam = PST:getTreeSnapshotMod("totalFamiliars", 0)
                if activeFam > 0 then
                    dmgMult = dmgMult + math.min(0.4, (tmpMod[1] * activeFam) / 100)
                end
            end

            -- Astral weapon mod: +% damage dealt for X seconds after a familiar kills an enemy
            tmpMod = PST:getSnapAstralWepMod("famKillDmg")
            if tmpMod and PST.specialNodes.astralwep_famKillTimer > 0 then
                dmgMult = dmgMult + tmpMod[1] / 100
            end

            -- Astral weapon mod: +% damage dealt while you have a holy mantle shield
            tmpMod = PST:getSnapAstralWepMod("holyMantleDmg")
            if tmpMod then
                local plEffects = srcPlayer:GetEffects()
                if plEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) or plEffects:HasTrinketEffect(TrinketType.TRINKET_WOODEN_CROSS) then
                    dmgMult = dmgMult + tmpMod[1] / 100
                end
            end

            -- Astral weapon mod: +% damage dealt while you have an eternal heart
            tmpMod = PST:getSnapAstralWepMod("eternalDmg")
            if tmpMod and srcPlayer:GetEternalHearts() > 0 then
                dmgMult = dmgMult + tmpMod[1] / 100
            end

            -- Astral weapon mod: +% damage dealt for X seconds after using an active item
            tmpMod = PST:getSnapAstralWepMod("activeDmg")
            if tmpMod and PST.specialNodes.astralwep_activeDmgTimer > 0 then
                dmgMult = dmgMult + tmpMod[1] / 100
            end

            local targetHPPerc = target.HitPoints / target.MaxHitPoints
            -- Astral weapon mod: +% damage dealt to enemies above 90% HP
            tmpMod = PST:getSnapAstralWepMod("healthyMobDmg")
            if tmpMod and targetHPPerc >= 0.9 then
                dmgMult = dmgMult + tmpMod[1] / 100
            end

            -- Astral weapon mod: +% damage dealt to enemies below 15% HP
            tmpMod = PST:getSnapAstralWepMod("injuredMobDmg")
            if tmpMod and targetHPPerc <= 0.15 then
                dmgMult = dmgMult + tmpMod[1] / 100
            end

            -- Astral weapon mod: +% damage dealt while standing on creep
            tmpMod = PST:getSnapAstralWepMod("creepDmg")
            if tmpMod then
                local effectList = Isaac.FindByType(EntityType.ENTITY_EFFECT)
                for _, tmpEffect in ipairs(effectList) do
                    if PST:arrHasValue(PST.allCreep, tmpEffect.Variant) and srcPlayer.Position:Distance(tmpEffect.Position) <= 50 then
                        dmgMult = dmgMult + tmpMod[1] / 100
                        break
                    end
                end
            end

            -- Astral weapon mod: +% damage dealt with lasers
            tmpMod = PST:getSnapAstralWepMod("laserDmg")
            if tmpMod and (flag & DamageFlag.DAMAGE_LASER) then
                dmgMult = dmgMult + tmpMod[1] / 100
            end

            -- Astral weapon mod: +% damage dealt with explosions
            tmpMod = PST:getSnapAstralWepMod("explosionDmg")
            if tmpMod and (flag & DamageFlag.DAMAGE_EXPLOSION) then
                dmgMult = dmgMult + tmpMod[1] / 100
            end

            -- Astral weapon mod: +% damage dealt while half or more of your red heart containers are empty
            tmpMod = PST:getSnapAstralWepMod("injuredDmg")
            if tmpMod and srcPlayer:GetHearts() > 0 and srcPlayer:GetHearts() / srcPlayer:GetEffectiveMaxHearts() <= 0.5 then
                dmgMult = dmgMult + tmpMod[1] / 100
            end
        end

        -- Check if a familiar got hit
        local tmpFamiliar = target:ToFamiliar()
        if tmpFamiliar then
            -- Wisps
            if tmpFamiliar.Variant == FamiliarVariant.WISP then
                -- Will-o-the-Wisp node (Bethany's tree)
                if PST:getTreeSnapshotMod("willOTheWisp", false) then
                    dmgMult = dmgMult - 0.6
                end

                -- Soul Trickle node (Bethany's tree)
                if PST:getTreeSnapshotMod("soulTrickle", false) and PST:getTreeSnapshotMod("soulTrickleWispDrops", 0) < 2 and
                100 * math.random() < 5 then
                    Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, tmpFamiliar.Position, Vector.Zero, nil, HeartSubType.HEART_HALF_SOUL, Random() + 1)
                    PST:addModifiers({ soulTrickleWispDrops = 1 }, true)
                end
            -- Item wisps
            elseif tmpFamiliar.Variant == FamiliarVariant.ITEM_WISP then
                -- Resilient Flickers node (T. Bethany's tree)
                if PST:getTreeSnapshotMod("resilientFlickers", false) then
                    dmgMult = dmgMult - 0.6
                end

                -- Inherited Chaos node (T. Bethany's tree)
                if PST:getTreeSnapshotMod("inheritedChaos", false) and tmpFamiliar.SubType == CollectibleType.COLLECTIBLE_CHAOS then
                    dmgMult = dmgMult + 2
                end

                -- Mod: % chance for wisps to fire a homing tear away from you when hit
                local tmpMod = PST:getTreeSnapshotMod("wispHomingTearRetal", 0)
                if tmpMod > 0 and 100 * math.random() < tmpMod then
                    local tmpVel = (tmpFamiliar.Position - srcPlayer.Position):Normalized() * 7
                    local newTear = Game():Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, tmpFamiliar.Position, tmpVel, tmpFamiliar, 0, Random() + 1)
                    newTear:ToTear():AddTearFlags(TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_HOMING)
					newTear:ToTear().Height = srcPlayer.TearHeight
					newTear:ToTear().FallingSpeed = -srcPlayer.TearFallingSpeed * 2
                    newTear.CollisionDamage = 4
                    newTear.Color = PST:RGBColor(120, 30, 182)
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
                            local dmgBonus = srcPlayer.Damage * PST:getTreeSnapshotMod("clotPulseDmgInherit", 0) / 100
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
                    -- Mod: dead bird damage inheritance
                    local birdInheritDmg = PST:getTreeSnapshotMod("deadBirdInheritDamage", 0)
                    if birdInheritDmg > 0 then
                        dmgMult = dmgMult + birdInheritDmg / 100
                    end
                end

                if tmpFamiliar.Variant == FamiliarVariant.BLUE_FLY and tmpFamiliar.SubType == 0 then
                    -- Mod: +damage when a blue fly dies, up to +1.2. Resets every floor
                    local tmpBonus = PST:getTreeSnapshotMod("blueFlyDeathDamage", 0)
                    local tmpTotal = PST:getTreeSnapshotMod("blueFlyDeathDamageTotal", 0)
                    if tmpBonus > 0 and tmpTotal < 1.2 then
                        local tmpAdd = math.min(tmpBonus, 1.2 - tmpTotal)
                        PST:addModifiers({ damage = tmpAdd, blueFlyDeathDamageTotal = tmpAdd }, true)
                    end

                    -- Marquess of Flies node (T. Keeper's tree)
                    if PST:getTreeSnapshotMod("marquessOfFlies", false) then
                        dmgMult = dmgMult + math.min(50, PST:getPlayer():GetNumCoins()) / 100

                        if PST:getTreeSnapshotMod("marquessFliesCache", 0) > 0 then
                            PST:addModifiers({ marquessFliesCache = -1 }, true)
                            PST:updateCacheDelayed(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY)
                        end
                    end

                    -- Mod: +% damage dealt by blue flies
                    local tmpMod = PST:getTreeSnapshotMod("blueFlyDamage", 0)
                    if tmpMod > 0 then
                        dmgMult = dmgMult + tmpMod / 100
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
                        local tmpMod = PST:getTreeSnapshotMod("lilClotDmg", 0)
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

                -- Locust hit
                if tmpFamiliar.Variant == FamiliarVariant.ABYSS_LOCUST or (tmpFamiliar.Variant == FamiliarVariant.BLUE_FLY and tmpFamiliar.SubType >= 1 and tmpFamiliar.SubType <= 5) then
                    -- Locust tear
                    if source.Type == EntityType.ENTITY_TEAR then
                        damage = PST:getPlayer().Damage * (0.2 + PST:getTreeSnapshotMod("locustTearDmgInherit", 0) / 100)
                    end

                    -- Mod: +% damage dealt by locusts
                    local tmpMod = PST:getTreeSnapshotMod("locustDmg", 0)
                    if tmpMod ~= 0 then
                        dmgMult = dmgMult + tmpMod / 100
                    end

                    -- Great Devourer node (T. Apollyon's tree)
                    tmpMod = PST:getTreeSnapshotMod("greatDevourerBoost", 0)
                    if tmpFamiliar.Variant == FamiliarVariant.ABYSS_LOCUST and tmpMod > 0 then
                        dmgMult = dmgMult + tmpMod * 0.08
                    end

                    -- Extension cord laser
                    if PST:getPlayer():HasTrinket(TrinketType.TRINKET_EXTENSION_CORD) and (flag & DamageFlag.DAMAGE_LASER) > 0 then
                        -- Electrified Swarm node (T. Apollyon's tree)
                        if PST:getTreeSnapshotMod("electrifiedSwarm", false) then
                            dmgMult = dmgMult - 0.33
                        end

                        -- Great Devourer node (T. Apollyon's tree)
                        if PST:getTreeSnapshotMod("greatDevourer", false) then
                            damage = damage * 2
                        end

                        -- Mod: extension cord beam deals an additional % of your damage
                        tmpMod = PST:getTreeSnapshotMod("extCordDmgInherit", 0)
                        if tmpMod > 0 then
                            dmgExtra = dmgExtra + PST:getPlayer().Damage * (tmpMod / 100)
                        end

                        -- Mod: % chance for extension cord beams to slow for 2 seconds on hit
                        tmpMod = PST:getTreeSnapshotMod("extCordSlow", 0)
                        if tmpMod > 0 and 100 * math.random() < tmpMod then
                            target:AddSlowing(EntityRef(PST:getPlayer()), 60, 0.85, Color(0.9, 0.9, 0.9, 1))
                        end
                    end
                end

                -- Item wisp hit
                if tmpFamiliar.Variant == FamiliarVariant.ITEM_WISP then
                    -- Resilient Flickers node (T. Bethany's tree)
                    if PST:getTreeSnapshotMod("resilientFlickers", false) then
                        dmgMult = dmgMult + 0.35
                    end
                end

                -- Siren Minion hit
                local sirenMinionID = Isaac.GetEntityVariantByName("Siren Minion")
                if sirenMinionID ~= -1 and tmpFamiliar.Variant == sirenMinionID then
                    -- Mod: +% damage dealt by Siren Minions
                    local tmpMod = PST:getTreeSnapshotMod("sirenMinionDmg", 0)
                    if tmpMod > 0 then
                        dmgMult = dmgMult + tmpMod / 100
                    end
                end

                -- Mod: % non-whip damage
                local tmpMod = PST:getTreeSnapshotMod("nonWhipDmg", 0)
                if tmpMod ~= 0 then
                    dmgMult = dmgMult + tmpMod / 100
                end

                -- Grand Consonance node (T. Siren's tree)
                if PST:getTreeSnapshotMod("grandConsonance", false) then
                    -- Mom's Razor: chance for familiar hits to cause bleeding
                    local tmpRazors = PST:getPlayer():GetCollectibleNum(CollectibleType.COLLECTIBLE_MOMS_RAZOR)
                    if tmpRazors > 0 and 100 * math.random() < math.min(9, 3 * tmpRazors) then
                        target:AddBleeding(EntityRef(PST:getPlayer()), 120)
                    end

                    -- Damage reduction
                    local tmpReduction = math.min(12, PST:getTreeSnapshotMod("grandConsonanceDmg", 0)) * 4
                    if tmpReduction > 0 then
                        dmgMult = dmgMult - tmpReduction / 100
                    end
                end
            -- Bomb hits enemy
            elseif source.Type == EntityType.ENTITY_BOMB then
                -- Troll bomb hit
                if source.Variant == BombVariant.BOMB_TROLL or source.Variant == BombVariant.BOMB_SUPERTROLL then
                    -- Anarchy node (T. Judas' tree)
                    if PST:getTreeSnapshotMod("anarchy", false) then
                        dmgMult = dmgMult - 0.75
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
                    Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, source.Entity.Position, Vector.Zero, PST:getPlayer(), 0, Random() + 1)
                    PST:addModifiers({ bobHeadFliesSpawned = 1 }, true)
                end
            -- Dark Esau hit
            elseif source.Type == EntityType.ENTITY_DARK_ESAU then
                -- Spiritual Covenant node (T. Jacob's tree)
                if PST:getTreeSnapshotMod("spiritualCovenant", false) and PST:getPlayer():GetPlayerType() == PlayerType.PLAYER_JACOB2_B then
                    damage = math.min(40, PST:getPlayer().Damage * 2)
                end

                -- Kinetic Vengeance node (T. Jacob's tree)
                if PST:getTreeSnapshotMod("kineticVengeance", false) then
                    local tmpDarkEsau = source.Entity:ToNPC()
                    if tmpDarkEsau then
                        if tmpDarkEsau.State == 3 then
                            dmgMult = dmgMult - 0.25
                        elseif not PST:arrHasValue(PST.specialNodes.animaChainedMobs, tmpDarkEsau.InitSeed) then
                            dmgMult = dmgMult + 0.25
                        end
                    end
                end

                -- Mod: +% damage dealt by Dark Esau against monsters
                local tmpMod = PST:getTreeSnapshotMod("darkEsauDmg", 0)
                if tmpMod > 0 then
                    dmgMult = dmgMult + tmpMod / 100
                end
            else
                if PST.specialNodes.SC_causeConvBossEnt and PST.specialNodes.SC_causeConvBossEnt:Exists() then
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
                end

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
                    local isDarkArts = false
                    -- Player tear hit
                    if source.Entity.Type == EntityType.ENTITY_TEAR then
                        -- Mod: % extra damage from coin tears against gilded monsters
                        local tmpMod = PST:getTreeSnapshotMod("coinTearsChance", 0)
                        if tmpMod > 0 and source.Entity.Variant == TearVariant.COIN and (target:GetSprite():GetRenderFlags() & AnimRenderFlags.GOLDEN) > 0 then
                            dmgMult = dmgMult + 0.1
                        end

                        -- T. Forgotten bone tears
                        if source.Entity.Variant == TearVariant.BONE and source.Entity.SpawnerEntity:ToPlayer():GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B then
                            -- Mod: % chance for T. Forgotten bone tears to paralyze enemies on hit for 1 second
                            tmpMod = PST:getTreeSnapshotMod("forgBoneTearPara", 0)
                            if tmpMod > 0 and 100 * math.random() < tmpMod then
                                target:AddFreeze(EntityRef(srcPlayer), 30)
                            end

                            -- Mod: % chance for T. Forgotten bone tears to slow enemies on hit for 2 seconds
                            tmpMod = PST:getTreeSnapshotMod("forgBoneTearSlow", 0)
                            if tmpMod > 0 and 100 * math.random() < tmpMod then
                                target:AddSlowing(EntityRef(srcPlayer), 60, 0.9, Color(0.9, 0.9, 0.9, 1))
                            end
                        end
                    -- Player effect hit
                    elseif source.Entity.Type == EntityType.ENTITY_EFFECT then
                        -- Dark Arts
                        if source.Entity.Variant == EffectVariant.DARK_SNARE then
                            isDarkArts = true

                            -- Mod: dark arts damage %
                            local tmpMod = PST:getTreeSnapshotMod("darkArtsDmg", 0)
                            if tmpMod ~= 0 then
                                dmgMult = dmgMult + tmpMod / 100
                            end

                            local bossProc = false
                            -- Dark Expertise node (T. Judas' tree)
                            if PST:getTreeSnapshotMod("darkExpertise", false) then
                                local tmpSlot = srcPlayer:GetActiveItemSlot(CollectibleType.COLLECTIBLE_DARK_ARTS)
                                if tmpSlot ~= -1 then
                                    if not target:IsBoss() then
                                        srcPlayer:SetActiveCharge(srcPlayer:GetActiveCharge(tmpSlot) + 15, tmpSlot)
                                    elseif not PST.specialNodes.darkArtsBossHitProc then
                                        srcPlayer:SetActiveCharge(srcPlayer:GetActiveCharge(tmpSlot) + 30, tmpSlot)
                                        bossProc = true
                                    end
                                end
                            end

                            -- Agile Expertise node (T. Judas' tree)
                            if PST:getTreeSnapshotMod("agileExpertise", false) then
                                local tmpSlot = srcPlayer:GetActiveItemSlot(CollectibleType.COLLECTIBLE_DARK_ARTS)
                                if tmpSlot ~= -1 then
                                    if target:IsBoss() then
                                        srcPlayer:SetActiveCharge(srcPlayer:GetActiveCharge(tmpSlot) + 30, tmpSlot)
                                        bossProc = true
                                    end
                                end
                            end
                            
                            if bossProc then PST.specialNodes.darkArtsBossHitProc = true end

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
                        end
                    -- Direct non-tear player hit to enemy (e.g. melee hits)
                    elseif source.Entity.Type == EntityType.ENTITY_PLAYER and flag == 0 then
                        -- Mod: Bag of Crafting's melee attack gains % of your damage
                        local tmpMod = PST:getTreeSnapshotMod("craftBagMeleeDmgInherit", 0)
                        if tmpMod > 0 and srcPlayer:HasCollectible(CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING) then
                            dmgExtra = dmgExtra + srcPlayer.Damage * (tmpMod / 100)
                        end

                        -- Mod: +% melee damage
                        tmpMod = PST:getTreeSnapshotMod("meleeDmg", 0)
                        if tmpMod > 0 then
                            dmgMult = dmgMult + tmpMod / 100
                        end

                        -- Hemoptysis hit
                        if PST.specialNodes.hemoptysisFired > 0 then
                            -- Mod: % chance to slow enemies hit by hemoptysis for 2 seconds
                            tmpMod = PST:getTreeSnapshotMod("hemoptysisSlowChance", 0)
                            if tmpMod > 0 and 100 * math.random() < tmpMod then
                                target:AddSlowing(EntityRef(srcPlayer), 60, 0.8, Color(0.8, 0.8, 0.8, 1))
                            end

                            -- Mod: +% speed for 1 second when hitting enemies with hemoptysis
                            tmpMod = PST:getTreeSnapshotMod("hemoptysisSpeed", 0)
                            if tmpMod > 0 then
                                PST.specialNodes.hemoptysisSpeedTimer = 30
                                PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
                            end
                        end
                    end

                    -- Mod: +% non-melee damage
                    if source.Entity.Type ~= EntityType.ENTITY_PLAYER then
                        tmpMod = PST:getTreeSnapshotMod("nonMeleeDmg", 0)
                        if tmpMod > 0 then
                            dmgMult = dmgMult + tmpMod / 100
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

                        -- Mod: chance for Book of Belial to gain a charge when hitting a boss
                        local tmpSlot = srcPlayer:GetActiveItemSlot(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL)
                        if tmpSlot ~= -1 then
                            if PST:getTreeSnapshotMod("belialChargesGained", 0) < 12 and 100 * math.random() < PST:getTreeSnapshotMod("belialBossHitCharge", 0) then
                                PST:addModifiers({ belialChargesGained = 1 }, true)
                                srcPlayer:AddActiveCharge(1, tmpSlot, true, false, false)
                            end
                        end

                        -- Mod: chance for Flip to gain a charge when hitting a boss
                        tmpSlot = srcPlayer:GetActiveItemSlot(CollectibleType.COLLECTIBLE_FLIP)
                        if tmpSlot ~= -1 then
                            if 100 * math.random() < PST:getTreeSnapshotMod("flipBossHitCharge", 0) then
                                srcPlayer:AddActiveCharge(1, tmpSlot, true, false, false)
                            end
                        end

                        -- Blood Harvest node (T. Bethany's tree)
                        if PST:getTreeSnapshotMod("bloodHarvest", false) and PST:getTreeSnapshotMod("bloodHarvestBossDrops", 0) < 4 and 100 * math.random() < 7 then
                            local tmpHeart = Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, target.Position, RandomVector() * 3, nil, HeartSubType.HEART_HALF, Random() + 1):ToPickup()
                            tmpHeart.Timeout = 90
                            PST:addModifiers({ bloodHarvestBossDrops = 1 }, true)
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

                        -- Astral weapon mod: +% damage dealt by player creep
                        tmpMod = PST:getSnapAstralWepMod("playerCreepDmg")
                        if tmpMod then
                            dmgMult = dmgMult + tmpMod[1] / 100
                        end

                        -- Ancient weapon mod: Oceanic Might
                        tmpMod = PST:getSnapAstralWepMod("oceanicMight")
                        if tmpMod then
                            dmgMult = dmgMult + tmpMod[1] / 100
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

                    -- T. Samson on-hit nodes
                    if PST.specialNodes.berserkHitCooldown == 0 then
                        -- Absolute Rage node (T. Samson's tree)
                        if PST:getTreeSnapshotMod("absoluteRage", false) then
                            local berserkEffect = PST:getPlayer():GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK)
                            local tmpMod = PST:getTreeSnapshotMod("absoluteRageCharge", 0)
                            if berserkEffect and tmpMod > 0 then
                                local tmpFalloff = 15
                                if PST:getPlayer():HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
                                    tmpFalloff = 8
                                end
                                local tmpRed = math.max(0, tmpMod - tmpFalloff)
                                PST:addModifiers({ absoluteRageCharge = { value = tmpRed, set = true } }, true)
                            end
                        end

                        -- Mod: when hitting enemies, gain an additional % berserk charge
                        local tmpMod = PST:getTreeSnapshotMod("berserkHitChargeGain", 0)
                        if tmpMod > 0 and not PST:isBerserk() then
                            PST:getPlayer().SamsonBerserkCharge = PST:getPlayer().SamsonBerserkCharge + 1000 * tmpMod
                            PST:updateCacheDelayed(CacheFlag.CACHE_COLOR)
                        end

                        PST.specialNodes.berserkHitCooldown = 5
                    end

                    -- Mod: +% damage dealt to enemies, which falls off the further away they are
                    local tmpMod = PST:getTreeSnapshotMod("proximityDamage", 0) / 100
                    if tmpMod > 0 then
                        local dist = PST:distBetweenPoints(srcPlayer.Position, target.Position)
                        local distMult = math.max(0, math.min(1, 1 - math.max(0, dist - 30) / 180))
                        dmgMult = dmgMult + tmpMod * distMult
                    end

                    -- Spiritual Covenant node (T. Jacob's tree)
                    if PST:getTreeSnapshotMod("spiritualCovenant", false) and PST:getPlayer():GetPlayerType() == PlayerType.PLAYER_JACOB2_B then
                        PST.specialNodes.spiritCovenantTarget = target
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

                    -- Mod: % non-whip damage
                    tmpMod = PST:getTreeSnapshotMod("nonWhipDmg", 0)
                    if tmpMod ~= 0 then
                        dmgMult = dmgMult + tmpMod / 100
                    end
                end
            end
        -- Misc hits
        elseif source.Type == EntityType.ENTITY_NULL and flag == 0 then
            -- Gello whip
            if PST.specialNodes.gelloFired > 0 then
                -- Mod: % whip attack damage
                local tmpMod = PST:getTreeSnapshotMod("whipDmg", 0)
                if tmpMod ~= 0 then
                    dmgMult = dmgMult + tmpMod / 100
                end

                -- Charging Behemoth node (T. Lilith's tree)
                if PST:getTreeSnapshotMod("chargingBehemoth", false) then
                    target:AddSlowing(EntityRef(PST:getPlayer()), 30, 0.85, Color(0.85, 0.85, 0.85, 1))
                end

                -- Coordinated Demons node (T. Lilith's tree)
                if PST.specialNodes.coordinatedDemonsWait >= 60 then
                    dmgMult = dmgMult + 0.3
                    PST.specialNodes.coordinatedDemonsWait = 0
                end
            end
        end

        -- Cosmic Realignment node
        if PST:cosmicRCharPicked(PlayerType.PLAYER_AZAZEL_B) then
            -- Tainted Azazel, -40% damage dealt to enemies far away from you, based on your range stat
            local dist = PST:distBetweenPoints(srcPlayer.Position, target.Position)
            if dist > srcPlayer.TearRange * 0.4 then
                dmgMult = dmgMult - 0.4
            end
        end

        -- Expedition implicit: monster damage reduction
        local tmpMod = PST:getTreeSnapshotMod("expedImp_mobDmgRed", 0)
        if tmpMod > 0 and target:IsActiveEnemy(false) and not EntityRef(target).IsFriendly then
            damage = damage * (1 - tmpMod / 100)
        end

        return { Damage = damage * math.max(0.01, dmgMult) + dmgExtra }
    end
end

---@param player EntityPlayer
---@param damage number
---@param flag DamageFlag
---@param source EntityRef
function PST:prePlayerDamage(player, damage, flag, source)
    -- Reaper Wraiths node (T. Jacob's tree)
    if PST:getTreeSnapshotMod("reaperWraiths", false) and source.Entity then
        if source.Type == EntityType.ENTITY_DARK_ESAU or (source.Entity.Parent and source.Entity.Parent.Type == EntityType.ENTITY_DARK_ESAU) or
        (source.Entity.SpawnerEntity and source.Entity.SpawnerEntity.Type == EntityType.ENTITY_DARK_ESAU) then
            return false
        end
    end

    -- Mod: halve chance to receive The Stairway
    tmpMod = PST:getTreeSnapshotMod("stairwayBoon", 0)
    if tmpMod > 0 then
        PST:addModifiers({ stairwayBoon = -tmpMod / 2 }, true)
    end

    -- Shadowmeld item - take no damage during transition
    if PST.specialFX.shadowmeldTransition then
        return false
    end
end

function PST:preNPCCollision(npc, collider, low)
    local player = collider:ToPlayer()
    if player then
        -- Reaper Wraiths node (T. Jacob's tree)
        if PST:getTreeSnapshotMod("reaperWraiths", false) and npc.Type == EntityType.ENTITY_DARK_ESAU then
            return { Collide = false, SkipCollisionEffects = true }
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