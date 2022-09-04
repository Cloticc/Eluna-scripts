local TRIGGER_EVENT_ON_TRIGGER = 24

local zoneBuffs = {
    --{zoneId, buffId, amount, duration},
    --example: Below is an example of a zone buff that gives battleShout in Elwynn Forest and in Westfall Commanding Shout. duration is in miliseconds.
    [12] = {
        {buffId = 47436, amount = 5, duration = 60000}
    },
    [40] = {
        {buffId = 47440, amount = 2, duration = 60000}
    }
}
