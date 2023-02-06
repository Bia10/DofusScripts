local characterStats = {}

function characterStats.GetHighestStat()
    local statsTable = {
        { Points = character:getAgilityBase(), Type = "Agility" },
        { Points = character:getChanceBase(), Type = "Chance" },
        { Points = character:getIntelligenceBase(), Type = "Inteligence" },
        { Points = character:getStrenghtBase(), Type = "Strenght" },
        { Points = character:getVitalityBase(), Type = "Vitality" },
        { Points = character:getWisdomBase(), Type = "Wisdom" },
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

    if statType == "Inteligence" then
        if character:getCostIntelligence() > pointsToInvest then
            return false
        end
    elseif statType == "Strength" then
        if character:getCostStrenght() > pointsToInvest then
            return false
        end
    elseif statType == "Agility" then
        if character:getCostAgility() > pointsToInvest then
            return false
        end
    elseif statType == "Chance" then
        if character:getCostChance() > pointsToInvest then
            return false
        end
    elseif statType == "Vitality" then
        if character:getCostVitality() > pointsToInvest then
            return false
        end
    elseif statType == "Wisdom" then
        if character:getCostWisdom() > pointsToInvest then
            return false
        end
    end

    return true
end

function characterStats.UpgradeStat(statType, pointsToInvest)
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
