local spellTargetType = require("DofusTypes.Enum.SpellTargetType")

local targetTypeRequirement = {}

function IsValid(requiredType, targetEntityType)
    if requiredType == spellTargetType.NONE then
        return true
    end

    if requiredType == spellTargetType.SELF or spellTargetType.SELF_ONLY  then
        return targetEntityType == spellTargetType.SELF
    end

    return false;
end

return targetTypeRequirement
