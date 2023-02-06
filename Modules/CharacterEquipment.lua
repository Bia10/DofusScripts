local characterEquipment = {}

characterEquipment.Slots = {
    { SlotIndex = 0, SlotNameEn = "Amulet" },
    { SlotIndex = 1, SlotNameEn = "Weapon" },
    { SlotIndex = 2, SlotNameEn = "Ring Left" },
    { SlotIndex = 3, SlotNameEn = "Belt" },
    { SlotIndex = 4, SlotNameEn = "Ring Right" },
    { SlotIndex = 5, SlotNameEn = "Boots" },
    { SlotIndex = 6, SlotNameEn = "Hat" },
    { SlotIndex = 7, SlotNameEn = "Cape" },
    { SlotIndex = 8, SlotNameEn = "Pet" },
    { SlotIndex = 9, SlotNameEn = "First Dofus Slot" },
    { SlotIndex = 10, SlotNameEn = "Second Dofus Slot" },
    { SlotIndex = 11, SlotNameEn = "Third Dofus Slot" },
    { SlotIndex = 12, SlotNameEn = "Fouth Dofus Slot" },
    { SlotIndex = 13, SlotNameEn = "Fifth Dofus Slot" },
    { SlotIndex = 14, SlotNameEn = "Sixth Dofus Slot" },
    { SlotIndex = 15, SlotNameEn = "Shield" },
    { SlotIndex = 16, SlotNameEn = "Mount" }
}

characterEquipment.ItemType = {
    AMULET = 1,
    BOW = 2,
    WAND = 3,
    STAFF = 4,
    DAGGER = 5,
    SWORD = 6,
    HAMMER = 7,
    SHOVEL = 8,
    RING = 9,
    BELT = 10,
    BOOTS = 11,
    POTION = 12,
    EXPERIENCE_SCROLL = 13,
    ORDER_ABILITY_ITEM = 14,
    MISCELLANEOUS_RESOURCES = 15,
    HAT = 16,
    CLOAK = 17,
    PET = 18,
    AXE = 19,
    TOOL = 20,
    PICKAXE = 21,
    SCYTHE = 22,
    DOFUS = 23,
    MISCELLANEOUS = 24,
    DOCUMENT = 25,
    SMITHMAGIC_POTION = 26,
}

function characterEquipment:SlotNameToIndex(slotName)
    for _, value in pairs(self.Slots) do
        if value.SlotNameEn == slotName then
            return value.SlotIndex
        end
    end
end

function characterEquipment:GetNameFromGid(itemGid)
    return inventory:itemNameId(itemGid)
end

function characterEquipment:HasItem(itemGid)
    return inventory:itemCount(itemGid) > 0
end

function characterEquipment:GetSlotNameFromType(itemGid)
    if inventory:itemTypeId(itemGid) == self.ItemType.BELT then
        for key, _ in pairs(self.Slots) do
            if self.Slots[key].SlotIndex == 3 then
                return self.Slots[key].SlotNameEn
            end
        end
    end
end

function characterEquipment:CanEquip(itemGid, equpmentSlotName)
    local itemLevelRequirement = inventory:itemLevelId(itemGid)
    local playerLevel = character:level()
    --local isEquipmentSlotUsable = self:IsSlotUsable(equpmentSlotName)

    return self:HasItem(itemGid) and playerLevel >= itemLevelRequirement
end

function characterEquipment:EquipIntoSlot(itemGid, equpmentSlotName)
    local equpmentSlotIndex = self:SlotNameToIndex(equpmentSlotName)

    if inventory:equipItem(itemGid, equpmentSlotIndex) == true then
        global:printMessage("[CharacterEquipment] equiped item: " .. itemGid .. " into slot: " .. equpmentSlotName)
        return
    end

    global:printMessage("[CharacterEquipment] failed to equip item: " ..
        itemGid .. " into slot: " .. equpmentSlotName)
end

function characterEquipment:EquipMultipleItems(listOfitemsGid)
    for i = 1, #listOfitemsGid, 1 do
        local curItemGid = listOfitemsGid[i].ItemGid
        local curItemslotName = self:GetSlotNameFromType(curItemGid)

        if self:CanEquip(curItemGid, curItemslotName) then
            self:EquipIntoSlot(curItemGid, curItemslotName)
        end
    end
end

return characterEquipment
