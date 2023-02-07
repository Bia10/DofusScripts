local spell = require("Modules.Spell")

local emptyCellRequirement = {}

function emptyCellRequirement.IsValid(targetCellId)
    if spell:IsTargetCellOccupied(targetCellId) then
        return true
    end

    return false;
end

return emptyCellRequirement
