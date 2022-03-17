------------------------------------------------------------------------------------------------
-- ACCOUNT MOUNTS MOD
------------------------------------------------------------------------------------------------

local EnableModule = true
local AnnounceModule = true   -- Announce module on player login ?

local StrictFactions = true  -- Disallow learning mounts from opposing faction
local GM_LearnAllCmd = false  -- enable ".learn all mounts" command for GM (debug)

------------------------------------------------------------------------------------------------
-- END CONFIG
------------------------------------------------------------------------------------------------

if (not EnableModule) then return end
local FILE_NAME = string.match(debug.getinfo(1,'S').source, "[^/\\]*.lua$")

-- [spellID] = { ridingSkillRank, class, team+1, extraSkillId, extraSkillRank }
-- list containts every single mount (396 total) in version 3.3.5.12340

local mount_listing = {
    [458] = {75,0,1,0,0}, -- Brown Horse
    [470] = {75,0,1,0,0}, -- Black Stallion
    [472] = {75,0,1,0,0}, -- Pinto
    [580] = {75,0,2,0,0}, -- Timber Wolf
    [3363] = {300,0,0,0,0}, -- Nether Drake
    [6648] = {75,0,1,0,0}, -- Chestnut Mare
    [6653] = {75,0,2,0,0}, -- Dire Wolf
    [6654] = {75,0,2,0,0}, -- Brown Wolf
    [6777] = {75,0,1,0,0}, -- Gray Ram
    [6898] = {75,0,1,0,0}, -- White Ram
    [6899] = {75,0,1,0,0}, -- Brown Ram
    [8394] = {75,0,1,0,0}, -- Striped Frostsaber
    [8395] = {75,0,2,0,0}, -- Emerald Raptor
    [8396] = {0,0,0,0,0}, -- Summon Ivory Tallstrider
    [10789] = {75,0,1,0,0}, -- Spotted Frostsaber
    [10793] = {75,0,1,0,0}, -- Striped Nightsaber
    [10796] = {75,0,2,0,0}, -- Turquoise Raptor
    [10799] = {75,0,2,0,0}, -- Violet Raptor
    [10800] = {0,0,0,0,0}, -- Summon Brown Tallstrider
    [10801] = {0,0,0,0,0}, -- Summon Gray Tallstrider
    [10802] = {0,0,0,0,0}, -- Summon Pink Tallstrider
    [10803] = {0,0,0,0,0}, -- Summon Purple Tallstrider
    [10804] = {0,0,0,0,0}, -- Summon Turquoise Tallstrider
    [10873] = {75,0,1,0,0}, -- Red Mechanostrider
    [10969] = {75,0,1,0,0}, -- Blue Mechanostrider
    [15779] = {150,0,1,0,0}, -- White Mechanostrider Mod B
    [15780] = {75,0,1,0,0}, -- Green Mechanostrider
    [15781] = {75,0,1,0,0}, -- Steel Mechanostrider
    [16055] = {150,0,1,0,0}, -- Black Nightsaber
    [16056] = {150,0,1,0,0}, -- Ancient Frostsaber
    [16058] = {75,0,1,0,0}, -- Primal Leopard
    [16059] = {75,0,1,0,0}, -- Tawny Sabercat
    [16060] = {75,0,1,0,0}, -- Golden Sabercat
    [16080] = {150,0,2,0,0}, -- Red Wolf
    [16081] = {150,0,2,0,0}, -- Winter Wolf
    [16082] = {150,0,1,0,0}, -- Palomino
    [16083] = {150,0,1,0,0}, -- White Stallion
    [16084] = {150,0,2,0,0}, -- Mottled Red Raptor
    [17229] = {150,0,1,0,0}, -- Winterspring Frostsaber
    [17450] = {150,0,2,0,0}, -- Ivory Raptor
    [17453] = {75,0,1,0,0}, -- Green Mechanostrider
    [17454] = {75,0,1,0,0}, -- Unpainted Mechanostrider
    [17455] = {75,0,1,0,0}, -- Purple Mechanostrider
    [17456] = {75,0,1,0,0}, -- Red and Blue Mechanostrider
    [17459] = {150,0,1,0,0}, -- Icy Blue Mechanostrider Mod A
    [17460] = {150,0,1,0,0}, -- Frost Ram
    [17461] = {150,0,1,0,0}, -- Black Ram
    [17462] = {75,0,2,0,0}, -- Red Skeletal Horse
    [17463] = {75,0,2,0,0}, -- Blue Skeletal Horse
    [17464] = {75,0,2,0,0}, -- Brown Skeletal Horse
    [17465] = {150,0,2,0,0}, -- Green Skeletal Warhorse
    [17481] = {150,0,0,0,0}, -- Rivendare's Deathcharger
    [18363] = {75,0,0,0,0}, -- Riding Kodo
    [18989] = {75,0,2,0,0}, -- Gray Kodo
    [18990] = {75,0,2,0,0}, -- Brown Kodo
    [18991] = {150,0,2,0,0}, -- Green Kodo
    [18992] = {150,0,2,0,0}, -- Teal Kodo
    [22717] = {150,0,1,0,0}, -- Black War Steed
    [22718] = {150,0,2,0,0}, -- Black War Kodo
    [22719] = {150,0,1,0,0}, -- Black Battlestrider
    [22720] = {150,0,1,0,0}, -- Black War Ram
    [22721] = {150,0,2,0,0}, -- Black War Raptor
    [22722] = {150,0,2,0,0}, -- Red Skeletal Warhorse
    [22723] = {150,0,1,0,0}, -- Black War Tiger
    [22724] = {150,0,2,0,0}, -- Black War Wolf
    [23219] = {150,0,1,0,0}, -- Swift Mistsaber
    [23220] = {150,0,1,0,0}, -- Swift Dawnsaber
    [23221] = {150,0,1,0,0}, -- Swift Frostsaber
    [23222] = {150,0,1,0,0}, -- Swift Yellow Mechanostrider
    [23223] = {150,0,1,0,0}, -- Swift White Mechanostrider
    [23225] = {150,0,1,0,0}, -- Swift Green Mechanostrider
    [23227] = {150,0,1,0,0}, -- Swift Palomino
    [23228] = {150,0,1,0,0}, -- Swift White Steed
    [23229] = {150,0,1,0,0}, -- Swift Brown Steed
    [23238] = {150,0,1,0,0}, -- Swift Brown Ram
    [23239] = {150,0,1,0,0}, -- Swift Gray Ram
    [23240] = {150,0,1,0,0}, -- Swift White Ram
    [23241] = {150,0,2,0,0}, -- Swift Blue Raptor
    [23242] = {150,0,2,0,0}, -- Swift Olive Raptor
    [23243] = {150,0,2,0,0}, -- Swift Orange Raptor
    [23246] = {150,0,2,0,0}, -- Purple Skeletal Warhorse
    [23247] = {150,0,2,0,0}, -- Great White Kodo
    [23248] = {150,0,2,0,0}, -- Great Gray Kodo
    [23249] = {150,0,2,0,0}, -- Great Brown Kodo
    [23250] = {150,0,2,0,0}, -- Swift Brown Wolf
    [23251] = {150,0,2,0,0}, -- Swift Timber Wolf
    [23252] = {150,0,2,0,0}, -- Swift Gray Wolf
    [23338] = {150,0,1,0,0}, -- Swift Stormsaber
    [23509] = {150,0,0,0,0}, -- Frostwolf Howler
    [23510] = {150,0,0,0,0}, -- Stormpike Battle Charger
    [24242] = {150,0,0,0,0}, -- Swift Razzashi Raptor
    [24252] = {150,0,0,0,0}, -- Swift Zulian Tiger
    [24576] = {150,0,0,0,0}, -- Chromatic Mount
    [25675] = {75,0,0,0,0}, -- Reindeer
    [25858] = {75,0,0,0,0}, -- Reindeer
    [25859] = {150,0,0,0,0}, -- Reindeer
    [25863] = {150,0,0,0,0}, -- Black Qiraji Battle Tank
    [25953] = {150,0,0,0,0}, -- Blue Qiraji Battle Tank
    [26054] = {150,0,0,0,0}, -- Red Qiraji Battle Tank
    [26055] = {150,0,0,0,0}, -- Yellow Qiraji Battle Tank
    [26056] = {150,0,0,0,0}, -- Green Qiraji Battle Tank
    [26655] = {150,0,0,0,0}, -- Black Qiraji Battle Tank
    [26656] = {150,0,0,0,0}, -- Black Qiraji Battle Tank
    [28828] = {0,0,0,0,0}, -- Nether Drake
    [29059] = {150,0,0,0,0}, -- Naxxramas Deathcharger
    [30174] = {0,0,0,0,0}, -- Riding Turtle
    [31700] = {0,0,0,0,0}, -- Black Qiraji Battle Tank
    [31973] = {150,0,0,0,0}, -- Kessel's Elekk
    [32235] = {225,0,1,0,0}, -- Golden Gryphon
    [32239] = {225,0,1,0,0}, -- Ebon Gryphon
    [32240] = {225,0,1,0,0}, -- Snowy Gryphon
    [32242] = {300,0,1,0,0}, -- Swift Blue Gryphon
    [32243] = {225,0,2,0,0}, -- Tawny Wind Rider
    [32244] = {225,0,2,0,0}, -- Blue Wind Rider
    [32245] = {225,0,2,0,0}, -- Green Wind Rider
    [32246] = {300,0,2,0,0}, -- Swift Red Wind Rider
    [32289] = {300,0,1,0,0}, -- Swift Red Gryphon
    [32290] = {300,0,1,0,0}, -- Swift Green Gryphon
    [32292] = {300,0,1,0,0}, -- Swift Purple Gryphon
    [32295] = {300,0,2,0,0}, -- Swift Green Wind Rider
    [32296] = {300,0,2,0,0}, -- Swift Yellow Wind Rider
    [32297] = {300,0,2,0,0}, -- Swift Purple Wind Rider
    [32345] = {0,0,0,0,0}, -- Peep the Phoenix Mount
    [32420] = {0,0,0,0,0}, -- Old Crappy McWeakSauce
    [33630] = {75,0,1,0,0}, -- Blue Mechanostrider
    [33631] = {0,0,0,0,0}, -- Video Mount
    [33660] = {150,0,2,0,0}, -- Swift Pink Hawkstrider
    [34068] = {0,0,0,0,0}, -- Summon Dodostrider
    [34406] = {75,0,1,0,0}, -- Brown Elekk
    [34407] = {150,0,1,0,0}, -- Great Elite Elekk
    [34790] = {150,0,0,0,0}, -- Dark War Talbuk
    [34795] = {75,0,2,0,0}, -- Red Hawkstrider
    [34896] = {150,0,2,0,0}, -- Cobalt War Talbuk
    [34897] = {150,0,2,0,0}, -- White War Talbuk
    [34898] = {150,0,2,0,0}, -- Silver War Talbuk
    [34899] = {150,0,2,0,0}, -- Tan War Talbuk
    [35018] = {75,0,2,0,0}, -- Purple Hawkstrider
    [35020] = {75,0,2,0,0}, -- Blue Hawkstrider
    [35022] = {75,0,2,0,0}, -- Black Hawkstrider
    [35025] = {150,0,2,0,0}, -- Swift Green Hawkstrider
    [35027] = {150,0,2,0,0}, -- Swift Purple Hawkstrider
    [35028] = {150,0,2,0,0}, -- Swift Warstrider
    [35710] = {75,0,1,0,0}, -- Gray Elekk
    [35711] = {75,0,1,0,0}, -- Purple Elekk
    [35712] = {150,0,1,0,0}, -- Great Green Elekk
    [35713] = {150,0,1,0,0}, -- Great Blue Elekk
    [35714] = {150,0,1,0,0}, -- Great Purple Elekk
    [36702] = {150,0,0,0,0}, -- Fiery Warhorse
    [37015] = {300,0,0,0,0}, -- Swift Nether Drake
    [39315] = {150,0,2,0,0}, -- Cobalt Riding Talbuk
    [39316] = {150,0,0,0,0}, -- Dark Riding Talbuk
    [39317] = {150,0,2,0,0}, -- Silver Riding Talbuk
    [39318] = {150,0,2,0,0}, -- Tan Riding Talbuk
    [39319] = {150,0,2,0,0}, -- White Riding Talbuk
    [39450] = {150,0,0,0,0}, -- Tallstrider
    [39798] = {300,0,0,0,0}, -- Green Riding Nether Ray
    [39800] = {300,0,0,0,0}, -- Red Riding Nether Ray
    [39801] = {300,0,0,0,0}, -- Purple Riding Nether Ray
    [39802] = {300,0,0,0,0}, -- Silver Riding Nether Ray
    [39803] = {300,0,0,0,0}, -- Blue Riding Nether Ray
    [39910] = {150,0,0,0,0}, -- Riding Clefthoof
    [39949] = {300,0,0,0,0}, -- Mount (Test Anim)
    [40192] = {300,0,0,0,0}, -- Ashes of Al'ar
    [40212] = {300,0,0,0,0}, -- Dragonmaw Nether Drake
    [41252] = {150,0,0,0,0}, -- Raven Lord
    [41513] = {300,0,0,0,0}, -- Onyx Netherwing Drake
    [41514] = {300,0,0,0,0}, -- Azure Netherwing Drake
    [41515] = {300,0,0,0,0}, -- Cobalt Netherwing Drake
    [41516] = {300,0,0,0,0}, -- Purple Netherwing Drake
    [41517] = {300,0,0,0,0}, -- Veridian Netherwing Drake
    [41518] = {300,0,0,0,0}, -- Violet Netherwing Drake
    [42363] = {0,0,0,0,0}, -- Dan's Steam Tank Form
    [42387] = {0,0,0,0,0}, -- Dan's Steam Tank Form (Self)
    [42776] = {75,0,0,0,0}, -- Spectral Tiger
    [42777] = {150,0,0,0,0}, -- Swift Spectral Tiger
    [42929] = {75,0,0,0,0}, -- [DNT] Test Mount
    [43688] = {150,0,0,0,0}, -- Amani War Bear
    [43810] = {300,0,0,0,0}, -- Frost Wyrm
    [43880] = {0,0,0,0,0}, -- Ramstein's Swift Work Ram
    [43883] = {0,0,0,0,0}, -- Rental Racing Ram
    [43899] = {75,0,0,0,0}, -- Brewfest Ram
    [43900] = {150,0,0,0,0}, -- Swift Brewfest Ram
    [43927] = {300,0,0,0,0}, -- Cenarion War Hippogryph
    [44317] = {300,0,0,0,0}, -- Merciless Nether Drake
    [44655] = {300,0,0,0,0}, -- Flying Reindeer
    [44744] = {300,0,0,0,0}, -- Merciless Nether Drake
    [44824] = {225,0,0,0,0}, -- Flying Reindeer
    [44825] = {300,0,0,0,0}, -- Flying Reindeer
    [44827] = {300,0,0,0,0}, -- Flying Reindeer
    [45177] = {0,0,0,0,0}, -- Copy of Riding Turtle
    [46197] = {225,0,0,0,0}, -- X-51 Nether-Rocket
    [46199] = {300,0,0,0,0}, -- X-51 Nether-Rocket X-TREME
    [46628] = {150,0,0,0,0}, -- Swift White Hawkstrider
    [46980] = {150,0,0,0,0}, -- Northrend Nerubian Mount (Test)
    [47037] = {150,0,0,0,0}, -- Swift War  Elekk
    [48023] = {75,0,0,0,0}, -- Headless Horseman's Mount
    [48024] = {75,0,0,0,0}, -- Headless Horseman's Mount
    [48025] = {75,0,0,0,0}, -- Headless Horseman's Mount
    [48027] = {150,0,1,0,0}, -- Black War Elekk
    [48954] = {150,0,0,0,0}, -- Swift Zhevra
    [49193] = {300,0,0,0,0}, -- Vengeful Nether Drake
    [49322] = {150,0,0,0,0}, -- Swift Zhevra
    [49378] = {75,0,0,0,0}, -- Brewfest Riding Kodo
    [49379] = {150,0,0,0,0}, -- Great Brewfest Kodo
    [49908] = {0,0,0,0,0}, -- Pink Elekk
    [50281] = {150,0,1,0,0}, -- Black Warp Stalker
    [50869] = {75,0,0,0,0}, -- Brewfest Kodo
    [50870] = {75,0,0,0,0}, -- Brewfest Ram
    [51412] = {150,0,0,0,0}, -- Big Battle Bear
    [51617] = {75,0,0,0,0}, -- Headless Horseman's Mount
    [51621] = {75,0,0,0,0}, -- Headless Horseman's Mount
    [51960] = {300,0,0,0,0}, -- Frost Wyrm Mount
    [54753] = {150,0,0,0,0}, -- White Polar Bear
    [55164] = {300,0,0,0,0}, -- Swift Spectral Gryphon
    [55293] = {150,0,0,0,0}, -- Amani War Bear
    [55531] = {150,0,2,0,0}, -- Mechano-hog
    [58615] = {300,0,0,0,0}, -- Brutal Nether Drake
    [58819] = {150,0,1,0,0}, -- Swift Brown Steed
    [58983] = {75,0,0,0,0}, -- Big Blizzard Bear
    [58997] = {75,0,0,0,0}, -- Big Blizzard Bear
    [58999] = {75,0,0,0,0}, -- Big Blizzard Bear
    [59567] = {300,0,0,0,0}, -- Azure Drake
    [59568] = {300,0,0,0,0}, -- Blue Drake
    [59569] = {300,0,0,0,0}, -- Bronze Drake
    [59570] = {300,0,0,0,0}, -- Red Drake
    [59571] = {300,0,0,0,0}, -- Twilight Drake
    [59572] = {150,0,0,0,0}, -- Black Polar Bear
    [59573] = {150,0,0,0,0}, -- Brown Polar Bear
    [59650] = {300,0,0,0,0}, -- Black Drake
    [59785] = {150,0,1,0,0}, -- Black War Mammoth
    [59788] = {150,0,2,0,0}, -- Black War Mammoth
    [59791] = {150,0,1,0,0}, -- Wooly Mammoth
    [59793] = {150,0,2,0,0}, -- Wooly Mammoth
    [59797] = {150,0,2,0,0}, -- Ice Mammoth
    [59799] = {150,0,1,0,0}, -- Ice Mammoth
    [59802] = {150,0,0,0,0}, -- Grand Ice Mammoth
    [59804] = {150,0,0,0,0}, -- Grand Ice Mammoth
    [59961] = {300,0,0,0,0}, -- Red Proto-Drake
    [59976] = {300,0,0,0,0}, -- Black Proto-Drake
    [59996] = {300,0,0,0,0}, -- Blue Proto-Drake
    [60002] = {300,0,0,0,0}, -- Time-Lost Proto-Drake
    [60021] = {300,0,0,0,0}, -- Plagued Proto-Drake
    [60024] = {300,0,0,0,0}, -- Violet Proto-Drake
    [60025] = {300,0,0,0,0}, -- Albino Drake
    [60114] = {150,0,1,0,0}, -- Armored Brown Bear
    [60116] = {150,0,2,0,0}, -- Armored Brown Bear
    [60118] = {150,0,1,0,0}, -- Black War Bear
    [60119] = {150,0,2,0,0}, -- Black War Bear
    [60136] = {150,0,0,0,0}, -- Grand Caravan Mammoth
    [60140] = {150,0,0,0,0}, -- Grand Caravan Mammoth
    [60424] = {150,0,1,0,0}, -- Mekgineer's Chopper
    [61229] = {300,0,1,0,0}, -- Armored Snowy Gryphon
    [61230] = {300,0,2,0,0}, -- Armored Blue Wind Rider
    [61294] = {300,0,0,0,0}, -- Green Proto-Drake
    [61425] = {150,0,1,0,0}, -- Traveler's Tundra Mammoth (Alliance)
    [61447] = {150,0,2,0,0}, -- Traveler's Tundra Mammoth (Horde)
    [61465] = {150,0,1,0,0}, -- Grand Black War Mammoth
    [61467] = {150,0,2,0,0}, -- Grand Black War Mammoth
    [61469] = {150,0,2,0,0}, -- Grand Ice Mammoth
    [61470] = {150,0,1,0,0}, -- Grand Ice Mammoth
    [61983] = {150,0,0,0,0}, -- Dan's Test Mount
    [61996] = {300,0,0,0,0}, -- Blue Dragonhawk
    [61997] = {300,0,0,0,0}, -- Red Dragonhawk
    [62048] = {300,0,0,0,0}, -- Black Dragonhawk Mount
    [63232] = {150,0,1,0,0}, -- Stormwind Steed
    [63635] = {150,0,2,0,0}, -- Darkspear Raptor
    [63636] = {150,0,1,0,0}, -- Ironforge Ram
    [63637] = {150,0,1,0,0}, -- Darnassian Nightsaber
    [63638] = {150,0,1,0,0}, -- Gnomeregan Mechanostrider
    [63639] = {150,0,1,0,0}, -- Exodar Elekk
    [63640] = {150,0,2,0,0}, -- Orgrimmar Wolf
    [63641] = {150,0,2,0,0}, -- Thunder Bluff Kodo
    [63642] = {150,0,2,0,0}, -- Silvermoon Hawkstrider
    [63643] = {150,0,2,0,0}, -- Forsaken Warhorse
    [63796] = {300,0,0,0,0}, -- Mimiron's Head
    [63844] = {300,0,0,0,0}, -- Argent Hippogryph
    [63956] = {300,0,0,0,0}, -- Ironbound Proto-Drake
    [63963] = {300,0,0,0,0}, -- Rusted Proto-Drake
    [64656] = {150,0,2,0,0}, -- Blue Skeletal Warhorse
    [64657] = {75,0,2,0,0}, -- White Kodo
    [64658] = {75,0,2,0,0}, -- Black Wolf
    [64659] = {150,0,2,0,0}, -- Venomhide Ravasaur
    [64681] = {225,0,0,0,0}, -- Loaned Gryphon
    [64731] = {75,0,0,0,0}, -- Sea Turtle
    [64761] = {225,0,0,0,0}, -- Loaned Wind Rider
    [64927] = {300,0,0,0,0}, -- Deadly Gladiator's Frost Wyrm
    [64977] = {75,0,2,0,0}, -- Black Skeletal Horse
    [64992] = {75,0,0,0,0}, -- Big Blizzard Bear [PH]
    [64993] = {75,0,0,0,0}, -- Big Blizzard Bear [PH]
    [65439] = {300,0,0,0,0}, -- Furious Gladiator's Frost Wyrm
    [65637] = {150,0,1,0,0}, -- Great Red Elekk
    [65638] = {150,0,1,0,0}, -- Swift Moonsaber
    [65639] = {150,0,2,0,0}, -- Swift Red Hawkstrider
    [65640] = {150,0,1,0,0}, -- Swift Gray Steed
    [65641] = {150,0,2,0,0}, -- Great Golden Kodo
    [65642] = {150,0,1,0,0}, -- Turbostrider
    [65643] = {150,0,1,0,0}, -- Swift Violet Ram
    [65644] = {150,0,2,0,0}, -- Swift Purple Raptor
    [65645] = {150,0,2,0,0}, -- White Skeletal Warhorse
    [65646] = {150,0,2,0,0}, -- Swift Burgundy Wolf
    [65917] = {150,0,0,0,0}, -- Magic Rooster
    [66087] = {300,0,0,0,0}, -- Silver Covenant Hippogryph
    [66088] = {300,0,0,0,0}, -- Sunreaver Dragonhawk
    [66090] = {150,0,1,0,0}, -- Quel'dorei Steed
    [66091] = {150,0,2,0,0}, -- Sunreaver Hawkstrider
    [66122] = {150,0,0,0,0}, -- Magic Rooster
    [66123] = {150,0,0,0,0}, -- Magic Rooster
    [66124] = {150,0,0,0,0}, -- Magic Rooster
    [66846] = {150,0,2,0,0}, -- Ochre Skeletal Warhorse
    [66847] = {75,0,1,0,0}, -- Striped Dawnsaber
    [67336] = {300,0,0,0,0}, -- Relentless Gladiator's Frost Wyrm
    [67466] = {150,0,0,0,0}, -- Argent Warhorse
    [68056] = {150,0,2,0,0}, -- Swift Horde Wolf
    [68057] = {150,0,1,0,0}, -- Swift Alliance Steed
    [68187] = {150,0,1,0,0}, -- Crusader's White Warhorse
    [68188] = {150,0,2,0,0}, -- Crusader's Black Warhorse
    [68768] = {0,0,1,0,0}, -- Little White Stallion
    [68769] = {0,0,2,0,0}, -- Little Ivory Raptor
    [69395] = {300,0,0,0,0}, -- Onyxian Drake
    [71342] = {150,0,0,0,0}, -- Big Love Rocket
    [71343] = {150,0,0,0,0}, -- Big Love Rocket
    [71344] = {75,0,0,0,0}, -- Big Love Rocket
    [71345] = {150,0,0,0,0}, -- Big Love Rocket
    [71346] = {150,0,0,0,0}, -- Big Love Rocket
    [71347] = {150,0,0,0,0}, -- Big Love Rocket
    [71810] = {300,0,0,0,0}, -- Wrathful Gladiator's Frost Wyrm
    [72281] = {75,0,0,0,0}, -- Invincible
    [72282] = {75,0,0,0,0}, -- Invincible
    [72283] = {75,0,0,0,0}, -- Invincible
    [72284] = {75,0,0,0,0}, -- Invincible
    [72286] = {75,0,0,0,0}, -- Invincible
    [72807] = {300,0,0,0,0}, -- Icebound Frostbrood Vanquisher
    [72808] = {300,0,0,0,0}, -- Bloodbathed Frostbrood Vanquisher
    [74854] = {225,0,0,0,0}, -- Blazing Hippogryph
    [74855] = {300,0,0,0,0}, -- Blazing Hippogryph
    [74856] = {225,0,0,0,0}, -- Blazing Hippogryph
    [74918] = {150,0,0,0,0}, -- Wooly White Rhino
    [75614] = {75,0,0,0,0}, -- Celestial Steed
    [75617] = {75,0,0,0,0}, -- Celestial Steed
    [75618] = {75,0,0,0,0}, -- Celestial Steed
    [75619] = {75,0,0,0,0}, -- Celestial Steed
    [75620] = {75,0,0,0,0}, -- Celestial Steed
    [75957] = {225,0,0,0,0}, -- X-53 Touring Rocket
    [75972] = {225,0,0,0,0}, -- X-53 Touring Rocket
    [75973] = {225,0,0,0,0}, -- X-53 Touring Rocket
    [76153] = {75,0,0,0,0}, -- Celestial Steed
    [76154] = {225,0,0,0,0}, -- X-53 Touring Rocket
    [10792] = {75,0,0,0,0}, -- Spotted Panther
    [17458] = {75,0,0,0,0}, -- Fluorescent Green Mechanostrider

    -- class mounts
    [66906] = {150,2,0,0,0}, -- Argent Charger
    [66907] = {75,2,0,0,0}, -- Argent Warhorse
    [13819] = {75,2,1,0,0}, -- Warhorse
    [23214] = {150,2,1,0,0}, -- Charger
    [34769] = {75,2,2,0,0}, -- Summon Warhorse
    [34767] = {150,2,2,0,0}, -- Summon Charger
    [48778] = {150,6,0,0,0}, -- Acherus Deathcharger
    [54726] = {225,6,0,0,0}, -- Winged Steed of the Ebon Blade
    [54727] = {300,6,0,0,0}, -- Winged Steed of the Ebon Blade
    [54729] = {225,6,0,0,0}, -- Winged Steed of the Ebon Blade
    [73313] = {150,6,0,0,0}, -- Crimson Deathcharger
    [23161] = {150,9,0,0,0}, -- Dreadsteed
    [5784] = {75,9,0,0,0}, -- Felsteed

    -- profession mounts
    [75387] = {300,0,0,197,425}, -- Tiny Mooncloth Carpet
    [75596] = {300,0,0,197,425}, -- Frosty Flying Carpet
    [61451] = {225,0,0,197,300}, -- Flying Carpet
    [61442] = {300,0,0,197,450}, -- Swift Mooncloth Carpet
    [61444] = {300,0,0,197,450}, -- Swift Shadoweave Carpet
    [61446] = {300,0,0,197,450}, -- Swift Spellfire Carpet
    [61309] = {300,0,0,197,425}, -- Magnificent Flying Carpet
    [44151] = {300,0,0,202,375}, -- Turbo-Charged Flying Machine
    [44153] = {225,0,0,202,300}, -- Flying Machine

    -- old vanilla faction mounts, used to need special skills
    -- A: Horse Riding (148), Tiger Riding (150), Ram Riding(152)
    -- H: Wolf Riding (149), Raptor Riding (533), Undead Horsemanship (554)
    -- req can probably be safely ignored
    [459] = {75,0,2,149,1}, -- Gray Wolf
    [468] = {75,0,1,148,1}, -- White Stallion
    [471] = {75,0,1,148,1}, -- Palamino
    [578] = {75,0,2,149,1}, -- Black Wolf
    [579] = {150,0,2,149,1}, -- Red Wolf
    [581] = {75,0,2,149,1}, -- Winter Wolf
    [6896] = {75,0,1,152,1}, -- Black Ram
    [6897] = {75,0,1,152,1}, -- Blue Ram
    [10788] = {75,0,1,150,1}, -- Leopard
    [10790] = {75,0,1,150,1}, -- Tiger
    [8980] = {75,0,2,554,1}, -- Skeletal Horse
    [10787] = {75,0,1,150,1}, -- Black Nightsaber
    [10795] = {75,0,2,533,1}, -- Ivory Raptor
    [10798] = {75,0,2,533,1}, -- Obsidian Raptor

    -- mounts from items with duration
    [42667] = {225,0,0,0,0}, -- Flying Broom
    [42668] = {300,0,0,0,0}, -- Swift Flying Broom
    [42680] = {75,0,0,0,0}, -- Magic Broom
    [42683] = {150,0,0,0,0}, -- Swift Magic Broom
    [42692] = {0,0,0,0,0}, -- Rickety Magic Broom
    [47977] = {300,0,0,0,0}, -- Magic Broom
    [61289] = {150,0,0,0,0}, -- Borrowed Broom

    -- disabled
    -- [60120] = {0,0,0,0,0}, -- Summon Loaner Wind Rider
    -- [26332] = {0,0,0,0,0}, -- Summon Mouth Tentacle
    -- [30829] = {150,0,0,0,0}, -- Summon Kessel's Elekk
    -- [30837] = {150,0,0,0,0}, -- Summon Kessel's Elekk
}

