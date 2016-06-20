screenX, screenY = guiGetScreenSize()

addEventHandler("onClientResourceStart", resourceRoot, function()

  setBlurLevel(Config.Get("blurlevel"))
  setFPSLimit(Config.Get("fpslimit"))
  setDevelopmentMode(Config.Get("devmode"), Config.Get("devmode"))


  GUI.Init()
  Translations.Init()
  Radar.Init()

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
