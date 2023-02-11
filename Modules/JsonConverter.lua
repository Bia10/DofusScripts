local json = require("Libs.json")
local Bounds = require("DofusTypes.Class.Bounds")
local Area = require("DofusTypes.Class.Area")

local jsonConverter = {}

function jsonConverter.ToType(data)
    local result = json.decode(data)

    -- clearly an area
    if result["superAreaId"] then
        local areaBounds = Bounds:new(nil, result.bounds.x, result.bounds.y, result.bounds.width, result.bounds.height)
        local area = Area:new(nil, result.id, result.nameId, result.superAreaId, result.containHouses,
                result.containPaddocks, areaBounds, result.worldmapId, result.hasWorldMap, result.hasSuggestion)
        return area
    end

    return ""
end

function jsonConverter.FromType(data)
    return json.encode(data)
end

return jsonConverter
