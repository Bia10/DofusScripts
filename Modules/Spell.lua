local utils = require("Modules.Utils")

local spell = {}

spell.Data = {
    { Id = 0,  NameFr = "Coup de poing", NameEn = "Punch" },
    { Id = 13338,  NameFr = "Lancer de Pièces", NameEn = "Coin Throwing" },
 }

 spell.CastOnCellState = {
        CastingPossible = 0,
        LimitOfCastsPerTurnReached = 1,
        SpellOnCooldown = 2,
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

return spell