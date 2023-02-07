local characterClass = require("Modules.CharacterClass")
local spellEntityTargetType = require("DofusTypes.Enum.SpellTargetType")
local fightEntityTeamType = require("DofusTypes.Enum.FightEntityTeamType")

local fightEngine = {}

function fightEngine.ChoseStrartingCell(occupiedAttackerCells)
    -- free cell nearby ally cell occupied by class feca/eniprisa/ecaflip
    for key, _ in pairs(occupiedAttackerCells) do
        local figtherClassAtCell = fightAction:getFighter(occupiedAttackerCells[key].CellId)

        if characterClass.IsSupportClass(figtherClassAtCell) then
            local adjacentCellsIds = fightAction:getAdjacentCells(occupiedAttackerCells[key].CellId)

            for cellKey, _ in pairs(adjacentCellsIds) do
                if fightAction:isFreeCell(adjacentCellsIds[cellKey]) and
                    fightAction:getDistance(adjacentCellsIds[cellKey], fightAction:getNearestEnemy()) > 3 then
                    return adjacentCellsIds[cellKey].CellId
                end
            end
        end
    end

    -- TODO: case 2 hide supports/ranged behind tankier chars
    -- TODO: case 3 place close ranged attackers near enemy, seek glyph/aoe dmg openings
end

function fightEngine.getEntityTargetType(fightEntity)
    if fightEntity.Mycharacter then
        return spellEntityTargetType.SELF
    end

    -- TODO: depends who began the fight, assuming i do
    if fightEntity.Team == fightEntityTeamType.CHALLENGER then
        return spellEntityTargetType.ALLY_ALL
    end

    if fightEntity.Team == fightEntityTeamType.DEFENDER then
        return spellEntityTargetType.ENEMY_ALL
    end
end

function fightEngine.GetFightEntities()
    if fightEngine.IsInCombat() and fightAction:getEntitiesCount() > 0 then
        local fightEntities = fightAction:getAllEntities()

        if #fightEntities > 0 then
            return fightEntities
        end
    end
end

function fightEngine.IsFightStart()
    return global:isInFight() and fightAction:getCurrentTurn() == 0
end

function fightEngine.IsFirstTurn()
    return global:isInFight() and fightAction:getCurrentTurn() == 1
end

function fightEngine.IsInCombat()
    return not global:afterFight() and global:isInFight() and fightAction:getCurrentTurn() >= 0
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
