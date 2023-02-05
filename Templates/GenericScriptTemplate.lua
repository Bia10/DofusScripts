----------------------
-- Generic settings --
----------------------

-- Items to automatically delete when out of combat
-- Type: global table of of integers (itemIds)
AUTO_DELETE = {}
-- Ressources to gather if availible at map
-- Type: global table of of integers (ressourceIds)
GATHER = {}
-- Minimum number of monsters in mob group to attack it
-- Type: global integer variable
MIN_MONSTERS = 1
-- Maximum number of monsters in mob group to attack it
-- Type: global integer variable
MAX_MONSTERS = 8
-- Required monsters in mob group to attack it
-- Type: global table of integers (mobIds)
FORCE_MONSTERS = {}
-- Forbidden monsters in mob group to never attack it
-- Type: global table of integers (mobIds)
FORBIDDEN_MONSTERS = {}

--------------------
-- Main Functions --
--------------------

-- This executes only when below banking % of pods or when banking disabled
function move()
    return {
        -- map defined by mapX, mapY pos, path to change to next map by top edge of map box
        { map = "4,-19", path = "top" },
        -- map defined by mapX, mapY pos, path to change map specifies map box edge and also concrete cellId to use
        { map = "0,0", path = "left(364)" },
        -- map defined by mapId, path defined by combination of possible paths results in a randomized selection of one result
        { map = "9856523", path = "top|left|right"},
    }
end

-- This executes only when above % of pods set to bank or when returning from bank to fight area
function bank()
    return {
        -- normal move
        { map = "5,-16", path = "left" },
        -- map defined by mapId, interact with banker and deposit all, exit bank via cellId
        { map = "9856523", npcBank = true, path = "406" },
    }
end

-- This executes only when in ghost mode
function phenix()
    return {
        { map = "-3,-12", path = "right" },
        -- map defines by by X, Y pos, door action demands interaction with object of objId
        { map = "4,-20", door = "254" },
    }
end

-- This executes if script abnormaly terminates (crash, disconnect etc...)
function stopped()
    global:printError("Warning script terminated!")
    -- Reloads script and executes it
    -- global:reloadScript()
    -- Disconnects client from server
    -- global:disconnect()
end