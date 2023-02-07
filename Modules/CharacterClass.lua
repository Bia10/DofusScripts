local characterStats = require("Modules.CharacterStats")
local enutrofBasicWaterStrategy = require("Strategies.Enutrof.BasicWaterStrategy")

local characterClass = {}

characterClass.Data = {
    { Id = 1, NameFr = "Féca", NameEn = "Feca" },
    { Id = 2, NameFr = "Osamodas", NameEn = "Osamodas" },
    { Id = 3, NameFr = "Enutrof", NameEn = "Enutrof" },
    { Id = 4, NameFr = "Sram", NameEn = "Sram" },
    { Id = 5, NameFr = "Xélor", NameEn = "Xelor" },
    { Id = 6, NameFr = "Ecaflip", NameEn = "Ecaflip" },
    { Id = 7, NameFr = "Eniripsa", NameEn = "Eniripsa" },
    { Id = 8, NameFr = "Iop", NameEn = "Iop" },
    { Id = 9, NameFr = "Crâ", NameEn = "Cra" },
    { Id = 10, NameFr = "Sadida", NameEn = "Sadida" },
    { Id = 11, NameFr = "Sacrieur", NameEn = "Sacrier" },
    { Id = 12, NameFr = "Pandawa", NameEn = "Pandawa" },
    { Id = 13, NameFr = "Roublard", NameEn = "Rouge" },
    { Id = 14, NameFr = "Zobal", NameEn = "Masquerider" },
    { Id = 15, NameFr = "Steamer", NameEn = "Foggernaut" },
    { Id = 16, NameFr = "Eliotrope", NameEn = "Eliotrope" },
    { Id = 17, NameFr = "Huppermage", NameEn = "Huppermage" },
    { Id = 18, NameFr = "Ouginak", NameEn = "Ouginak" },
    { Id = 20, NameFr = "Forgelance", NameEn = "Forgelance" }
}

function characterClass.IsSupportClass(classId)
    local supportClassIds = { 1, 2, 6, 7 }

    for i = 1, #supportClassIds, 1 do
        return supportClassIds == classId
    end
end

function characterClass.SelectAndExecuteFightStrategy(selectByMainElement)
    local characterClassId = character:breed()
    local mainStat = characterStats.GetHighestStat()

    if characterClassId == 1 then
        if selectByMainElement then
            if mainStat == "Inteligence" then
                -- return fecaBasicFireStrategy.Execute()
            elseif mainStat == "Strength" then
                -- return fecaBasicStrengthStrategy.Execute()
            elseif mainStat == "Agility" then
                -- return fecaBasicAgilityStrategy.Execute()
            elseif mainStat == "Chance" then
                -- return fecaBasicWaterStrategy.Execute()
            end
        end
    elseif characterClassId == 2 then
        if selectByMainElement then
            if mainStat == "Inteligence" then
                -- return osamodasBasicFireStrategy.Execute()
            elseif mainStat == "Strength" then
                -- return osamodasBasicStrengthStrategy.Execute()
            elseif mainStat == "Agility" then
                -- return osamodasBasicAgilityStrategy.Execute()
            elseif mainStat == "Chance" then
                -- return osamodasBasicWaterStrategy.Execute()
            elseif mainStat == "Vitality" then
                -- return osamodasBasicVitalityStrategy.Execute()
            end
        end
    elseif characterClassId == 3 then
        if selectByMainElement then
            if mainStat == "Inteligence" then
                -- return enutrofBasicFireStrategy.Execute()
            elseif mainStat == "Strength" then
                -- return enutrofBasicStrengthStrategy.Execute()
            elseif mainStat == "Agility" then
                -- return enutrofBasicAgilityStrategy.Execute()
            elseif mainStat == "Chance" then
                return enutrofBasicWaterStrategy.Execute()
            end
        end
    end
end

return characterClass
