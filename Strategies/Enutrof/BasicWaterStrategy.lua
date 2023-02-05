local spell = require("Modules.Spell")

local basicWaterStrategy = {}

function basicWaterStrategy.Execute()
    basicWaterStrategy.SummonLivingBag()
    basicWaterStrategy.CastThrowingCoinsAtNearestEnemy()
end

function basicWaterStrategy.CastThrowingCoinsAtNearestEnemy()
    local spellId = spell.GetIdByName("Coin Throwing", "En")
    local maxCastsPerTurnPerTarget = spell.GetSpellParam(spellId, "CastsPerTurnPerTarget")

    if spell.IsCastable(spellId, maxCastsPerTurnPerTarget) then
        for i = 1, maxCastsPerTurnPerTarget, 1 do
            local myCellId = fightCharacter:getCellId();
            local nearestEnemyCellId = fightAction:getNearestEnemy()

            -- Check range and try casting
            if spell.IsCastableAtTargetCell(spellId, nearestEnemyCellId) then
                spell.TryCastingAtTargetCell(spellId, myCellId, nearestEnemyCellId)
            end

            -- If i have mp left move towards target
            if fightCharacter:getMP() > 0 then
                spell.TryMoveIntoCastRange(spellId, nearestEnemyCellId, true)

                -- Again check range and try casting
                if spell.IsCastableAtTargetCell(spellId, nearestEnemyCellId) then
                    spell.TryCastingAtTargetCell(spellId, myCellId, nearestEnemyCellId)
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
                spell.TryCastingAtTargetCell(spellId, myCellId, adjecentCellIds[i])
            end
        end
    end
end

return basicWaterStrategy
