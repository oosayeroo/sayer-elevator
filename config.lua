Config = {}
Config.DebugPoly = false
Config.UseTarget = false --false for drawtext

Config.UIPosition = 'left' --'left' / 'center' / 'right' (add more positions in html,script.js)

Config.UseElevatorSound = 'elevator'
Config.SoundVolume = 0.1 -- volume of elevator sound

Config.ElevatorLabel = "Use Elevator"
Config.Elevators = { --you must set up elevators for your server. i just provided a way to do that
    ['mrpd_main'] = { --this must be unique (THIS IS THE ELEVATOR)
        JobCode = false, --jobocde or false
        Floors = { --add floors here. max is about 14 per elevator (due to UI)
            [1] = {
                ID = 1, --must be unique to this elevator
                Label = "G Floor", --label for button and notify
                Coords = vector4(414.33, -962.09, 29.48, 339.17),
            },
            [2] = {
                ID = 2,
                Label = "1st Floor",
                Coords = vector4(415.27, -941.16, 29.42, 171.9),
            },
            [3] = {
                ID = 3,
                Label = "2nd Floor",
                Coords = vector4(415.27, -941.16, 29.42, 171.9),
            },
            [4] = {
                ID = 4,
                Label = "3rd Floor",
                Coords = vector4(415.27, -941.16, 29.42, 171.9),
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