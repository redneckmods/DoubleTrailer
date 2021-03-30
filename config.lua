config = {}

config = {
    trailers = {
        `doubletrailer`,
    },
    boats = {
        `zodiac`,
    },
    water_vehicles = {
        `20ramswr`,
        `20ramcwr`,
        `16ramswr`,
        `16ramcwr`,
        `f550ramswr`,
        `f550ramcwr`,
    },
    spawnCommand = 'dblTrailerTest', -- trailer spawn with 2 boats on it 
    default = {
        trailer = `doubletrailer`,
        boat = `zodiac`
    },
    label = "~b~Instructional Buttons: ~w~[~r~Beta Phase~w~]~n~~w~Press ~INPUT_CONTEXT~ to open~w~ compartment doors.~n~~w~Press ~INPUT_DETONATE~ to raise/lower~w~ flood lights.",
    occupied = '~r~Error: ~w~All spaces are occupied.',
    safetySpawn = '~r~Error: ~w~There was an issue. Please check that you loaded the trailer and boat resources.',
    boatCommands = 38, -- Default: E // If you would like to change this, here are the controls list https://docs.fivem.net/docs/game-references/controls/
    pressButtonDetach = '~b~Instructional Buttons: ~w~[~r~Beta Phase~w~]~n~Press ~g~E~w~ to detach.',
    pressButtonAttach = '~b~Instructional Buttons: ~w~[~r~Beta Phase~w~]~n~Press ~g~E~w~ to attach to trailer.',
    offset = {
                top = vector3(0.0,-1.0,-0.2),
                bottom = vector3(0.0,-1.0,-0.2),
                drop = vector3(0.0,-7.5,-1.0),
            },
}