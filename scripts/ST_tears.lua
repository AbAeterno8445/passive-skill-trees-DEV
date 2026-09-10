---@param tear EntityTear
function PST:postFireTear(tear)
    -- Mod: % chance for fired tears to be coin tears from Head of the Keeper
    local tmpMod = PST:getTreeSnapshotMod("coinTearsChance", 0)
    if tmpMod > 0 and tear.Variant ~= TearVariant.COIN and 100 * math.random() < tmpMod then
        tear:ChangeVariant(TearVariant.COIN)
        tear:AddTearFlags(TearFlags.TEAR_GREED_COIN)
    end

    -- Mod: % chance for locusts to shoot a small tear towards nearby enemies whenever you shoot
    tmpMod = PST:getTreeSnapshotMod("locustTears", 0)
    if PST:getTreeSnapshotMod("greatDevourer", false) then
        tmpMod = tmpMod * 3
    end
    if tmpMod > 0 and PST.specialNodes.locustTearsTimer == 0 then
        for _, tmpLocust in ipairs(PST.specialNodes.activeLocusts) do
            if tmpLocust:Exists() and 100 * math.random() < tmpMod then
                local nearbyEnemies = Isaac.FindInRadius(tmpLocust.Position, 120, EntityPartition.ENEMY)
                if #nearbyEnemies > 0 then
                    for _, tmpEnemy in ipairs(nearbyEnemies) do
                        if tmpEnemy:IsActiveEnemy(false) and tmpEnemy:IsVulnerableEnemy() and not EntityRef(tmpEnemy).IsFriendly then
                            local tearVel = (tmpEnemy.Position - tmpLocust.Position):Normalized() * (7 * PST:getPlayer().ShotSpeed)
                            local tmpVariant = TearVariant.BLOOD

                            local newTear = Game():Spawn(
                                EntityType.ENTITY_TEAR,
                                tmpVariant,
                                tmpLocust.Position,
                                tearVel,
                                tmpLocust,
                                0,
                                Random() + 1
                            )

                            -- Electrified Swarm node (T. Apollyon's tree)
                            if PST:getTreeSnapshotMod("electrifiedSwarm", false) then
                                local tmpChance = 33
                                if 100 * math.random() < tmpChance then
                                    newTear:ToTear():AddTearFlags(TearFlags.TEAR_JACOBS)
                                end
                            end

                            -- Mod: % chance for locusts tears to be spectral and piercing
                            local tmpSpectral = PST:getTreeSnapshotMod("locustTearSpectral", 0)
                            if tmpSpectral > 0 and not newTear:ToTear():HasTearFlags(TearFlags.TEAR_JACOBS) and 100 * math.random() < tmpSpectral then
                                newTear:ToTear():AddTearFlags(TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL)
                            end

                            if not PST:getTreeSnapshotMod("greatDevourer", false) then
                                newTear.SpriteScale = Vector(0.85, 0.85)
                            else
                                newTear.SpriteScale = tmpLocust.SpriteScale - Vector(0.15, 0.15)
                            end
                            break
                        end
                    end
                end
            end
        end
        PST.specialNodes.locustTearsTimer = 4
    end
end

function PST:onTearDeath(tear)
    -- Starcursed modifier: tear explosion on mob death
    if PST:arrHasValue(PST.specialNodes.SC_exploderTears, tear.InitSeed) then
        local tmpMod = PST:SC_getSnapshotMod("tearExplosionOnDeath", {0, 0})
        if tmpMod[2] > 0 then
            local tmpSpeed = 6
            local tmpColor = Color(1, 0.1, 0.1, 1)
            for i=1,tmpMod[2] do
                local tmpAng = ((2 * math.pi) / tmpMod[2]) * (i - 1)
                local tmpVel = Vector(tmpSpeed * math.cos(tmpAng), tmpSpeed * math.sin(tmpAng))
                local newTear = Game():Spawn(
                    EntityType.ENTITY_PROJECTILE,
                    ProjectileVariant.PROJECTILE_TEAR,
                    tear.Position,
                    tmpVel,
                    tear.SpawnerEntity,
                    0,
                    Random() + 1
                )
                newTear.Color = tmpColor
                newTear:ToProjectile().FallingAccel = 0.45
            end
        end
    end
end

-- Tear collision
---@param tear EntityTear
---@param collider Entity
function PST:onTearCollision(tear, collider, low)
    -- Ancient weapon mod: Azurebinder
    local tmpMod = PST:getSnapAstralWepMod("azurebinder")
    local tearData = PST:getEntData(tear)
    if tmpMod and tear:HasTearFlags(TearFlags.TEAR_SHIELDED) and collider.Type == EntityType.ENTITY_PROJECTILE and not tearData.PST_collided then
        if PST.specialNodes.ancwep_azurebinderBuff < tmpMod[2] then
            PST.specialNodes.ancwep_azurebinderBuff = math.min(PST.specialNodes.ancwep_azurebinderBuff + tmpMod[1], tmpMod[2])
            PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
            tearData.PST_collided = true
        end
    end

    -- Eraser tear collision
    local tmpNPC = collider:ToNPC()
    if tear.Variant == TearVariant.ERASER and tmpNPC then
        -- Reverse Annihilation node (Apollyon's tree)
        if PST:getTreeSnapshotMod("reverseAnnihilation", false) and PST:getTreeSnapshotMod("reverseAnnihilationProcs", 0) < 3 then
            PST:getPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_FRIEND_FINDER, UseFlag.USE_NOANIM)
            PST:addModifiers({ reverseAnnihilationProcs = 1 }, true)
        end
    end
end