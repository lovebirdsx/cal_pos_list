function cal_pos_list(unit_list, pos)

line_max = 8             --一排最多的的个数
all_num = #unit_list     --所有单位的个数
all_line = 0             --排列后的总行数
all_melee_line = 0       --melee单位会有的总行数
all_no_melee_line = 0    --非melee单位会有的总行数
is_melee_num = 0         --定义近战个数
no_melee_num = 0         --定义非近战个数

--直接统计近战非近战总个数---------------------------------------------------------------------------------

function type_num( unit_list )  --返回两种类型的数量，近战，非近战
	local melee_num = 0
	local no_melee_num = 0
	for i,melee in pairs(unit_list) do
		if melee.is_melee == true then melee_num =melee_num +1
		else
			no_melee_num = no_melee_num +1
	    end
	end
		return melee_num,no_melee_num

end

is_melee_num,no_melee_num= type_num( unit_list )  --最终赋值，近战个数  与 非近战个数----------------


-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
------------------------------------------计算melee和nomelee每个名字的个数-------------------------------------------
 table_is_melee_num = {}--melee个数包含名字的table
 table_no_melee_num = {}--nomelee个数包含名字的table

for i,unit in pairs(unit_list) do
	if unit.is_melee == true then 
			table.insert(table_is_melee_num,unit) --是melee就放入is_melee_num中

		else
			table.insert(table_no_melee_num,unit) --反则放入 no_melee_num中				
	end
end	


--近战or非近战的名字个数统计-------------------------------------------------------------------------------
function name_num ( unit_list)--通用的函数，用于计算不同战斗种类名字的个数-----------------------------
	local name_and_num = {}
	for i,unit in ipairs(unit_list) do
		local name = unit.name
		if name_and_num[name] == nil then name_and_num[name] = 0
		end
		name_and_num[name] = name_and_num[name]+1
	end

	return 
	name_and_num
end

------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------


------------------------计算melee和非melee行数的过程----------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
melee_line = math.modf(is_melee_num/line_max)   --melee除去未满8个的行数
no_melee_line = math.modf(no_melee_num/line_max) ----melee除去未满8个的行数

is_melee_another_num = is_melee_num%line_max  --melee落单的个数
no_melee_another_num = no_melee_num%line_max  --no_melee 落单个数


all_line = melee_line + no_melee_line  
all_melee_line = melee_line
all_no_melee_line = no_melee_line


if is_melee_another_num > 0 					--若melee单位不是8的倍数
	then all_line = all_line +1  
		 all_melee_line = all_melee_line+1
end

if no_melee_another_num > 0                     --若非melee单位不是8的倍数
	then all_line = all_line +1  
	      all_no_melee_line = all_no_melee_line+1
end



print("\n=====================================")
print("units'information:\n ")
print("all_num is "..all_num)                          --全部单位的个数
print("all_line is  "..all_line)					   --总共的行数
print("all_melee_line is "..all_melee_line)            --近战的行数
print("all_no_melee_line is "..all_no_melee_line)      --非近战的行数
print("melee_another_num is "..is_melee_another_num)   --melee不满8的落单个数
print("no_melee_another_num is "..no_melee_another_num)--非melee不满8的落单个数

print("=====================================\n")



-------------------算出Y轴的最高点---------------------------------------------------
y_max = (all_line-1) * 40                   --整个坐标系占用的y轴大小
middle = y_max/2                        --中间位置（相对自己的位置）
y_top = pos.y+middle                    --Y轴最高点



---------算出近战第一个坐标----------------x轴位置------------------
x_top = 0 

if is_melee_another_num > 0   
	then x_top = pos.x-((is_melee_another_num-1)*30)/2 
	else x_top = pos.x-(7*30)/2
end


------------------------------------------------------------------
--------------非近战第一个坐标---------------------------------
x_top_no_melee = 0--X轴--

if no_melee_another_num > 0   
	then x_top_no_melee = pos.x-((no_melee_another_num-1)*30)/2 
	else x_top_no_melee = pos.x-(7*30)/2
end



