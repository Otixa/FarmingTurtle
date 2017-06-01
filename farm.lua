--[[ Config ]]--
local fieldDepth = 9
local fieldWidth = 2
local seedSlot = 1
local fuelSlot = 16
--[[ End Config]]--

local initialPosition = true

local function PlaceSlot(slot)
  local currentSlot = turtle.getSelectedSlot()
  if turtle.getItemCount(slot) > 0 then
    turtle.placeDown()
  else
    print("Unable to place. Slot "..slot.." is empty.")
  end
  turtle.select(currentSlot)
end

local function DoWork(shouldMove)
  turtle.digDown()
  PlaceSlot(seedSlot)
  if shouldMove then
    turtle.forward()
  end
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

local function UnloadCargo()
  local currentSlot = turtle.getSelectedSlot()
  for slot = 1,16 do
    if slot ~= seedSlot and slot ~= fuelSlot then
      turtle.select(slot)
      turtle.dropDown()
    end
  end
  turtle.select(currentSlot)
end

--[[ Main Loop ]]--
local function Main()
  turtle.forward()
  for x = 1,fieldWidth do
    for y = 1,fieldDepth do
      CheckFuel()
      if y == fieldDepth then
        DoWork(false)
      else
        DoWork(true)
      end
    end

    if x % 2 == 0 and x ~= fieldWidth then
      turtle.turnLeft()
    else
      turtle.turnRight()
    end

    if x < fieldWidth then
      turtle.forward()
    end

    if x == fieldWidth and y == nil then
      if fieldWidth % 2 ~= 0 then
        turtle.turnRight()
      end
    else
      if x % 2 == 0 then
        turtle.turnLeft()
      else
        turtle.turnRight()
      end
    end
  end

  --[[ Return to original position ]]--
  if fieldWidth % 2 ~= 0 then
    for y = 1,fieldDepth-1 do
      turtle.forward()
    end
    turtle.turnRight()
  end
  for x = 1,fieldWidth-1 do
    turtle.forward()
  end
  turtle.turnRight()
  turtle.back()
  UnloadCargo()
end

Main()
