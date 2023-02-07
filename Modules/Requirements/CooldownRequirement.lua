local spell = require("Modules.Spell")

local cooldownRequirement = {}

function IsValid(spellId)
    return spell:CanCastThisTurn(spellId)
end

return cooldownRequirement