local spell = require("Modules.Spell")

function move()
	return {}
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

            -- Assuming out of range so move towards nearest enemy
            fightAction:moveToWardCell(fightAction:getNearestEnemy())

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
            BasicWaterEnuStrategy()
    
            --------------------------------------------
            -- After doing actions check positioning --
            --------------------------------------------
            -- TODO: move away from enemy/ally? move closer to enemy/ally?
            -- TODO: move away from dranger (AOE spell, powerfull enemies, to gain range for long range spells)?   

            -- When all is done then end turn
            fightAction:passTurn()
    end
end

function BasicWaterEnuStrategy()
    CastThrowingCoinsAtNearestEnemy(3)
end

function CastThrowingCoinsAtNearestEnemy(numberOfTimes)
    -- Get spellId of Coin Throwing
    local spellId = spell.GetIdByName("Coin Throwing", "En")
    
    if (spell.HasApToCast(spellId, numberOfTimes)) then
        for i = 1, numberOfTimes do
            -- Get my cellId
            local myCellId = fightCharacter:getCellId();
            -- Get cellId of nearestEnemy
            local nearestEnemycellId = fightAction:getNearestEnemy()
            -- Verification if we can cast spell on given cellId, result is a enum defined in spell.CastOnCellState
            local spellCastOnCellState = fightAction:canCastSpellOnCell(myCellId, spellId, nearestEnemycellId)
            -- Convert reason int value to string
            local spellCastOnCellStateStr = spell.CastOnCellStateToString(spellCastOnCellState)

            -- Its not possble to cast given spellId at given cellId for a reason
            if (spellCastOnCellState ~= spell.CastOnCellState.CASTING_POSSIBLE) then
                global:printError("Its not possible to cast: " ..spellId.. " on cellId: " ..myCellId.. " reason: " ..spellCastOnCellStateStr)
                ---------------------------------------------
                -- Spell cast on cellId failure processing --
                ---------------------------------------------
                -- TODO: collect data, what is the reason of failure?
                -- TODO: is possible to fix the reason of failure?
            end

            -- Casting possible then cast spell on cellId
            fightAction:castSpellOnCell(spellId, nearestEnemycellId)
        end
    end
end