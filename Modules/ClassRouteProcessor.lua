local characterStats = require("Modules.CharacterStats")
local characterEquipment = require("Modules.CharacterEquipment")
local fightEngine = require("Modules.FightEngine")
local worldMove = require("Modules.WorldMove")
--local fireBuildRoute = require("classRoutes.Feca.FireBuildRoute")

local classRouteProcessor = {}

classRouteProcessor.CurrentTraningNode = {}
classRouteProcessor.ClassRouteNodes = {}

-- classRouteProcessor:Run(fireBuildRoute, false, true, true)

function classRouteProcessor:ProcessLocationInfo(gatherOnMaps, fightOnMaps, traverseMaps)
    local locationInfo = self.CurrentTraningNode.LocationInfo
    local currentMapPos = map.currentPos()
    local currentMapId = tostring(map.currentMapId())
    local currentMapNode = nil
    local reusltMoveData = { { map = currentMapNode.MapIdNode, path = currentMapNode.MoveNode,
        fight = currentMapNode.FightNode, gather = currentMapNode.GatherNode }, }

    -- Locating starting mapNode
    for _, mapNode in pairs(locationInfo.MapNodes) do
        if mapNode.MapIdNode == currentMapPos or mapNode.MapIdNode == currentMapId then
            currentMapNode = mapNode
            break
        end
    end

    -- Starting mapNode je nill we cannot continue
    if not currentMapNode then
        global.printMessage("[RouteProcessor] None mapNode found for mapPos: " ..
            currentMapPos .. " (" .. currentMapId .. ").")

        return self.NoneMapNodeFound()
    end

    -- GatherNodes processing which are boolean type
    if currentMapNode.GatherNode then
        if type(currentMapNode.GatherNode) == "boolean" and currentMapNode.GatherNode == true then
            if gatherOnMaps == true then
                -- TODO: custom logic
            elseif gatherOnMaps == false then
                reusltMoveData.gather = currentMapNode.GatherNode
            end
        end
    end

    -- FightNodes processing which are boolean type
    if currentMapNode.FightNode then
        if type(currentMapNode.FightNode) == "boolean" and currentMapNode.FightNode == true then
            if fightOnMaps == true and global:maximumNumberFightsOfDay() == false then
                -- TODO: custom logic
                fightEngine.setForbiddenMonsters(fightEngine.suggestForbiddenMonsters())
                fightEngine.setRequiredMonsters(fightEngine.suggestRequiredMonsters())
                -- Fight will take into consideration the global script params!
                map:fight()
            elseif fightOnMaps == false then
                reusltMoveData.fight = currentMapNode.FightNode
            end
        end
    end

    -- MoveNodes processing
    if currentMapNode.MoveNode then
        -- TODO: moveNode types and processing

        -- if type(currentMapNode.MoveNode) == "table" then
        --     -- locate my routeNode, is key currentMapId in the set of route nodes?
        --     if self.CurrentTraningNode.MapIdNode[currentMapId] then
        --         -- change position of my routeNode to next node
        --         self.CurrentTraningNode[currentMapId] = classRouteProcessor.NextRouteNode[currentMapId]
        --     else -- change position of my routeNode to start
        --         self.CurrentTraningNode[currentMapId] = 1
        --     end

        --     -- is current node value outside lenght of replacementNodes
        --     if self.ClassRouteNodes[currentMapId] > #currentMapNode.MoveNode then
        --         -- put node of my mapId to start
        --         self.ClassRouteNodes[currentMapId] = 1
        --     end

        --     -- select new replacementNode at position of my routeNode
        --     local CurrentTraningNodeNode = self.ClassRouteNodes[currentMapId]
        --     local currentMapIdNode = currentMapNode.MapIdNode[CurrentTraningNodeNode]
        --     local newMoveNode = currentMapNode.MoveNode[CurrentTraningNodeNode]

        --     -- if its a function type, change node type at routeNode position
        --     if type(newMoveNode) == "function" then
        --         currentMapNode.MoveNode = nil
        --         currentMapNode.CustomFunctionNode = newMoveNode
        --     else
        --         currentMapNode.MoveNode = newMoveNode
        --         if traverseMaps == true then
        --             worldMove.ToMap(tonumber(currentMapIdNode))
        --         end
        --     end
        -- end
    end

    reusltMoveData.map = currentMapNode.MapIdNode
    reusltMoveData.path = currentMapNode.MoveNode

    global.printMessage("[RouteProcessor] Generating move() data," ..
        " map: " .. reusltMoveData.map .. " path: " .. reusltMoveData.path ..
        " gather: " .. reusltMoveData.gather .. "fight: " .. reusltMoveData.fight)

    -- Now we done what we wanted time to return basic data back to move() function
    return
