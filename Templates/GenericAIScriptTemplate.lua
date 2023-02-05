local enutrofBasicWaterStrategy = require("Strategies.Enutrof.BasicWaterStrategy")

function move()
    return {}
end

-- example of input data
local attackersCellsExample = {
    { cellId = 0, entityId = 0 }
}

-- Main function managing pre-fight placement of attackers and defenders
function prefightManagement(attackersCells, defendersCells)

    global:printSuccess("Scanning placement of attackers: ")
    for cellId, entityId in pairs(attackersCells) do
        global:printMessage("CellId: " .. cellId .. " EntityId: " .. entityId)
    end

    global:printMessage("Scanning placement of defenders: ")
    for cellId, entityId in pairs(defendersCells) do
        global:printMessage("CellId: " .. cellId .. " EntityId: " .. entityId)
    end

    -- TODO: cell selection logic
    -- fightAction:chooseCell(chosenCellId)
end

-- Main function managing the AI of character wich executes the script
function fightManagement()
    -- Check if i am at turn so logic runs only for my char
    if (fightCharacter:isItMyTurn() == true) then
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

        ---------------------------
        -- Spell cast validation --
        ---------------------------
        -- TODO: 1. calculate how many casts i can do in turn
        -- TODO: 2. check how many times i have casted on same entity
        -- TODO: 3. check other targets to cast on

        --------------------
        -- Basic strategy --
        --------------------
        enutrofBasicWaterStrategy.Execute()

        --------------------------------------------
        -- After doing actions check positioning --
        --------------------------------------------
        -- TODO: move away from enemy/ally? move closer to enemy/ally?
        -- TODO: move away from dranger (AOE spell, powerfull enemies, to gain range for long range spells)?

        -- When all is done then end turn
        fightAction:passTurn()
    end
end
