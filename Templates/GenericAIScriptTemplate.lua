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
            -- Check range and try casting
            if (spell.IsTargetInRange(spellId, nearestEnemycellId)) then
                spell.TryCastingAtCellId(spellId, myCellId, nearestEnemycellId)
            end
            -- If i have mp left move towards target
            if (fightCharacter:getMP() > 0) then
                fightAction:moveToWardCell(nearestEnemycellId)
                -- Again check range and try casting
                if ((spell.IsTargetInRange(spellId, nearestEnemycellId))) then
                    spell.TryCastingAtCellId(spellId, myCellId, nearestEnemycellId)
                end
            end

        end
    end
end