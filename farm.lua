--[[ Config ]]--
local fieldDepth = 9
local fieldWidth = 1

-- [[ Main Action ]]--
local function DoWork()
  turtle.forward()
  turtle.digDown()
end

--[[ Utilities ]]--

local function CheckFuel()
  if turtle.getFuelLevel() < 5 then
    print("Fuel level low.")
    if turtle.refuel() then
      print("Refueled.")
    else
      print("Unable to refuel.")
    end
end

--[[ Main Loop ]]--

for x = 1,fieldWidth do
  for y = 1,fieldDepth do
    CheckFuel()
    DoWork()
  end
end
