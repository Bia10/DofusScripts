local SpellsModule = require("Constants.Spells")
local CastSpellState = require("Constants.CastSpellState")

function move()
	return {}
end

function fightManagement()
    -- Check if i am at turn so logic runs only for my char
    if (fightCharacter:isItMyTurn() == true) then
            -- Assuming out of range so move towards nearest enemy
            fightAction:moveToWardCell(fightAction:getNearestEnemy())
            -- 3 times launch coin throwing at nearest enemy cellId
            for i = 1, 3 do

                    local myCellId = fightCharacter:getCellId();
                    -- get cellId of nearestEnemy
                    local nearestEnemycellId = fightAction:getNearestEnemy()
                    -- get spellId of Coin Throwing
                    local spellId = SpellsModule.GetSpellIdByName("Coin Throwing", "En")
                    
                    -- Verification if we can cast spell
                    if (fightAction:canCastSpellOnCell(myCellId, spellId, nearestEnemycellId) == CastSpellState.CastingPossible) then
                            -- Cast spell on cellId
                            fightAction:castSpellOnCell(spellId, nearestEnemycellId)
                    end

                    -- if result != 0 then integer is enum of possible failures
            end
            -- End our turn
            fightAction:passTurn()
    end
end