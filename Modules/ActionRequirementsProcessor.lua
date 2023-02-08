local actionPointsRequirement = require("Modules.Requirements.ActionPointsRequirement")
local cooldownRequirement = require("Modules.Requirements.CooldownRequirement")
local lineOfSightRequirement = require("Modules.Requirements.LineOfSightRequirement")
local emptyCellRequirement = require("Modules.Requirements.EmptyCellRequirement")
local targetTypeRequired = require("Modules.Requirements.TargetTypeRequirement")

local actionRequirementsProcessor = {}

function actionRequirementsProcessor.Validate(spellLevel, spellId, numberOfCasts, sourceCellId, targetCellId,
                                              requiredType, targetType)
    cooldownRequirement.IsValid(spellId)
    actionPointsRequirement.IsValid(spellId, numberOfCasts)

    if spellLevel.CastTestLos then
        lineOfSightRequirement.IsValid(sourceCellId, targetCellId)
    elseif spellLevel.NeedFreeCell then
        emptyCellRequirement.IsValid(targetCellId)
    elseif spellLevel.NeedTakenCell then
        --occupiedCellRequirement.IsValid(targetCellId)
    elseif spellLevel.NeedVisibleEntity then
    elseif spellLevel.NeedFreeTrapCell then
    elseif spellLevel.NeedCellWithoutPortal then
    elseif spellLevel.CastInLine then
    elseif spellLevel.CastInDiagonal then
    end

    --targetTypeRequired.IsValid(requiredType, targetType)
end

return actionRequirementsProcessor
