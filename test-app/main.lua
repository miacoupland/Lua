-- Import a module called 'love'
_G.love = require('love')

-- Basic concepts of running a game
-- There is the load, update, and drawing stages
-- Love2D makes this simple

-- Load data when the app start
function love.load()
    _G.dog = {
        x = 0,
        y = 0,
        walkSprite = {
            image = love.graphics.newImage("sprites/Walk.png"),
            -- 288px x 48px
            width = 288,
            height = 48
        },
        animation = {
            direction = "right",
            idle = true,
            frame = 1,
            max_frames = 6,
            speed = 20,
            timer = 0.1
        }
    }

    -- 42.5
    QUAD_WIDTH, QUAD_HEIGHT = 48, dog.walkSprite.height

    _G.quads = {}

    for i = 1, dog.animation.max_frames do
        quads[i] = love.graphics.newQuad(QUAD_WIDTH * (i - 1), 0, QUAD_WIDTH, QUAD_HEIGHT, dog.walkSprite.width, dog.walkSprite.height)
    end
end

-- Updates once every 60 frames (60fps)
-- dt is delta time, time between this frame and the last
function love.update(dt)
    if love.keyboard.isDown("d") then
        dog.animation.idle = false
        dog.animation.direction = "right"
    elseif love.keyboard.isDown("a") then
        dog.animation.idle = false
        dog.animation.direction = "left"
    else 
        dog.animation.idle = true
        dog.animation.frame = 1
    end

    if not dog.animation.idle then
        dog.animation.timer = dog.animation.timer + dt

        if dog.animation.timer > 0.2 then
            dog.animation.timer = 0.1

            dog.animation.frame = dog.animation.frame + 1

        if dog.animation.direction == "right" then
            dog.x = dog.x + dog.animation.speed
        elseif dog.animation.direction == "left" then
            dog.x = dog.x - dog.animation.speed
        end

            if dog.animation.frame > dog.animation.max_frames then
                dog.animation.frame = 1
            end
        end
    end
end

-- Draws everything to the screen, relating to the update
function love.draw()
    if dog.animation.direction == "right" then
        love.graphics.draw(dog.walkSprite.image, quads[dog.animation.frame], dog.x, dog.y)
    else
        -- 0 is radians, or orientation
        -- -1 and 1 is scaling x and y (flipping)
        -- and then we have the offsets
        love.graphics.draw(dog.walkSprite.image, quads[dog.animation.frame], dog.x, dog.y, 0, -1, 1, QUAD_WIDTH, 0)
    end
end
