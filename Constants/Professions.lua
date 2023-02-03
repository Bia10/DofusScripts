ProfessionIds = {
    { Id = 1,  NameFr = "Base",      NameEn = "Base" },
    { Id = 2,  NameFr = "Bűcheron",  NameEn = "Lumberjack"},
    { Id = 11, NameFr = "Forgeron",  NameEn = "Smith" },
    { Id = 13, NameFr = "Sculpteur", NameEn = "Carver" },
    { Id = 14, NameFr = "",          NameEn = "Hammersmith" },
    { Id = 15, NameFr = "Cordonnier", NameEn = "Shoemaker" },
    { Id = 16, NameFr = "Bijoutier", NameEn = "Jeweler" },
    { Id = 17, NameFr = "", NameEn = "Daggersmith" },
    { Id = 18, NameFr = "", NameEn = "Staffcarver" },
    { Id = 20, NameFr = "", NameEn = "Shovelsmith" },
    { Id = 24, NameFr = "Mineur", NameEn = "Miner" },
    { Id = 26, NameFr = "Alchimiste", NameEn = "Alchemist" },
    { Id = 27, NameFr = "Tailleur", NameEn = "Tailor" },
    { Id = 28, NameFr = "Paysan", NameEn = "Farmer" },
    { Id = 31, NameFr = "", NameEn = "Axesmith" },
    { Id = 36, NameFr = "Pęcheur", NameEn = "Fisherman" },
    { Id = 41, NameFr = "Chasseur", NameEn = "Hunter" },
    { Id = 43, NameFr = "", NameEn = "Dagger Smithmagus" },
    { Id = 44, NameFr = "Forgemage", NameEn = "Smithmagus" },
    { Id = 45, NameFr = "", NameEn = "Hammer Smithmagus" },
    { Id = 46, NameFr = "", NameEn = "Shovel Smithmagus" },
    { Id = 47, NameFr = "", NameEn = "Axe Smithmagus" },
    { Id = 48, NameFr = "Sculptemage", NameEn = "Carvmagus" },
    { Id = 48, NameFr = "", NameEn = "Wand Carvmagus" },
    { Id = 60, NameFr = "Façonneur", NameEn = "Artificer" },
    { Id = 62, NameFr = "Cordomage", NameEn = "Shoemagus" },
    { Id = 63, NameFr = "Joaillomage", NameEn = "Jewelmagus" },
    { Id = 64, NameFr = "Costumage", NameEn = "Costumagus" },
    { Id = 65, NameFr = "Bricoleur", NameEn = "Handyman" },
    { Id = 74, NameFr = "Façomage", NameEn = "Craftmagus" },
    { Id = 75, NameFr = "Parchomage", NameEn = "Scrollmage" },
    { Id = 78, NameFr = "", NameEn = "Beastologist" },
 }

 function GetProfessionNameById(professionId, localization)
    for key, value in pairs(ProfessionIds) do
        if (value.Id == professionId) then
            if (localization == "Fr") then
                return value.NameFr
            elseif (localization == "En")  then
                return value.NameEn
            end
        end
    end
 end

 function GetProfessionIdByName(professionName, localization)
    for key, value in pairs(ProfessionIds) do
        if (localization == "Fr") then
            if (value.NameFr == professionName) then
                return value.Id
            end
        elseif (localization == "En") then
            if (value.NameEn == professionName) then
                return value.Id
            end
        end
    end
 end