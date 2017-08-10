local channel = "PowerPlant"

--[[ Setup ]]
term.clear()
term.setCursorPos(1,1)

--[[ Bundle Class ]]
BundledCables = {side="back"}
function BundledCables.__init__(baseClass, data)
  local self = {side=data}
  print("Initiating BundledCables on side "..self.side)
  setmetatable (self, {__index=BundledCables})
  self.enabledColors = redstone.getBundledInput(self.side)
  return self
end
setmetatable (BundledCables, {__call=BundledCables.__init__})

function BundledCables:Enable(color)
  self.enabledColors = colors.combine(self.enabledColors, color)
  redstone.setBundledOutput(self.side, self.enabledColors)
end

function BundledCables:EnableFor(color, time)
  self.enabledColors = colors.combine(self.enabledColors, color)
  redstone.setBundledOutput(self.side, self.enabledColors)
  local colorTimer = os.startTimer(time)
  repeat
    local sEvent, param = os.pullEvent( "timer" )
  until param == colorTimer
  self.enabledColors = colors.subtract(self.enabledColors, color)
  redstone.setBundledOutput(self.side, self.enabledColors)
end

function BundledCables:Disable(color)
  self.enabledColors = colors.subtract(self.enabledColors, color)
  redstone.setBundledOutput(self.side, self.enabledColors)
end

function BundledCables:IsEnabled(color)
  self.enabledColors = redstone.getBundledInput(self.side)
  return colors.test(self.enabledColors, color)
end

--[[ Rednet Listener ]]
RednetManager = {listenChannel="Default"}
function RednetManager.__init__(baseClass, data)
  local self = {listenChannel=data}
  setmetatable (self, {__index=RednetManager})
  local sides = {"left", "right", "front", "back", "top", "bottom"}
  self.modemSide = "none"
  for k, v in pairs(sides) do
    if peripheral.isPresent(v) then
      if peripheral.getType(v) == "modem" then
        self.modemSide = v
      end
    end
  end
  if self.modemSide == "none" then
    print("Modem not detected!")
  else
      print("Initiating RednetManager on side "..self.modemSide..", channel "..self.listenChannel)
      rednet.open(self.modemSide)
  end
  self.callbacks = {}
  local function defaultPreParser(message)
    return message
  end
  self.preParser = defaultPreParser
  return self
end
setmetatable (RednetManager, {__call=RednetManager.__init__})

--[[ TODO: Make callbacks be an array per hKey ]]
function RednetManager:RegisterHandler(handlerKey, fn)
  self.callbacks[handlerKey] = fn
end

function RednetManager:UnregisterHandler(handlerKey, fn)
  self.callbacks[handlerKey] = nil
end

function RednetManager:Listen()
  local senderId, message, protocol = rednet.receive(self.listenChannel)
  local hKey = self.preParser(message)
  if self.callbacks[hKey] ~= nil then
    self.callbacks[hKey](senderId, message, protocol)
  end
end

--[[ End Classes ]]
local function splitString(str)
  local words = {}
  for word in str:gmatch( "%S+" ) do
        words[ #words + 1 ] = word
  end
  return words
end

function RednetPreParser(message)
  local msg = splitString(message)
  return msg[1]
end
--[[ Main Management ]]
local bundle = BundledCables("back")
local rn = RednetManager(channel)
rn.preParser = RednetPreParser

--[[ Packet Handlers]]
local function DoorHandler(senderId, message, protocol)
  local msg = splitString(message)
  if msg[2] == "outer" then
    bundle:EnableFor(colors.green, 5)
  elseif msg[2] == "inner" then
    bundle:EnableFor(colors.lime, 10)
  end
end
rn:RegisterHandler("OpenDoor", DoorHandler)

--[[ Main Loop]]
os.sleep(2)
local function processRednet()
  while true do
    rn:Listen()
  end
end

while true do
  parallel.waitForAll(processRednet)
end
