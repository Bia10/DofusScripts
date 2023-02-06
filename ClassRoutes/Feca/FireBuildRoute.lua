local fireBuildRoute = {}

fireBuildRoute.RouteNodes = {
    { TraningNode = fireBuildRoute.TraningNodeLevel_0_10 },
    { TraningNode = fireBuildRoute.TraningNodeLevel_10_20, }
}

---------------------------
-- TraningNodeLevel_0_10 --
---------------------------
fireBuildRoute.TraningNodeLevel_0_10 = {
    GeneralInfo = fireBuildRoute.TraningNodeLevel_0_10.GeneralInfo,
    LocationInfo = fireBuildRoute.TraningNodeLevel_0_10.LocationInfo,
    CharacterInfo = fireBuildRoute.TraningNodeLevel_0_10.CharacterInfo
}

fireBuildRoute.TraningNodeLevel_0_10.GeneralInfo = {
    MinimumLevel = 0, MaximumLevel = 10,
    MinimumGroupSize = 0, MaximumGroupSize = 0,
    MinimumGroupTotalLevel = 0, MaximumGroupTotalLevel = 0,
    CanTrainSolo = true
}

fireBuildRoute.TraningNodeLevel_0_10.LocationInfo = {
    Area = "Incarnam", SubArea = "Incarnam",
    TraversalMode = "Random", SyncGroupTraversal = false,
    MapNodes = {
        { MapIdNode = 99999, FightNode = true, MoveNode = "top", },
        { MapIdNode = 99999, FightNode = true, MoveNode = "top" },
        { MapIdNode = 99999, FightNode = true, MoveNode = "top" },
        { MapIdNode = 99999, FightNode = true, CustomFunctionNode = fireBuildRoute.takeRandomBreak() },
    },
}

fireBuildRoute.TraningNodeLevel_0_10.CharacterInfo = {
    CombatRole = "Damage", AutoTrainStats = true, AutoEquipItems = true,
    LevelUpNodes = {
        { CharacterLevel = 1, StatType = "Inteligence", PointsToUse = -1 },
        { CharacterLevel = 2, StatType = "Inteligence", PointsToUse = -1 },
        { CharacterLevel = 3, StatType = "Inteligence", PointsToUse = -1 },
        { CharacterLevel = 4, StatType = "Inteligence", PointsToUse = -1 },
        { CharacterLevel = 5, StatType = "Inteligence", PointsToUse = -1 },
        { CharacterLevel = 6, StatType = "Inteligence", PointsToUse = -1 },
        { CharacterLevel = 7, StatType = "Inteligence", PointsToUse = -1 },
        { CharacterLevel = 8, StatType = "Inteligence", PointsToUse = -1 },
        { CharacterLevel = 9, StatType = "Inteligence", PointsToUse = -1 },
        { CharacterLevel = 10, StatType = "Inteligence", PointsToUse = -1 },
    },
    GearUpNodes = {
        { CharacterLevel = 7, ItemIdsToEquip = { 8237 } },
    }
}

-- TODO: professionInfo -- CraftNode

function fireBuildRoute.takeRandomBreak()
    local miliseconds = math.random(20000, 120000)
    global.printMessage("Breaking for " .. miliseconds .. " ms.")
    global:delay(miliseconds)
end

---------------------------
-- TraningNodeLevel_10_20 --
---------------------------
return fireBuildRoute
