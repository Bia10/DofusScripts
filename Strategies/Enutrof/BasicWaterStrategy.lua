local spell = require("Modules.Spell")

local basicWaterStrategy = {}

function basicWaterStrategy.Execute()
    basicWaterStrategy.SummonLivingBag()
    basicWaterStrategy.CastThrowingCoinsAtNearestEnemy(3)
end

function basicWaterStrategy.CastThrowingCoinsAtNearestEnemy(numberOfTimes)
    local spellId = spell.GetIdByName("Coin Throwing", "En")

    if spell.HasApToCast(spellId, numberOfTimes) then
        for i = 1, numberOfTimes do
            local myCellId = fightCharacter:getCellId();
            local nearestEnemycellId = fightAction:getNearestEnemy()

            -- Check range and try casting
            if spell.IsTargetInRange(spellId, nearestEnemycellId) then
                spell.TryCastingAtCellId(spellId, myCellId, nearestEnemycellId)
            end

            -- If i have mp left move towards target
            if fightCharacter:getMP() > 0 then
                fightAction:moveToWardCell(nearestEnemycellId)

                -- Again check range and try casting
                if spell.IsTargetInRange(spellId, nearestEnemycellId) then
                    spell.TryCastingAtCellId(spellId, myCellId, nearestEnemycellId)
                end
            end
        end
    end
end

function basicWaterStrategy.SummonLivingBag()
    local spellId = spell.GetIdByName("Living Bag", "En")

    if spell.HasApToCast(spellId, 1) and spell.CanCastThisTurn(spellId) then
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
