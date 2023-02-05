local utils = require("Modules.Utils")
local fightEngine = require("Modules.FightEngine")

local spell = {}

spell.Data = {
    { Id = 0, NameFr = "Coup de poing", NameEn = "Punch", ApCost = 3, DefaultRange = 1, LosRequired = false,
        TargetRequired = false, RecastTime = 1 },
    { Id = 7533, NameFr = "Lancer de Pièces", NameEn = "Coin Throwing", ApCost = 2, DefaultRange = 8, LosRequired = true,
        TargetRequired = true, RecastTime = 1, CastsPerTurnPerTarget = 3 },
    { Id = 7535, NameFr = "Sac Animé", NameEn = "Living Bag", ApCost = 2, DefaultRange = 1, LosRequired = false,
        TargetRequired = false, EmptyCellRequired = true, RecastTime = 4 },
}

spell.CastOnCellState = {
    CASTING_POSSIBLE = 0,
    LIMIT_OF_CASTS_PER_TURN_REACHED = 1,
    SPELL_ON_COOLDOWN = 2,
    INSUFICIENT_ACTION_POINTS = 3,
    LIMIT_OF_CAST_PER_TARGET_REACHED = 4,
    TARGET_TOO_FAR = 5,
    TARGET_TOO_CLOSE = 6,
    MUST_BE_CAST_IN_LINE = 7,
    TARGET_OUTSIDE_LINE_OF_SIGHT = 8,
    LIMIT_OF_SUMMONS_REACHED = 9,
    TARGET_CELL_IS_OCCUPIED = 10,
    TARGET_CELL_IS_EMPTY = 11,
    STATE_EFFECT_REQUIRED = 12,
    STATE_EFFECT_FORBIDDEN = 13,
    MUST_BE_CAST_IN_DIAGONAL = 14,
    UNKNOWN = 15,
    OUT_OF_RANGE = 16
}

function spell.GetIdByName(spellName, localization)
    for _, value in pairs(spell.Data) do
        if localization == "Fr" and value.NameFr == spellName then
            return value.Id
        elseif localization == "En" and value.NameEn == spellName then
            return value.Id
        end
    end
end

function spell.GetSpellParam(spellId, param)
    for _, value in pairs(spell.Data) do
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

function spell.CastOnCellStateToString(curCastOnCellState)
    return utils.switch(spell.CastOnCellState, curCastOnCellState)
end

function spell.CanCastThisTurn(spellId)
    local spellRecastTime = spell.GetSpellParam(spellId, "RecastTime")
    -- TODO: is castable at first turn?
    return fightEngine.IsFirstTurn() or fightAction:getCurrentTurn() % spellRecastTime == 0
end

function spell.HasApToCast(spellId, numberOfTimes)
    local spellApCost = spell.GetApCost(spellId)
    if numberOfTimes == 1 then
        return fightCharacter:getAP() >= spellApCost
    elseif numberOfTimes > 1 then
        return (fightCharacter:getAP() * numberOfTimes) >= (spellApCost * numberOfTimes)
    end
end

-- TODO: rename ro IsTargetCellWithinRangeInterval
-- TODO: use spell DefaultRangeMin, DefaultRangeMax
function spell.IsTargetCellInRange(spellId, myCellId, targetCellId)
    local spellDefaultRange = spell.GetSpellParam(spellId, "DefaultRange")
    local characterRangeBonus = fightCharacter:getRange()

    -- TODO: we assume that spell range is modyfiable, we asume reuirement for line of sight
    -- TODO: we assume a level 1 spell range as its actually progressive
    -- TODO: we assume spell is not required to be cast in geometric shape (only in line, only in circle etc...)
    if fightAction:getDistance(myCellId, targetCellId) < (spellDefaultRange + characterRangeBonus) then
        return true
    end
end

function spell.IsTargetCellInLineOfSight(myCellId, targetCellId)
    return fightAction:inLineOfSight(myCellId, targetCellId) == true
end

function spell.IsTargetCellOccupied(targetCellId)
    return fightAction:isFreeCell(targetCellId) == false
end

