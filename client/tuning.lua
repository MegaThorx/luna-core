Tuning = {}
Tuning.camPos = {
  ["front"] = {-1995.25390625, 162.26243591309, 51.778945922852, -2002.6253662109, 62.671863555908, 46.546337127686},
  ["back"] = {-1995.8482666016, 145.80703735352, 51.639602661133, -1992.1895751953, 245.60299682617, 46.406993865967},
  ["right"] = {-1985.9364013672, 153.75267028809, 51.677310943604, -2085.5356445313, 156.91165161133, 43.311100006104},
  ["left"] = {-2004.5252685547, 154.01948547363, 51.886009216309, -1904.8430175781, 149.8719329834, 45.085762023926},
  ["top"] = {-1995.2438964844, 153.07389831543, 63.311256408691, -1994.9595947266, 162.12322998047, -36.278045654297}
}

addCommandHandler("posi", function(cmd, pos)
  if(Tuning.camPos[pos])then
    local x, y, z, lx, ly, lz = Tuning.camPos[pos][1], Tuning.camPos[pos][2], Tuning.camPos[pos][3], Tuning.camPos[pos][4], Tuning.camPos[pos][5], Tuning.camPos[pos][6]
    setCameraMatrix(x, y, z, lx, ly, lz)
  end
end)

addCommandHandler ( "carshowoff", function ( )
	local vehicle = getPedOccupiedVehicle ( localPlayer )
	if vehicle then
    local open = true
		for i=0,5 do
			setVehicleDoorOpenRatio ( vehicle, i, 1 - getVehicleDoorOpenRatio ( vehicle, i ), 2500 )
		end
    setTimer(function()
      if open then
        open = false
    		for i=0,5 do
    			setVehicleDoorOpenRatio ( vehicle, i, 0, 2500 )
    		end
      else
        open = true
    		for i=0,5 do
    			setVehicleDoorOpenRatio ( vehicle, i, 1, 2500 )
    		end
      end
    end, 3000, 0)
	end
end )

local draggingVehicle = nil
local distance = 8
addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedWorld)
  if button == "right" then
    if state == "down" then
      if clickedWorld and not draggingVehicle then
        if getElementType(clickedWorld) == "vehicle" then
          distance = 8
          draggingVehicle = clickedWorld
        end
      end
    elseif state == "up" then
      draggingVehicle = nil
    end
  end
end)

addEventHandler("onClientCursorMove", root, function(cursorX, cursorY, absoluteX, absoluteY, worldX, worldY, worldZ)
  if draggingVehicle then
    local x, y, z = getWorldFromScreenPosition(absoluteX, absoluteY, distance)
    z = getGroundPosition(x, y, z + 20)
    setElementPosition(draggingVehicle, x, y, z + 0.8)
    local rx, ry, rz = getElementRotation(draggingVehicle)
    setElementRotation(draggingVehicle, rx, ry, 0)
  end
end)

bindKey("mouse_wheel_up", "down", function()
  if draggingVehicle then
    distance = distance + 0.8
  end
end)

bindKey("mouse_wheel_down", "down", function()
  if draggingVehicle then
    distance = distance - 0.8
  end
end)
