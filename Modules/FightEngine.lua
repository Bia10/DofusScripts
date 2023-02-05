local fightEngine = {}

function fightEngine.GetFightEntities()
    if fightEngine.IsInCombat() and fightAction:getEntitiesCount() > 0 then
        local fightEntities = fightAction:getAllEntities()

        if #fightEntities > 0 then
            return fightEntities
        end
    end
end

function fightEngine.IsFightStart()
    return global:isInFight() == true and fightAction:getCurrentTurn() == 0
end

function fightEngine.IsFirstTurn()
    return global:isInFight() == true and fightAction:getCurrentTurn() == 1
end

function fightEngine.IsInCombat()
    return global:afterFight() == false and global:isInFight() == true and fightAction:getCurrentTurn() >= 0
end

function fightEngine.setpecificMonsterGroups(monsterIds, mins, maxs)
    local specificMobGroups = {}

    for i = 1, #monsterIds, 1 do
        specificMobGroups[i] = { monsterIds[i], mins[i], maxs[i] }
    end

    config:setAmountOfSpecificMonsters(specificMobGroups)
    global:printMessage("[FightEngine] Set new specific monster groups param: " .. config:getAmountOfSpecificMonsters())
end

function fightEngine.setMinOfMobsInGroup(minMobs)
    if minMobs ~= config:getMinMonsters() then
        config:setMinMonsters(minMobs)
        global:printMessage("[FightEngine] Set new monster minimum in group param: " .. config:getMinMonsters())
    end
end

function fightEngine.setMaxOfMobsInGroup(maxMobs)
    if maxMobs ~= config:getMaxMonsters() then
        config:setMaxMonsters(maxMobs)
        global:printMessage("[FightEngine] Set new monster maximum in group param: " .. config:getMaxMonsters())
    end
end

function fightEngine.setRequiredMonsters(requiredMobIds)
    if requiredMobIds ~= config:getMandatoryMonsters() then
        config:setMandatoryMonsters(requiredMobIds)
        global:printMessage("[FightEngine] Set new required monsters in group param: " .. config:getMandatoryMonsters())
    end
end

function fightEngine.setForbiddenMonsters(forbiddenMobIds)
    if forbiddenMobIds ~= config:getForbiddenMonsters() then
        config:setForbiddenMonsters(forbiddenMobIds)
        global:printMessage("[FightEngine] Set new forbidden monsters in group param: " .. config:getForbiddenMonsters())
    end
end

function fightEngine.suggestRequiredMonsters()
    local suggestedMonstersIds
    -- Check my characters strenghts and monsters weaknesses
    return suggestedMonstersIds
end

function fightEngine.suggestForbiddenMonsters()
    local forbiddenMonstersIds
    -- Arch mobs
    -- Bosses
    -- Quest mobs
    return forbiddenMonstersIds
end

return fightEngine
