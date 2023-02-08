-- flags actually
local spellTargetType = {
    NONE = 0,
    SELF = 1,
    ALLY_MONSTER_SUMMON = 2,
    ALLY_SUMMON = 4,
    ALLY_NON_MONSTER_SUMMON = 8,
    ALLY_COMPANION = 16,
    ALLY_MONSTER = 32,
    ALLY_SUMMONER = 64,
    ALLY_PLAYER = 128,
    ALLY_ALL_EXCEPT_SELF = 254,
    ALLY_ALL = 255,
    ENEMY_MONSTER_SUMMON = 256,
    ENEMY_SUMMON = 512,
    ENEMY_NON_MONSTER_SUMMON = 1024,
    ENEMY_COMPANION = 2048,
    ENEMY_MONSTER = 4096,
    ENEMY_HUMAN = 8192,
    ENEMY_PLAYER = 16384,
    ENEMY_ALL = 32512,
    ALL = 32767,
    SELF_ONLY = 524288
}

spellTargetType.CodeMap = {
    { Code = "C",              Value = spellTargetType.SELF_ONLY },
    { Code = "c",              Value = spellTargetType.SELF },
    { Code = "s",              Value = spellTargetType.ALLY_MONSTER_SUMMON },
    { Code = "j",              Value = spellTargetType.ALLY_SUMMON },
    { Code = "i",              Value = spellTargetType.ALLY_NON_MONSTER_SUMMON },
    { Code = "d",              Value = spellTargetType.ALLY_COMPANION },
    { Code = "m",              Value = spellTargetType.ALLY_MONSTER },
    { Code = "h",              Value = spellTargetType.ALLY_SUMMONER },
    { Code = "l",              Value = spellTargetType.ALLY_PLAYER },
    { Code = "a",              Value = spellTargetType.ALLY_ALL },
    { Code = "g",              Value = spellTargetType.ALLY_ALL_EXCEPT_SELF },
    { Code = "s",              Value = spellTargetType.ENEMY_MONSTER_SUMMON },
    { Code = "J",              Value = spellTargetType.ENEMY_SUMMON },
    { Code = "I",              Value = spellTargetType.ENEMY_NON_MONSTER_SUMMON },
    { Code = "D",              Value = spellTargetType.ENEMY_COMPANION },
    { Code = "M",              Value = spellTargetType.ENEMY_MONSTER },
    { Code = "H",              Value = spellTargetType.ENEMY_HUMAN },
    { Code = "L",              Value = spellTargetType.ENEMY_PLAYER },
    { Code = "A",              Value = spellTargetType.ENEMY_ALL },
    { Code = { "a,A", "A,a" }, Value = spellTargetType.ALL },
    { Code = "",               Value = spellTargetType.NONE },
}

function spellTargetType.CodeToValue(code)
    for key, _ in pairs(spellTargetType.CodeMap) do
        local currentTuple = spellTargetType.CodeMap[key]

        if #currentTuple.Code == 1 and code == currentTuple.Code then
            return currentTuple.Value
        elseif #currentTuple.Code > 1 and code == currentTuple.Code[1] or code == currentTuple.Code[2] then
            return currentTuple.Value
        end

        -- TODO: other combinations
    end
end

return spellTargetType
