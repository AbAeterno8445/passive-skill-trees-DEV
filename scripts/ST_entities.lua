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
            end
        end
    end
end

---@param effect EntityEffect
function PST:onEffectInit(effect)
    -- Lingering Malice node (T. Magdalene's tree)
    if PST:getTreeSnapshotMod("lingeringMalice", false) and PST:arrHasValue(PST.playerDamagingCreep, effect.Variant) then
        table.insert(PST.specialNodes.lingMaliceCreepList, effect)
    end

    -- Anima sola chain (main)
	if effect.Variant == EffectVariant.ANIMA_CHAIN and effect.SubType == 0 then
        table.insert(PST.specialNodes.animaNewChains, effect.InitSeed)
        PST.specialNodes.checkAnimaChain = true
	end
end

---@param npc EntityNPC
function PST:postNPCInit(npc)
    -- Mod: Greed has lower health
    if npc.Type == EntityType.ENTITY_GREED then
        npc.HitPoints = npc.HitPoints - math.min(npc.HitPoints / 2, npc.MaxHitPoints * (PST:getTreeSnapshotMod("greedLowerHealth", 0) / 100))
    end

    -- Reaper Wraiths node (T. Jacob's tree)
    if npc.Type == EntityType.ENTITY_DARK_ESAU and npc.Variant == 0 and npc.SubType == 0 and PST:getTreeSnapshotMod("reaperWraiths", false) and
    PST:getPlayer():HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
        local darkEsauAltCount = #Isaac.FindByType(EntityType.ENTITY_DARK_ESAU, 0, 1)
        if darkEsauAltCount == 0 then
            local tmpDarkEsauAlt = Game():Spawn(EntityType.ENTITY_DARK_ESAU, 0, npc.Position + Vector(10, 0), Vector.Zero, PST:getPlayer(), 1, Random() + 1)
            tmpDarkEsauAlt:AddEntityFlags(EntityFlag.FLAG_PERSISTENT | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
        end
    end
end

---@param npc EntityNPC
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

    -- Grand Consonance node (T. Siren's tree)
    if PST:getTreeSnapshotMod("grandConsonance", false) and PST:arrHasValue(PST.grandConsonanceWhitelist, familiar.Variant) and not familiar:GetData().PST_noConsonance then
        local player = PST:getPlayer()
        local hide = true
        local famData = familiar:GetData()
        local noZeroScale = false

        -- Launched familiars
        if familiar.Variant == FamiliarVariant.LITTLE_CHUBBY or familiar.Variant == FamiliarVariant.HOLY_WATER or familiar.Variant == FamiliarVariant.BIG_CHUBBY or
        familiar.Variant == FamiliarVariant.JAW_BONE or familiar.Variant == FamiliarVariant.LIL_PORTAL then
            hide = familiar.FireCooldown >= 0
        -- Lil Gurdy
        elseif familiar.Variant == FamiliarVariant.LIL_GURDY then
            local famAnim = familiar:GetSprite():GetAnimation()
            hide = famAnim ~= "Dashing"
        -- Dead Bird: after you get hit, launch multiple short lived small dead birds while firing (lifespan based on range, rate of fire based on tears)
        elseif familiar.Variant == FamiliarVariant.DEAD_BIRD then
            local plInput = player:GetShootingInput()
		    local isShooting = plInput.X ~= 0 or plInput.Y ~= 0
            if isShooting then
                if famData.PST_fireDelay == nil then famData.PST_fireDelay = 0 end
                if famData.PST_fireDelay <= 0 then
                    local tmpBird = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.DEAD_BIRD, 0, player.Position + RandomVector() * 5, plInput * 10, player)
                    tmpBird.CollisionDamage = tmpBird.CollisionDamage - 0.4
                    tmpBird:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    tmpBird:GetData().PST_scale = Vector(0.7, 0.7)
                    tmpBird:GetData().PST_noConsonance = true
                    tmpBird:GetData().PST_lifespan = math.ceil(player.TearRange * 0.2)
                    SFXManager():Play(SoundEffect.SOUND_BIRD_FLAP, 0.3)

                    famData.PST_fireDelay = math.max(4, math.ceil(player.MaxFireDelay))
                else
                    famData.PST_fireDelay = famData.PST_fireDelay - 1
                end
            end
        -- Reduced hitboxes
        elseif familiar.Variant == FamiliarVariant.BUM_FRIEND or familiar.Variant == FamiliarVariant.DRY_BABY or familiar.Variant == FamiliarVariant.LEECH or
        familiar.Variant == FamiliarVariant.DARK_BUM then
            familiar:SetSize(0.1, Vector(0.1, 0.1), 0)
        -- Guppy's Hairball / Samson's Chains: launched from you, stays active while firing
        elseif familiar.Variant == FamiliarVariant.GUPPYS_HAIRBALL or familiar.Variant == FamiliarVariant.SAMSONS_CHAINS then
            local plInput = player:GetShootingInput()
		    local isShooting = plInput.X ~= 0 or plInput.Y ~= 0
            if isShooting then
                hide = false
                if famData.PST_wasHiding then
                    familiar.Velocity = plInput * 40
                end
            elseif familiar.Position:Distance(player.Position) >= 40 then
                familiar.Velocity = Vector.Zero
                familiar.Position = familiar.Position + (player.Position - familiar.Position) * 0.4
                hide = false
            end
        -- Bob's Brain
        elseif familiar.Variant == FamiliarVariant.BOBS_BRAIN then
            famData.PST_consonanceTag = true
            if familiar.FireCooldown < 0 or famData.PST_explosionCountdown ~= nil then
                hide = false
                if famData.PST_explosionCountdown and famData.PST_explosionCountdown > 0 then
                    familiar.Velocity = familiar.Velocity * 0.82
                    famData.PST_explosionCountdown = famData.PST_explosionCountdown - 1

                    local tmpPerc = famData.PST_explosionCountdown / 45
                    familiar:SetColor(Color(tmpPerc, tmpPerc, tmpPerc, 1), 2, 1, false, false)
                    if famData.PST_explosionCountdown == 0 then
                        local tmpDummyFly = Isaac.Spawn(EntityType.ENTITY_FLY, 0, 0, Vector.Zero, Vector.Zero, nil)
                        tmpDummyFly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                        familiar:ForceCollide(tmpDummyFly, false)
                        tmpDummyFly:Remove()
                    end
                end
            else
                familiar:SetSize(0.1, Vector(0.1, 0.1), 0)

                if familiar.FireCooldown == 0 and famData.PST_respawnFlag then
                    local tmpSprite = Sprite("gfx/003.059_bobs brain.anm2", true)
                    tmpSprite:SetFrame("Idle", 0)
                    PST:createFloatIconFX(tmpSprite, Vector.Zero, 0.2, 70, true)
                    famData.PST_respawnFlag = false
                end
            end
        -- Lil Haunt
        elseif familiar.Variant == FamiliarVariant.LIL_HAUNT then
            hide = not PST.specialNodes.consonanceLilHauntOut
        -- Finger / Bloodshot Eye
        elseif familiar.Variant == FamiliarVariant.FINGER or familiar.Variant == FamiliarVariant.BLOODSHOT_EYE then
            familiar.Color = Color(0.1, 0.1, 0.1, 1)
            hide = false
        -- Depression
        elseif familiar.Variant == FamiliarVariant.DEPRESSION then
            familiar:SetSize(1.6, Vector(1.6, 1.6), 1)
        -- My Shadow
        elseif familiar.Variant == 131 then
            hide = false

            if not famData.PST_shadowGrowth then famData.PST_shadowGrowth = 0 end
            if not famData.PST_collisionCooldowns then famData.PST_collisionCooldowns = {} end

            local plInput = player:GetShootingInput()
		    local isShooting = plInput.X ~= 0 or plInput.Y ~= 0
            if isShooting then
                if famData.PST_shadowGrowth < 200 then
                    famData.PST_shadowGrowth = famData.PST_shadowGrowth + 1
                end
            elseif famData.PST_shadowGrowth > 0 then
                famData.PST_shadowGrowth = math.max(0, famData.PST_shadowGrowth - 3)
            end

            -- Enemy contact damage cooldowns
            for tmpEnemy, _ in pairs(famData.PST_collisionCooldowns) do
                if famData.PST_collisionCooldowns[tmpEnemy] > 0 then
                    famData.PST_collisionCooldowns[tmpEnemy] = famData.PST_collisionCooldowns[tmpEnemy] - 1
                end
                if famData.PST_collisionCooldowns[tmpEnemy] == 0 then
                    famData.PST_collisionCooldowns[tmpEnemy] = nil
                end
            end

            local tmpScale = 0.2 + famData.PST_shadowGrowth / 400
            local famSprite = familiar:GetSprite()
            familiar.Position = player.Position
            familiar.Velocity = Vector.Zero
            familiar.SpriteScale = Vector(tmpScale, tmpScale)
            familiar:SetSize(40 * tmpScale, Vector(1.9, 1), math.floor(40 * tmpScale))
            famSprite.Color.A = 0.5
            famSprite.PlaybackSpeed = 0.5
            famSprite:Play("Idle4")
        -- Non-zero scaled familiars
        elseif familiar.Variant == FamiliarVariant.CENSER or familiar.Variant == FamiliarVariant.SUCCUBUS then
            noZeroScale = true
        -- Removed familiars
        elseif familiar.Variant == FamiliarVariant.BBF or familiar.Variant == FamiliarVariant.MOMS_RAZOR then
            familiar:Remove()
        end

        -- Pop-up poof FX
        if famData.PST_wasHiding == nil then famData.PST_wasHiding = true end
        if famData.PST_wasHiding ~= hide then
            Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, familiar.Position, Vector.Zero, nil, 1, Random() + 1)
            famData.PST_wasHiding = hide
        end

        if hide then
            local famSprite = familiar:GetSprite()
            if not noZeroScale then
                if famSprite.Scale.X > 0 then
                    famSprite.Scale = Vector.Zero
                end
            else
                familiar:SetColor(Color(0, 0, 0, 0), 2, 10, false, false)
            end
            --familiar.Velocity = Vector.Zero
            familiar.OrbitDistance = Vector.One
            familiar.OrbitSpeed = 0
            familiar.Position = player.Position + Vector(0, 5)
        end
    end

    -- Scale change
    if familiar:GetData().PST_scale ~= nil then
        familiar.SpriteScale = familiar:GetData().PST_scale
    end

    -- Limited lifespan
    if familiar:GetData().PST_lifespan ~= nil then
        if familiar:GetData().PST_lifespan > 0 then
            familiar:GetData().PST_lifespan = familiar:GetData().PST_lifespan - 1
        else
            Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, familiar.Position, Vector.Zero, nil, 1, Random() + 1)
            familiar:Remove()
        end
    end
end

---@param familiar EntityFamiliar
---@param collider Entity
---@param low boolean
function PST:preFamiliarCollision(familiar, collider, low)
    local tmpEnemy = collider:ToNPC()
    if tmpEnemy and tmpEnemy:IsActiveEnemy(false) and tmpEnemy:IsVulnerableEnemy() and not EntityRef(tmpEnemy).IsFriendly then
        -- Grand Consonance node (T. Siren's tree)
        if PST:getTreeSnapshotMod("grandConsonance", false) then
            local famData = familiar:GetData()

            -- Bob's Brain collision
            if familiar.Variant == FamiliarVariant.BOBS_BRAIN then
                -- Grand Consonance node (T. Siren's tree)
                if PST:getTreeSnapshotMod("grandConsonance", false) then
                    if famData.PST_explosionCountdown == nil then
                        famData.PST_explosionCountdown = 45
                    end
                end

                if famData.PST_explosionCountdown ~= 0 then
                    return { Collide = false, SkipCollisionEffects = true }
                else
                    famData.PST_explosionCountdown = nil
                    famData.PST_respawnFlag = true
                end
            -- War Locust collision
            elseif familiar.Variant == FamiliarVariant.BLUE_FLY and familiar.SubType == 1 then
                if familiar.Position:Distance(PST:getPlayer().Position) <= 70 then
                    return { Collide = false, SkipCollisionEffects = true }
                end
            -- My Shadow collision
            elseif familiar.Variant == 131 and not tmpEnemy:GetData().PST_dummy then
                if famData.PST_collisionCooldowns then
                    local enemyHitCD = famData.PST_collisionCooldowns[tmpEnemy.InitSeed]
                    if not enemyHitCD or (enemyHitCD and enemyHitCD == 0) then
                        tmpEnemy:TakeDamage(4, 0, EntityRef(familiar), 0)
                        famData.PST_collisionCooldowns[tmpEnemy.InitSeed] = 15

                        -- Chance to spawn charger
                        if 100 * math.random() < 15 then
                            local tmpDummyFly = Isaac.Spawn(EntityType.ENTITY_FLY, 0, 0, Vector.Zero, Vector.Zero, nil)
                            tmpDummyFly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                            tmpDummyFly:GetData().PST_dummy = true
                            familiar:ForceCollide(tmpDummyFly, false)
                            tmpDummyFly:Remove()
                        end
                    end
                end
                return { Collide = false, SkipCollisionEffects = true }
            end
        end
    end
end

---@param tear EntityTear
function PST:tearFired(tear)
    -- Grand Consonance node (T. Siren's tree) - Bloodshot Eye tear effects
    if tear.SpawnerEntity and tear.SpawnerEntity.Type == EntityType.ENTITY_FAMILIAR and tear.SpawnerEntity.Variant == FamiliarVariant.BLOODSHOT_EYE then
        tear:AddTearFlags(TearFlags.TEAR_HOMING)
        if 100 * math.random() < 10 then
            tear:AddTearFlags(TearFlags.TEAR_FEAR)
            tear:ChangeVariant(TearVariant.DARK_MATTER)
        end
        tear.Color = PST:RGBColor(72, 34, 72)
    end
end
PST:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, PST.tearFired)

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