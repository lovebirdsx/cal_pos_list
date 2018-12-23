local cal_pos_list = require('cal_pos_list')

local unit_list = {
    {name="A",is_melee=true},
    {name="A",is_melee=true},
    {name="A",is_melee=true},
    {name="A",is_melee=true},
    {name="A",is_melee=true},
    {name="A",is_melee=true},
    {name="B",is_melee=true},
    {name="a",is_melee=false},
    {name="a",is_melee=false},
    {name="a",is_melee=false},
    {name="a",is_melee=false},
    {name="b",is_melee=false},
    {name="b",is_melee=false},
    {name="b",is_melee=false},
    {name="b",is_melee=false},
    {name="b",is_melee=false},
    {name="b",is_melee=false},
    {name="b",is_melee=false},
    {name="b",is_melee=false},
    {name="b",is_melee=false},
    {name="b",is_melee=false},
    {name="b",is_melee=false},
    {name="b",is_melee=false},
    {name="a",is_melee=false},
    {name="B",is_melee=true},
    {name="A",is_melee=true},
    {name="b",is_melee=false},
    {name="B",is_melee=true},
    {name="B",is_melee=true},
}

local pos_list = cal_pos_list(unit_list, {x = 400, y = 300})

function love.draw()
    for i, pos in ipairs(pos_list) do
        local u = unit_list[i]
        local r = 15
        love.graphics.circle('line', pos.x, pos.y, r)
        love.graphics.print(u.name, pos.x - 4, pos.y - 7)
    end
end