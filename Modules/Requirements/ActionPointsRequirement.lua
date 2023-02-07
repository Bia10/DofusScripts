local spell = require("Modules.Spell")

local actionPointsRequirement = {}

function actionPointsRequirement.IsValid(spellId, numberOfCasts)
    return spell:HasApToCast(spellId, numberOfCasts)
end

return actionPointsRequirement