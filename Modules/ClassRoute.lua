local utils = require("Modules.Utils")
local genericDeque = require("Modules.GenericDeque")
local NodeProcessor= require("Modules.NodeProcessor")

local classRoute = {}
local mapNodesDeque = {}

function classRoute.Initialize(currentRouteNodes)
    local mapNodes = currentRouteNodes.LocationInfo.MapNodes

    local nodeProcessor = NodeProcessor:new(mapNodes)

    for nodeIndex, nodeData in pairs(mapNodes) do
        mapNodesDeque:pushRight(nodeData)
    end
end

function classRoute.PrintContent()
    local mapNodes = mapNodesDeque:contents()
    utils.tablePrint(mapNodes)
end

function classRoute.ProcessTraningRoute(trainingNode)
    local generalInfo = trainingNode.GeneralInfo
    local characterInfo = trainingNode.CharacterInfo

    if characterInfo.LevelUpConfig.AutoGenerateLevelUpNodes and utils.IsTableEmpty(characterInfo.LevelUpNodesthen) then
        characterInfo.LevelUpNodes = classRoute.generateLevelUpNodes(generalInfo, characterInfo)
    end
end

function classRoute.GenerateLevelUpNodes(generalInfo, characterInfo)
    local currentLevelUpNode = { CharacterLevel = {}, StatType = {}, PointsToUse = {} }

    for i = generalInfo.MinimumLevel, generalInfo.MaximumLevel, characterInfo.levelUpConfig.LevelStepSize do
        currentLevelUpNode.CharacterLevel.insert(i)
    end

    if characterInfo.levelUpConfig.LevelOnlyMainStatType then
        currentLevelUpNode.StatType.insert(characterInfo.MainStat)
    end

    if characterInfo.levelUpConfig.UseAllAvailiblePoints then
        currentLevelUpNode.PointsToUse.insert( -1)
    end

    return currentLevelUpNode
end

return classRoute
