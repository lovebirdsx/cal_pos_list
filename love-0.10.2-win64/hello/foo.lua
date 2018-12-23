function foo()
    for i = 1, 5 do
        love.graphics.print("foo " .. i, 200, 200 + 30 * i)
    end
end