Config = {}
Config.DebugPoly = true

Config.UseElevatorSound = 'elevator'
Config.SoundVolume = 0.1 -- volume of elevator sound

Config.Elevators = { --you must set up elevators for your server. i just provided a way to do that
    ['mrpd'] = { --this must be unique
        JobCode = 'police', --jobocde or false
        Floors = { --add as little or as many floors as you like
            [1] = {
                Label = "Ground Floor", --label for menu and notify
                Coords = vector4(0,0,0,0), --corrds of the floor
            },
            [2] = {
                Label = "First Floor",
                Coords = vector4(0,0,0,0),
            },
            [3] = {
                Label = "Second Floor",
                Coords = vector4(0,0,0,0),
            },
        },
    },
    ['hospital'] = { 
        JobCode = false, 
        Floors = {
            [1] = {
                Label = "Ground Floor", 
                Coords = vector4(0,0,0,0), 
            },
            [2] = {
                Label = "First Floor",
                Coords = vector4(0,0,0,0),
            },
            [3] = {
                Label = "Second Floor",
                Coords = vector4(0,0,0,0),
            },
        },
    },
}