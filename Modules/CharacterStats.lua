local characterStats = {}

function characterStats.GetHighestStat()
    local statsTable = {
        { Points = character:getAgilityBase(),      Type = "Agility" },
        { Points = character:getChanceBase(),       Type = "Chance" },
        { Points = character:getIntelligenceBase(), Type = "Inteligence" },
        { Points = character:getStrenghtBase(),     Type = "Strenght" },
        { Points = character:getVitalityBase(),     Type = "Vitality" },
        { Points = character:getWisdomBase(),       Type = "Wisdom" },
    }

    -- sort table in ascending order, therefore last is highest value
    table.sort(statsTable, function(a, b) return a.Points < b.Points end)

    return statsTable[#statsTable].Type
end

function characterStats.CanUpgrade(statType, pointsToInvest)
    -- not enough points to upgrade
    if pointsToInvest > character:statsPoint() then
        return false
    end

    if statType == "Inteligence" and character:getCostIntelligence() > pointsToInvest then
        return false
    elseif statType == "Strength" and character:getCostStrenght() > pointsToInvest then
        return false
    elseif statType == "Agility" and character:getCostAgility() > pointsToInvest then
        return false
    elseif statType == "Chance" and character:getCostChance() > pointsToInvest then
        return false
    elseif statType == "Vitality" and character:getCostVitality() > pointsToInvest then
        return false
    elseif statType == "Wisdom" and character:getCostWisdom() > pointsToInvest then
        return false
    end

    return true
end

function characterStats.Upgrade(statType, pointsToInvest)
    if characterStats.CanUpgrade(statType, pointsToInvest) then
        if statType == "Inteligence" then
            character:upgradeIntelligence(pointsToInvest)
        elseif statType == "Strength" then
            character:upgradeStrenght(pointsToInvest)
        elseif statType == "Agility" then
            character:upgradeAgility(pointsToInvest)
        elseif statType == "Chance" then
            character:upgradeChance(pointsToInvest)
        elseif statType == "Vitality" then
            character:upgradeVitality(pointsToInvest)
        elseif statType == "Wisdom" then
            character:upgradeWisdom(pointsToInvest)
        end
    end
end

return characterStats
