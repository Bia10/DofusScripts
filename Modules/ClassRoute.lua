local utils = require("Modules.Utils")
local nodeProcessor = require("Modules.NodeProcessor")

local classRoute = {}

local currentnodeProcessor
local currentRoute

function classRoute.initialize(route)
    currentRoute = route

    classRoute.processRoute(currentRoute)

    local mapNodes = route.LocationInfo.MapNodes
    local characterInfo = route.CharacterInfo

    currentnodeProcessor = nodeProcessor:new(nil, mapNodes, characterInfo)
end

function classRoute.printContent()
    local allNodes = nodeProcessor:getContents()

    utils.tablePrint(allNodes)
end

function classRoute.processRoute(route)
    local generalInfo = route.GeneralInfo
    local characterInfo = route.CharacterInfo
    --local charLevel = character:level()

    -- if charLevel < generalInfo.MinimumLevel or charLevel > generalInfo.MaximumLevel then
    --     global:printError("[ClassRoute] Outside level requirements for class route charLevel: " ..
    --     charLevel .. " reqMinLvL: " .. generalInfo.MinimumLevel .. " reqMaxLvL: " .. generalInfo.MaximumLevel)
    --     global:disconnect()
    -- end

    if characterInfo.LevelUpConfig.AutoGenerateLevelUpNodes then
        classRoute.generateLevelUpNodes(generalInfo, characterInfo)
    end

    -- isSolo? canTrainSolo check
    -- isGroup? groupReqCheck
end

function classRoute.generateLevelUpNodes(generalInfo, characterInfo)
    local currentLevelUpNode = { CharacterLevel = 0, StatType = "", PointsToUse = -1 }

    for i = generalInfo.MinimumLevel, generalInfo.MaximumLevel, characterInfo.LevelUpConfig.LevelStepSize do
        currentLevelUpNode.CharacterLevel = i

        if characterInfo.LevelUpConfig.LevelOnlyMainStatType then
            currentLevelUpNode.StatType = characterInfo.MainStat
        end

        if characterInfo.LevelUpConfig.UseAllAvailiblePoints then
            currentLevelUpNode.PointsToUse = -1
        end

        table.insert(characterInfo.LevelUpNodes, currentLevelUpNode)
    
        currentLevelUpNode = { CharacterLevel = 0, StatType = "", PointsToUse = -1 }
    end
end

return classRoute
