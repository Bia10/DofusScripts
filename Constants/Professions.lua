local professions =  {}

professions.ProfessionIds = {
    { Id = 1, NameFr = "Base", NameEn = "Base" },
    { Id = 2, NameFr = "Bűcheron", NameEn = "Lumberjack"},
    { Id = 11, NameFr = "Forgeron", NameEn = "Smith" },
    { Id = 13, NameFr = "Sculpteur", NameEn = "Carver" },
    { Id = 14, NameFr = "Forgeur de Marteaux", NameEn = "Hammer Smith" },
    { Id = 15, NameFr = "Cordonnier", NameEn = "Shoemaker" },
    { Id = 16, NameFr = "Bijoutier", NameEn = "Jeweler" },
    { Id = 17, NameFr = "Forgeur de Dagues", NameEn = "Dagger Smith" },
    { Id = 18, NameFr = "Sculpteur de Bâtons", NameEn = "Staff Carver" },
    { Id = 19, NameFr = "Sculpteur de Baguettes", NameEn = "Wand Carver" },
    { Id = 20, NameFr = "Forgeur de Pelles", NameEn = "Shovel Smith" },
    { Id = 24, NameFr = "Mineur", NameEn = "Miner" },
    { Id = 26, NameFr = "Alchimiste", NameEn = "Alchemist" },
    { Id = 27, NameFr = "Tailleur", NameEn = "Tailor" },
    { Id = 28, NameFr = "Paysan", NameEn = "Farmer" },
    { Id = 31, NameFr = "Forgeur de Haches", NameEn = "Axe Smith" },
    { Id = 36, NameFr = "Pęcheur", NameEn = "Fisherman" },
    { Id = 41, NameFr = "Chasseur", NameEn = "Hunter" },
    { Id = 43, NameFr = "Forgemage de Dagues", NameEn = "Dagger Smithmagus" },
    { Id = 44, NameFr = "Forgemage", NameEn = "Smithmagus" },
    { Id = 45, NameFr = "Forgemage de Marteaux", NameEn = "Hammer Smithmagus" },
    { Id = 46, NameFr = "Forgemage de Pelles", NameEn = "Shovel Smithmagus" },
    { Id = 47, NameFr = "Forgemage de Haches", NameEn = "Axe Smithmagus" },
    { Id = 48, NameFr = "Sculptemage", NameEn = "Carvmagus" },
    { Id = 49, NameFr = "Sculptemage de Baguettes", NameEn = "Wand Carvmagus" },
    { Id = 50, NameFr = "Sculptemage de Bâtons", NameEn = "Staff Carvmagus" },
    { Id = 60, NameFr = "Façonneur", NameEn = "Artificer" },
    { Id = 62, NameFr = "Cordomage", NameEn = "Shoemagus" },
    { Id = 63, NameFr = "Joaillomage", NameEn = "Jewelmagus" },
    { Id = 64, NameFr = "Costumage", NameEn = "Costumagus" },
    { Id = 65, NameFr = "Bricoleur", NameEn = "Handyman" },
    { Id = 74, NameFr = "Façomage", NameEn = "Craftmagus" },
    { Id = 75, NameFr = "Parchomage", NameEn = "Scrollmage" },
    { Id = 78, NameFr = "", NameEn = "Beastologist" }
 }

 function professions.GetProfessionNameById(professionId, localization)
    for _, value in pairs(professions.ProfessionIds) do
        if (value.Id == professionId and localization == "Fr") then
                return value.NameFr
        elseif (value.Id == professionId and localization == "En")  then
                return value.NameEn
        end
    end
end 

 function professions.GetProfessionIdByName(professionName, localization)
    for _, value in pairs(professions.ProfessionIds) do
        if (localization == "Fr" and value.NameFr == professionName) then
                return value.Id
        elseif (localization == "En" and value.NameEn == professionName) then
                return value.Id
        end
    end
 end

 return professions