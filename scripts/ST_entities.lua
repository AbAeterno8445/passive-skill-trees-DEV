function PST:onEntitySpawn(type, variant, subtype, position, velocity, spawner, seed)
    if PST:getRoom():GetFrameCount() > 1 then
        -- Dead bird spawn, set active
        if type == EntityType.ENTITY_FAMILIAR and variant == FamiliarVariant.DEAD_BIRD and not PST.specialNodes.deadBirdActive then
            PST.specialNodes.deadBirdActive = true
            PST:updateCacheDelayed()
        end
    end

    -- Cosmic Realignment node
    if PST:cosmicRCharPicked(PlayerType.PLAYER_BETHANY) then
        local player = PST:getPlayer()
        -- Bethany, as Keeper: -0.01 luck whenever a blue fly spawns, up to -2
        if type == EntityType.ENTITY_FAMILIAR and variant == FamiliarVariant.BLUE_FLY and subtype == 0 and
        (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or
        player:GetPlayerType() == PlayerType.PLAYER_KEEPERB) then
            local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.treeMods.cosmicRCache)
            if cosmicRCache.bethanyKeeperLuck > -2 then
                PST:addModifiers({ luck = -0.01 }, true)
                cosmicRCache.bethanyKeeperLuck = cosmicRCache.bethanyKeeperLuck - 0.01
                PST:save()
            end
        end
    end
end

function PST:onEffectInit(effect)
    -- Lingering Malice node (T. Magdalene's tree)
    if PST:getTreeSnapshotMod("lingeringMalice", false) and PST:arrHasValue(PST.playerDamagingCreep, effect.Variant) then
        table.insert(PST.specialNodes.lingMaliceCreepList, effect)
    end
end

function PST:postNPCInit(npc)
    -- Mod: Greed has lower health
    if npc.Type == EntityType.ENTITY_GREED then
        npc.HitPoints = npc.HitPoints - math.min(npc.HitPoints / 2, npc.MaxHitPoints * (PST:getTreeSnapshotMod("greedLowerHealth", 0) / 100))
    end
end

function PST:onNPCUpdate(npc)
    -- Ancient starcursed jewel: Cause Converter - remove boss minions
    if npc.Parent and PST.specialNodes.SC_causeConvBossEnt and npc.Parent.InitSeed == PST.specialNodes.SC_causeConvBossEnt.InitSeed then
        Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, npc.Position, Vector.Zero, nil, 0, Random() + 1)
        npc:Remove()
    end
end

