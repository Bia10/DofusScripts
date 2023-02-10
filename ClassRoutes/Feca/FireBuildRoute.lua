local fireBuildRoute = {}

---------------------------
-- TraningNodeLevel_0_10 --
---------------------------
local function takeRandomBreak()
    local miliseconds = math.random(20000, 120000)
    global.printMessage("Breaking for " .. miliseconds .. " ms.")
    global:delay(miliseconds)
end

fireBuildRoute.GeneralInfo = {
    MinimumLevel = 0,
    MaximumLevel = 10,
    MinimumGroupSize = 0,
    MaximumGroupSize = 0,
    MinimumGroupTotalLevel = 0,
    MaximumGroupTotalLevel = 0,
    CanTrainSolo = true
}

fireBuildRoute.LocationInfo = {
    Area = "Incarnam",
    SubArea = "Incarnam",
    TraversalMode = "Random",
    SyncGroupTraversal = false,
    MapNodes = {
        { MapIdNode = 99999, FightNode = true, MoveNode = "top", },
        { MapIdNode = 99999, FightNode = true, MoveNode = "top" },
        { MapIdNode = 99999, FightNode = true, MoveNode = "top" },
        { MapIdNode = 99999, FightNode = true, CustomFunctionNode = takeRandomBreak }
    }
}

fireBuildRoute.CharacterInfo = {
    MainStat = "Inteligence",
    CombatRole = "Damage",
    AutoTrainStats = true,
    AutoEquipItems = true,
    LevelUpConfig = { AutoGenerateLevelUpNodes = true, LevelStepSize = 1, LevelOnlyMainStatType = true, UseAllAvailiblePoints = true },
    LevelUpNodes = {},
    GearUpConfig = { AutoGenerateGearUpNodes = false, BuyGearIfNotFound = false },
    GearUpNodes = {
        { CharacterLevel = 7,  ItemIdsToEquip = { 8237 } },
        { CharacterLevel = 8,  ItemIdsToEquip = { 8231 } },
        { CharacterLevel = 9,  ItemIdsToEquip = { 8225 } },
        { CharacterLevel = 10, ItemIdsToEquip = { 8219 } },
        { CharacterLevel = 12, ItemIdsToEquip = { 8243 } }
    }
}

fireBuildRoute.ProfessionInfo = {
    BlockMoveToNextRouteNodeIfLevelNotReached = true,
    CraftAfterGatheing = false,
    LevelUpRequirements = {
        { ProffesionId = 34, LevelToReach = 42 }
    },
    CraftNodes = {
        { ItemIdToCraft = 4546, NumberOfTimes = 200, }
    }
}

---------------------------
-- TraningNodeLevel_10_20 --
---------------------------

return fireBuildRoute
