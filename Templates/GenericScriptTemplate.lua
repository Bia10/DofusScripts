----------------------
-- Generic settings --
----------------------

-- These script params are global meaning they will be taken into account by calling various API methods,
-- like map:fight() will take into account these script params.

-- Hours of a day during wich bot will be offline from 0 = 0:00 to 23 = 23:59
-- Type: global table of of integers (hours)
PLANNING = { 1, 2, 4 }
-- Items to automatically delete when out of combat
-- Type: global table of of integers (itemIds)
AUTO_DELETE = { 156, 5478, 546, 1221 }
-- Ressources to gather if availible at map
-- Type: global table of of integers (ressourceIds)
GATHER = { 84, 64 }
-- Indication wherever to open or not ressource bags
-- Type: global boolean
OPEN_BAGS = true
-- Indication wherever to ignore or not guild invites
-- Type: global boolean
IGNORE_REQUEST_GUILD = true
-- Indication wherever to ignore or not duel invites
-- Type: global boolean
IGNORE_REQUEST_DUEL = true
-- Indication wherever to ignore or not trade invites
-- Type: global boolean
IGNORE_REQUEST_EXCHANGE = true
-- Minimum number of monsters in mob group to attack it
-- Type: global integer variable
MIN_MONSTERS = 1
-- Maximum number of monsters in mob group to attack it
-- Type: global integer variable
MAX_MONSTERS = 8
-- Required monsters in mob group to attack it
-- Type: global table of integers (mobIds)
FORCE_MONSTERS = { 156 }
-- Forbidden monsters in mob group to never attack it
-- Type: global table of integers (mobIds)
FORBIDDEN_MONSTERS = { 2316, 1756 }

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
        { map = "9856523", path = "top|left|right" },
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

    --TODO: check if all group characters are online and at same map, if so try restarting script
    --TODO: monitor time of launch and if stopped() is called within timeout disconnect as script is not working properly
    -- Reloads script and executes it
    -- global:reloadScript()
    -- Disconnects client from server
    -- global:disconnect()
end
