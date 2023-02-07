local spellTargetType = require("DofusTypes.Enum.SpellTargetType")

local targetTypeRequirement = {}

function IsValid(requiredType, targetEntityType)
    if requiredType == spellTargetType.NONE then
        return true
    elseif requiredType == spellTargetType.SELF or spellTargetType.SELF_ONLY then
        return targetEntityType == spellTargetType.SELF
    end

    global:printError("[Requirement-TargetType] Required target type: " .. requiredType .. "is not implemented")
    return false;
end

return targetTypeRequirement
