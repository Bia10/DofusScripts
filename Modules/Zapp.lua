local worldMove = require("Modules.WorldMove")

local zapp = {}

zapp.Data = {
    { ZaapId = 0, MapId = 191105026, MapPos = "5, -18", LocationNameFr = "Cite d'Astrub", LocationNameEn = "Astrub City" },
    { ZaapId = 0, MapId = 120062979, MapPos = "1, -32", LocationNameFr = "Tainela", LocationNameEn = "Tainela" },
}

function zapp.TryMovingTo(mapId)
    worldMove.ToMap(mapId)
    if map.currentMapId() == mapId then
        global:printMessage("[Zaap] moved to zaap at mapId: " .. mapId .. ".")
        return true
    end

    global:printMessage("[Zaap] failed to move to zaap at mapId: " .. mapId .. ".")
    return false
end

function zapp.TryDisoveringAtMap(mapId)
    if zapp.TryMovingTo(mapId) == true then
        local zaapId = map:getNearestZaap(mapId)

        if zaapId ~= 0 then
            global:printMessage("[Zaap] found zaap at mapId: " .. mapId .. " zappId: " .. zaapId .. " saving.")
            map:saveZaap()
            global:delay(math.random(1800, 4000))

            return zaapId
        end

        global:printMessage("[Zaap] failed to locate zaap near mapId: " .. mapId .. ".")
    end

    return 0
end

return zapp
