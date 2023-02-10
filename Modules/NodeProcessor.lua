local genericDeque = require("Modules.GenericDeque")

local nodeProcessor = {}

local traningNodeDeque
local mapNodesDeque
local characterNodesDeque
local professionNodesDeque

function nodeProcessor:new(mapNodes)
    nodeProcessor = {}
    setmetatable(nodeProcessor, { __index = self })

    self.mapNodesDeque = genericDeque:new()
    self.mapNodesDeque = self.addNodesToDeque(mapNodes, true)

    return nodeProcessor
end

function nodeProcessor:addNodesToDeque(nodePath, toRight)
    if toRight then
        for _, mapNodeValue in pairs(nodePath) do
            self.mapNodesDeque.pushRight(mapNodeValue)
        end
    elseif not toRight then
        for _, mapNodeValue in pairs(nodePath) do
            self.mapNodesDeque.pushLeft(mapNodeValue)
        end
    end
end

function nodeProcessor:processNodes()
    for i = 1, self.mapNodesDeque.length(), 1 do
        self.processNode(self.mapNodesDeque[i])
    end
end

function nodeProcessor:processNode(mapnode)
    -- mapnode
end

return nodeProcessor
