local spell = require("Modules.Spell")

local lineOfSightRequirement = {}

function lineOfSightRequirement.IsValid(sourceCellId, targetCellId)
    if spell:IsTargetCellInLineOfSight(sourceCellId, targetCellId) then
        return true
    end

    return false;
end

return lineOfSightRequirement
