local utils = require("Modules.Utils")

local spell = {}

spell.Data = {
    { Id = 0,  NameFr = "Coup de poing", NameEn = "Punch" },
    { Id = 13338,  NameFr = "Lancer de Pièces", NameEn = "Coin Throwing", ApCost = 2 },
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

function spell.CastOnCellStateToString(curCastOnCellState)
        return utils.switch(spell.CastOnCellState, curCastOnCellState)
end

function spell.CanCastThisTurn(turnNumber)
        -- Assuming that first turn its always castable, may not be
      return fightAction:getCurrentTurn() == 1 or fightAction:getCurrentTurn() % turnNumber == 0
end

function spell.HasApToCast(spellId, numberOfTimes)
  for _, value in pairs(spell.Data) do
     if (value.Id == spellId) then
        if (numberOfTimes == 1) then
           return fightCharacter:getAP() >= value.ApCost
        elseif (numberOfTimes > 1) then
           return (fightCharacter:getAP() * numberOfTimes) >= (value.ApCost * numberOfTimes)
        end
      end
   end
end

return spell