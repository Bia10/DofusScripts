local characterClass = require("Modules.CharacterClass")

function move()
    return {}
end

-- example of input data
local attackersCellsExample = {
    { cellId = 0, entityId = 0 }
}

local FREE_CELL_ENTITY_ID = -1

-- Main function managing pre-fight placement of attackers and defenders
function prefightManagement(attackersCells, defendersCells)
    local freeAttackerCells = {}
    local freeDefenderCells = {}

    global:printSuccess("Scanning placement of attackers: ")
    for cellId, entityId in pairs(attackersCells) do
        global:printMessage("CellId: " .. cellId .. " EntityId: " .. entityId)
        if entityId == FREE_CELL_ENTITY_ID then
            freeAttackerCells.insert(cellId)
        end
    end

    global:printMessage("Scanning placement of defenders: ")
    for cellId, entityId in pairs(defendersCells) do
        global:printMessage("CellId: " .. cellId .. " EntityId: " .. entityId)
        if entityId == FREE_CELL_ENTITY_ID then
            freeDefenderCells.insert(cellId)
        end
    end

    -- TODO: cell selection logic
    -- TODO: case 1 aoe buffs: search for empty cell wich has adjecent cells ocupied by allies
    -- TODO: case 2 hide supports/ranged behind tankier chars
    -- TODO: case 3 place close ranged attackers near enemy, seek glyph/aoe dmg openings
    -- fightAction:chooseCell(chosenCellId)
end

-- Main function managing the AI of character wich executes the script
function fightManagement()
    -- Check if i am at turn so logic runs only for my char
    if fightCharacter:isItMyTurn() == true then
        --------------------------------------------
        -- Before doing actions check positioning --
        --------------------------------------------
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
    end
end
