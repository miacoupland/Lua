function love.conf(t)
    t.identity = "data/saves"
    -- t.version = "1.0.0"
    t.console = false
    t.externalstorage = true
    -- overall brightness
    t.gammacorrect = true
    -- microphone permissions
    t.audio.mic = true
    -- add a title to the window
    t.window.title = "Game title"
    -- add an icon
    -- t.window.icon = "./icon/ghost.ico"
    -- t.window.width = 400
    -- t.window.height = 200
    t.window.resizable = true
    t.window.minheight = 500
    t.window.minwidth = 500
    -- vertical sync, sound and video, but optional
    t.window.vsync = 1
    -- pick which display to go on
    t.window.display = 1
    -- pick where on the display to show the app
    -- t.window.x = 200
    -- t.window.y = 200

    -- you can disable modules if you want to
    -- but if you did below, you'd never get the timer for updates, for example
    -- t.modules.timer = false


end