function spell.IsCastable(spellId, numberOfTimes)

    return spell.HasApToCast(spellId, numberOfTimes) == true and spell.CanCastThisTurn(spellId) == true
end

function spell.GetCastRequirements(spellId)
    local spellCastRequirements = { SpellId = spellId, Requirements = {} }
    local isLineOfSightRequired = spell.GetSpellParam(spellId, "LosRequired")
    local isTargetRequired = spell.GetSpellParam(spellId, "TargetRequired")
    local isEmptyCellRequired = spell.GetSpellParam(spellId, "EmptyCellRequired")

    if isLineOfSightRequired == true then
        spellCastRequirements.Requirements.insert("LosRequired")
    elseif isTargetRequired == true then
        spellCastRequirements.Requirements.insert("TargetRequired")
    elseif isEmptyCellRequired == true then
        spellCastRequirements.Requirements.insert("EmptyCellRequired")
    end

    return spellCastRequirements
end

function spell.IsCastableAtTargetCell(spellId, numberOfTimes, spellLaunchCellId, targetCellId)
    spellLaunchCellId = fightCharacter:getCellId();

    if spell.IsCastable(spellId, numberOfTimes) == false then
        return false
    elseif spell.IsTargetCellInRange(spellId, spellLaunchCellId, targetCellId) == false then
        return false
    elseif spell.ValidateAgainstRequirements(spellId, spellLaunchCellId, targetCellId) == false then
        return false
    end

    -- TODO: enemy/ally entity team type requirement
    -- TODO: minimum distance from caster requirement
    -- TODO: number of casts per turn per target requirement
    -- TODO: total number of casts per turn requirement
    -- TODO: total ammount of summons per character requirement

    return true
end

function spell.ValidateAgainstRequirements(spellId, spellLaunchCellId, targetCellId)
    local spellCastRequirements = spell.GetCastRequirements(spellId)

    for _, value in pairs(spellCastRequirements.Requirements) do
        if #value.Requirements > 0 then
            for _, requirementName in pairs(value.Requirements) do
                if requirementName == "LosRequired" then
                    return spell.IsTargetCellInLineOfSight(spellLaunchCellId, targetCellId) == true
                elseif requirementName == "TargetRequired" then
                    return spell.IsTargetCellOccupied(targetCellId) == true
                elseif requirementName == "EmptyCellRequired" then
                    return spell.IsTargetCellOccupied(targetCellId) == false
                end
            end
        end
    end
end

function spell.TryMoveIntoCastRange(spellId, targetCellId, onFailMoveTowardsTarget)
    local reachableCellsIds = fightAction:getReachableCells()
    local maxCastsPerTurnPerTarget = spell.GetSpellParam(spellId, "CastsPerTurnPerTarget")

    if #reachableCellsIds < 1 or maxCastsPerTurnPerTarget < 1 then
        return
    end

    for _, reachableCellsId in pairs(reachableCellsIds) do
        if spell.IsCastableAtTargetCell(spellId, maxCastsPerTurnPerTarget, reachableCellsId, targetCellId) then
            global:printMessage("[SPELL] found rechable cell: " ..
                reachableCellsId .. " where target cell: " .. targetCellId .. " can be attacked moving towards it.")
            fightAction:moveToWardCell(reachableCellsId)
            return
        end
    end

    global:printMessage("[SPELL] failed to find a rechable cell where target cell: " ..
        targetCellId .. " can be attacked.")
    if onFailMoveTowardsTarget == true then
        fightAction:moveToWardCell(targetCellId)
    end
end

function spell.TryCastingAtTargetCell(spellId, myCellId, targetCellId)
    -- Verification if we can cast spell on given cellId, result is a enum defined in spell.CastOnCellState
    local spellCastOnCellState = fightAction:canCastSpellOnCell(myCellId, spellId, targetCellId)
    -- Convert reason int value to string
    local spellCastOnCellStateStr = spell.CastOnCellStateToString(spellCastOnCellState)

    -- Its not possble to cast given spellId at given cellId for a reason
    if spellCastOnCellState ~= spell.CastOnCellState.CASTING_POSSIBLE then
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
