local utils = require("Modules.Utils")

local spell = {}

spell.Data = {
    { Id = 0,  NameFr = "Coup de poing", NameEn = "Punch", ApCost = 3, DefaultRange = 1 },
    { Id = 13338,  NameFr = "Lancer de Pièces", NameEn = "Coin Throwing", ApCost = 2, DefaultRange = 8 },
 }

 spell.CastOnCellState = {
        CASTING_POSSIBLE = 0,
        LIMIT_OF_CASTS_PER_TURN_REACHED = 1,
        SPELL_ON_COOLDOWN = 2,
 }

 function spell.GetIdByName(spellName, localization)
    for _, value in pairs(spell.Data) do
        if (localization == "Fr" and value.NameFr == spellName) then
                return value.Id
        elseif (localization == "En" and value.NameEn == spellName) then
                return value.Id
        end
    end
 end

 function spell.GetSpellParam(spellId, param)
   for _, value in pairs(spell.Data) do
        if (value.Id == spellId) then
           if (param == "ApCost") then
                return value.ApCost
           elseif (param == "DefaultRange") then
                return value.DefaultRange
           end
        end
   end
end

function spell.CastOnCellStateToString(curCastOnCellState)
    return utils.switch(spell.CastOnCellState, curCastOnCellState)
end

function spell.CanCastThisTurn(turnNumber)
     -- Assuming that first turn its always castable, may not be
     return fightAction:getCurrentTurn() == 1 or fightAction:getCurrentTurn() % turnNumber == 0
end

function spell.HasApToCast(spellId, numberOfTimes)
    local spellApCost = spell.GetApCost(spellId)
    if (numberOfTimes == 1) then
        return fightCharacter:getAP() >= spellApCost
    elseif (numberOfTimes > 1) then
        return (fightCharacter:getAP() * numberOfTimes) >= (spellApCost * numberOfTimes)
   end
end

function spell.IsTargetInRange(spellId, targetCellId)
   local myCellId = fightCharacter:getCellId();
   local distanceToTargetCell = fightAction:getDistance(myCellId, targetCellId)
   local spellDefaultRange = spell.GetSpellParam(spellId, param)
   local characterRangeBonus = fightCharacter:getRange()

   -- TODO: we assume that spell range is modyfiable, we asume reuirement for line of sight
   -- TODO: we assume a level 1 spell range as its actually progressive
   -- TODO: we assume spell is not required to be cast in geometric shape (only in line, only in circle etc...)
   if (distanceToTargetCell < (spellDefaultRange + characterRangeBonus)) then
       return true
   end
end

function spell.TryCastingAtCellId(spellId, myCellId, targetCellId)
        -- Verification if we can cast spell on given cellId, result is a enum defined in spell.CastOnCellState
        local spellCastOnCellState = fightAction:canCastSpellOnCell(myCellId, spellId, targetCellId)
        -- Convert reason int value to string
        local spellCastOnCellStateStr = spell.CastOnCellStateToString(spellCastOnCellState)

        -- Its not possble to cast given spellId at given cellId for a reason
        if (spellCastOnCellState ~= spell.CastOnCellState.CASTING_POSSIBLE) then
                global:printError("Its not possible to cast: " ..spellId.. " on cellId: " ..targetCellId.. " reason: " ..spellCastOnCellStateStr)
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