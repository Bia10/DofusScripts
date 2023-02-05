local utils = require("Modules.Utils")

local spell = {}

spell.Data = {
    { Id = 0, NameFr = "Coup de poing", NameEn = "Punch", ApCost = 3, DefaultRange = 1, RecastTime = 1 },
    { Id = 7533, NameFr = "Lancer de Pièces", NameEn = "Coin Throwing", ApCost = 2, DefaultRange = 8, LosRequired = true,
        RecastTime = 1, CastsPerTurnPerTarget = 3 },
    { Id = 7535, NameFr = "Sac Animé", NameEn = "Living Bag", ApCost = 2, DefaultRange = 1, RecastTime = 4 },
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
    return fightAction:getCurrentTurn() == 1 or fightAction:getCurrentTurn() % spellRecastTime == 0
end

function spell.HasApToCast(spellId, numberOfTimes)
    local spellApCost = spell.GetApCost(spellId)
    if numberOfTimes == 1 then
        return fightCharacter:getAP() >= spellApCost
    elseif numberOfTimes > 1 then
        return (fightCharacter:getAP() * numberOfTimes) >= (spellApCost * numberOfTimes)
    end
end

function spell.IsTargetCellInRange(spellId, myCellId, targetCellId)
    local distanceToTargetCell = fightAction:getDistance(myCellId, targetCellId)
    local spellDefaultRange = spell.GetSpellParam(spellId, "DefaultRange")
    local characterRangeBonus = fightCharacter:getRange()

    -- TODO: we assume that spell range is modyfiable, we asume reuirement for line of sight
    -- TODO: we assume a level 1 spell range as its actually progressive
    -- TODO: we assume spell is not required to be cast in geometric shape (only in line, only in circle etc...)
    if distanceToTargetCell < (spellDefaultRange + characterRangeBonus) then
        return true
    end
end

function spell.IsTargetCellInLineOfSight(spellId, myCellId, targetCellId)
    local isLineOfSightRequired = spell.GetSpellParam(spellId, "LosRequired")

    if isLineOfSightRequired == false then
        return true
    end

    if isLineOfSightRequired == true and fightAction:inLineOfSight(myCellId, targetCellId) == true then
        return true
    end

    return false
end

function spell.IsCastable(spellId, numberOfTimes)
    if spell.HasApToCast(spellId, numberOfTimes) and spell.CanCastThisTurn(spellId) then
        return true
    end
    return false
end

function spell.IsCastableAtTargetCell(spellId, numberOfTimes, targetCellId)
    local myCellId = fightCharacter:getCellId();

    if spell.IsCastable(spellId, numberOfTimes) == false then
        return false
    end

    if spell.IsTargetCellInRange(spellId, myCellId, targetCellId) == false then
        return false
    end

    if spell.IsTargetCellInLineOfSight(spellId, myCellId, targetCellId) == false then
        return false
    end

    return true
end

function spell.TryMoveIntoCastRange(spellId, targetCellId)
    local reachableCellsIds = fightAction:getReachableCells()
    local spellDefaultRange = spell.GetSpellParam(spellId, "DefaultRange")
    local characterRangeBonus = fightCharacter:getRange()

    for _, value in pairs(reachableCellsIds) do
        if fightAction:getDistance(value, targetCellId) < (spellDefaultRange + characterRangeBonus) then
            fightAction:moveToWardCell(value)
        end
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
