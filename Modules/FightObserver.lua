local fightEngine = require("Modules.FightEngine")

local fightObserver = {}

fightObserver.FightEntitiesList = {}
fightObserver.AllyFightEntitiesList = {}
fightObserver.EnemyFightEntitiesList = {}
fightObserver.EntitiesContext = {}
fightObserver.GenericContext = {}
fightObserver.FightContext = {}

function fightObserver:LoadFightContext()
    self:LoadEntitiesContext()
    self:LoadGenericContext()

    self.FightContext = {
        self.GenericContext,
        self.EntitiesContext,
    }
end

function fightObserver:LoadEntitiesContext()
    self.FightEntitiesList = fightEngine.GetFightEntities()

    for key, _ in pairs(self.FightEntitiesList) do
        local currentEntity = self.FightEntitiesList[key]

        if currentEntity.Team then
            self.EnemyFightEntitiesList.insert(currentEntity)
        elseif not currentEntity.Team then
            self.AllyFightEntitiesList.insert(currentEntity)
        end
    end

    self.EntitiesContext = { {
        FightEntities = self.FightEntitiesList,
        AllyFightEntities = self.AllyFightEntitiesList,
        EnemyFightEntities = self.EnemyFightEntitiesList,
    } }
end

function fightObserver:LoadGenericContext()
    self.GenericContext = { {
        CurrentTurnNumber = fightAction:getCurrentTurn(),
        CurrentFightCount = global:getCountFight(),
        TotalEntitiesCount = #self.FightEntitiesList,
        EnemyEntitiesCount = #self.EnemyFightEntitiesList,
        AllyEntitiesCount = #self.AllyFightEntitiesList,
    } }
end

function fightObserver:GetAttackersCells()
    local attackerCells = {}

    -- assuming i am attacking and not being agroed
    for key, _ in pairs(self.AllyFightEntitiesList) do
        local currentAllyEntity = self.AllyFightEntitiesList[key]

        attackerCells.insert(currentAllyEntity.CellId, currentAllyEntity.Id)
    end

    return attackerCells
end

function fightObserver:GetDefendersCells()
    local defenderCells = {}

    for key, _ in pairs(self.EnemyFightEntitiesList) do
        local currentEnemyEntity = self.EnemyFightEntitiesList[key]

        defenderCells.insert(currentEnemyEntity.CellId, currentEnemyEntity.Id)
    end

    return defenderCells
end

function fightObserver:getEntityAtCellId(cellId)
    for key, _ in pairs(self.FightEntitiesList) do
        if self.FightEntitiesList[key].CellId == cellId then
            return self.FightEntitiesList[key]
        end
    end
end

function fightObserver:GetEnemiesWeakToElementType(elementType)
    local enemyResistances = {}

    for key, _ in pairs(self.EnemyFightEntitiesList) do
        local currentEnemyEntity = self.EnemyFightEntitiesList[key]

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
        table.sort(enemyResistances,
            function(a, b) return a.ResistanceNeaturalPercentage < b.ResistanceNeaturalPercentage end)
    end

    return enemyResistances
end

return fightObserver
