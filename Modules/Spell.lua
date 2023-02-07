local utils = require("Modules.Utils")
local fightEngine = require("Modules.FightEngine")
local spellCastResult = require("Enum.SpellCastResult")
--local cooldownRequirement = require("Modules.Requirements.CooldownRequirement")

local spell = {}

spell.Data = {
    { Id = 0,    NameFr = "Coup de poing",    NameEn = "Punch",         ApCost = 3, DefaultRange = 1, LosRequired = false, TargetRequired = false, EmptyCellRequired = false, RecastTime = 1, CastsPerTurnPerTarget = 3 },
    { Id = 7533, NameFr = "Lancer de Pièces", NameEn = "Coin Throwing", ApCost = 2, DefaultRange = 8, LosRequired = true,  TargetRequired = true,  EmptyCellRequired = false, RecastTime = 1, CastsPerTurnPerTarget = 3 },
    { Id = 7535, NameFr = "Sac Animé",        NameEn = "Living Bag",    ApCost = 2, DefaultRange = 1, LosRequired = false, TargetRequired = false, EmptyCellRequired = true,  RecastTime = 4, CastsPerTurnPerTarget = 0 },
}

function spell:GetIdByName(spellName, localization)
    for _, value in pairs(self.Data) do
        if localization == "Fr" and value.NameFr == spellName then
            return value.Id
        elseif localization == "En" and value.NameEn == spellName then
            return value.Id
        end
    end
end

function spell:GetSpellParam(spellId, param)
    for _, value in pairs(self.Data) do
        if value.Id == spellId then
            if param == "ApCost" then
                return value.ApCost
            elseif param == "DefaultRange" then
                return value.DefaultRange
            elseif param == "RecastTime" then
                return value.RecastTime
            elseif param == "CastsPerTurnPerTarget" then
                return value.CastsPerTurnPerTarget
            elseif param == "LosRequired" then
                return value.LosRequired
            elseif param == "TargetRequired" then
                return value.TargetRequired
            elseif param == "EmptyCellRequired" then
                return value.EmptyCellRequired
            end
        end
    end
end

function spell:CastOnCellStateToString(curCastOnCellState)
    return utils.switch(self.CastOnCellState, curCastOnCellState)
end

function spell:CanCastThisTurn(spellId)
    local spellRecastTime = self:GetSpellParam(spellId, "RecastTime")
    -- TODO: is castable at first turn?
    return fightEngine.IsFirstTurn() or fightAction:getCurrentTurn() % spellRecastTime == 0
end

function spell:HasApToCast(spellId, numberOfTimes)
    local spellApCost = self:GetApCost(spellId)
    if numberOfTimes == 1 then
        return fightCharacter:getAP() >= spellApCost
    elseif numberOfTimes > 1 then
        return (fightCharacter:getAP() * numberOfTimes) >= (spellApCost * numberOfTimes)
    end
end

function spell:IsTargetCellWithinRange(spellId, myCellId, targetCellId)
    -- TODO: spell range depends on spell level
    local spellDefaultMaxRange = self:GetSpellParam(spellId, "DefaultMaxRange")
    local spellDefaultMinRange = self:GetSpellParam(spellId, "DefaultMinRange")
    local characterRangeBonus = fightCharacter:getRange()
    local distanceToTargetCell = fightAction:getDistance(myCellId, targetCellId)
    -- TODO: is spell range modyfiable?
    local spellMaxModifiedRange = spellDefaultMaxRange + characterRangeBonus
    local spellMinModifiedRange = spellDefaultMinRange + characterRangeBonus
    local isWithinMaxRange = false
    local isWithinMinRange = false

    -- TODO: we asume reuirement for line of sight
    -- TODO: distance depends on choice of metric space, we assume euclidian metric space

    if distanceToTargetCell <= spellMaxModifiedRange then
        isWithinMaxRange = true
    end

    if distanceToTargetCell >= spellMinModifiedRange then
        isWithinMinRange = true
    end

    return isWithinMaxRange and isWithinMinRange;
end

function spell:IsTargetCellInLineOfSight(myCellId, targetCellId)
    return fightAction:inLineOfSight(myCellId, targetCellId)
end

function spell:IsTargetCellOccupied(targetCellId)
    return not fightAction:isFreeCell(targetCellId)
end

function spell:IsCastable(spellId, numberOfTimes)
    return self:HasApToCast(spellId, numberOfTimes) and self:CanCastThisTurn(spellId)
