local fightEngine = require("Modules.FightEngine")

local fightObserver = {}

fightObserver.FightEntitiesList = {}
fightObserver.AllyFightEntitiesList = {}
fightObserver.EnemyFightEntitiesList = {}
fightObserver.EntitiesContext = {}
fightObserver.GenericContext = {}
fightObserver.FightContext = {}

function fightObserver.LoadFightContext()
    fightObserver.LoadEntitiesContext()
    fightObserver.LoadGenericContext()

    fightObserver.FightContext = {
        fightObserver.GenericContext,
        fightObserver.EntitiesContext,
    }
end

function fightObserver.LoadEntitiesContext()
    fightObserver.FightEntitiesList = fightEngine.GetFightEntities()

    for key, _ in pairs(fightObserver.FightEntitiesList) do
        local currentEntity = fightObserver.FightEntitiesList[key]

        if currentEntity.Team == true then
            fightObserver.EnemyFightEntitiesList.insert(currentEntity)
        elseif currentEntity.Team == false then
            fightObserver.AllyFightEntitiesList.insert(currentEntity)
        end
    end

    fightObserver.EntitiesContext = { {
        FightEntities = fightObserver.FightEntitiesList,
        AllyFightEntities = fightObserver.AllyFightEntitiesList,
        EnemyFightEntities = fightObserver.EnemyFightEntitiesList,
    } }
end

function fightObserver.LoadGenericContext()
    fightObserver.GenericContext = { {
        CurrentTurnNumber = fightAction:getCurrentTurn(),
        CurrentFightCount = global:getCountFight(),
        TotalEntitiesCount = #fightObserver.FightEntitiesList,
        EnemyEntitiesCount = #fightObserver.EnemyFightEntitiesList,
        AllyEntitiesCount = #fightObserver.AllyFightEntitiesList,
    } }
end

function fightObserver.GetAttackersCells()
    local attackerCells = {}

    -- assuming i am attacking and not being agroed
    for key, _ in pairs(fightObserver.AllyFightEntitiesList) do
        local currentAllyEntity = fightObserver.AllyFightEntitiesList[key]

        attackerCells.insert(currentAllyEntity.CellId, currentAllyEntity.Id)
    end

    return attackerCells
end

function fightObserver.GetDefendersCells()
    local defenderCells = {}

    for key, _ in pairs(fightObserver.EnemyFightEntitiesList) do
        local currentEnemyEntity = fightObserver.EnemyFightEntitiesList[key]

        defenderCells.insert(currentEnemyEntity.CellId, currentEnemyEntity.Id)
    end

    return defenderCells
end

function fightObserver.GetEnemiesWeakToElementType(elementType)
    local enemyResistances = {}

    for key, _ in pairs(fightObserver.EnemyFightEntitiesList) do
        local currentEnemyEntity = fightObserver.EnemyFightEntitiesList[key]

        enemyResistances = { {
            EnemyEntityId = currentEnemyEntity.Id, CellId = currentEnemyEntity.CellId,
            ResistanceEarthPercentage = currentEnemyEntity.PercentTerre,
            ResistanceFirePercentage = currentEnemyEntity.PercentFeu,
            ResistanceWaterPercentage = currentEnemyEntity.PercentEau,
            ResistanceAirPercentage = currentEnemyEntity.PercentAir,
            ResistanceNeaturalPercentage = currentEnemyEntity.PercentNeutre
        } }
    end

    if elementType == "Earth" then
        table.sort(enemyResistances, function(a, b) return a.ResistanceEarthPercentage < b.ResistanceEarthPercentage end)
    elseif elementType == "Fire" then
        table.sort(enemyResistances, function(a, b) return a.ResistanceFirePercentage < b.ResistanceFirePercentage end)
    elseif elementType == "Water" then
        table.sort(enemyResistances, function(a, b) return a.ResistanceWaterPercentage < b.ResistanceWaterPercentage end)
    elseif elementType == "Air" then
        table.sort(enemyResistances, function(a, b) return a.ResistanceAirPercentage < b.ResistanceAirPercentage end)
    elseif elementType == "Neutral" then
        table.sort(enemyResistances, function(a, b) return a.ResistanceNeaturalPercentage < b.ResistanceNeaturalPercentage end)
    end

    return enemyResistances
end

return fightObserver
