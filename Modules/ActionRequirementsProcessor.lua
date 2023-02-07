local actionPointsRequirement = require("Modules.Requirements.ActionPointsRequirement")
local cooldownRequirement = require("Modules.Requirements.CooldownRequirement")
local lineOfSightRequirement = require("Modules.Requirements.LineOfSightRequirement")
local emptyCellRequirement = require("Modules.Requirements.EmptyCellRequirement")
local targetTypeRequired = require("Modules.Requirements.TargetTypeRequirement")

local actionRequirementsProcessor = {}

function actionRequirementsProcessor.Validate(spellId, numberOfCasts, sourceCellId, targetCellId, requiredType, targetType)
    -- TODO: load requirements from spellLevel
    local isLineOfSightRequired = self:GetSpellParam(spellId, "LosRequired")
    local isTargetRequired = self:GetSpellParam(spellId, "TargetRequired")
    local isEmptyCellRequired = self:GetSpellParam(spellId, "EmptyCellRequired")

    cooldownRequirement.IsValid(spellId)
    actionPointsRequirement.IsValid(spellId, numberOfCasts)

    if isLineOfSightRequired then
        lineOfSightRequirement.IsValid(sourceCellId, targetCellId)
    elseif isEmptyCellRequired then
        emptyCellRequirement.IsValid(targetCellId)
    elseif isTargetRequired then
        targetTypeRequired.IsValid(requiredType, targetType)
    end
end

return actionRequirementsProcessor
