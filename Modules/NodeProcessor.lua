local genericDeque = require("Modules.GenericDeque")

local nodeProcessor = {}

local mapNodesDeque
local characterNodesDeque
--local professionNodesDeque

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

function nodeProcessor:processNodes()
    for i = 1, mapNodesDeque.length(), 1 do
        self:processNode(mapNodesDeque[i])
    end
end

function nodeProcessor:processNode(mapnode)
    -- mapnode
end

return nodeProcessor
