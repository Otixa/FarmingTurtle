--[[ Config ]]--
local fieldDepth = 9
local fieldWidth = 1
local fuelSlot = 16

-- [[ Main Action ]]--
local function DoWork()
  turtle.forward()
  turtle.digDown()
end

--[[ Utilities ]]--

local function CheckFuel()
  local currentSlot = turtle.getSelectedSlot()
  turtle.select(fuelSlot)
  if turtle.getFuelLevel() < 5 then
    print("Fuel level low.")
    if turtle.refuel() then
      print("Refueled.")
    else
      print("Unable to refuel.")
    end
  end
  turtle.select(currentSlot)
end

--[[ Main Loop ]]--

for x = 1,fieldWidth do
  for y = 1,fieldDepth do
    CheckFuel()
    DoWork()
  end
  turtle.turnLeft()
  if x < fieldWidth then
    turtle.forward()
  end
  turtle.turnLeft()
end

--[[ Return to original position ]]--
