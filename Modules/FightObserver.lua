local fightEngine = require("Modules.FightEngine")

local fightObserver = {}

fightObserver.FightEntitiesList = {}
fightObserver.AllyFightEntitiesList = {}
fightObserver.EnemyFightEntitiesList = {}

fightObserver.FightContext = { {
    FightEntities = fightObserver.FightEntitiesList,
    AllyFightEntities = fightObserver.AllyFightEntitiesList,
    EnemyFightEntities = fightObserver.EnemyFightEntitiesList,
} }

function fightObserver.LoadFightEntitites()
    fightObserver.FightEntitiesList = fightEngine.GetFightEntities()

    for key, _ in pairs(fightObserver.FightEntitiesList) do
        local currentEntity = fightObserver.FightEntitiesList[key]

        if currentEntity.Team == true then
            fightObserver.EnemyFightEntitiesList.insert(currentEntity)
        elseif currentEntity.Team == false then
            fightObserver.AllyFightEntitiesList.insert(currentEntity)
        end
    end
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

return fightObserver