y_top_no_melee = y_top - (all_melee_line*40)--y轴

-----------------------------------------------------------------------

pos_new = {}  -----建立一个顺序存储的位置结构体
x_first = pos.x-(7*30)/2  ---- --满8的第一个X位置
---===================================存储所有melee坐标的过程==============================================================
if is_melee_another_num > 0 then
		local x = x_top
		local y = y_top
		for i=1,is_melee_another_num,1 do
			pos_new[i] = {x=x,y=y}
			x = x + 30
		end


		local x = x_first
		local y = y_top -40
		local count = 0
		for i=is_melee_another_num+1,is_melee_num,1 do
			pos_new[i] = {x=x,y=y}
			x = x+30
			count = count +1
			if count == 8 then count=0 y=y-40 x=x_first
			end
		end


	else
		local x = x_first
		local y = y_top
		local count = 0
		for i=1,is_melee_num,1 do
			pos_new[i] = {x=x,y=y}
			x = x+30
			count = count +1
			if count == 8 then count=0 y=y-40 x=x_first
			end
		end

end
---=======================================================================================================================


---===================================存储所有no_melee坐标的过程===========================================================

if no_melee_another_num > 0 then
		local x = x_top_no_melee
		local y = pos_new[is_melee_num].y-40
		--local z = 
		for i=is_melee_num+1,is_melee_num+no_melee_another_num,1 do
			pos_new[i] = {x=x,y=y}
			x = x + 30
		end


		local x = x_first
		local y =  y_top_no_melee  -40
		local count = 0
		for i=is_melee_num+no_melee_another_num+1,all_num,1 do
			pos_new[i] = {x=x,y=y}
			x = x+30
			count = count +1
			if count == 8 then count=0 y=y-40 x=x_first
			end
		end


	else
		local x = x_first
		local y = pos_new[is_melee_num].y-40
		local count = 0
		for i=is_melee_num+1,all_num,1 do
			pos_new[i] = {x=x,y=y}
			x = x+30
			count = count +1
			if count == 8 then count=0 y=y-40 x=x_first
			end
		end

end

---=======================================================================================================================



---======================================下面操作是保持原来输入unit的顺序位置，存储坐标=======================================

--=========================================先标记一下unit本来的位置===========================================================
for i,k in ipairs(unit_list) do
	k.num = i
end


table.sort(unit_list,function(a,b)

	if a.is_melee == true and b.is_melee == nil then return true        -----保证近战的在前面
		elseif
			 b.is_melee == true and a.is_melee == nil then return false
		else 		
			return a.name < b.name 	                                    --再根据名字排序
	end		                                
end)

----====================按顺序分配坐标======================================================================================
for i,k in pairs (unit_list) do
	k.x,k.y = pos_new[i].x,pos_new[i].y
	
	--print(i,k.x,k.y)

end
------------------根据之前的标志位置，排序，得到原本输入unit的位置，让坐标最终按照输入时的顺序输出==========================
table.sort(unit_list,function(a,b)

			return a.num < b.num	                                   		                                
end)
--------------------排序成功后，提出所需的x轴、y轴坐标，然后最后返回一个pos_list============================================

pos_list = {}

print("retuen's result :")
for i,k in pairs(unit_list) do
	pos_list[i] = k
	print(pos_list[i].x,pos_list[i].y)
	end

	return pos_list   ------返回pos_list

end   ----cla_pos_list函数结束=============================================================================

-----测试数据===============================================================================================


-- unit_list = {
-- {name="a",is_melee=true},
-- {name="a",is_melee=true},
-- {name="a",is_melee=true},
-- {name="a",is_melee=true},
-- {name="c",is_melee=true},
-- {name="b",is_melee=nil},
-- {name="b",is_melee=nil},
-- {name="c",is_melee=true},
-- {name="a",is_melee=nil},
-- {name="b",is_melee=true},
-- {name="c",is_melee=true},
-- {name="c",is_melee=true},
-- }

-- pos = {x=60,y=70}


--  cal_pos_list (unit_list,pos)   ------调用函数

return cal_pos_list