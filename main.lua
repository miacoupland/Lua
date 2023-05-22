local enemy = require "Enemy"

local game = {
    difficulty = 1,
    state = {
        menu = true,
        paused = false,
        running = false,
        ended = false
    }
}

local player = {
    radius = 20,
    x = 30,
    y = 30
}

local enemies = {
    
}

function love.load()
    love.mouse.setVisible(false)

    table.insert(enemies, 1, enemy())
end

function love.update(dt)
    player.x, player.y = love.mouse.getPosition()

    for i = 1, #enemies do
        enemies[i]: move(player.x, player.y)
    end
end

function love.draw()
    love.graphics.printf("FPS: " .. love.timer.getFPS(), love.graphics.newFont(16, "normal"), 10,
        love.graphics.getHeight() - 30, love.graphics
        .getWidth())

    if game.state["running"] then
        love.graphics.circle("fill", player.x, player.y, player.radius)
    end

    if not game.state["running"] then
        love.graphics.circle("fill", player.x, player.y, player.radius / 2)
    end

    for i = 1, #enemies do
        enemies[i]: draw()
    end
end