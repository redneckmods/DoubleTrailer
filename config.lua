config = {}

config = {
    trailers = {
        'doubletrailer',
    },
    boats = {
        'zodiac',
    },
    spawnCommand = 'dblTrailerTest', -- trailer spawn with 2 boats on it 
    default = {
        trailer = 'doubletrailer',
        boat = 'zodiac'
    },
    occupied = 'All spaces are occupied.',
    safetySpawn = '~r~ There was an issue. Please check that you loaded the trailer and boat resources.',
    boatCommands = 38, -- Default: E // If you would like to change this, here are the controls list https://docs.fivem.net/docs/game-references/controls/
    pressButtonDetach = 'Press ~g~E~w~ to detach.',
    pressButtonAttach = 'Press ~g~E~w~ to attach to trailer.',
    offset = {
                top = vector3(0.0,-1.0,-0.2),
                bottom = vector3(0.0,-1.0,-0.2),
                drop = vector3(0.0,-7.5,-1.0),
            },
}