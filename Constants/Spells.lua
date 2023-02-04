local spells = {}

spells.SpellIds = {
    { Id = 0,  NameFr = "Coup de poing", NameEn = "Punch" },
    { Id = 13338,  NameFr = "Lancer de Pièces", NameEn = "Coin Throwing" },
 }

 function spells.GetSpellIdByName(spellName, localization)
    for _, value in pairs(spells.SpellIds) do
        if (localization == "Fr" and value.NameFr == spellName) then
                return value.Id
        elseif (localization == "En" and value.NameEn == spellName) then
                return value.Id
        end
    end
 end

return spells