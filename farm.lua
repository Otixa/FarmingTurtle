--[[ Config ]]--
local fieldDepth = 9
local fieldWidth = 1
local seedSlot = 1
local fuelSlot = 16

local function PlaceSlot(slot)
  local currentSlot = turtle.getSelectedSlot()
  if turtle.getItemCount(slot) > 0 then
    turtle.placeDown()
  else
    print("Unable to place. Slot "..slot.." is empty.")
  end
  turtle.select(currentSlot)
end

local function DoWork()
  turtle.forward()
  turtle.digDown()
  PlaceSlot(seedSlot)
end

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
  turtle.turnRight()
  if x < fieldWidth then
    turtle.forward()
  end
  turtle.turnRight()
end

--[[ Return to original position ]]--
