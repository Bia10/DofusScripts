----------------------------------
-- Spell level class definition --
----------------------------------
local SpellLevel = {
    Id = 0,
    SpellId = 0,
    Grade = 0,
    SpellBread = 0,
    ApCost = 0,
    MinRange = 0,
    MaxRange = 0,
    CastInLine = false,
    CastInDiagonal = false,
    CastTestLos = false,
    criticalHitProbability = 0,
    NeedFreeCell = false,
    NeedTakenCell = false,
    NeedVisibleEntity = false,
    NeedCellWithoutPortal = false,
    PortalProjectionForbidden = false,
    NeedFreeTrapCell = false,
    RangeCanBeBoosted = false,
    MaxStack = 0,
    MaxCastPerTurn = 0,
    MaxCastPerTarget = 0,
    MinCastInterval = 0,
    InitialCooldown = 0,
    GlobalCooldown = 0,
    MinPlayerLevel = 0,
    HideEffects = false,
    Hidden = false,
    PlayAnimation = false,
    StatesCriterion = "",
    Effects = {},
    CriticalEffects = {},
    PreviewZones = {}
}

----------
-- Ctor --
----------
function SpellLevel:new(thisObj, id, spellId, grade, spellBreed, apCost, minRange, maxRange, castInline, castInDiagonal,
                        castTestLos, criticalHitProbability, needFreeCell, needTakenCell, needVisibleEntity,
                        needCellWithoutPortal, portalProjectionForbidden, needFreeTrapCell, rangeCanBeBoosted, maxStack,
                        maxCastPerTurn, maxCastPerTarget, minCastInterval, initialCooldown, globalCooldown,
                        minPlayerLevel, hideEffects, hidden, playAnimation, statesCriterion, effects, criticalEffects,
                        previewZones
)
    thisObj = thisObj or {}
    setmetatable(thisObj, self)
    self.__index = self

    self.Id = id
    self.SpellId = spellId
    self.Grade = grade
    self.SpellBread = spellBreed
    self.ApCost = apCost
    self.MinRange = minRange
    self.MaxRange = maxRange
    self.CastInLine = castInline
    self.CastInDiagonal = castInDiagonal
    self.CastTestLos = castTestLos
    self.CriticalHitProbability = criticalHitProbability
    self.NeedFreeCell = needFreeCell
    self.NeedTakenCell = needTakenCell
    self.NeedVisibleEntity = needVisibleEntity
    self.NeedCellWithoutPortal = needCellWithoutPortal
    self.PortalProjectionForbidden = portalProjectionForbidden
    self.NeedFreeTrapCell = needFreeTrapCell
    self.RangeCanBeBoosted = rangeCanBeBoosted
    self.MaxStack = maxStack
    self.MaxCastPerTurn = maxCastPerTurn
    self.MaxCastPerTarget = maxCastPerTarget
    self.MinCastInterval = minCastInterval
    self.InitialCooldown = initialCooldown
    self.GlobalCooldown = globalCooldown
    self.MinPlayerLevel = minPlayerLevel
    self.HideEffects = hideEffects
    self.Hidden = hidden
    self.PlayAnimation = playAnimation
    self.StatesCriterion = statesCriterion
    self.Effects = effects
    self.CriticalEffects = criticalEffects
    self.PreviewZones = previewZones

    return thisObj
end

return SpellLevel
