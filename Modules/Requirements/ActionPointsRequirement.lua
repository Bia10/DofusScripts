local spell = require("Modules.Spell")

local actionPointsRequirement = {}

function IsValid(spellId, numberOfCasts)
    return spell:HasApToCast(spellId, numberOfCasts)
end

return actionPointsRequirement