local characterClass = require("Modules.CharacterClass")
local fightEngine = require("Modules.FightEngine")
local fightObserver = require("Modules.FightObserver")

local updateDelay = 300000;

function move()
    if fightEngine.IsFightStart() then
        fightObserver:LoadFightContext()

        local attackersCells = fightObserver:GetAttackersCells()
        local defendersCells = fightObserver:GetDefendersCells()

        prefightManagement(attackersCells, defendersCells)
        fightManagement()
    end

    return {}
end

-- Main function managing pre-fight placement of attackers and defenders
function prefightManagement(attackersCells, defendersCells)
    local FREE_CELL_ENTITY_ID = -1
    local freeAttackerCells = {}
    local occupiedAttackerCells = {}
    local freeDefenderCells = {}
    local occupiedDefenderCells = {}

    global:printSuccess("Scanning placement of attackers: ")
    for cellId, entityId in pairs(attackersCells) do
        global:printMessage("CellId: " .. cellId .. " EntityId: " .. entityId)
        if entityId == FREE_CELL_ENTITY_ID then
            freeAttackerCells.insert(cellId)
        elseif entityId > 1 then
            occupiedAttackerCells.insert(cellId)
        end
    end

    global:printMessage("Scanning placement of defenders: ")
    for cellId, entityId in pairs(defendersCells) do
        global:printMessage("CellId: " .. cellId .. " EntityId: " .. entityId)
        if entityId == FREE_CELL_ENTITY_ID then
            freeDefenderCells.insert(cellId)
        elseif entityId > 1 then
            occupiedDefenderCells.insert(cellId)
        end
    end

    local chosenCellId = fightEngine.ChoseStrartingCell(occupiedAttackerCells)

    fightAction:chooseCell(chosenCellId)
    fightObserver:isTimeToUpdate(updateDelay)
end

-- Main function managing the AI of character wich executes the script
function fightManagement()
    -- Check if i am at turn so logic runs only for my char
    if fightCharacter:isItMyTurn() then
        fightObserver:isTimeToUpdate(updateDelay)
        --------------------------------------------
        -- Before doing actions check positioning --
        --------------------------------------------
        if fightEngine.IsFirstTurn() then
            --fightEngine.CheckOportunitiesForBetterPosition()
        end

        -- TODO: move away from enemy/ally? move closer to enemy/ally?
        -- TODO: move away from dranger (AOE spell, powerfull enemies, to gain range for long range spells)?

        --------------------------------
        -- Action selection algorithm --
        --------------------------------
        -- TODO: basicly should decide what is optimal action to undertake given the fight data context
        -- TODO: given the massive ammount of possible combinations, heuristic guidance only

        --------------------
        -- Basic strategy --
        --------------------
        characterClass.SelectAndExecuteFightStrategy(true)

        --------------------------------------------
        -- After doing actions check positioning --
        --------------------------------------------
        -- TODO: move away from enemy/ally? move closer to enemy/ally?
        -- TODO: move away from dranger (AOE spell, powerfull enemies, to gain range for long range spells)?

        -- When all is done then end turn
        fightAction:passTurn()
        fightObserver:isTimeToUpdate(updateDelay)
    end
end
