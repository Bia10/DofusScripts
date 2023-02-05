local routeProcessor = {}

routeProcessor.Nodes = {}
routeProcessor.RouteData = {
    -- replacementNode as table of move options
    { mapNode = "212601864", replacementNode = {"left", "top"} },
    { mapNode = "212601350", replacementNode = {"right", "bottom"} },
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
    global.printMessage("Breaking for " ..miliseconds.. " ms.")
    global:delay(miliseconds)
end

-- Example of execution
-- routeProcessor:Run(routeProcessor.RouteData)

-- Runs a custom route data processor wich ultimately outputs only basic move data to move() of main script
function routeProcessor:Run(routeDataTable)
    local currentMapPos = map.currentPos()
    local currentMapId = tostring(map.currentMapId())

    local routeDataTableRow = nil
    for _, value in pairs(routeDataTable) do
        if value.mapNode == currentMapPos or value.mapNode == currentMapId then
            routeDataTableRow = value
            break
        end
    end

    -- There is no defined mapAction for given mapId or mapPos
    if not routeDataTableRow then
        global.printMessage("[RouteProcessor] None route data found on mapPos: " ..currentMapPos.. " (" ..currentMapId.. ").")
        return self.noneRouteDataTableRow()
    end

    -- ReplacementNodes processing wich can be a table or function type
    if routeDataTableRow.replacementNode then
        if (type(routeDataTableRow.replacementNode) == "table") then
            if self.Nodes[currentMapId] then
                self.Nodes[currentMapId] = self.Nodes[currentMapId] + 1
            else
                self.Nodes[currentMapId] = 1
            end

            if self.Nodes[currentMapId] > #routeDataTableRow.replacementNode then
                self.Nodes[currentMapId] = 1
            end

            local newNode = routeDataTableRow.replacementNode[self.Nodes[currentMapId]]

            if (type(newNode) == "function") then
                routeDataTableRow.replacementNode = nil
                routeDataTableRow.customFunctionNode = newNode
            else
                routeDataTableRow.replacementNode = newNode
            end
        end
    end

    -- FightNodes processing which are boolean type
    if (routeDataTableRow.fightNode) then
        if (type(routeDataTableRow.fightNode) == "boolean" and routeDataTableRow.fightNode == true) then
            -- TODO: custom logic
            map:fight()
        end
    end

    -- Now we done what we wanted time to return basic data back to move() function
    local normalMoveData
    normalMoveData.map = routeDataTableRow.mapNode
    normalMoveData.path = routeDataTableRow.replacementNode

    -- FightNodes processing which are boolean type
    if (routeDataTableRow.gatherNode) then
        if (type(routeDataTableRow.gatherNode) == "boolean" and routeDataTableRow.gatherNode == true) then
            -- TODO: custom logic
            normalMoveData.gather = routeDataTableRow.gatherNode
        end
    end

	global.printMessage("[RouteProcessor] Generating move() data, map: " ..normalMoveData.map.. " path: " ..normalMoveData.path)

    return { normalMoveData }
end

function routeProcessor:ResetNodes()
    self.Nodes = {}
end

function routeProcessor.noneRouteDataTableRow()
	global.printMessage("[RouteProcessor] Nothing to do, nowhere to move ... going into heavenbag.")

    return {
        { map = map.currentMapId(), havenbag = true },
    }
end

return routeProcessor