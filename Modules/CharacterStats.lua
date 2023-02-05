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

return characterStats
