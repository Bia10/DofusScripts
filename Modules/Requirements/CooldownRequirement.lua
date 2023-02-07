local spell = require("Modules.Spell")

local cooldownRequirement = {}

function cooldownRequirement.IsValid(spellId)
    return spell:CanCastThisTurn(spellId)
end

return cooldownRequirement
