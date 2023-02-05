local worldMove = require("Modules.WorldMove")

local zapp = {}

zapp.Data = {
    { ZaapId = 0, MapId = 191105026, MapPos = "5, -18", LocationNameFr = "Cite d'Astrub", LocationNameEn = "Astrub City" },
    { ZaapId = 0, MapId = 120062979, MapPos = "1, -32", LocationNameFr = "Tainela", LocationNameEn = "Tainela" },
}

function zapp.DisoverZaapAtMap(mapId)
    worldMove.ToMap(mapId)

    if fightCharacter:getCellId() == mapId then
        if map:getNearestZaap(mapId) ~= 0 then
            map:saveZaap()
        end
    end
end

return zapp
