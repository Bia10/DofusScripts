local fightEngine = require("Modules.FightEngine")

local routeProcessor = {}

routeProcessor.RouteNodes = {}
routeProcessor.RouteData = {
    -- replacementNode as table of move options
    { mapNode = "212601864", replacementNode = { "left", "top" } },
    { mapNode = "212601350", replacementNode = { "right", "bottom" } },
    -- with fight node
    { mapNode = "172753417", replacementNode = "right", fightNode = true },
    { mapNode = "172753928", replacementNode = "right", fightNode = true },
    -- with gatherNode
    { mapNode = "172754952", replacementNode = "top", gatherNode = true },
    -- normal replacementNode
    { mapNode = "212601349", replacementNode = "top" },
    -- with replacementNode replaced by customFunctionNode
    { mapNode = "179830787", customFunctionNode = routeProcessor.takeRandomBreak() },
}

function routeProcessor.takeRandomBreak()
    local miliseconds = math.random(20000, 120000)
    global.printMessage("Breaking for " .. miliseconds .. " ms.")
    global:delay(miliseconds)
end

-- Example of execution
-- routeProcessor:Run(routeProcessor.RouteData, true, false)

-- Runs a custom route data processor wich ultimately outputs only basic move data to move() of main script
function routeProcessor:Run(routeDataTable, fightOnMaps, gatherOnMaps)
    local currentMapPos = map.currentPos()
    local currentMapId = tostring(map.currentMapId())
    local routeDataTableRow = nil

    for _, value in pairs(routeDataTable) do
        if value.mapNode == currentMapPos or value.mapNode == currentMapId then
            routeDataTableRow = value
            break
        end
    end

    -- There are no data for given mapId or mapPos
    if not routeDataTableRow then
        global.printMessage("[RouteProcessor] None route data found on mapPos: " ..
            currentMapPos .. " (" .. currentMapId .. ").")
        return self.noneRouteDataTableRow()
    end

    -- ReplacementNodes processing wich can be a table or function type
    if routeDataTableRow.replacementNode then
        if (type(routeDataTableRow.replacementNode) == "table") then
            -- locate my routeNode, is key currentMapId in the set of route nodes?
            if self.RouteNodes[currentMapId] then
                -- change position of my routeNode to next node
                self.RouteNodes[currentMapId] = self.NextRouteNode[currentMapId]
            else -- change position of my routeNode to start
                self.RouteNodes[currentMapId] = 1
            end

            -- is current node value outside lenght of replacementNodes
            if self.RouteNodes[currentMapId] > #routeDataTableRow.replacementNode then
                -- put node of my mapId to start
                self.RouteNodes[currentMapId] = 1
            end

            -- select new replacementNode at position of my routeNode
            local currentRouteNode = self.RouteNodes[currentMapId]
            local newReplacementNode = routeDataTableRow.replacementNode[currentRouteNode]

            -- if its a function type, change node type at routeNode position
            if (type(newReplacementNode) == "function") then
                routeDataTableRow.replacementNode = nil
                routeDataTableRow.customFunctionNode = newReplacementNode
            else
                routeDataTableRow.replacementNode = newReplacementNode
            end
        end
    end

    -- Begin assembling normal move() data
    local normalMoveData
    normalMoveData.map = routeDataTableRow.mapNode
    normalMoveData.path = routeDataTableRow.replacementNode

    -- FightNodes processing which are boolean type
    if (routeDataTableRow.fightNode) then
        if (type(routeDataTableRow.fightNode) == "boolean" and routeDataTableRow.fightNode == true) then
            if (fightOnMaps == true) then
                -- TODO: custom logic
                fightEngine.setForbiddenMonsters(fightEngine.suggestForbiddenMonsters)
                fightEngine.setRequiredMonsters(fightEngine.suggestRequiredMonsters)
                -- Fight will take into consideration the global script params!
                map:fight()
            elseif (fightOnMaps == false) then
                normalMoveData.fight = routeDataTableRow.fightNode
            end
        end
    end

    -- FightNodes processing which are boolean type
    if (routeDataTableRow.gatherNode) then
        if (type(routeDataTableRow.gatherNode) == "boolean" and routeDataTableRow.gatherNode == true) then
            if (gatherOnMaps == true) then
                -- TODO: custom logic
            elseif (gatherOnMaps == false) then
                normalMoveData.gather = routeDataTableRow.gatherNode
            end
        end
    end

    global.printMessage("[RouteProcessor] Generating move() data, map: " ..
        normalMoveData.map .. " path: " .. normalMoveData.path .. " gather: " .. normalMoveData.gather)

    -- Now we done what we wanted time to return basic data back to move() function
    return { normalMoveData }
end

function routeProcessor:ResetRouteNodes()
    self.RouteNodes = {}
end

function routeProcessor:NextRouteNode(nodeIndex)
    return self.RouteNodes[nodeIndex] + 1
end

function routeProcessor:PrevRouteNode(nodeIndex)
    return self.RouteNodes[nodeIndex] - 1
end

function routeProcessor.noneRouteDataTableRow()
    global.printMessage("[RouteProcessor] Nothing to do, nowhere to move ... going into heavenbag.")
    return { { map = map.currentMapId(), havenbag = true }, }
end

return routeProcessor
