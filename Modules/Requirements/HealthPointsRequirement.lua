local healthPointsRequirement = {}

function IsValid(requiredHP, comparisonType, targetEntity)
    local targetEntityCurHP = targetEntity.LifePoints

    if comparisonType == "Less" then
        return targetEntityCurHP < requiredHP
    elseif comparisonType == "LessOrEqual" then
        return targetEntityCurHP <= requiredHP
    elseif comparisonType == "Equal" then
        return targetEntityCurHP == requiredHP
    elseif comparisonType == "Greater" then
        return targetEntityCurHP > requiredHP
    elseif comparisonType == "GreaterOrEqual" then
        return targetEntityCurHP >= requiredHP
    end

    global:printError("[Requirement-HP] Invalid comparison type: " ..comparisonType)
    return false;
end

return healthPointsRequirement