end

function classRouteProcessor:ProcessCharacterInfo(currentCharLevel)
    local characterInfo = self.TraningNode.CharacterInfo

    if characterInfo.AutoTrainStats then
        for _, levelUpNode in pairs(characterInfo.LevelUpNodes) do
            if levelUpNode.CharacterLevel == currentCharLevel then
                local pointsToUse = levelUpNode.PointsToUse

                -- code for all points
                if pointsToUse == -1 then
                    pointsToUse = character:statsPoint()
                end

                characterStats.Upgrade(levelUpNode.StatType, pointsToUse)
            end
        end
    end

    if characterInfo.AutoEquipItems then
        for _, gearUpNode in pairs(characterInfo.GearUpNodes) do
            if gearUpNode.CharacterLevel == currentCharLevel then
                -- TODO: dict is not needed eqSlot is inferable from itemTypeEnum
                characterEquipment.EquipMultipleItems(gearUpNode.ItemIdsToEquip)
            end
        end
    end
end

function classRouteProcessor.SelectSuitableTraningNode(classRoute, currentCharLevel)
    local trainingNodeCount = #classRoute.TraningNode

    if trainingNodeCount == 1 then
        classRouteProcessor.CurrentTraningNode = classRoute.TraningNode
    elseif trainingNodeCount > 1 then
        for i = 1, trainingNodeCount, 1 do
            local generalInfo = classRoute.TraningNode[i].GeneralInfo

            if currentCharLevel < generalInfo.MinimumLevel or currentCharLevel > generalInfo.MaximumLevel then
                classRoute.remove(classRoute.TraningNode[i])
            end

            -- TODO: group param validation
            -- TODO: solo vs group validation
        end

        -- first because incompatible traningNodes are removed
        classRouteProcessor.CurrentTraningNode = classRoute.TraningNode
    end

    -- first by default
    classRouteProcessor.CurrentTraningNode = classRoute.TraningNode
end

function classRouteProcessor:Run(classRoute, gatherOnMaps, fightOnMaps, traverseMaps)
    local currentCharLevel = character:level()

    classRouteProcessor.SelectSuitableTraningNode(classRoute, currentCharLevel)

    if self.CurrentTraningNode ~= nil then
        self:ProcessCharacterInfo(currentCharLevel)
        self:ProcessLocationInfo(gatherOnMaps, fightOnMaps, traverseMaps)
    end
end

function classRouteProcessor:ResetClassRouteNodes()
    self.ClassRouteNodes = {}
end

function classRouteProcessor:NextClassRouteNode(nodeIndex)
    return self.ClassRouteNodes[nodeIndex] + 1
end

function classRouteProcessor:PrevClassRouteNode(nodeIndex)
    return self.ClassRouteNodes[nodeIndex] - 1
end

function classRouteProcessor.NoneMapNodeFound()
    global.printMessage("[RouteProcessor] Nothing to do, nowhere to move ... going into havenbag.")

    return { { map = map.currentMapId(), havenbag = true }, }
end

return classRouteProcessor
