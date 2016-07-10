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
  Bank.Init()
  PlayerVehicle.Init()
  PlayerHouse.Init()

  addEventHandler("onClientBrowserCreated", GUI.browser,
    function()
      GUI.InitRendering()
    end
  )

  addEventHandler ( "onClientBrowserDocumentReady" , GUI.browser,
  	function ( url )
        if url == "http://mta/" .. getResourceName(getThisResource()) .. "/files/html/index.html" then
          GUI.InitReady()
          if fileExists("autologin.dat") then
            local token = ""
            local file = fileOpen("autologin.dat")
            token = fileRead(file, fileGetSize(file))
            fileClose(file)

            triggerServerEvent("onClientReady", localPlayer, token)
          else
            triggerServerEvent("onClientReady", localPlayer)
          end
        end
  	end
  )
end)