--local RIDING_SPELL = {
--    [75] = 33388, -- Apprentince Riding (75)
--    [150] = 33391, -- Journeyman Riding (150)
--    [225] = 34090, -- Expert Riding (225)
--    [300] = 34091, -- Artisan Riding (300)
--}

local function OnLogin(event, player)
    if (AnnounceModule and event) then
        player:SendBroadcastMessage("This server is running the |cff4CFF00AccountMounts|r module.")
    end

    local pGUID = player:GetGUIDLow()
    local pAccountId = player:GetAccountId()
    local results = CharDBQuery("SELECT guid FROM characters WHERE account = "..pAccountId.." and guid <> "..pGUID)

    local guids = {}
    if (results) then
        repeat
            table.insert(guids, results:GetUInt32(0))
        until not results:NextRow()
    end

    if (#guids > 0) then
        local guidstr = guids[1]
        for i = 2, #guids do
            guidstr = guidstr .. ",".. guids[i]
        end

        results = CharDBQuery("SELECT DISTINCT spell FROM character_spell WHERE guid IN("..guidstr..")")
        if (results) then
            local skill = player:GetSkillValue(762)
            local class = player:GetClass()
            local team = player:GetTeam()
            repeat
                local spellId = results:GetUInt32(0)
                local mount = mount_listing[spellId]
                if (mount) then
                    if ((skill >= mount[1]) and
                    ((mount[2]==0) or (mount[2]==class)) and
                    ((not StrictFactions) or (mount[3]==0) or (mount[3]==(team+1))) and
                    ((mount[4]==0) or (mount[4]==148) or (mount[4]==149) or (mount[4]==150) or (mount[4]==152) or (mount[4]==533) or (mount[4]==554) or (player:GetSkillValue(mount[4]) >= mount[5]))) then
                        if ((spellId == 61425) and (team == 2)) then -- if StrictFactions=false, have to check and replace traveler mammoth special case, to not spawn enemy vendors
                            spellId = 61447
                        elseif ((spellId == 61447) and (team == 1)) then
                            spellId = 61425
                        end
                        if (not player:HasSpell(spellId)) then
                            player:LearnSpell(spellId)
                        end
                    end
                end
            until not results:NextRow()
        end
    end
end

local function OnCommand(event, player, command)
    if (GM_LearnAllCmd and (command:lower() == "learn all mounts") and (player:GetGMRank() >= 1)) then

        player:LearnSpell(33388) -- Apprentince Riding (75)
        player:LearnSpell(33391) -- Journeyman Riding (150)
        player:LearnSpell(34090) -- Expert Riding (225)
        player:LearnSpell(34091) -- Artisan Riding (300)
        for k,_ in pairs(mount_listing) do
            player:LearnSpell(k)
        end
        return false
    end
end

local function OnSendLearnedSpell(event, packet, player)
  local  spellId = packet:ReadULong() -- spellId(SMSG_LEARNED_SPELL) / oldSpellId (SMSG_SUPERCEDED_SPELL)
    if(spellId == 33388 or spellId == 33391 or spellId == 34090 or spellId == 34091) then
        player:RegisterEvent((function(_,_,_,p) OnLogin(nil, p) end), 100)
    end
end

RegisterPlayerEvent(3, OnLogin)
RegisterPlayerEvent(42, OnCommand)
RegisterPacketEvent(299, 7, OnSendLearnedSpell) -- PACKET_EVENT_ON_PACKET_SEND (SMSG_LEARNED_SPELL)
RegisterPacketEvent(300, 7, OnSendLearnedSpell) -- PACKET_EVENT_ON_PACKET_SEND (SMSG_SUPERCEDED_SPELL)