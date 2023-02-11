local utils = require("Modules.Utils")
local SpellClass = require("DofusTypes.Class.SpellLevel")
local fireBuildRoute = require("ClassRoutes.Feca.FireBuildRoute")
local classRoute = require("Modules.ClassRoute")

Main = {}

-- local jsontest = {}

-- local result = utils.decodeToClass(jsontest)

-- utils.tablePrint(result, 2)

-- local newSpell = SpellClass:new(nil, result["id"], result["spellId"], result["grade"], result["spellBread"],
--         result["apCost"], result["minRange"], result["maxRange"], result["castInLine"], result["castInDiagonal"],
--         result["castTestLos"], result["criticalHitProbability"], result["needFreeCell"], result["needTakenCell"],
--         result["needVisibleEntity"], result["needCellWithoutPortal"], result["portalProjectionForbidden"],
--         result["needFreeTrapCell"], result["rangeCanBeBoosted"], result["maxStack"], result["maxCastPerTurn"],
--         result["maxCastPerTarget"], result["minCastInterval"], result["initialCooldown"], result["globalCooldown"],
--         result["minPlayerLevel"], result["hideEffects"], result["hidden"], result["playAnimation"], nil, nil, nil,
--         nil
--     )

classRoute.initialize(fireBuildRoute)
classRoute.printContent()

return Main
