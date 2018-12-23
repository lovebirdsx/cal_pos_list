require('foo')

function love.draw()
    foo()
    for i = 1, 5 do
        love.graphics.print("Hello " .. i, 400, 200 + 30 * i)
    end
end