---@param familiar EntityFamiliar
function PST:familiarInit(familiar)
    -- Spider Mod node, prevent spider familiar from spawning
    if PST:getTreeSnapshotMod("spiderMod", false) and familiar.Variant == FamiliarVariant.SPIDER_MOD then
        familiar:Remove()
    else
        -- Familiar quantity update
        PST:addModifiers({ totalFamiliars = 1 }, true)
        PST:updateCacheDelayed()

        -- Blood clots (Sumptorium)
        if familiar.Variant == FamiliarVariant.BLOOD_BABY then
            -- Mod: +% damage for the current room when absorbing a red clot (subtract when spawning)
            if familiar.SubType == 0 then
                local tmpMod = PST:getTreeSnapshotMod("redClotAbsorbDmg", 0)
                if tmpMod > 0 and PST:getTreeSnapshotMod("redClotAbsorbBuff", 0) > 0 then
                    PST:addModifiers({ damagePerc = -tmpMod, redClotAbsorbBuff = -tmpMod }, true)
                end
            -- Mod: +% tears for the current room when absorbing a red clot (subtract when spawning)
            elseif familiar.SubType == 1 then
                local tmpMod = PST:getTreeSnapshotMod("soulClotAbsorbTears", 0)
                if tmpMod > 0 and PST:getTreeSnapshotMod("soulClotAbsorbBuff", 0) > 0 then
                    PST:addModifiers({ tearsPerc = -tmpMod, soulClotAbsorbBuff = -tmpMod }, true)
                end
            end
        -- Blue flies
        elseif familiar.Variant == FamiliarVariant.BLUE_FLY and familiar.SubType == 0 then
            -- Marquess of Flies node (T. Keeper's tree)
            if PST:getTreeSnapshotMod("marquessOfFlies", false) then
                local tmpFlies = #Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY) + 1
                if PST:getTreeSnapshotMod("marquessFliesCache", 0) ~= tmpFlies then
                    PST:addModifiers({ marquessFliesCache = { value = tmpFlies, set = true } }, true)
                    PST:updateCacheDelayed(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY)
                end
            end
        -- Locusts
        elseif familiar.Variant == FamiliarVariant.ABYSS_LOCUST then
            -- Great Devourer node (T. Apollyon's tree)
            local otherLocusts = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST)
            if PST:getTreeSnapshotMod("greatDevourer", false) and #otherLocusts > 0 then
                local tmpPoof = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, otherLocusts[1].Position, Vector.Zero, nil, 0, Random() + 1)
                tmpPoof:GetSprite().Scale = Vector(1.15, 1.15)
                SFXManager():Play(SoundEffect.SOUND_VAMP_GULP, 0.6, 2, false, 1.1)

                familiar:Remove()
                if PST:getTreeSnapshotMod("greatDevourerBoost", 0) < 25 then
                    PST:addModifiers({ greatDevourerBoost = 1 }, true)
                end
            end
        end
    end
end

local tmpLastFrame = 0
---@param familiar EntityFamiliar
function PST:familiarUpdate(familiar)
    -- Locust
    if familiar.Variant == FamiliarVariant.ABYSS_LOCUST then
        -- Close Keeper node (T. Apollyon's tree)
        if PST:getTreeSnapshotMod("closeKeeper", false) then
            local player = PST:getPlayer()
            -- State is -1 while flying out, 0 while following
            if familiar.State == 0 and familiar.Position:Distance(player.Position) > 6 then
                familiar.Position = familiar.Position - (familiar.Position - player.Position) / 4
            end
        end

        -- Great Devourer node (T. Apollyon's tree)
        if PST:getTreeSnapshotMod("greatDevourer", false) then
            local tmpMod = PST:getTreeSnapshotMod("greatDevourerBoost", 0)
            if tmpMod > 0 then
                local tmpMult = 1 + tmpMod / 20
                if familiar.SpriteScale.X ~= tmpMult then
                    familiar.SpriteScale = Vector(tmpMult, tmpMult)
                end
                if familiar:GetSpeedMultiplier() ~= tmpMult then
                    familiar:SetSpeedMultiplier(tmpMult)
                end
                familiar:GetSprite():SetFrame(tmpLastFrame)
                tmpLastFrame = (tmpLastFrame + 1) % 8
            end
        end
    end
end

function PST:onBombInit(bomb)
    -- Mod: chance to turn troll and super troll bombs into regular bombs
    tmpMod = PST:getTreeSnapshotMod("trollBombDisarm", 0)
    if tmpMod > 0 then
        -- Chance debuff after certain events (bomb bum, anarchist cookbook, tower card, etc.) or boss rooms
        local roomType = PST:getRoom():GetType()
        if PST.specialNodes.trollBombDisarmDebuffTimer > 0 or roomType == RoomType.ROOM_BOSS or roomType == RoomType.ROOM_BOSSRUSH then
            tmpMod = tmpMod / 4
        end
        if (bomb.Variant == BombVariant.BOMB_TROLL or bomb.Variant == BombVariant.BOMB_SUPERTROLL) and 100 * math.random() < tmpMod then
            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, bomb.Position, Vector.Zero, nil, BombSubType.BOMB_NORMAL, Random() + 1)
            PST:createFloatTextFX("Troll bomb disarmed", bomb.Position, Color(1, 1, 1, 1), 0.12, 70, false)
            bomb:Remove()
        end
    end
end