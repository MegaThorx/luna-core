screenX, screenY = guiGetScreenSize()

addEventHandler("onClientResourceStart", resourceRoot, function()

  setBlurLevel(Config.Get("blurlevel"))
  setFPSLimit(Config.Get("fpslimit"))
  setDevelopmentMode(Config.Get("devmode"), Config.Get("devmode"))


  GUI.Init()
  Translations.Init()
  Radar.Init()
  HUD.Init()
  Models.Init()
  Binds.Init()
  Scoreboard.Init()

  addEventHandler("onClientBrowserCreated", GUI.browser,
    function()
      GUI.InitRendering()
    end
  )

  addEventHandler ( "onClientBrowserDocumentReady" , GUI.browser,
  	function ( url )
        GUI.InitReady()
        if fileExists("autologin.dat") then
          local token = ""
          local file = fileOpen("autologin.dat")
          token = fileRead(file, fileGetSize(file))

          triggerServerEvent("onClientReady", localPlayer, token)
        else
          triggerServerEvent("onClientReady", localPlayer)
        end

  	end
  )
end)

local lastSpeed = 0
local isOnVehicle = nil

setTimer(function()
  local x, y, z = getElementPosition(localPlayer)
  local hit, _, _, _, veh = processLineOfSight(x, y, z, x, y, z - 2, false, true, false, false, false, false, false, false)

  if not getPedOccupiedVehicle(localPlayer) and hit then
    if isOnVehicle then
      isOnVehicle = veh
      local newSpeed = Utils.GetElementSpeed(veh, "km/h")

      if newSpeed < lastSpeed - 10 then
    		local x,y,z = getElementVelocity(veh)
    		setElementVelocity(localPlayer,x,y,z+1.5)
      end
      lastSpeed = newSpeed
    else
      isOnVehicle = veh
      lastSpeed = Utils.GetElementSpeed(veh, "km/h")
    end
  else
    isOnVehicle = nil
    lastSpeed = 0
  end
end, 50, 0)

function noDamageToPlayersFromCustomWeapons(_, _, _, x, y, z)
    createExplosion(x, y, z, 5)
    createExplosion(x + 1, y + 1, z, 5)
    createExplosion(x - 1, y + 1, z, 5)
    createExplosion(x + 1, y - 1, z, 5)
    createExplosion(x - 1, y - 1, z, 5)
end
addEventHandler("onClientPlayerWeaponFire", root, noDamageToPlayersFromCustomWeapons)
