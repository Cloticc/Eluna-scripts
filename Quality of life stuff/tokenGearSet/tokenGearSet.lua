
--[[
This won't do anything without Items in the itemIdsForToken table. So make a Token with stoneharrys spelleditor and add dummy use effect for the spell. Could probably use random item such as the tokens in game already have not tried this yet.


Add item's to tierLevelList exp tierLevel60={[equipmentIDChar] = {[TalentId] = itemId, [TalentId] = itemId, [TalentId] = itemId},}
tierLevel60={[HEAD] = {[1] = 123, [2] = nil, [3] = nil},}




 ]]



 local ITEM_EVENT_ON_REMOVE = 5
 local PLAYER_EVENT_ON_CHAT = 18 -- for my own use to add boxes

 local CLASS_WARRIOR = 1
 local CLASS_PALADIN = 2
 local CLASS_HUNTER = 3
 local CLASS_ROGUE = 4
 local CLASS_PRIEST = 5
 local CLASS_DEATH_KNIGHT = 6
 local CLASS_SHAMAN = 7
 local CLASS_MAGE = 8
 local CLASS_WARLOCK = 9
 local CLASS_DRUID = 11


 local HEAD = 1
 local NECK = 2
 local SHOULDER = 3
 local SHIRT = 4
 local CHEST = 5
 local BELT = 6
 local LEGS = 7
 local FEET = 8
 local WRIST = 9
 local GLOVES = 10
 local FINGER1 = 11
 local FINGER2 = 12
 local TRINKET1 = 13
 local TRINKET2 = 14
 local BACK = 15
 local MAINHAND = 16
 local OFFHAND = 17
 local RANGED = 18
 local TABARD = 19

 local itemIdsForToken = {
     [1] = {
         [56812] = {HEAD},
         [56813] = {SHOULDER},
         [56814] = {CHEST},
         [56815] = {GLOVES},
         [56816] = {LEGS}
     },
     [2] = {
         [56817] = {HEAD},
         [56818] = {SHOULDER},
         [56819] = {CHEST},
         [56820] = {GLOVES},
         [56821] = {LEGS}
     }
 }
 local tierLevel80 = {
     [CLASS_WARRIOR] = {
         [HEAD] = {[1] = 16478, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = 16480, [2] = nil, [3] = nil},
         [CHEST] = {[1] = 16477, [2] = niln, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = 16484, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = 16479, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_PALADIN] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_HUNTER] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_ROGUE] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_PRIEST] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_DEATH_KNIGHT] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_SHAMAN] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_MAGE] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_WARLOCK] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },

     [CLASS_DRUID] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     }

 }
 local tierLevel70 = {
     [CLASS_WARRIOR] = {
         [HEAD] = {[1] = 16478, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = 16480, [2] = nil, [3] = nil},
         [CHEST] = {[1] = 16477, [2] = niln, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = 16484, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = 16479, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_PALADIN] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_HUNTER] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_ROGUE] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_PRIEST] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_DEATH_KNIGHT] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_SHAMAN] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_MAGE] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_WARLOCK] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },

     [CLASS_DRUID] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     }

 }

 local tierLevel60 = {
     [CLASS_WARRIOR] = {
         [HEAD] = {[1] = 21999, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = 22001, [2] = nil, [3] = nil},
         [CHEST] = {[1] = 21997, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = 21998, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = 22000, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_PALADIN] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_HUNTER] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_ROGUE] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_PRIEST] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_DEATH_KNIGHT] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_SHAMAN] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_MAGE] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },
     [CLASS_WARLOCK] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     },

     [CLASS_DRUID] = {
         [HEAD] = {[1] = nil, [2] = nil, [3] = nil},
         [NECK] = {[1] = nil, [2] = nil, [3] = nil},
         [SHOULDER] = {[1] = nil, [2] = nil, [3] = nil},
         [CHEST] = {[1] = nil, [2] = nil, [3] = nil},
         [SHIRT] = {[1] = nil, [2] = nil, [3] = nil},
         [TABARD] = {[1] = nil, [2] = nil, [3] = nil},
         [WRIST] = {[1] = nil, [2] = nil, [3] = nil},
         [GLOVES] = {[1] = nil, [2] = nil, [3] = nil},
         [BELT] = {[1] = nil, [2] = nil, [3] = nil},
         [LEGS] = {[1] = nil, [2] = nil, [3] = nil},
         [FEET] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER1] = {[1] = nil, [2] = nil, [3] = nil},
         [FINGER2] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET1] = {[1] = nil, [2] = nil, [3] = nil},
         [TRINKET2] = {[1] = nil, [2] = nil, [3] = nil},
         [MAINHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [OFFHAND] = {[1] = nil, [2] = nil, [3] = nil},
         [RANGED] = {[1] = nil, [2] = nil, [3] = nil}
     }

 }

 local function transformTokenToItem(event, player, item, target)
     local class = player:GetClass()


     for slotForGearLevel, itemIdForToken in pairs(itemIdsForToken) do
         for gearTokenId, gearSlotIdTable in pairs(itemIdForToken) do
             for gearItemId, slotId in pairs(gearSlotIdTable) do
                 if slotForGearLevel == 1 and item:GetEntry() == gearTokenId then
                     local itemId = tierLevel60[class][slotId][gearItemId]
                     if itemId then
                         local itemTransformed = player:AddItem(itemId)
                         if itemTransformed then
                             player:SendAreaTriggerMessage("|cff00ff00" ..
                                                               item:GetItemLink() ..
                                                               "|r" ..
                                                               " has been transformed to " ..
                                                               "|cff00ff00" ..
                                                               itemTransformed:GetItemLink() ..
                                                               "|r" .. ".")
                         end
                     end
                 elseif slotForGearLevel == 2 and item:GetEntry() == gearTokenId then
                     local itemId = tierLevel70[class][slotId][gearItemId]

                     if itemId then
                         local itemTransformed = player:AddItem(itemId)
                         if itemTransformed then
                             player:SendAreaTriggerMessage("|cff00ff00" ..
                                                               item:GetItemLink() ..
                                                               "|r" ..
                                                               " has been transformed to " ..
                                                               "|cff00ff00" ..
                                                               itemTransformed:GetItemLink() ..
                                                               "|r" .. ".")
                         end
                     end
                 elseif slotForGearLevel == 3 and item:GetEntry() == gearTokenId then
                     local itemId = tierLevel80[class][slotId][gearItemId]

                     if itemId then
                         local itemTransformed = player:AddItem(itemId)
                         if itemTransformed then
                             player:SendAreaTriggerMessage("|cff00ff00" ..
                                                               item:GetItemLink() ..
                                                               "|r" ..
                                                               " has been transformed to " ..
                                                               "|cff00ff00" ..
                                                               itemTransformed:GetItemLink() ..
                                                               "|r" .. ".")
                         end
                     end

                 end
             end
         end
     end
     player:SendAreaTriggerMessage("You have used a " .. item:GetName())
 end

 for i, v in pairs(itemIdsForToken) do
     for j, k in pairs(v) do
         --  print(i,v,j,k)
         RegisterItemEvent(j, ITEM_EVENT_ON_REMOVE, transformTokenToItem)
     end
 end

 local function addBoxes(event, player, msg, Type, lang) -- made for debugging.
     if not player:IsGM() then return end
     if (msg == "#box") then

         for i, v in pairs(itemIdsForToken) do
             for j, k in pairs(v) do
                 if not player:HasItem(j) then player:AddItem(j) end
             end
         end
         return false
     end
 end

 RegisterPlayerEvent(PLAYER_EVENT_ON_CHAT, addBoxes)
