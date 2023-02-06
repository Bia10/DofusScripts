local worldMove = {}

function worldMove.ToMap(mapId, mapX, mapY)
    -- loading next map destination by mapId
    if mapId ~= 0 then
        if map:loadMove(mapId) ~= 0 then
            if map:moveNext() then
                global:printMessage("[WorldMove] found destination of mapId: " .. mapId .. " proceding to move!")
            end
            global:printMessage("[WorldMove] failed to find destination of mapId: " .. mapId .. ".")
        end
    end
    -- loading next map destination by mapX, mapY pos
    if map:loadMove(mapX, mapY) ~= 0 then
        if map:moveNext() then
            global:printMessage("[WorldMove] found destination of mapX: " ..
                mapX .. " mapY: " .. mapY .. " proceding to move!")
        end
        global:printMessage("[WorldMove] failed to find destination of mapX: " .. mapX .. " mapY: " .. mapY .. ".")
    end
end

return worldMove