end

function spell:GetCastRequirements(spellId)
    local spellCastRequirements = { SpellId = spellId, Requirements = {} }
    local isLineOfSightRequired = self:GetSpellParam(spellId, "LosRequired")
    local isTargetRequired = self:GetSpellParam(spellId, "TargetRequired")
    local isEmptyCellRequired = self:GetSpellParam(spellId, "EmptyCellRequired")

    if isLineOfSightRequired then
        spellCastRequirements.Requirements.insert("LosRequired")
    elseif isTargetRequired then
        spellCastRequirements.Requirements.insert("TargetRequired")
    elseif isEmptyCellRequired then
        spellCastRequirements.Requirements.insert("EmptyCellRequired")
    end

    return spellCastRequirements
end

function spell:IsCastableAtTargetCell(spellId, numberOfTimes, spellLaunchCellId, targetCellId)
    spellLaunchCellId = fightCharacter:getCellId();

    if not self:IsCastable(spellId, numberOfTimes) then
        return false
    elseif not self:IsTargetCellWithinRange(spellId, spellLaunchCellId, targetCellId) then
        return false
    elseif not self:ValidateAgainstRequirements(spellId, spellLaunchCellId, targetCellId) then
        return false
    end

    -- TODO: enemy/ally entity team type requirement
    -- TODO: minimum distance from caster requirement
    -- TODO: number of casts per turn per target requirement
    -- TODO: total number of casts per turn requirement
    -- TODO: total ammount of summons per character requirement

    return true
end

function spell:ValidateAgainstRequirements(spellId, spellLaunchCellId, targetCellId)
    local spellCastRequirements = self:GetCastRequirements(spellId)

    for _, value in pairs(spellCastRequirements.Requirements) do
        if #value.Requirements > 0 then
            for _, requirementName in pairs(value.Requirements) do
                if requirementName == "LosRequired" then
                    return self:IsTargetCellInLineOfSight(spellLaunchCellId, targetCellId)
                elseif requirementName == "TargetRequired" then
                    return self:IsTargetCellOccupied(targetCellId)
                elseif requirementName == "EmptyCellRequired" then
                    return not self:IsTargetCellOccupied(targetCellId)
                end
            end
        end
    end
end

function spell:TryMoveIntoCastRange(spellId, targetCellId, onFailMoveTowardsTarget)
    local reachableCellsIds = fightAction:getReachableCells()
    local maxCastsPerTurnPerTarget = self:GetSpellParam(spellId, "CastsPerTurnPerTarget")

    if #reachableCellsIds < 1 or maxCastsPerTurnPerTarget < 1 then
        return
    end

    for _, reachableCellsId in pairs(reachableCellsIds) do
        if self:IsCastableAtTargetCell(spellId, maxCastsPerTurnPerTarget, reachableCellsId, targetCellId) then
            global:printMessage("[SPELL] found rechable cell: " ..
            reachableCellsId .. " where target cell: " .. targetCellId .. " can be attacked moving towards it.")
            fightAction:moveToWardCell(reachableCellsId)
            return
        end
    end

    global:printMessage("[SPELL] failed to find a rechable cell where target cell: " ..
    targetCellId .. " can be attacked.")
    if onFailMoveTowardsTarget then
        fightAction:moveToWardCell(targetCellId)
    end
end

function spell:TryCastingAtTargetCell(spellId, myCellId, targetCellId)
    -- Verification if we can cast spell on given cellId, result is a enum defined in self:CastOnCellState
    local spellCastOnCellState = fightAction:canCastSpellOnCell(myCellId, spellId, targetCellId)
    -- Convert reason int value to string
    local spellCastOnCellStateStr = self:CastOnCellStateToString(spellCastOnCellState)

    -- Its not possble to cast given spellId at given cellId for a reason
    if spellCastOnCellState ~= spellCastResult.CASTING_POSSIBLE then
        global:printError("Its not possible to cast spellId: " ..
        spellId .. " on cellId: " .. targetCellId .. " reason: " .. spellCastOnCellStateStr)
        ---------------------------------------------
        -- Spell cast on cellId failure processing --
        ---------------------------------------------
        -- TODO: collect data, what is the reason of failure?
        -- TODO: is possible to fix the reason of failure?
    end

    -- Casting possible then cast spell on cellId
    fightAction:castSpellOnCell(spellId, targetCellId)
end

return spell
