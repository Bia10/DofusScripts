----------------------------------------------
-- Effect instance integer class definition --
----------------------------------------------
local EffectInstanceInteger = {
    EffectUid = 0,
    BaseEffectId = 0,
    EffectId = 0,
    Order = 0,
    TargetId = 0,
    TargetMask = "",
    Duration = 0,
    Random = 0,
    Group = 0,
    VisibleInTooltip = false,
    VisibleInBuffUi = false,
    VisibleInFightLog = false,
    VisibleOnTerrain = false,
    ForClientOnly = false,
    Dispellable = 0,
    RawZone = "",
    Delay = 0,
    Triggers = "",
    EffectElement = 0,
    SpellId = 0
}

----------
-- Ctor --
----------
function EffectInstanceInteger:new(thisObj, effectUid, baseEffectId, effectId, order, targetId,
                            targetMask, duration, random, group, visibleInTooltip, visibleInBuffUi, visibleInFightLog,
                            visibleOnTerrain, forClientOnly, dispellable, rawZone, delay, triggers, effectElement,
                            spellId
)
    thisObj = thisObj or {}
    setmetatable(thisObj, self)
    self.__index = self

    self.EffectUid = effectUid
    self.BaseEffectId = baseEffectId
    self.EffectId = effectId
    self.Order = order
    self.TargetId = targetId
    self.TargetMask = targetMask
    self.Duration = duration
    self.Random = random
    self.Group = group
    self.VisibleInTooltip = visibleInTooltip
    self.VisibleInBuffUi = visibleInBuffUi
    self.VisibleInFightLog = visibleInFightLog
    self.VisibleOnTerrain = visibleOnTerrain
    self.ForClientOnly = forClientOnly
    self.Dispellable = dispellable
    self.RawZone = rawZone
    self.Delay = delay
    self.Triggers = triggers
    self.EffectElement = effectElement
    self.SpellId = spellId

    return thisObj
end

return EffectInstanceInteger