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
    local currentMapPos = map.currentPos()
    local currentMapId = tostring(map.currentMapId())
    local currentMapNode = nil
    local reusltMoveData = nil

    -- Locating starting mapNode
    for _, mapNode in pairs(self.CurrentTraningNode.LocationInfo.MapNodes) do
        if mapNode.MapIdNode == currentMapPos or mapNode.MapIdNode == currentMapId then
            currentMapNode = mapNode
            break
        end
    end

    -- Starting mapNode is nill or false we cannot continue
    if not currentMapNode then
        global.printMessage("[RouteProcessor] None mapNode found for mapPos: " ..
            currentMapPos .. " (" .. currentMapId .. ").")

        return self.NoneMapNodeFound()
    end

    reusltMoveData = { { map = currentMapNode.MapIdNode, path = currentMapNode.MoveNode,
        fight = currentMapNode.FightNode, gather = currentMapNode.GatherNode }, }

    -- GatherNodes processing which are boolean type
    if currentMapNode.GatherNode and type(currentMapNode.GatherNode) == "boolean" then
        if gatherOnMaps then
            -- TODO: custom logic
        elseif not gatherOnMaps then
            reusltMoveData.gather = false
        end
    end

    -- FightNodes processing which are boolean type
    if currentMapNode.FightNode and type(currentMapNode.FightNode) == "boolean" then
        if fightOnMaps and not global:maximumNumberFightsOfDay() then
            -- TODO: custom logic
            local suggestedForbiddenMobs = fightEngine.suggestForbiddenMonsters()
            local suggestedRequiredMobs = fightEngine.suggestRequiredMonsters()

            fightEngine.setForbiddenMonsters(suggestedForbiddenMobs)
            fightEngine.setRequiredMonsters(suggestedRequiredMobs)
            -- Fight will take into consideration the global script params!
            map:fight()
        elseif not fightOnMaps then
            reusltMoveData.fight = false
        end
    end

    -- MoveNodes processing
    -- TODO: moveNode types and processing
    if currentMapNode.MoveNode and type(currentMapNode.MoveNode) == "table" then
        --     -- locate my routeNode, is key currentMapId in the set of route nodes?
        --     if self.CurrentTraningNode.MapIdNode[currentMapId] then
        --         -- change position of my routeNode to next node
        --         self.CurrentTraningNode[currentMapId] = classRouteProcessor.NextRouteNode[currentMapId]
        --     else -- change position of my routeNode to start
        --         self.CurrentTraningNode[currentMapId] = 1
        --     end
    end

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

    reusltMoveData.map = currentMapNode.MapIdNode
    reusltMoveData.path = currentMapNode.MoveNode

    global.printMessage("[RouteProcessor] Generating move() data," ..
        " map: " .. reusltMoveData.map .. " path: " .. reusltMoveData.path ..
        " gather: " .. reusltMoveData.gather .. "fight: " .. reusltMoveData.fight)

    -- Now we done what we wanted time to return basic data back to move() function
    return reusltMoveData
end

function classRouteProcessor:ProcessCharacterInfo(currentCharLevel)
    local characterInfo = self.CurrentTraningNode.CharacterInfo

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
                characterEquipment.EquipMultipleItems(gearUpNode.ItemIdsToEquip)
            end
        end
    end
end

function classRouteProcessor:SelectSuitableTraningNode(classRoute, currentCharLevel)
    local trainingNodeCount = #classRoute.TraningNode

    if trainingNodeCount == 1 then
        self.CurrentTraningNode = classRoute.TraningNode
    elseif trainingNodeCount > 1 then
        for i = 1, trainingNodeCount, 1 do
            local currentTrainingNode = classRoute.TraningNode[i]
            if not ValidaceTraningNodeRequirements(currentTrainingNode, currentCharLevel) then
                classRoute.remove(currentTrainingNode)
            end
        end

        -- first because incompatible traningNodes are removed
        self.CurrentTraningNode = classRoute.TraningNode
    end

    -- first by default
    self.CurrentTraningNode = classRoute.TraningNode
end

function ValidaceTraningNodeRequirements(currentTrainingNode, currentCharLevel)
    local routeGeneralInfo = currentTrainingNode.GeneralInfo

    -- level range validation
    if currentCharLevel < routeGeneralInfo.MinimumLevel or currentCharLevel > routeGeneralInfo.MaximumLevel then
        return false
    end

    -- TODO: group param validation
    -- TODO: solo vs group validation

    return true
end

function classRouteProcessor:Run(classRoute, gatherOnMaps, fightOnMaps, traverseMaps)
    local currentCharLevel = character:level()

    self:SelectSuitableTraningNode(classRoute, currentCharLevel)

    if self.CurrentTraningNode then
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
