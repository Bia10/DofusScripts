local spell = require("Modules.Spell")

local basicWaterStrategy = {}

function basicWaterStrategy.Execute()
    basicWaterStrategy.SummonLivingBag()
    basicWaterStrategy.CastThrowingCoinsAtNearestEnemy(3)
end

function basicWaterStrategy.CastThrowingCoinsAtNearestEnemy(numberOfTimes)
    local spellId = spell.GetIdByName("Coin Throwing", "En")

    if spell.IsCastable(spellId) then
        for i = 1, numberOfTimes do
            local myCellId = fightCharacter:getCellId();
            local nearestEnemyCellId = fightAction:getNearestEnemy()

            -- Check range and try casting
            if spell.IsTargetInRange(spellId, nearestEnemyCellId) then
                spell.TryCastingAtCellId(spellId, myCellId, nearestEnemyCellId)
            end

            -- If i have mp left move towards target
            if fightCharacter:getMP() > 0 then
                spell.TryMoveIntoCastRange(spellId, nearestEnemyCellId)

                -- Again check range and try casting
                if spell.IsTargetInRange(spellId, nearestEnemyCellId) then
                    spell.TryCastingAtCellId(spellId, myCellId, nearestEnemyCellId)
                end
            end
        end
    end
end

function basicWaterStrategy.SummonLivingBag()
    local spellId = spell.GetIdByName("Living Bag", "En")

    if spell.IsCastable(spellId) then
        local myCellId = fightCharacter:getCellId();
        local adjecentCellIds = fightAction:getAdjacentCells(myCellId)

        -- Check cells around my cell if its empty summon living bag
        for i = 1, #adjecentCellIds, 1 do
            if fightAction:isFreeCell(adjecentCellIds[i]) then
                spell.TryCastingAtCellId(spellId, myCellId, adjecentCellIds[i])
            end
        end
    end
end

return basicWaterStrategy
