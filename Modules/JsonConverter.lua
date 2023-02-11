local json = require("Libs.json")

local jsonConverter = {}

function jsonConverter.ToType(data)
    return json.encode(data)
end

function jsonConverter.FromType(data)
    return json.decode(data)
end

return jsonConverter