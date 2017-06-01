--[[ Config ]]--
local fieldDepth = 9
local fieldWidth = 1

-- [[ Main Action ]]--
local function DoWork()
  turtle.forward()
  turtle.digDown()
end

local function CheckFuel()
  if turtle.getFuelLevel() < 5 then
    turtle.refuel()
end
