local genericDeque = require("Modules.GenericDeque")
local fightEngine = require("Modules.FightEngine")
local worldMove = require("Modules.WorldMove")

local nodeProcessor = {}

local mapNodesDeque
local characterNodesDeque
--local professionNodesDeque

local fightOnMaps = false
local traverseMaps = true

function nodeProcessor:new(thisObj, mapNodes, characterInfo)
    thisObj = thisObj or {}
    setmetatable(thisObj, { __index = self })

    mapNodesDeque = genericDeque:new()
    -- add map nodes to right
    self:addNodesToDeque(mapNodesDeque, mapNodes, true)

    characterNodesDeque = genericDeque:new()
    -- add levelUp nodes to right
    self:addNodesToDeque(characterNodesDeque, characterInfo.LevelUpNodes, true)
    -- add gearUp nodes to left
    self:addNodesToDeque(characterNodesDeque, characterInfo.GearUpNodes, false)

    nodeProcessor:processMapNodes(mapNodesDeque)

    return nodeProcessor
end

function nodeProcessor:addNodesToDeque(nodesDeque, mapNodes, toRight)
    if toRight then
        for _, mapNodeValue in pairs(mapNodes) do
            nodesDeque:pushRight(mapNodeValue)
        end
    elseif not toRight then
        for _, mapNodeValue in pairs(mapNodes) do
            nodesDeque:pushLeft(mapNodeValue)
        end
    end
end

function nodeProcessor:getContents()
    local mapNodes = mapNodesDeque:contents()
    local characterNodes = characterNodesDeque:contents()
    --local professionNodes = professionNodesDeque:contents()

    local allNodes = { mapNodes, characterNodes } --professionNodes

    return allNodes
end

function nodeProcessor:processMapNodes(mapNodesDeque)
    local mapNodes = mapNodesDeque:contents()
    local currentMapPos = map.currentPos()
    local currentMapId = tostring(map.currentMapId())
    local currentMapNode = nil
    local reusltMoveData = nil

    -- Locating starting mapNode
    for _, mapNode in pairs(mapNodes) do
        if mapNode.MapIdNode == currentMapPos or mapNode.MapIdNode == currentMapId then
            currentMapNode = mapNode
            break
        end
    end

    -- Starting mapNode is nill or false we cannot continue
    if not currentMapNode then
        global.printMessage("[RouteProcessor] None mapNode found for mapPos: " ..
        currentMapPos .. " (" .. currentMapId .. ").")
        -- TODO: fallback
        -- 1. can i pathfind towards closest map in set of map nodes?
        -- 2. can i traverse towards it?
        -- 3. worldMove towards it
        return self.NoneMapNodeFound()
    end

    if currentMapNode.FightNode then
        self:processFightNode()
    end

    -- mapnode.GatherNode

    if currentMapNode.MoveNode then
        self:processMoveNode(mapNodes, currentMapId)
    end

    -- { MapIdNode = 99999, FightNode = true, MoveNode = "top", }
end

function nodeProcessor:processFightNode()
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

function nodeProcessor:processGatherNode()
end

function nodeProcessor:processMoveNode(mapNodes, currentMapId)
    local currentMapIdNode
    local nextMoveNode

    -- TODO: traversal type
    -- random
    if true then
        currentMapIdNode = mapNodes.MapIdNode[math.random(#mapNodes.MapIdNode)]
    end

    if false then
        -- locate my routeNode, is key currentMapId in the set of route nodes?
        if mapNodes.MapIdNode[currentMapId] then
            -- change position of my routeNode to next node
            mapNodes.MapIdNode[currentMapId] = mapNodes.MapIdNode[currentMapId] + 1
        else -- change position of my routeNode to start
            mapNodes.MapIdNode[currentMapId] = 1
        end

        -- is current node value outside lenght of replacementNodes
        if mapNodes.MapIdNode[currentMapId] > #mapNodes.MoveNode then
            -- put node of my mapId to start
            mapNodes.MapIdNode[currentMapId] = 1
        end

        currentMapIdNode = mapNodes.MapIdNode[currentMapId]
    end

    nextMoveNode = mapNodes.MoveNode[currentMapIdNode]

    -- decode node type
    if type(nextMoveNode) == "function" then
        nextMoveNode.MoveNode = nil
        nextMoveNode.CustomFunctionNode = nextMoveNode
    else
        nextMoveNode.MoveNode = nextMoveNode
    end

    if traverseMaps then
        -- world move to mapId
        worldMove.ToMap(nextMoveNode.MapIdNode)
        -- TODO: map edge move
    end
end

return nodeProcessor
