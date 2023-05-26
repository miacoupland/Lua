local enemy = require "Enemy"
local button = require "Button"

-- every time the game boots up, randomise!
math.randomseed(os.time())

local game = {
    difficulty = 1,
    state = {
        menu = true,
        paused = false,
        running = false,
        ended = false
    },
    points = 0,
    levels = { 15, 30, 60, 120 }
}

local fonts = {
    medium = {
        font = love.graphics.newFont(16),
        size = 16
    },
    large = {
        font = love.graphics.newFont(24),
        size = 24
    },
    massive = {
        font = love.graphics.newFont(30),
        size = 30
    }
}

local player = {
    radius = 20,
    x = 30,
    y = 30
}

local buttons = {
    menu_state = {},
    ended_state = {},
    paused_state = {},
    running_state = {}
}

local enemies = {}

local function changeGameState(state)
    -- if state is menu, then menu is true, otherwise false. == means t/f
    game.state["menu"] = state == "menu"
    game.state["paused"] = state == "paused"
    game.state["running"] = state == "running"
    game.state["ended"] = state == "ended"
end

local function startNewGame()
    changeGameState("running")

    game.points = 0

    enemies = {
        enemy(1)
    }
end

local function pause()
    if game.state["running"] then
        game.state['running'], game.state['paused'] = false, true
    end
end

local function unpause()
    if game.state["paused"] then
        game.state['paused'], game.state['running'] = false, true
    end
end


function love.mousepressed(x, y, button, istouch, presses)
    if not game.state['running'] then
        if button == 1 then
            if game.state["menu"] then
                for index in pairs(buttons.menu_state) do
                    buttons.menu_state[index]:checkPressed(x, y, player.radius)
                end
            elseif game.state["ended"] then
                for index in pairs(buttons.ended_state) do
                    buttons.ended_state[index]:checkPressed(x, y, player.radius)
                end
            elseif game.state["paused"] then
                for index in pairs(buttons.paused_state) do
                    buttons.paused_state[index]:checkPressed(x, y, player.radius)
                end
            end
        end
    elseif game.state["running"] then
        for index in pairs(buttons.running_state) do
            buttons.running_state[index]:checkPressed(x, y, player.radius)
        end
    end
end

function love.load()
    love.mouse.setVisible(false)

    buttons.menu_state.play_game = button("Play Game", startNewGame, nil)
    buttons.menu_state.settings = button("Settings", nil, nil)
    buttons.menu_state.exit_game = button("Exit Game", love.event.quit, nil, nil)

    buttons.ended_state.replay_game = button("Replay", startNewGame, nil)
    buttons.ended_state.menu = button("Menu", changeGameState, "menu", nil, nil)
    buttons.ended_state.exit_game = button("Quit", love.event.quit, nil, nil)

    buttons.paused_state.play = button("Unpause", unpause, nil)

    buttons.running_state.pause = button("Pause", pause, nil)
end

function love.update(dt)
    player.x, player.y = love.mouse.getPosition()

    if game.state["running"] then
        for i = 1, #enemies do
            if not enemies[i]:checkTouched(player.x, player.y, player.radius) then
                enemies[i]:move(player.x, player.y)

                for j = 1, #game.levels do
                    if math.floor(game.points) == game.levels[j] then
                        table.insert(enemies, 1, enemy(game.difficulty * (j + 1)))

                        game.points = game.points + 1
                    end
                end

                -- if love.keyboard.isDown("p") then
                --     game.state['running'], game.state['paused'] = false, true
                -- end
            else
                changeGameState("ended")
            end
        end
        game.points = game.points + dt
    end
end

function love.draw()
    love.graphics.setFont(fonts.medium.font)
    love.graphics.printf("FPS: " .. love.timer.getFPS(), fonts.medium.font, 10,
        love.graphics.getHeight() - 30, love.graphics
        .getWidth())

    if game.state["running"] then
        buttons.running_state.pause:draw(10, 20, 17, 10, 50, 40)
        love.graphics.printf(math.floor(game.points), fonts.large.font, 0, 10, love.graphics.getWidth(), "center")
        love.graphics.circle("fill", player.x, player.y, player.radius)
        for i = 1, #enemies do
            enemies[i]:draw()
        end
    elseif game.state["menu"] then
        buttons.menu_state.play_game:draw(10, 20, 17, 10)
        buttons.menu_state.settings:draw(10, 70, 17, 10)
        buttons.menu_state.exit_game:draw(10, 120, 17, 10)
    elseif game.state["ended"] then
        love.graphics.setFont(fonts.large.font)
        buttons.ended_state.replay_game:draw(love.graphics.getWidth() / 2.25, love.graphics.getWidth() / 2, 10, 10)
        buttons.ended_state.menu:draw(love.graphics.getWidth() / 2.25, love.graphics.getWidth() / 1.74, 10, 10)
        buttons.ended_state.exit_game:draw(love.graphics.getWidth() / 2.25, love.graphics.getWidth() / 1.53, 10, 10)

        love.graphics.printf(math.floor(game.points), fonts.massive.font, 0,
            love.graphics.getHeight() / 2 - fonts.massive.size, love.graphics.getWidth(), "center")
    elseif game.state["paused"] then
        love.graphics.printf("Paused", fonts.massive.font, 0, love.graphics.getHeight() / 2 - fonts.massive.size,
            love.graphics.getWidth(), "center")
        buttons.paused_state.play:draw(love.graphics.getWidth() / 2.32, love.graphics.getWidth() / 2, 10, 10)
    end

    if not game.state["running"] then
        love.graphics.circle("fill", player.x, player.y, player.radius / 2)
    end
end
