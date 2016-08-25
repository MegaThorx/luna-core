screenX, screenY = guiGetScreenSize()

addEventHandler("onClientResourceStart", resourceRoot, function()

    setBlurLevel(Config.Get("blurlevel"))
    setFPSLimit(Config.Get("fpslimit"))
    setDevelopmentMode(Config.Get("devmode"), Config.Get("devmode"))

    GUI.Init()
    Translations.Init()
    Toast.Init()
    Radar.Init()
    HUD.Init()
    Models.Init()
    Binds.Init()
    Scoreboard.Init()
    Inventory.Init()
    Bank.Init()
    PlayerVehicle.Init()
    PlayerHouse.Init()

    local clientData = {}

    clientData["resolution"] = {}
    clientData["resolution"].screenX, clientData["resolution"].screenY = guiGetScreenSize()

    clientData["version"] = {}
    for k, v in pairs(getVersion()) do
      clientData["version"][k] = v
    end

    clientData["dx"] = {}
    for k, v in pairs(dxGetStatus()) do
      clientData["dx"][k] = v
    end

    addEventHandler("onClientBrowserCreated", GUI.browser,
      function()
        GUI.InitRendering()
      end
    )

    addEventHandler ( "onClientBrowserDocumentReady" , GUI.browser,
      function ( url )
        if url == "http://mta/" .. getResourceName(getThisResource()) .. "/files/html/login.html" then
          GUI.InitReady()
          if fileExists("autologin.dat") then
            local token = ""
            local file = fileOpen("autologin.dat")
            token = fileRead(file, fileGetSize(file))
            fileClose(file)

            triggerServerEvent("onClientReady", localPlayer, token, toJSON(clientData))
          else
            triggerServerEvent("onClientReady", localPlayer, nil, toJSON(clientData))
          end
        end
      end
    )
  end)
